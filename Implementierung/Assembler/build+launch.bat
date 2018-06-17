nasm -f elf32 -o coshInv.o coshInv.asm
gcc -m32 -o coshInvTest coshInv.o rahmenprogramm.c
.\coshInvTest
pause