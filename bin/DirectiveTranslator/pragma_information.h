#ifndef VALT_PRAGMA_INFORMATION_H
#define VALT_PRAGMA_INFORMATION_H

#include <stdbool.h>

typedef enum {
  ALIGNED_, UNALIGNED_
} align_t;

typedef enum {
  NONTEMP_, TEMP_
} temp_t;

typedef struct
v_options_t {
  _Bool always;
  align_t align_value;
  temp_t temp_value;
  _Bool novector;
} v_options_t;    


typedef struct
l_options_t {
  int unroll;
  int jam;
  _Bool dist;
  _Bool nofusion;
} l_options_t;    

typedef struct
options_t {
  v_options_t vector;
  _Bool ignoreDep;
  int vsize;
  l_options_t loop;
} options_t;

extern const int DEFAULT_VALUE;
extern const int ERROR_VALUE;

options_t
DEFAULT_OPTIONS ();

#endif
