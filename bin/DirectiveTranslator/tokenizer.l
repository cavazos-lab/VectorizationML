%{
#include <stdio.h>
#include "y.tab.h"

/* handle locations */
int yycolumn = 1;

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;
%}

%option noyywrap

%%
\(           return LPAREN;
\)           return RPAREN;
,            return COMMA;
[0-9]+       yylval=atoi(yytext); return NUMBER;
"VALT"       return DIRECTIVE_CODE;
"#pragma"    return PRAGMA;
"none"       yylval=0; return NONE;
"default"    yylval=-1; return DEFAULT;
"vectorsize" return VECTORSIZE;
"vector"     return VECTOR;
"depend"     return DEPEND;
"loop"       return LOOP;
"always"     return ALWAYS;
"aligned"    return ALIGNED;
"unaligned"  return UNALIGNED;
"nontemp"    return NONTEMP;
"temp"       return TEMP;
"ignore"     return IGNORE;
"distribute" return DISTRIBUTE;
"nofusion"   return NOFUSION;
"unroll"     return UNROLL;
"jam"        return JAM;             
[ \t]+       /* do nothing */
\n           yycolumn = 1; ++yylineno; /* newlines are cool */
\\\n         yycolumn = 1; ++yylineno; /* escaped newlines are cool, too */
.            return JUNK;
%%

