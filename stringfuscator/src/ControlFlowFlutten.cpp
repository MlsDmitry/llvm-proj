#include <vector>

#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/CFG.h"
#include "llvm/Support/Debug.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/Reg2Mem.h"

#define DEBUG_TYPE "obf-cff"

using namespace llvm;
using namespace std;

//-----------------------------------------------------------------------------
// ControlFlowFlutten implementation
//-----------------------------------------------------------------------------
// No need to expose the internals of the pass to the outside world - keep
// everything in an anonymous namespace.
namespace
{
	bool valueEscapes(Instruction &ins)
	{
		BasicBlock *bb = ins.getParent();

		for (Value::use_iterator UI = ins.use_begin(), E = ins.use_end(); UI != E;
			 ++UI)
		{
			if (Instruction *ins_i = dyn_cast<Instruction>(*UI)) {
				return ins_i->getParent() != bb || isa<PHINode>(ins_i);
			}
		}
		return false;
	}

	void fixStack(Function &F)
	{
		// Try to remove phi node and demote reg to stack
		std::vector<PHINode*> tmpPhi;
		std::vector<Instruction*> tmpReg;
		BasicBlock &bbEntry = F.getBasicBlockList().front();

		do
		{
			tmpPhi.clear();
			tmpReg.clear();

			// for (Function::iterator i = f->begin(); i != f->end(); ++i)
			// {
			for (BasicBlock &bb : F)
			{
				for (Instruction &ins : bb)
				{
					if (isa<PHINode>(ins))
					{
						PHINode &phi = cast<PHINode>(ins);
						tmpPhi.push_back(&phi);
						continue;
					}
					if (!(isa<AllocaInst>(ins) && ins.getParent() == &bbEntry) &&
						(valueEscapes(ins) || ins.isUsedOutsideOfBlock(&bb)))
					{
						tmpReg.push_back(&ins);
						continue;
					}
				}
			}

			for (unsigned int i = 0; i != tmpReg.size(); ++i)
			{
				DemoteRegToStack(*tmpReg.at(i), F.getBasicBlockList().begin()->getTerminator());
			}

			for (unsigned int i = 0; i != tmpPhi.size(); ++i)
			{
				DemotePHIToStack(tmpPhi.at(i), F.getBasicBlockList().begin()->getTerminator());
			}

		} while (tmpReg.size() != 0 || tmpPhi.size() != 0);
	}
	void visitor(Function &F)
	{
		if (F.getName() != "encode_alloc")
			return;

		BasicBlock &firstBB = F.getBasicBlockList().front();
		LLVMContext &context = F.getContext();
		IRBuilder<> builder(context);

		// some constants
		auto *Int64Type = Type::getInt64Ty(context);
		auto *state_value = ConstantInt::get(Int64Type, 0);
		auto state_zero = ConstantInt::get(Int64Type, 0);

		LLVM_DEBUG(dbgs() << "Entering function " << F.getName() << "\n");

		// Initialization basic block
		BasicBlock *init_bb = BasicBlock::Create(context, "init", &F, &firstBB);

		builder.SetInsertPoint(init_bb);
		// allocate memory for state variable
		AllocaInst *state = builder.CreateAlloca(Int64Type, 0, "state");
		// initialize it with state "zero"
		builder.CreateStore(state_zero, state);

		// Dispatcher basic block
		BasicBlock *dispatcher_bb = BasicBlock::Create(context, "dispatcher", &F, &firstBB);

		// jump from init to dispatcher
		builder.CreateBr(&firstBB);

		// Dispatcher instructions
		builder.SetInsertPoint(dispatcher_bb);

		// load value for later use in the dispatcher (switch)
		LoadInst *state_p = builder.CreateLoad(Int64Type, state);
		// dispatcher
		SwitchInst *state_switch = builder.CreateSwitch(state_p, &firstBB, 1);
		// add initial state
		state_switch->addCase(state_zero, &firstBB);

		int state_counter = 1;

		std::map<std::string, int> state_transitions;

		for (BasicBlock &bb : F)
		{
			LLVM_DEBUG(dbgs() << bb.getNameOrAsOperand() << "\n");
			if (bb.getNameOrAsOperand() == "dispatcher" || bb.getNameOrAsOperand() == "init")
				continue;

			if (BranchInst *branch_ins = dyn_cast<BranchInst>(bb.getTerminator()))
			{
				std::string type_str;
				llvm::raw_string_ostream rso(type_str);

				bb.getTerminator()->print(rso);
				LLVM_DEBUG(dbgs() << rso.str() << "\n");
				LLVM_DEBUG(dbgs() << "Successor: " << branch_ins->getSuccessor(0)->getNameOrAsOperand() << "\n");

				if (branch_ins->getNumSuccessors() == 1)
				{
					std::string successor_name = branch_ins->getSuccessor(0)->getNameOrAsOperand();

					LLVM_DEBUG(dbgs() << "Successor name: " << successor_name << "\n");

					if (state_transitions.find(successor_name) == state_transitions.end())
					{
						state_value = ConstantInt::get(Int64Type, state_counter);

						state_switch->addCase(state_value, branch_ins->getSuccessor(0));

						state_transitions.insert({successor_name, state_counter});

						state_counter++;
					}
					else
					{
						int defined_state = state_transitions.at(successor_name);
						state_value = ConstantInt::get(Int64Type, defined_state);
					}

					builder.SetInsertPoint(branch_ins);

					StoreInst *store_state_ins = builder.CreateStore(state_value, state);

					builder.CreateBr(dispatcher_bb);

					branch_ins->eraseFromParent();
				}
			}
		}

		fixStack(F);

		std::string type_str;
		llvm::raw_string_ostream rso(type_str);

		F.print(rso);
		LLVM_DEBUG(dbgs() << rso.str() << "\n");
	}
	// New PM implementation
	struct ControlFlowFlutten : PassInfoMixin<ControlFlowFlutten>
	{
		// Main entry point, takes IR unit to run the pass on (&F) and the
		// corresponding pass manager (to be queried if need be)
		PreservedAnalyses run(Function &F, FunctionAnalysisManager &)
		{
			visitor(F);
			return PreservedAnalyses::none();
		}

