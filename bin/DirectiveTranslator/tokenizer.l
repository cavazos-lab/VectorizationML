%{
#include <stdio.h>

#include "pragma_information.h"
#include "y.tab.h"

/* handle locations */
int yycolumn = 1;

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;
%}

%x INPRAGMA

pragma       #[ \t]*pragma[ \t]+VALT
ws           [\t ]+
newline      \n
slashnewline \\\n
lparen       \(
rparen       \)
comma        ,
number       [0-9]+
none         "none"
default      "default"
vectorsize   "vectorsize"
vector       "vector"
depend       "depend"
loop         "loop"
always       "always"
aligned      "aligned"
unaligned    "unaligned"
nontemp      "nontemp"
temp         "temp"
ignore       "ignore"
dist         "distribute"
nofusion     "nofusion"
unroll       "unroll"
jam          "jam"
word         [^\t\n ]+

%option noyywrap

%%

<INPRAGMA>{
  {lparen}       return LPAREN;
  {rparen}       return RPAREN;
  {comma}        return COMMA;
  {number}       yylval.num=atoi(yytext); return NUMBER;
  {none}         yylval.num=0; return NONE;
  {default}      yylval.num=-1; return DEFAULT;
  {vectorsize}   return VECTORSIZE;
  {vector}       return VECTOR;
  {depend}       return DEPEND;
  {loop}         return LOOP;
  {always}       return ALWAYS;
  {aligned}      return ALIGNED;
  {unaligned}    return UNALIGNED;
  {nontemp}      return NONTEMP;
  {temp}         return TEMP;
  {ignore}       return IGNORE;
  {dist}         return DISTRIBUTE;
  {nofusion}     return NOFUSION;
  {unroll}       return UNROLL;
  {jam}          return JAM;
  {ws}           /* do nothing */
  {slashnewline} yycolumn = 1; ++yylineno;
  {newline}      yycolumn = 1; ++yylineno; BEGIN(INITIAL);
  .              return WORD;
}

<INITIAL>{
  {pragma}        BEGIN(INPRAGMA); return PRAGMA;
  {slashnewline}  |
  {newline}       yylval.str = strdup (yytext); yycolumn = 1; ++yylineno; return CODE_BLOCK;
  {word}          yylval.str = strdup (yytext); return CODE_BLOCK;
  {ws}            yylval.str = strdup (yytext); return CODE_BLOCK;
}
