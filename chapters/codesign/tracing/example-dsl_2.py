@jit
def kernel(a, b, c):
    for i in range(5):
        a[i] = a[i] + b[i] * c[i]

kernel(a, b, c)
