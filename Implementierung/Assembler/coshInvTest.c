#include <stdio.h>
#include <math.h> 
#include <sys/time.h>
#include <sys/resource.h>

extern int coshInv() asm("coshInv");

int debug=0;

int main(){


	int debug = 0; //1-print each value, 0-only print final results
	int result = singleOperations(10000); //return -1 if assembler makes wrong calculation
	setOfOperations(10000);

	if(result != -1){
		printf("***********\nTest Successful\n*************\n");
	}
	else{
		printf("***********\nTest Failed\n************\n");
	}

}

int singleOperations(int amount){

	for(float i = 1; i<amount; i++){

		//library Operation

		struct timeval tval_before, tval_after, tval_result;
		gettimeofday(&tval_before, NULL);

		float c1 = acosh(i);

		gettimeofday(&tval_after, NULL);
		timersub(&tval_after, &tval_before, &tval_result);

		//implemented Operation

		struct timeval tval_before2, tval_after2, tval_result2;
		gettimeofday(&tval_before2, NULL);

		float c2 = coshInv(i);

		gettimeofday(&tval_after2, NULL);
		timersub(&tval_after2, &tval_before2, &tval_result2);

		//Correction, if more than 5% difference
		if(fabsf(c2-c1)>(c2/20)){
			printf("ERROR: Wrong Calculation at x=%f CalculatedValue: %f RightValue: %f \n",i,c2,c1);
			return -1; //break out of the loop
		}


		if(debug == 1){
			printf("x: %f \n\nLibraryCalculation: %f Time: %ld.%06ld\n",i,c1, (long int)tval_result.tv_sec, (long int)tval_result.tv_usec);
			printf("AssemblerCalculation: %f Time: %ld.%06ld \n\n",c2, (long int)tval_result2.tv_sec, (long int)tval_result2.tv_usec);
		}

	}

}

int setOfOperations(int amount){

		//library Operation

		struct timeval tval_before, tval_after, tval_result;
		gettimeofday(&tval_before, NULL);

		for(float i = 1; i<amount; i++){
			float c1 = acosh(i);
		}

		gettimeofday(&tval_after, NULL);
		timersub(&tval_after, &tval_before, &tval_result);

		//implemented Operation

		struct timeval tval_before2, tval_after2, tval_result2;
		gettimeofday(&tval_before2, NULL);

		for(float i = 1; i<amount; i++){
			float c2 = coshInv(i);
		}

		gettimeofday(&tval_after2, NULL);
		timersub(&tval_after2, &tval_before2, &tval_result2);



		printf("LibraryCalucationTime: %ld.%06ld \n", (long int)tval_result.tv_sec, (long int)tval_result.tv_usec);
		printf("AssemblerCalculationTime: %ld.%06ld \n", (long int)tval_result2.tv_sec, (long int)tval_result2.tv_usec);




}
