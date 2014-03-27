#include <stdio.h>
#include <stdlib.h>
#include "pragma_information.h"

extern FILE* yyin;
extern int yyparse();
extern char* output;

int main(int ac, char** av)
{
  if (ac > 2)
  {
    fprintf (stderr, "Only one file may be read at a time!\n");
    exit (-1);
  }
  if (ac == 2)
  {
    FILE* f = fopen (av[1], "r");
    if (!f)
    {
      fprintf (stderr, "Cannot open file (%s) for reading!\n", av[1]);
      exit (-1);
    }
    yyin = f; 
  }

  do
  {
    yyparse();
  }
  while (!feof (yyin));
  fclose (yyin);

  fprintf (stdout, "%s\n", output);
}
