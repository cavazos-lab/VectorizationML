#include <stdlib.h>
#include <stdio.h>

#define PRAGMA BOO

int main() {
  /* THIS IS A COMMENT */

  int i,j,k;
  float a[100];
  float b[100];
  float c[100];

  /* MULTILINE TEST*/
#pragma VALT vector(none) \
  loop(unroll(4),         \
       distribute)
  for (i = 0; i < 100; ++i)
  {
#pragma VALT loop(unroll(junk), distribute)
    for (j = 0; j < 100; ++j)
    {
      a [j] = 0;
    }
    b [i] = i;
  }

#pragma simd
  for (k = 99; k >= 0; --k)
  {
    /* test to make sure simd still works by itself */
#pragma VALT vector(always) vectorsize(8)
    for (i = 0; i < 100; ++i)
    {
      c[i] = b[i] * b[i] + a[i];
    }
  }

  return 0;
}
