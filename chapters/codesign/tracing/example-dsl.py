def capture_ir(): ...
def ir_to_ptx(ir): ...

# START_0
class jit:
    def __init__(self, func):
        self.func = func

    def __call__(self, *args):
        with capture_ir() as ir:
            self.func(*args)
        ptx = ir_to_ptx(ir)
# END_0


