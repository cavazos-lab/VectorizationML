#include <stdio.h>

int
main (int ac, char** av)
{
  #pragma autovec permute
  for (i = 0; i < n; ++i)
    A[i] = 0;
  
  #pragma autovec permute
  for (i = 1; i < n; ++i)
    A[i] = A[i-1] + 1;
  
  #pragma vector always
  for (i = 0; i < n; ++i)
    A[i] = B[i];
  
}
