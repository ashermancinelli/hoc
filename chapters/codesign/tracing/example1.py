from .example_dsl import *
from pprint import pprint

a, b, c = [], [], []

# REGION loop-kernel
@jit
def kernel(a):
    for i in range(5):
        a[i] = i

kernel(a)
# ENDREGION loop-kernel

print('# First iteration only')
pprint(get_last_ir()[:6] + [ellipsis])
