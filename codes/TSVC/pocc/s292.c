#include <common.h>

int s292()
{

//	loop peeling
//	wrap around variable, 2 levels
//	similar to S291

	clock_t start_t, end_t, clock_dif; double clock_dif_sec;
	start_t = clock();
#pragma scop 


	int im1, im2;
	for (int nl = 0; nl < ntimes; nl++) {
		im1 = LEN-1;
		im2 = LEN-2;
		for (int i = 0; i < LEN; i++) {
			a[i] = (b[i] + b[im1] + b[im2]) * (float).333;
			im2 = im1;
			im1 = i;
		}
		dummy(a, b, c, d, e, aa, bb, cc, 0.);
	}
#pragma endscop 

	end_t = clock(); clock_dif = end_t - start_t;
	clock_dif_sec = (double) (clock_dif/1000000.0);
	printf("S292\t %.2f \t\t", clock_dif_sec);;
	check(1);
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
    s292();
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
    
    set1d(a,zero,unit);
    set1d(b, one,unit);
}
