def get_5():
    print("Hello!")
    return 5

def double(x):
    # argument thunk is evaluated twice
    return x() + x()

double(lambda: get_5())
