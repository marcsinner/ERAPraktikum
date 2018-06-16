#include <stdio.h>

extern float testing() asm("testing");

int main()
{
	float input;
	input = 10.0;
	printf("%f\n", testing(input));
}