from .example_dsl import *

# START_0
@jit
def kernel(a, b, c):
    for i in range(5):
        a[i] = a[i] + b[i] * c[i]

kernel(a, b, c)
# END_0
