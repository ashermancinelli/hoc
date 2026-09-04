class jit:
    def __init__(self, func):
        self.func = func

    def __call__(self, *args):
        # First stage
        syms = (to_symbol(arg) for arg in args)
        with capture_ir() as ir:
            self.func(*syms)
        # Second stage
        dso = ir_to_native(ir)
        func = load_function_pointer_from_dso(dso)
        func(*args) # or launch on GPU with driver api

