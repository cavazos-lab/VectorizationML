%{
#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>
#include <string.h>

#include "pragma_information.h"

#define YYSTYPE int

  typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
  } YYLTYPE;
#define YYLTYPE_IS_DECLARED 1

#define YYERROR_VERBOSE 1
  
  extern YYLTYPE yylloc;
  extern int yylex();
  
  options_t myOptions;

  void yyerror (char *s, ...)
  {
    va_list ap;
    va_start(ap, s);
    
    if (yylloc.first_line)
    {
      if (yylloc.first_line == yylloc.last_line)
      {
        fprintf (stderr, "Error! (%d:%d-%d): ", yylloc.first_line, yylloc.first_column, yylloc.last_column); 
      }
      else
      {
        fprintf (stderr, "Error! (%d:%d-%d:%d): ", yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);
      }
    }
    vfprintf (stderr, s, ap);
    fprintf (stderr, "\n");
  }
  
%}

%locations
%start directive

%token DIRECTIVE_CODE LPAREN RPAREN COMMA NUMBER PRAGMA NONE DEFAULT VECTORSTATEMENT DEPENDSTATEMENT LOOPSTATEMENT VECTORSIZE ALWAYS ALIGNED UNALIGNED NONTEMP TEMP IGNORE DISTRIBUTE NOFUSION UNROLL JAM

%%

directive : PRAGMA DIRECTIVE_CODE clause clauselist
;

clauselist : clause clauselist
| clause COMMA clauselist
| /* */
;

clause : vectorclause
| depclause
| lengthclause
| loopclause
;

vectorclause: VECTORSTATEMENT LPAREN vectorlist RPAREN
;

vectorlist: NONE { myOptions.vector.novector = true; }
| vectoritem
| vectoritem COMMA vectorlist
;

vectoritem: ALWAYS { myOptions.vector.always = true; }
| ALIGNED { myOptions.vector.align_value = ALIGNED_; }
| UNALIGNED { myOptions.vector.align_value = UNALIGNED_; }
| NONTEMP { myOptions.vector.temp_value = NONTEMP_; }
| TEMP  { myOptions.vector.temp_value = TEMP_; }
;

depclause: DEPENDSTATEMENT LPAREN depoption RPAREN
;

depoption: IGNORE { myOptions.ignoreDep = true; }
| DEFAULT { myOptions.ignoreDep = false; }
;

lengthclause: VECTORSIZE LPAREN NUMBER RPAREN
{ myOptions.vsize = $3; }
;

loopclause: LOOPSTATEMENT LPAREN looplist RPAREN
;

looplist: loopitem
| loopitem COMMA looplist
;

loopitem: UNROLL { myOptions.loop.unroll = 0; myOptions.loop.jam = DEFAULT_VALUE; }
| UNROLL LPAREN NUMBER RPAREN { myOptions.loop.unroll = $3; myOptions.loop.jam = DEFAULT_VALUE; }
| JAM { myOptions.loop.jam = 0; myOptions.loop.unroll = DEFAULT_VALUE; }
| JAM LPAREN NUMBER RPAREN { myOptions.loop.jam = $3; myOptions.loop.unroll = DEFAULT_VALUE; }
| DISTRIBUTE { myOptions.loop.dist = true; }
| NOFUSION { myOptions.loop.nofusion = true; }
;
