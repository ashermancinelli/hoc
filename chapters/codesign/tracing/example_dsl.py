from contextlib import contextmanager
from dataclasses import dataclass
from pprint import pprint

class Ellipsis:
    def __repr__(self):
        return '...'

ellipsis = Ellipsis()

def comment(text):
    class Comment:
        def __init__(self, text):
            self.text = text
        def __repr__(self):
            return '# ' + self.text
    return Comment(text)

@dataclass(frozen=True)
class Op:
    name: str
    operands: tuple

_ir = []
_id = 0

def gensym():
    global _id
    s = '$%d' % _id
    _id += 1
    return s

class SymbolicScalar():
    def __repr__(self): return f'SymbolicScalar{self.name}'
    def __init__(self, thing, name=None):
        self.thing = thing
        self.name = name or gensym()
    def __add__(self, other):
        _ir.append(Op('add', (self, other)))
        return SymbolicScalar(_ir[-1])
    def __mul__(self, other):
        _ir.append(Op('mul', (self, other)))
        return SymbolicScalar(_ir[-1])

class SymbolicArray():
    def __repr__(self): return f'SymbolicArray{self.name}'
    def __init__(self, real_array, name=None):
        self.real_array = real_array
        self.name = name or gensym()
    def __getitem__(self, indices):
        _ir.append(Op('getitem', (self, indices)))
        return SymbolicScalar(_ir[-1])
    def __setitem__(self, indices, value):
        _ir.append(Op('setitem', (self, indices, value)))

def get_last_ir():
    global _ir
    return _ir

@contextmanager
def capture_ir():
    _ir.clear()
    yield _ir

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

# REGION jit
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
# ENDREGION jit
