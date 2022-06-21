#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iterator>
#include <cmath>
#include <limits.h>
#include <fstream>
#include <errno.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <stdio.h>
#include <regex>

#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/Debug.h"
#include "llvm/Linker/IRMover.h"
#include "llvm/Transforms/Utils/Cloning.h"

#define DEBUG_TYPE "stringfuscator"

using namespace llvm;

namespace stringfuscator
{

std::string string_to_hex(const std::string& input)
{
    static const char hex_digits[] = "0123456789ABCDEF";
    
    std::string output;
    output.reserve(input.length() * 2);
    for (unsigned char c : input)
    {
        output.push_back(hex_digits[c >> 4]);
        output.push_back(hex_digits[c & 15]);
    }
    return output;
}

std::string gen_random(const int len) {
    static const char alphanum[] =
    "0123456789"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz";
    std::string tmp_s;
    tmp_s.reserve(len);
    
    for (int i = 0; i < len; ++i) {
        tmp_s += alphanum[rand() % (sizeof(alphanum) - 1)];
    }
    
    return tmp_s;
}

/*
 * ---------------------------------------------------------
 * encode_str --
 *
 *  Apply xor on bytes (data) with key (key).
 *
 * Results:
 *  Xored bytes stored in memory pointed by data variable;
 * ---------------------------------------------------------
 */
std::string
encode_str(unsigned char key[], size_t key_len, const char * data, size_t data_len)
{
    std::string tmp(data_len, 0);
    
    for (int i = 0; i < data_len; i++) {
        unsigned char ch = static_cast<unsigned char>(data[i]);
        tmp[i] = ch == 0 ? 0 : ch ^ key[i % key_len];
    }
    
    return tmp;
}

char *
read_file_alloc (const char *file_path, size_t * file_len) {
    FILE *fp;
    size_t fsize;
    char *buffer;
    
    if (!(fp = fopen(file_path, "r"))) {
        errs() << "fopen() " << strerror(errno);
        return nullptr;
    }
    
    if (fseek(fp, 0, SEEK_END) != 0) {
        errs() << "fseek(..., SEEK_END) " << strerror(errno);
        return nullptr;
    }
    
    if(!(fsize = ftell(fp))) {
        errs() << "ftell() " << strerror(errno);
        return nullptr;
    }
    
    if (fseek(fp, 0, SEEK_SET) != 0) {
        errs() << "fseek(..., SEEK_SET) " << strerror(errno);
        return nullptr;
    }
    
    
    if (!(buffer = (char *)malloc(fsize))) {
        errs() << "malloc() " << strerror(errno);
        return nullptr;
    }
    
    if (!fread(buffer, 1, fsize, fp)) {
        errs() << "fread error\n";
        return nullptr;
    }
    
    *file_len = fsize;
    
    return buffer;
}

std::string
parse_xor_module (const char * var_name, unsigned int encoded_str_len,unsigned int elem_count, unsigned int elem_size, unsigned char * key, unsigned int key_len)
{
    size_t file_len;
    
    char * ir_fmt;
    //    char * prepared_key_ir = nullptr;
    //    char * ir_str = nullptr;
    
    if (!(ir_fmt = read_file_alloc("/Users/mlsdmitry/Documents/spbctf/tools/llvm_proj/examples/xor.ll", &file_len))) {
        return nullptr;
    }
    
    std::string ir_str(ir_fmt);
    free(ir_fmt);
    
    ir_str = std::regex_replace(ir_str, std::regex("KEY_LENGTH"), std::to_string(key_len));
    ir_str = std::regex_replace(ir_str, std::regex("ELEM_COUNT"), std::to_string(elem_count));
    ir_str = std::regex_replace(ir_str, std::regex("ELEM_SIZE"), std::to_string(elem_size));
    ir_str = std::regex_replace(ir_str, std::regex("KEY_NAME"), "key");
    ir_str = std::regex_replace(ir_str, std::regex("KEY_VALUE"), std::string(elem_count * (elem_size / 8), 'A'));
    ir_str = std::regex_replace(ir_str, std::regex("STR_LENGTH"), std::to_string(encoded_str_len));
    
    LLVM_DEBUG(dbgs() << "IR Str: " << ir_str);
    
    //    free(ir_fmt);
    //    free(prepared_key_ir);
    //    free(ir_str);
    
    return ir_str;
    //    asprintf(ir_str, fmt, key_len, prepared_key_ir., );
}

/*
 * prngkey --
 *
 *  Generate pseudo-random integer without zeroes and save each byte in key_out.
 *
 * Results:
 *  Pseudo random integer with sizeof key_len saved in key_out.
 *
 */
void
prngkey(unsigned char * key_out, size_t key_len)
{
    for (int i = 0; i < key_len; i++) {
        key_out[i] = (unsigned char)(rand() % 0xFF + 1);
    }
}

GlobalVariable *
create_gv(GlobalVariable &src_gvar, Constant *new_const)
{
    return new GlobalVariable(src_gvar.getType(), src_gvar.isConstant(), src_gvar.getLinkage(), new_const, Twine(gen_random(10)), src_gvar.getThreadLocalMode(), src_gvar.getType()->getAddressSpace());
}

void
encode_const(Module &m, GlobalVariable &global_var)
{
    unsigned char key[4] = { 0 };
    unsigned int key_len = sizeof(key);
    LLVMContext &ctx = m.getContext();
    ConstantInt *Zero = ConstantInt::get(Type::getInt64Ty(ctx), 0);
    
    // check if constant is an array
    if (ConstantDataArray *const_arr = dyn_cast<ConstantDataArray>(global_var.getInitializer()))
    {
        size_t str_len = const_arr->getRawDataValues().size();
        LLVM_DEBUG(dbgs() << "Global variable value: " << const_arr->getRawDataValues());
        
        // generate pseudo-random key
        prngkey(key, 4);
        
        std::string new_str = encode_str(key, 4, const_arr->getRawDataValues().data(), str_len);
        
        LLVM_DEBUG(dbgs() << "Key: " << *(int *)&key << "\n");
        LLVM_DEBUG(dbgs() << "Encoded bytes: " << "\n");
        LLVM_DEBUG(dbgs() << string_to_hex(new_str) << "\n");
        LLVM_DEBUG(dbgs() << "global var name: " << global_var.getName() << "\n");
        
        Constant *encoded_const = ConstantDataArray::getRaw(StringRef(new_str), const_arr->getNumElements(), const_arr->getElementType());
        
        Type *char_type = const_arr->getElementType();
        TypeSize char_size = const_arr->getElementType()->getPrimitiveSizeInBits();
        
        
        LLVM_DEBUG(dbgs() << "Elements num: " << const_arr->getNumElements() << "\n");
        LLVM_DEBUG(dbgs() << "Element type: " << char_size << "\n");
        LLVM_DEBUG(dbgs() << "Element scalar type: " << const_arr->getElementType()->getScalarSizeInBits() << "\n");
        
        global_var.setInitializer(encoded_const);
        
        Function *encode_alloc_func = m.getFunction("encode_alloc");
        Function *encode_free_func = m.getFunction("encode_free");
        FunctionCallee enc_alloc_callee = FunctionCallee(encode_alloc_func);
        FunctionCallee enc_free_callee = FunctionCallee(encode_free_func);
        
        
        for (User *user : global_var.users()) {
//            user->print(rso);
            if (GetElementPtrInst* ins = dyn_cast<GetElementPtrInst>(user)) {
                LLVM_DEBUG(dbgs() << "Found getlementptr");
            }
//            LLVM_DEBUG(dbgs() << rso.str());
//            Type *user_type = user->getType();
            for (User *user2 : user->users()) {
//                user2->print(rso);
//                LLVM_DEBUG(dbgs() << rso.str());
//                user_type = user2->getType();
                if (Instruction* ins = dyn_cast<Instruction>(user2)) {
//                    ins->print(rso);
//                    LLVM_DEBUG(dbgs() << "Ins type: " << rso.str());
                    IRBuilder<> builder(ins);
					
                    Value *indices[2] = {Zero, Zero};
					
                    
					auto *key_gep = builder.CreateInBoundsGEP(global_var.getType()->getPointerElementType(), &global_var, ArrayRef<Value *>(indices, 2));
                    
                    Value *args[] = {
                        key_gep,
                        ConstantInt::get(Type::getInt64Ty(ctx), const_arr->getNumElements()),
                        key_gep,
                        ConstantInt::get(Type::getInt64Ty(ctx), const_arr->getNumElements())
                    };
                    
//                    args.push_back(key_gep);
//                    args.push_back(ConstantInt::get(Type::getInt64Ty(ctx), const_arr->getNumElements()));
//
//                    args.push_back(key_gep);
//                    args.push_back(ConstantInt::get(Type::getInt64Ty(ctx), const_arr->getNumElements()));
                    
                    builder.CreateCall(m.getFunction("encode_alloc"), args);
                } else {
                    LLVM_DEBUG(dbgs() << "Not an Instruction\n");
                }

            }
        }

//        global_var.setInitializer()
//        GlobalVariable * new_gv = create_gv(global_var, const_ptr);
//        global_var.replaceAllUsesWith(new_gv);
    
    } else {
        LLVM_DEBUG(dbgs() << "Not a ConstantDataArray\n");
    }
}

void
replace_gv(GlobalVariable &orig_vg, GlobalVariable &new_gw)
{
    
}

void visitor(Module &m)
{
    // IRBuilder<> builder(m.getContext());
//    for (Function &f : m.getFunctionList()) {
//        for (BasicBlock &bb : f) {
//            for (Instruction &ins : bb) {
//                std::string type_str;
//                llvm::raw_string_ostream rso(type_str);
//                ins.print(rso);
//                LLVM_DEBUG(dbgs() << rso.str() << "\n");
//            }
//        }
//    }
//
    for (GlobalVariable &global_var : m.getGlobalList())
    {
        LLVM_DEBUG(dbgs() << "\nGlobal var name: " << global_var.getName() << "\n");
        // cannot get value from external global var
        if (global_var.isExternallyInitialized() || !global_var.hasInitializer()) {
            LLVM_DEBUG(dbgs() << "Global variable is external or doesn't have an initializer\n");
            continue;
        }
        
        encode_const(m, global_var);
//        break;
        // if (ConstantArray *const_arr = cast<ConstantArray>(global_var.getInitializer()))
        // errs() << "Global var: " << globalVar.getName() << "\n";
    }
    errs() << "Module name: " << m.getName() << "\n";
}

struct StringObfuscator : PassInfoMixin<StringObfuscator>
{
    PreservedAnalyses run(Module &m, ModuleAnalysisManager &mm)
    {
        visitor(m);
        return PreservedAnalyses::all();
    }
};

// Legacy PM implementation
struct LegacyStringObfuscator : public ModulePass {
    static char ID;
    LegacyStringObfuscator() : ModulePass(ID) {}
    // Main entry point - the name conveys what unit of IR this is to be run on.
    bool runOnModule(Module &m) override {
        visitor(m);
        // Doesn't modify the input unit of IR, hence 'false'
        return true;
    }
};
} // namespace

