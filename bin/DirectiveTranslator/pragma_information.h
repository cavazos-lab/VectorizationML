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

#define DEFAULT_VALUE (-1)

#define ERROR_VALUE (-2)

#ifdef __cplusplus
extern "C" {
#endif
  
options_t default_options ();

options_t* default_options_ptr ();

options_t* merge_options (options_t*, options_t*);

options_t* merge_options_free (options_t*, options_t*);

char* print_options (options_t*);

#ifdef __cplusplus
} // extern "C"
#endif
  
#endif

