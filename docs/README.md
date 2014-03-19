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