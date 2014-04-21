#include <common.h>
#ifdef PAPI
#include <papi.h>
#include <math.h>
#include <stdlib.h>
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif


#define LD_CACHE_SIZE 800000
typedef unsigned int       uint32;
typedef unsigned long long uint64;
typedef union
{       uint64 int64;
  struct {uint32 lo, hi;} int32;
} tsc_counter;


#endif




#ifdef PAPI
void test_fail(char *file, int line, char *call, int retval)
{
   char buf[128];


   memset(buf, '\0', sizeof(buf));
   if (retval != 0)
      fprintf(stdout,"%-40s FAILED\nLine # %d\n", file, line);
   else {
      fprintf(stdout,"%-40s SKIPPED\n", file);
      fprintf(stdout,"Line # %d\n", line);
   }
   if (retval == PAPI_ESYS) {
      sprintf(buf, "System error in %s", call);
      perror(buf);
   } else if (retval > 0) {
      fprintf(stdout,"Error: %s\n", call);
   } else if (retval == 0) {
      fprintf(stdout,"Error: %s\n", call);
   } else {
      char errstring[PAPI_MAX_STR_LEN];
      PAPI_perror(errstring);
      fprintf(stdout,"Error in %s: %s\n", call, errstring);
   }
   fprintf(stdout,"\n");
   if ( PAPI_is_initialized() ) PAPI_shutdown();
   exit(1);
}
#endif




  int retval;
  int EventSet = PAPI_NULL;
  long_long values[1];
  long_long all_values[32];
  char descr[PAPI_MAX_STR_LEN];
  PAPI_event_info_t evinfo;
  long double* cache_cleaner;
  int cache_iter, cache_loop;


  const unsigned int eventlist[] = {
	PAPI_TOT_CYC,
	PAPI_L1_DCM,
	PAPI_L1_ICM,
	PAPI_L2_DCM,
	PAPI_L2_ICM,
	PAPI_L1_TCM,
	PAPI_L2_TCM,
	PAPI_L3_TCM,
	PAPI_L3_LDM,
	PAPI_TLB_DM,
	PAPI_TLB_IM,
	PAPI_TLB_TL,
	PAPI_L1_LDM,
	PAPI_L1_STM,
	PAPI_L2_LDM,
	PAPI_L2_STM,
	PAPI_BR_UCN,
	PAPI_BR_CN,
	PAPI_BR_TKN,
	PAPI_BR_NTK,
	PAPI_BR_MSP,
	PAPI_BR_PRC,
	PAPI_TOT_IIS,
	PAPI_TOT_INS,
	PAPI_FP_INS,
	PAPI_LD_INS,
	PAPI_SR_INS,
	PAPI_BR_INS,
	PAPI_RES_STL,
	PAPI_LST_INS,
	PAPI_L1_DCH,
	PAPI_L2_DCH,
	PAPI_L1_DCA,
	PAPI_L2_DCA,
	PAPI_L3_DCA,
	PAPI_L1_DCR,
	PAPI_L2_DCR,
	PAPI_L3_DCR,
	PAPI_L1_DCW,
	PAPI_L2_DCW,
	PAPI_L3_DCW,
	PAPI_L1_ICH,
	PAPI_L2_ICH,
	PAPI_L1_ICA,
	PAPI_L2_ICA,
	PAPI_L3_ICA,
	PAPI_L1_ICR,
	PAPI_L2_ICR,
	PAPI_L3_ICR,
	PAPI_L2_TCH,
	PAPI_L1_TCA,
	PAPI_L2_TCA,
	PAPI_L3_TCA,
	PAPI_L1_TCR,
	PAPI_L2_TCR,
	PAPI_L3_TCR,
	PAPI_L2_TCW,
	PAPI_L3_TCW,
	PAPI_FP_OPS,
	PAPI_SP_OPS,
	PAPI_DP_OPS,
	PAPI_VEC_SP,
	PAPI_VEC_DP,
	PAPI_REF_CYC,
	0
  };


  int evid, eviditer;



