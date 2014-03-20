Considerations For ML Training
==============================
* -vec-report (n)
* execution time
* graph representation

What should the compiler baseline be? What flags / target?

Can we compare to `-guided-vec`

Mucocos


Directives We Will Support
==========================

how to vectorize
----------------
* `#pragma vector always`
* `#pragma vector aligned|unaligned`
* `#pragma vector nontemporal|temporal`

* `#pragma novector`

dependencies
------------
* `#pragma ivdep`

data length
-----------
* `#pragma simd vectorlength[n]`

loop transformations
--------------------
* `#pragma unroll|unroll_and_jam [n]`
* `#pragma distribute_point`
* `#pragma nofusion`

Tokens
======
```
LPAREN           (
RPAREN           )
COMMA            ,
W                whole number (I >= 0)
N                natural number (I >= 1)

NONE             none
DEFAULT          default

PRAGMA           #pragma

VECTORSTATEMENT  vector
DEPENDSTATEMENT  depend
LOOPSTATEMENT    loop
VECTORSIZE       vectorsize

ALWAYS           always
ALIGNED          aligned
UNALIGNED        unaligned
NONTEMP          nontemp
TEMP             temp
IGNORE           ignore
DISTRIBUTE       distribute
NOFUSION         nofusion
UNROLL           unroll
JAM              jam
```
Directive Grammar
=================
```
$Directive := PRAGMA $Clause $ClauseList

$ClauseList := $Clause $ClauseList
            |  e

$Clause := $VectorClause
        |  $DepClause
        |  $LengthClause
        |  $LoopClause

$VectorClause := VECTORSTATEMENT LPAREN $VectorList RPAREN

$VectorList := NONE
            |  $VectorItems
            |  $VectorItem

$VectorItems := $VectorItem COMMA $VectorItems
             |  $VectorItem

$VectorItem := ALWAYS
            |  ALIGNED
            |  UNALIGNED
            |  NONTEMP
            |  TEMP

$DepClause := DEPENDSTATMENT LPAREN $DepOption RPAREN

$DepOption := IGNORE
           |  DEFAULT

$LengthClause := VECTORSIZE LPAREN $LengthValue RPAREN

$LengthValue := N

$LoopClause := LOOPSTATEMENT LPAREN $LoopList RPAREN

$LoopList := $LoopItems
          |  $LoopItem

$LoopItems := $LoopItem COMMA $LoopItem
           |  $LoopItem

$LoopItem := $UnrollOrJamStmt
          |  DISTRIBUTE
          |  NOFUSION

$UnrollOrJamStmt := $UnrollType $UnrollOption

$UnrollType := UNROLL
            |  JAM

$UnrollOption := LPAREN $UnrollOptionType RPAREN
              |  e

$UnrollOptionType := NONE
                  |  DEFAULT
                  |  $UnrollOptionValue

$UnrollOptionValue := W
```

Directive Parsing
=================

All directives are parsed left-to-right with any later option overriding a previously set option

Examples
--------

1. `#pragma <name> vector(none) loop(unroll(4), distribute)`
   Results in no vectorization but will unroll by a factor of and split if necessary
2. `#pragma <name> vector(always,temp) vectorsize(8) loop(nofusion)`
   Results in vectorization with temporal stores and a vector size of 8. Loop is never fused.
3. `#pragma <name> vector(always) depend(ignore) loop(jam)`
   Results in vectorization with no dependence checking (ignores). Loop is unrolled and jammed.
4. `pragma <name> vector(aligned) vectorsize(4) depend(default) loop(jam (8), nofusion, distribute)`
   Results in aligned vectorization code with a vector size of 4. Dependencies are used to determine vectorization. Loop is jammed and unrolled by a factor of 8 with no fusion. Loop will be split if necessary.
