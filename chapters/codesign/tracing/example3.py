from example_dsl import *
_print = print
from pprint import pprint as print
a, b, c = [], [], []

_print('# Dynamic bounds')
# REGION dyn
@jit
def kernel(a, N):
    @fori(N) # dynamic loop bounds
    def loop_body(i):
        a[i] = i

kernel(a, 5)
print(kernel.ir)
# ENDREGION dyn

_print('# Static bounds')
# REGION static
@jit
def kernel(a):
    @fori(5) # static loop bounds
    def loop_body(i):
        a[i] = i

kernel(a)
print(kernel.ir)
# ENDREGION static