PassPluginLibraryInfo getStringObfuscatorPluginInfo()
{
    return {
        LLVM_PLUGIN_API_VERSION,
        "stringfuscator",
        LLVM_VERSION_STRING,
        [](PassBuilder &pb)
        {
            pb.registerPipelineParsingCallback(
                                               [](StringRef name, ModulePassManager &fpm,
                                                  ArrayRef<PassBuilder::PipelineElement>)
                                               {
                                                   if (name == "stringfuscator")
                                                   {
                                                       fpm.addPass(stringfuscator::StringObfuscator());
                                                       return true;
                                                   }
                                                   return false;
                                               });
        }};
}


extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo()
{
    return getStringObfuscatorPluginInfo();
}

//-----------------------------------------------------------------------------
// Legacy PM Registration
//-----------------------------------------------------------------------------
// The address of this variable is used to uniquely identify the pass. The
// actual value doesn't matter.
char stringfuscator::LegacyStringObfuscator::ID = 0;

// This is the core interface for pass plugins. It guarantees that 'opt' will
// recognize LegacyHelloWorld when added to the pass pipeline on the command
// line, i.e.  via '--legacy-hello-world'
static RegisterPass<stringfuscator::LegacyStringObfuscator>
X("legacy-string-obfuscator", "String Obfuscator Pass",
  true, // This pass doesn't modify the CFG => true
  true // this pass modify IR
);
