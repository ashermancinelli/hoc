#import "../../macros.typ": *
#import "../../glossaries.typ": *

== Tracing JITs

AI kernel development typically requires the generation of lots of code specialized for specific
hardware and problem shapes and typical GPU programming models can make this difficult.
Prior to the popularization of tracing JITs, state of the art GPU programs were often written
using a CUDA C++ template library called CUTLASS, which has poor compile times and can
be difficult to use but can generate good performance from relatively high level information.