int vbor()
{

//	control loops
//	basic operations rates, isolate arithmetic from memory traffic
//	all combinations of three, 59 flops for 6 loads and 1 store.

	clock_t start_t, end_t, clock_dif; double clock_dif_sec;
#ifdef PAPI
  cache_cleaner=(long double*) malloc ((LD_CACHE_SIZE + 4) * sizeof (long double));
  for (cache_loop = 0; cache_loop < LD_CACHE_SIZE / 64; ++cache_loop)
    for (cache_iter = 0; cache_iter < LD_CACHE_SIZE; ++cache_iter)
      cache_cleaner[cache_iter] = M_PI * cache_iter * cache_loop;


  if ((retval = PAPI_library_init(PAPI_VER_CURRENT)) != PAPI_VER_CURRENT)
    test_fail(__FILE__, __LINE__, "PAPI_library_init", retval);


  if ((retval = PAPI_create_eventset(&EventSet)) != PAPI_OK)
    test_fail(__FILE__, __LINE__, "PAPI_create_eventset", retval);


  for (evid = 0; eventlist[evid] != 0; evid++)
    {
      PAPI_event_code_to_name(eventlist[evid], descr);
      if (PAPI_add_event(EventSet, eventlist[evid]) != PAPI_OK)
        continue;


      // Clean the cache at each iteration.
      for (cache_iter = 0; cache_iter < LD_CACHE_SIZE; ++cache_iter)
      cache_cleaner[cache_iter] *= M_PI + cache_iter;


      if (PAPI_get_event_info(eventlist[evid], &evinfo) != PAPI_OK)
        test_fail(__FILE__, __LINE__, "PAPI_get_event_info", retval);


      if ((retval = PAPI_start(EventSet)) != PAPI_OK)
      test_fail(__FILE__, __LINE__, "PAPI_start", retval);


      // Start cycle count.
#endif
	start_t = clock();

	float a1, b1, c1, d1, e1, f1;
#pragma autovec permute
	for (int nl = 0; nl < ntimes*10; nl++) {
#pragma autovec permute
		for (int i = 0; i < LEN2; i++) {
			a1 = a[i];
			b1 = b[i];
			c1 = c[i];
			d1 = d[i];
			e1 = e[i];
			f1 = aa[0][i];
			a1 = a1 * b1 * c1 + a1 * b1 * d1 + a1 * b1 * e1 + a1 * b1 * f1 +
				a1 * c1 * d1 + a1 * c1 * e1 + a1 * c1 * f1 + a1 * d1 * e1
				+ a1 * d1 * f1 + a1 * e1 * f1;
			b1 = b1 * c1 * d1 + b1 * c1 * e1 + b1 * c1 * f1 + b1 * d1 * e1 +
				b1 * d1 * f1 + b1 * e1 * f1;
			c1 = c1 * d1 * e1 + c1 * d1 * f1 + c1 * e1 * f1;
			d1 = d1 * e1 * f1;
			x[i] = a1 * b1 * c1 * d1;
		}
		dummy(a, b, c, d, e, aa, bb, cc, 0.);
	}
    
#ifdef PAPI
      if ((retval = PAPI_read(EventSet, &values[0])) != PAPI_OK)
        test_fail(__FILE__, __LINE__, "PAPI_read", retval);


      if ((retval = PAPI_stop(EventSet,NULL)) != PAPI_OK)
        test_fail(__FILE__, __LINE__, "PAPI_stop", retval);


      all_values[evid] = values[0];


      if ((retval = PAPI_remove_event(EventSet, eventlist[evid])) != PAPI_OK)
        test_fail(__FILE__, __LINE__, "PAPI_remove_event", retval);
    }


  if ((retval = PAPI_destroy_eventset(&EventSet)) != PAPI_OK)
    test_fail(__FILE__, __LINE__, "PAPI_destroy_eventset", retval);


  // Output measure results.
  printf("10-36");
  for (eviditer = 0; eviditer < evid; ++eviditer)
  printf (", %llu", all_values[eviditer]);
  printf ("\n");
#else
#endif
	end_t = clock(); clock_dif = end_t - start_t;
	clock_dif_sec = (double) (clock_dif/1000000.0);
	printf("vbor\t %.2f \t\t", clock_dif_sec);;
	temp = 0.;
	for (int i = 0; i < LEN; i++){
		temp += x[i];
	}
	check(-1);
	return 0;
}
int main(){
	int n1 = 1;
	int n3 = 1;
	int* ip = (int *) memalign (16, LEN*sizeof(float));
	float s1,s2;
	set(ip, &s1, &s2);
	printf("Loop \t Time(Sec) \t Checksum \n");

	init();
    vbor();
}

void set(int* ip, float* s1, float* s2){
	xx = (float*) memalign(16, LEN*sizeof(float));
	printf("\n");
	for (int i = 0; i < LEN; i = i+5){
		ip[i]	= (i+4);
		ip[i+1] = (i+2);
		ip[i+2] = (i);
		ip[i+3] = (i+3);
		ip[i+4] = (i+1);

	}

	set1d(a, 1.,1);
	set1d(b, 1.,1);
	set1d(c, 1.,1);
	set1d(d, 1.,1);
	set1d(e, 1.,1);
	set2d(aa, 0.,-1);
	set2d(bb, 0.,-1);
	set2d(cc, 0.,-1);

	for (int i = 0; i < LEN; i++){
		indx[i] = (i+1) % 4+1;
	}
	*s1 = 1.0;
	*s2 = 2.0;

}

int init()
{
	float any=0.;
	float zero=0.;
	float half=.5;
	float one=1.;
	float two=2.;
	float small = .000001;
	int unit =1;
	int frac=-1;
	int frac2=-2;
    
    set1d(a, any,frac);
    set1d(b, any,frac);
    set1d(c, one,frac);
    set1d(d, two,frac);
    set1d(e,half,frac);
    set2d(aa, any,frac);
}
