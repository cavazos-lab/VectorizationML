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
//#include <malloc.h>
#include <string.h>
#include <assert.h>
#include <xmmintrin.h>
#include <mm_malloc.h>

#define TYPE float

#define lll LEN

__attribute__ ((aligned(16))) TYPE X[lll],Y[lll],Z[lll],U[lll],V[lll];


inline
void* memalign (size_t align, size_t size) { return _mm_malloc (size, align); }

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

int set1d(float arr[LEN], float value, int stride)
{
	if (stride == -1) {
		for (int i = 0; i < LEN; i++) {
			arr[i] = 1. / (float) (i+1);
		}
	} else if (stride == -2) {
		for (int i = 0; i < LEN; i++) {
			arr[i] = 1. / (float) ((i+1) * (i+1));
		}
	} else {
		for (int i = 0; i < LEN; i += stride) {
			arr[i] = value;
		}
	}
	return 0;
}

int set1ds(int _n, float arr[LEN], float value, int stride)
{
	if (stride == -1) {
		for (int i = 0; i < LEN; i++) {
			arr[i] = 1. / (float) (i+1);
		}
	} else if (stride == -2) {
		for (int i = 0; i < LEN; i++) {
			arr[i] = 1. / (float) ((i+1) * (i+1));
		}
	} else {
		for (int i = 0; i < LEN; i += stride) {
			arr[i] = value;
		}
	}
	return 0;
}

int set2d(float arr[LEN2][LEN2], float value, int stride)
{

//  -- initialize two-dimensional arraysft

	if (stride == -1) {
		for (int i = 0; i < LEN2; i++) {
			for (int j = 0; j < LEN2; j++) {
				arr[i][j] = 1. / (float) (i+1);
			}
		}
	} else if (stride == -2) {
		for (int i = 0; i < LEN2; i++) {
			for (int j = 0; j < LEN2; j++) {
				arr[i][j] = 1. / (float) ((i+1) * (i+1));
			}
		}
	} else {
		for (int i = 0; i < LEN2; i++) {
			for (int j = 0; j < LEN2; j += stride) {
				arr[i][j] = value;
			}
		}
	}
	return 0;
}

float sum1d(float arr[LEN]){
	float ret = 0.;
	for (int i = 0; i < LEN; i++)
		ret += arr[i];
	return ret;
}

void check(int name){

	float suma = 0;
	float sumb = 0;
	float sumc = 0;
	float sumd = 0;
	float sume = 0;
	for (int i = 0; i < LEN; i++){
		suma += a[i];
		sumb += b[i];
		sumc += c[i];
		sumd += d[i];
		sume += e[i];
	}
	float sumaa = 0;
	float sumbb = 0;
	float sumcc = 0;
	for (int i = 0; i < LEN2; i++){
		for (int j = 0; j < LEN2; j++){
			sumaa += aa[i][j];
			sumbb += bb[i][j];
			sumcc += cc[i][j];

		}
	}
	float sumarray = 0;
	for (int i = 0; i < LEN2*LEN2; i++){
		sumarray += array[i];
	}

	if (name == 1) printf("%f \n",suma);
	if (name == 2) printf("%f \n",sumb);
	if (name == 3) printf("%f \n",sumc);
	if (name == 4) printf("%f \n",sumd);
	if (name == 5) printf("%f \n",sume);
	if (name == 11) printf("%f \n",sumaa);
	if (name == 22) printf("%f \n",sumbb);
	if (name == 33) printf("%f \n",sumcc);
	if (name == 0) printf("%f \n",sumarray);
	if (name == 12) printf("%f \n",suma+sumb);
	if (name == 25) printf("%f \n",sumb+sume);
	if (name == 13) printf("%f \n",suma+sumc);
	if (name == 123) printf("%f \n",suma+sumb+sumc);
	if (name == 1122) printf("%f \n",sumaa+sumbb);
	if (name == 112233) printf("%f \n",sumaa+sumbb+sumcc);
	if (name == 111) printf("%f \n",sumaa+suma);
	if (name == -1) printf("%f \n",temp);
	if (name == -12) printf("%f \n",temp+sumb);

}

#endif
