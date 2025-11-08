static LLVMContext *Context;
static IRBuilder<> *Builder;
static Module *LLVMModule;

Function *createAddFunction() {
    Type *i32 = Builder->getInt32Ty();
    auto *FT = FunctionType::get(i32, {i32, i32}, /*isVarArg=*/false);
    auto *Func = Function::Create(FT, Function::ExternalLinkage,
                                  "add_ints", LLVMModule);
    auto *BB = BasicBlock::Create(*Context, "entry", Func);
    Builder->SetInsertPoint(BB);
    auto LHS = Func->getArg(0);
    auto RHS = Func->getArg(1);
    auto Result = Builder->CreateAdd(LHS, RHS);
    Builder->CreateRet(Result);
    return Func;
}
