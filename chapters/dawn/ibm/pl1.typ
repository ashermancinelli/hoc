#import "../../../macros.typ": *
#import "../../../glossaries.typ": *



=== PL/1

NPL was later renamed to PL/I.

PL/1 used in the development of the Amber OS
#cite(<frankston_amber_os_bach_thesis_pastel_compiler_mit_1984>, form: "normal").

#quote(block: true)[
PL/I was chosen as the programming language in 1964. Other
	possibilities were a port of MAD (the Michigan Algorithm Display) or a
	port of AED-0 (an MIT display). The full PL/I language was harder to
	implement than expected. A contract was awarded to an outside firm
	to produce a PL/I compiler, and BTL administered the contract. The
	contractor assigned two people and had produced no compiler a year
	later. Bob Morris and Doug Mcllroy (at BTL) created a back-up plan for
	a PL/I compiler, using McClure's TMG language on the 7094.
	This language was called EPL (Early PL/I).
	#cite(<salus_quarter_century_unix_1994>, form: "normal").
]

#todo[
  See @Priestley2008_logic_dev_of_pl_1930_1975[6.4 Different philosophies of programming language design]
  for nice concise discussion of PL/I.
]

NPL would go on to become PL/I.
One of the core design principles would be (@Randin1965_NPL_highlights_of_new_pl):

#quote(block: true)[
  1. _Anything Goes._ 
    If a particular combination of symbols has a reasonably sensible meaning, that meaning will
    be made official An NPL compiler should normally have
    no permissive diagnostics ("This is wrong but I am so
    smart that I know what you really mean."); it should
    have many warning messages ("Are you sure you want to
    do this strange thing?"). This will help to insure realistic
    compatibility between different NPL compilers,
]

#todo[
  Is it true that PL/I went on to be the language used for space stuff?
  Steve Scalpone might have mentioned that it's still got some prop compiler
  teams working on it on the east coast.
]

=== COMTRAN

