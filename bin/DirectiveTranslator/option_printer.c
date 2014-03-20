#include <assert.h>

#include "option_printer.h"

void
print_options (FILE* out, options_t* options)
{
  if (!options->vector.novector) {
    if (options->vector.always)
    {
      fprintf (out, "#pragma vector always\n");
    }
    switch (options->vector.align_value)
    {
    case ALIGNED_:
      fprintf (out, "#pragma vector aligned\n");
      break;
    case UNALIGNED_:
      fprintf (out, "#pragma vector unaligned\n");
      break;
    }
    switch (options->vector.temp_value)
    {
    case NONTEMP_:
      fprintf (out, "#pragma vector nontemporal\n");
      break;
    case TEMP_:
      fprintf (out, "#pragma vector temporal\n");
      break;
    }
    if (options->ignoreDep)
    {
      fprintf (out, "#pragma ivdep\n");
    }
    if (options->vsize != DEFAULT_VALUE)
    {
      int x = options->vsize;
      assert (!(x & (x - 1)) && x); // ensures power of 2
      fprintf (out, "#pragma simd vectorlength(%d)\n", options->vsize);
    }
  }
  else
  {
    fprintf (out, "#pragma novector\n");
  }
  if (options->loop.jam != DEFAULT_VALUE)
  {
    if (options->loop.jam > 0)
      fprintf (out, "#pragma unroll_and_jam(%d)\n", options->loop.jam);
    else
      fprintf (out, "#pragma unroll_and_jam\n");
  }
  else if (options->loop.unroll != DEFAULT_VALUE)
  {
    if (options->loop.unroll > 0)
      fprintf (out, "#pragma unroll(%d)\n", options->loop.unroll);
    else
      fprintf (out, "#pragma unroll\n");
  }
  if (options->loop.dist)
  {
    fprintf (out, "#pragma distribute_point\n");
  }
  if (options->loop.nofusion)
  {
    fprintf (out, "#pragma nofusion\n");
  }
}
