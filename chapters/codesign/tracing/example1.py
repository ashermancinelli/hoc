from example_dsl import jit

a, b, c = [], [], []

# START_1
@jit
def kernel(a, b, c):
    a[0] = a[0] + b[0] * c[0]

kernel(a, b, c)
# END_1
