#include <stdio.h>
#include <stdlib.h>
#include <math.h> 
#include <float.h>
#include <time.h>

extern float coshInv(float x) asm("coshInv");

int testSize = 100000;

float a = FLT_MAX;

int main()
{
	float input[testSize];
	float testOutput[testSize];
	float compOutput[testSize];
	time_t t1, t2, t3;
	float tTest, tComp;
	
	printf("Commencing test for coshInv. Test sample: %d random floats.\nComputing...", testSize);
	
	for (int i = 0; i < testSize; ++i) {
		input[i] = ((float)rand()/(float)(RAND_MAX)) * a + 1.0f;
	}
	
	t1 = clock();
	
	for (int i = 0; i < testSize; ++i) {
		testOutput[i] = coshInv(input[i]);
	}
	
	t2 = clock();
	
	for (int i = 0; i < testSize; ++i) {
		compOutput[i] = acosh(input[i]);
	}
	
	t3 = clock();
	
	tTest = (t2 - t1) * 1000 / CLOCKS_PER_SEC;
	tComp = (t3 - t2) * 1000 / CLOCKS_PER_SEC;
	
	for (int i = 0; i < testSize; ++i) {
		printf("Test value #%d:\tInput: %f\tcoshInv: %f\tacosh(math.h): %f\n", i, input[i], testOutput[i], compOutput[i]);
		if (testOutput[i] != compOutput[i]) printf("Values not completely identical.\n");
		if (abs(testOutput[i] / compOutput[i] - 1.0f) > 0.001f) printf("coshInv value wrong.\n");
	}
	
	printf("\n\nTime of coshInv: %f\nTime of acosh(math.h): %f\n", tTest, tComp);
}