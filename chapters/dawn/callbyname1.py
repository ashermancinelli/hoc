def get_5():
    print("Hello!")
    return 5

def double(x):
    return x + x

# Prints "Hello!" once with call-by-value
# and twice with call-by-name
double(get_5())
