from typing import Callable
import textwrap
from contextlib import contextmanager
from dataclasses import dataclass, field
from pprint import pprint, pformat

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

class Symbol: ...

@dataclass(frozen=True)
class Op:
    name: str
    operands: tuple
    result: Symbol | None = None

    def __repr__(self):
        op = f'{self.name}(' + (', '.join(pformat(i) for i in self.operands)) + ')'
        if self.result is None:
            return op
        return pformat(self.result) + ' = ' + op

@dataclass
class InsertionPoint:
    ref: object = None
    def append(self, other):
        self.ref.append(other)
        return other.result
    def __getitem__(self, *args):
        return self.ref.__getitem__(*args)

ip = InsertionPoint()
_id = 0

@contextmanager
def insertion_point(new_body):
    old = ip.ref
    ip.ref = new_body
    yield
    ip.ref = old

def gensym():
    global _id
    # pyrefly: ignore [division-by-zero]
    s = '%d' % _id
    _id += 1
    return s

class SymbolicScalar(Symbol):
    def __repr__(self): return f'SymbolicScalar{self.name}'
    def __init__(self, thing=None, name=None):
        self.thing = thing
        self.name = name or gensym()
    def __add__(self, other):
        return ip.append(Op('add', (self, other), result=SymbolicScalar()))
    def __mul__(self, other):
        return ip.append(Op('mul', (self, other), result=SymbolicScalar()))

class SymbolicArray(Symbol):
    def __repr__(self): return f'SymbolicArray{self.name}'
    def __init__(self, real_array, name=None):
        self.real_array = real_array
        self.name = name or gensym()
    def __getitem__(self, indices):
        return ip.append(Op('getitem', (self, indices), result=SymbolicScalar()))
    def __setitem__(self, indices, value):
        return ip.append(Op('setitem', (self, indices, value)))

INDENT = ' ' * 4

@dataclass(frozen=True, kw_only=True)
class RuntimeLoop:
    bounds: range
    induction_variable: SymbolicScalar = field(default_factory=SymbolicScalar)
    body: Callable[[int], None] = field(default_factory=list)
    result = None

    def __repr__(self):
        s = f'for {self.induction_variable} in range({self.bounds}):\n'
        body = '\n'.join(pformat(i) for i in self.body)
        s += textwrap.indent(body, INDENT)
        return s


@dataclass(frozen=True)
class FunctionIR:
    name: str
    block_args: list
    body: list

    def __repr__(self):
        body = f'def {self.name}(' + ', '.join(pformat(i) for i in self.block_args) + '):\n'
        body += textwrap.indent('\n'.join(pformat(i) for i in self.body), INDENT)
        return body

# REGION for-decorator
def fori(bounds):
    def decorator(body):
        match bounds:
            case int():
                # Evaluate the loop in Python
                for i in range(bounds):
                    body(i)
            case SymbolicScalar():
                # Defer evaluation of the loop by turning it into IR
                loop = RuntimeLoop(bounds=bounds)
                with insertion_point(loop.body):
                    body(loop.induction_variable)
                ip.append(loop)
            case _:
                raise TypeError()
    return decorator
# ENDREGION for-decorator

def to_symbol(runtime_value):
    match runtime_value:
        case int() | float():
            return SymbolicScalar(runtime_value)
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
        self.ir = None

    def __call__(self, *args):
        # First stage
        block_args = tuple(to_symbol(arg) for arg in args)
        self.ir = FunctionIR(self.func.__name__, block_args, [])
        with insertion_point(self.ir.body):
            self.func(*block_args)
        # Second stage
        dso = ir_to_native(self.ir)
        func = load_function_pointer_from_dso(dso)
        func(*args) # or launch on GPU with driver api
# ENDREGION jit
