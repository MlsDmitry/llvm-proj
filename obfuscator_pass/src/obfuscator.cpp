#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace
{
    void visitor(Function &f)
    {
        const DataLayout &dl = f.getParent()->getDataLayout();

        errs() << "(test) func name: " << f.getName() << "\n";

        for (Instruction &ins : instructions(f)) {
            errs() << "(test) opcode name: " << ins.getOpcodeName() << "\n";
            errs() << "(test) may read? " << ins.mayReadFromMemory() << "\n";
            errs() << "(test) may wite? " << ins.mayWriteToMemory() << "\n";
        }
    }

    struct Obfuscator : PassInfoMixin<Obfuscator>
    {
        PreservedAnalyses run(Function &f, FunctionAnalysisManager &am)
        {
            visitor(f);
            return PreservedAnalyses::all();
        }
    };

}

PassPluginLibraryInfo getObfuscatorPluginInfo()
{
    return {
        LLVM_PLUGIN_API_VERSION,
        "obfuscator",
        LLVM_VERSION_STRING,
        [](PassBuilder &pb)
        {
            pb.registerPipelineParsingCallback(
                [](StringRef name, FunctionPassManager &fpm,
                   ArrayRef<PassBuilder::PipelineElement>)
                {
                    if (name == "obfuscator")
                    {
                        fpm.addPass(Obfuscator());
                        return true;
                    }
                    return false;
                });
        }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo()
{
    return getObfuscatorPluginInfo();
}