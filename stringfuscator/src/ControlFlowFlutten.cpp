#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/CFG.h"
#include "llvm/Support/Debug.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#define DEBUG_TYPE "obf-cff"

using namespace llvm;

//-----------------------------------------------------------------------------
// ControlFlowFlutten implementation
//-----------------------------------------------------------------------------
// No need to expose the internals of the pass to the outside world - keep
// everything in an anonymous namespace.
namespace
{

	void visitor(Function &F)
	{
		BasicBlock &firstBB = F.getBasicBlockList().front();
		LLVMContext &context = F.getContext();
		IRBuilder<> builder(context);

		// some constants
		auto *Int64Type = Type::getInt64Ty(context);
		auto *state_value = ConstantInt::get(Int64Type, 0);
		auto state_zero = ConstantInt::get(Int64Type, 0);


		LLVM_DEBUG(dbgs() << "Entering function " << F.getName() << "\n");

		// Entry point basic block
		BasicBlock *entry_bb = BasicBlock::Create(context, "EntryPoint", &F, &firstBB);
		
		builder.SetInsertPoint(entry_bb);

		// allocate memory for state variable
		AllocaInst *state = builder.CreateAlloca(Int64Type, 0, "state");
		// initialize it with state "zero"
		builder.CreateStore(state_zero, state);
		// load value for later use in the dispatcher (switch)
		LoadInst *state_p = builder.CreateLoad(Int64Type, state);
		
		// dispatcher
		SwitchInst *state_switch  = builder.CreateSwitch(state_p, &firstBB, 1);
		// add initial state
		state_switch->addCase(state_zero, &firstBB);

		for (BasicBlock &bb : F)
		{
			LLVM_DEBUG(dbgs() << bb.getNameOrAsOperand() << "\n");
			if (bb.getNameOrAsOperand() == "EntryPoint")
				continue;

			if (BranchInst *branch_ins = dyn_cast<BranchInst>(bb.getTerminator())) {
				std::string type_str;
				llvm::raw_string_ostream rso(type_str);			

				bb.getTerminator()->print(rso);
				LLVM_DEBUG(dbgs() << rso.str() << "\n");
				LLVM_DEBUG(dbgs() << "Successors: " << branch_ins->getNumSuccessors() << "\n");

				if (branch_ins->getNumSuccessors() == 1) {
					state_value = ConstantInt::get(Int64Type, 1234);
					
					builder.SetInsertPoint(branch_ins);
					
					StoreInst *store_state_ins = builder.CreateStore(state_value, state);

					// branch_ins->eraseFromParent();
					// branch_ins->eraseFromParent();
				}
			}
		}
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
	  true, // This pass doesn't modify the CFG => true
	  false // This pass is not a pure analysis pass => false
	);