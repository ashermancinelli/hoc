#import "../../macros.typ": *
#import "../../glossaries.typ": *

== Tracing DSLs

AI kernel development typically requires the generation of lots of code specialized for specific
hardware and problem shapes and typical GPU programming models can make this difficult.
Prior to the popularization of tracing JITs, state of the art GPU programs were often written
using a CUDA C++ template library called CUTLASS #citen(<nvidia_cutlass_2023>),
which can have poor compile times and be difficult to use but can generate good
performance from relatively high level information.

While not the first tracing DSL, Tensorflow's DSL #citen(<agrawal2019tensorflow>)
is a useful example because we have a well-established corpus of open-source Tensorflow
code both with and without the tracing DSL.
