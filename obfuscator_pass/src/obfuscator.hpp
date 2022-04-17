#pragma once

#include <llvm/IR/PassManager>

namespace llvm
{

    class ObfuscatorPass : public PassInfoMixin<ObfuscatorPass>
    {
    public:
        PreservedAnalyses run(Function &f, FunctionAnalysisManager, &am);
    }

}