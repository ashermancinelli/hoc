// clang++ $(llvm-config --cxxflags --ldflags --system-libs --libs core) chapters/codesign/llvm-full-example.cpp && ./a.out
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>
#include <stdio.h>

using namespace llvm;

#include "llvm-example.cpp"

int main() {
    auto context = std::make_unique<LLVMContext>();
    Context = context.get();
    IRBuilder<> builder(*context);
    Builder = &builder;
    auto module = std::make_unique<Module>("example", *context);
    LLVMModule = module.get();
    createAddFunction();

    module->print(llvm::outs(), nullptr);

    return 0;
}
