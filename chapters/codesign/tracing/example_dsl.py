from contextlib import contextmanager
from dataclasses import dataclass
from pprint import pprint

@dataclass(frozen=True)
class Op:
    name: str
    operands: tuple

_ir = []

class SymbolicScalar():
    def __repr__(self): return 'SymbolicScalar'
    def __init__(self, thing):
        self.thing = thing
    def __add__(self, other):
        _ir.append(Op('add', (self, other)))
        return SymbolicScalar(_ir[-1])
    def __mul__(self, other):
        _ir.append(Op('mul', (self, other)))
        return SymbolicScalar(_ir[-1])

class SymbolicArray():
    def __repr__(self): return 'SymbolicArray'
    def __init__(self, real_array):
        self.real_array = real_array
    def __getitem__(self, indices):
        _ir.append(Op('getitem', (self, indices)))
        return SymbolicScalar(_ir[-1])
    def __setitem__(self, indices, value):
        _ir.append(Op('setitem', (self, indices, value)))

@contextmanager
def capture_ir():
    _ir.clear()
    yield _ir
    pprint(_ir)

def to_symbol(runtime_value):
    match runtime_value:
        case int() | float():
            return runtime_value
        case list():
            return SymbolicArray(runtime_value)
        case _:
            raise TypeError()

def ir_to_native(ir): return None
def load_function_pointer_from_dso(dso): return lambda *x: None

# START_0
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

# END_0

a, b, c = [], [], []

# START_1
@jit
def kernel(a, b, c):
    a[0] = a[0] + b[0] * c[0]

def main():
    kernel(a, b, c)
# END_1

if __name__ == "__main__":
    main()
