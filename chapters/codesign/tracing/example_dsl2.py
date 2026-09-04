from .example_dsl import a, b, c, jit

# START_0
@jit
def kernel(a, b, c):
    for i in range(5):
        a[i] = a[i] + b[i] * c[i]

def main():
    kernel(a, b, c)
# END_0

if __name__ == "__main__":
    main()