		// Without isRequired returning true, this pass will be skipped for functions
		// decorated with the optnone LLVM attribute. Note that clang -O0 decorates
		// all functions with optnone.
		static bool isRequired() { return true; }
	};

	// Legacy PM implementation
	struct LegacyControlFlowFlutten : public FunctionPass
	{
		static char ID;
		LegacyControlFlowFlutten() : FunctionPass(ID) {}
		// Main entry point - the name conveys what unit of IR this is to be run on.
		bool runOnFunction(Function &F) override
		{
			// visitor(F);
			visitor(F);
			// Doesn't modify the input unit of IR, hence 'false'
			return false;
		}
	};

} // namespace

//-----------------------------------------------------------------------------
// New PM Registration
//-----------------------------------------------------------------------------
llvm::PassPluginLibraryInfo getControlFlowFluttenPluginInfo()
{
	return {LLVM_PLUGIN_API_VERSION, "ControlFlowFlutten", LLVM_VERSION_STRING,
			[](PassBuilder &PB)
			{
				PB.registerPipelineParsingCallback(
					[](StringRef Name, FunctionPassManager &FPM,
					   ArrayRef<PassBuilder::PipelineElement>)
					{
						if (Name == "obf-cff")
						{
							FPM.addPass(ControlFlowFlutten());
							return true;
						}
						return false;
					});
			}};
}

// This is the core interface for pass plugins. It guarantees that 'opt' will
// be able to recognize ControlFlowFlutten when added to the pass pipeline on the
// command line, i.e. via '-passes=hello-world'
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo()
{
	return getControlFlowFluttenPluginInfo();
}

//-----------------------------------------------------------------------------
// Legacy PM Registration
//-----------------------------------------------------------------------------
// The address of this variable is used to uniquely identify the pass. The
// actual value doesn't matter.
char LegacyControlFlowFlutten::ID = 0;

// This is the core interface for pass plugins. It guarantees that 'opt' will
// recognize LegacyControlFlowFlutten when added to the pass pipeline on the command
// line, i.e.  via '--legacy-hello-world'
static RegisterPass<LegacyControlFlowFlutten>
	X("legacy-obf-cff", "Obfuscator[Control Flow Flutten] legacy pass ",
	  false, // This pass doesn't modify the CFG => true
	  false	 // This pass is not a pure analysis pass => false
	);