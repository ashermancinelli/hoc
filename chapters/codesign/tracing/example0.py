from example_dsl import *
from pprint import pprint

a, b, c = [], [], []

# REGION scalar-kernel
@jit
def kernel(a, b, c):
    a[0] = a[0] + b[0] * c[0]

kernel(a, b, c)
# ENDREGION scalar-kernel

pprint(kernel.ir)
