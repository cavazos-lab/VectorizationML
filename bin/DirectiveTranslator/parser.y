%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>
#include <string.h>

#include "pragma_information.h"

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

  char* output;
  
  void yyerror (const char *s, ...)
  {
    va_list ap;
    va_start(ap, s);
    
    if (yylloc.first_line)
    {
      if (yylloc.first_line == yylloc.last_line)
      {
        if (yylloc.first_column == yylloc.last_column)
        {
          fprintf (stderr, "Error! (%d:%d): ", yylloc.first_line, yylloc.first_column);
        }
        else
        {
          fprintf (stderr, "Error! (%d:%d-%d): ", yylloc.first_line, yylloc.first_column, yylloc.last_column); 
        }
      }
      else
      {
        fprintf (stderr, "Error! (%d:%d-%d:%d): ", yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);
      }
    }
    vfprintf (stderr, s, ap);
    fprintf (stderr, "\n");
  }


#define SET_OPTION($$,key,val)                   \
  {                                              \
    $$ = default_options_ptr();                  \
    $$ -> key = val;                             \
  } 
  
  char* merge_strings (char* first, char* second)
  {
    char* result;
    result = (char*)malloc (strlen (first) + strlen (second) + 2);
    *result = '\0';
    strncat (result, first, strlen (first));
    strncat (result, second, strlen (second));
    return result;
  }

  char* merge_strings_free (char* first, char* second)
  {
    char* result = merge_strings (first, second);
    free (first);
    free (second);
    first = second = NULL;
    return result;
  }
  
%}

%union {
  int num;
  char* str;
  options_t* options;
}

%token<num> LPAREN RPAREN COMMA NUMBER PRAGMA NONE DEFAULT VECTOR DEPEND LOOP VECTORSIZE ALWAYS ALIGNED UNALIGNED NONTEMP TEMP IGNORE DISTRIBUTE NOFUSION UNROLL JAM
%type<num> number_or_error

%token<str> CODE_BLOCK WORD
%type<str> entry program code

%type<options> directive clauselist clause vectorclause depclause lengthclause loopclause vectorlist vectoritem looplist loopitem

%locations

%start entry

%%

entry : program
{
  $$ = output = $1;
}

program : code program
{
  $$ = merge_strings_free ($1, $2);
}
| directive program
{
  $$ = merge_strings_free (print_options($1), $2);
}
| code
{
  $$ = $1;
}
| directive
{
  $$ = print_options($1);
}

code : code CODE_BLOCK
{
  $$ = merge_strings_free ($1, $2);
}
|
CODE_BLOCK
{
  $$ = $1;
}
;

directive : PRAGMA clauselist
{
  $$ = $2;
}
| PRAGMA error
{
  $$ = default_options_ptr();
}
;

clauselist : clauselist clause
{
  $$ = merge_options ($1, $2);
}
| clauselist COMMA clause
{
  $$ = merge_options ($1, $3);
}
| clause
{
  $$ = $1;
}
| clauselist error
{
  $$ = $1;
}
| clauselist COMMA error
{
  $$ = $1;
}
| error
{
  $$ = default_options_ptr();
}
;

clause : vectorclause
{
  $$ = $1;
}
| depclause
{
  $$ = $1;
}
| lengthclause
{
  $$ = $1;
}
| loopclause
{
  $$ = $1;
}
;

vectorclause: VECTOR LPAREN vectorlist RPAREN
{
  $$ = $3;
}
| VECTOR LPAREN error RPAREN
{
  $$ = default_options_ptr();
}
;

vectorlist: NONE
{
  SET_OPTION($$,vector.novector, true);
}
| vectorlist COMMA vectoritem
{
  $$ = merge_options ($1, $3);
}
| vectorlist COMMA error
{
  $$ = $1;
}
| vectoritem
{
  $$ = $1;
}
| error
{
  $$ = default_options_ptr();
}
;

vectoritem: ALWAYS
{
  SET_OPTION($$,vector.always, true);
}
| ALIGNED
{
  SET_OPTION($$,vector.align_value, ALIGNED_);
}
| UNALIGNED
{
  SET_OPTION($$,vector.align_value, UNALIGNED_);
}
| NONTEMP
{
  SET_OPTION($$,vector.temp_value, NONTEMP_);
}
| TEMP
{
  SET_OPTION($$,vector.temp_value, TEMP_);
}
;

depclause: DEPEND LPAREN IGNORE RPAREN
{
  SET_OPTION($$,ignoreDep, true);
}
| DEPEND LPAREN DEFAULT RPAREN
{
  SET_OPTION($$,ignoreDep, false);
}
;

lengthclause: VECTORSIZE LPAREN number_or_error RPAREN
{
  SET_OPTION($$,vsize, $3);
}
;

loopclause: LOOP LPAREN looplist RPAREN
{
  $$ = $3;
}
| LOOP LPAREN error RPAREN
{
  $$ = default_options_ptr();
}
;

looplist: looplist COMMA loopitem
{
  $$ = merge_options ($1, $3);
}
| looplist COMMA error
{
  $$ = $1;
}
| loopitem
{
  $$ = $1;
}
| error
{
  $$ = default_options_ptr();
}
;

loopitem: UNROLL
{
  SET_OPTION($$,loop.unroll, 0);
}
| UNROLL LPAREN number_or_error RPAREN
{
  SET_OPTION($$,loop.unroll, $3);
}
| JAM
{
  SET_OPTION($$,loop.jam, 0);
}
| JAM LPAREN number_or_error RPAREN
{
  SET_OPTION($$,loop.jam, $3);
}
| DISTRIBUTE
{
  SET_OPTION($$,loop.dist, true);
}
| NOFUSION
{
  SET_OPTION($$,loop.nofusion, true);
}
;

number_or_error: NUMBER
{
  $$ = $1;
}
| error
{
  $$ = ERROR_VALUE;
}
;
