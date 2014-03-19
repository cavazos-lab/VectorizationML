#ifndef _COMMON_TSVC_H_
#define _COMMON_TSVC_H_

#if HAVE_ICC
#pragma auto_inline(off)
#endif

#define LEN 32000
#define LEN2 256

#define ntimes 200000

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <sys/param.h>
#include <sys/times.h>
#include <sys/types.h>
#include <time.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>
#include <xmmintrin.h>

#define TYPE float

#define lll LEN

__attribute__ ((aligned(16))) TYPE X[lll],Y[lll],Z[lll],U[lll],V[lll];


//float* __restrict__ array;
float array[LEN2*LEN2] __attribute__((aligned(16)));

float x[LEN] __attribute__((aligned(16)));
float temp;
int temp_int;

__attribute__((aligned(16))) float a[LEN],b[LEN],c[LEN],d[LEN],e[LEN],
                                   aa[LEN2][LEN2],bb[LEN2][LEN2],cc[LEN2][LEN2],tt[LEN2][LEN2];

int indx[LEN] __attribute__((aligned(16)));

float* __restrict__ xx;
float* yy;

int dummy(float[LEN], float[LEN], float[LEN], float[LEN], float[LEN], float[LEN2][LEN2], float[LEN2][LEN2], float[LEN2][LEN2], float);

int dummy_media(short[], char[], int);

void set(int* ip, float* s1, float* s2);

int init ();

#endif
