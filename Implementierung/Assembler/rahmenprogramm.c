#include <stdio.h>

extern int coshInv() asm("coshInv");

int main()
{
	printf("%d\n", coshInv());
}