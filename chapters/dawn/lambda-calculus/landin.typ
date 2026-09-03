#import "../../../macros.typ": *
#import "../../../glossaries.typ": *


=== Peter Landin on the Lambda Calculus

 <sec:landin-lambda-calculus>

Exemplary of the varied approaches to formalizing the design of ALGOL 60,
Peter Landin sought to express the language's semantics in the
λ-calculus in #cite(<landin_algol_lambda_1965>, form: "normal")
#footnote[See #xref(<sec:algol60>, capital: false) for more details on the development of ALGOL 60.].
A few years earlier, McCarthy adopted some components of the λ-calculus in
Lisp, however McCarthy's language broke with λ in a few key areas,
namely #gls("dynamic-binding")
#footnote[ For a more complete treatment of Lisp, see #xref(<sec:lisp>, capital: false). ].
ALGOL's semantics provided a much cleaner relationship to λ, thanks to
its block structure and lexical scoping rules, thus Landin
made it possible to look at λ as a programming language in and of itself
in a more complete way than McCarthy had done with Lisp.

In parallel with his translation of ALGOL, Landin developed in
#cite(<landin_eval_of_expressions_1964>, form: "normal") an abstract machine for
λ called the #emph[SECD-machine].
