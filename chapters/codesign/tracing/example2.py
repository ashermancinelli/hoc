from .example_dsl import *
from pprint import pprint

a, b, c = [], [], []

# REGION loop-kernel-dyn
@jit
def kernel(a, N):
    for i in range(N):
        a[i] = i

kernel(a, 5)
# ENDREGION loop-kernel-dyn

print('# First iteration only')
pprint(get_last_ir()[:6] + [ellipsis])
