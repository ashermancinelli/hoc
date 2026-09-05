import os
import sys
import traceback
from dsl import *
from pprint import pprint

def relative_excepthook(type, value, tb):
    te = traceback.TracebackException(type, value, tb)
    for frame in te.stack:
        frame.filename = os.path.relpath(frame.filename)
    sys.stdout.write("".join(te.format()))

sys.excepthook = relative_excepthook

a, b, c = [], [], []

'''
# REGION loop-kernel-dyn
@jit
def kernel(a, N):
    for i in range(N):
        a[i] = i

kernel(a, 5)
# ENDREGION loop-kernel-dyn
'''

@jit
def kernel(a, N):
    for i in range(N):
        a[i] = i

try:
    kernel(a, 5)
except Exception as e:
    sys.excepthook(*sys.exc_info())
    sys.exit(0)
raise RuntimeError()
