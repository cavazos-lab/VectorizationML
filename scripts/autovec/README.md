Auto-Tuning Vectorization Code Generator

William Killian
University of Delaware

2014 February 18


Installation:

  * Add ./bin to path

Prereqs:

 * GNU coreutils (specifically sed, awk, bash, grep)

Usage:

 * auto_vec filename+

   where filename is one or more filenames

Output:

 * Generates several versions of each filename passed

Source Code Options:

 The following directives are recognized:

  * #pragma autovec vl(N) - expands to #pragma simd vectorlength(N)
  * #pragma autovec always - expands to #pragma vector always
  * #pragma autovec ivdep - expands to #pragma ivdep
  * #pragma autovec none - expands to nothing (for convenience)
  * #pragma autovec permute - expands to all supported directives
      vectorlength sizes of 2,4, and 8 are included

