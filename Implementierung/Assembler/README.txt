Cosh Inverse Calculation v1.1b in Assembly

This function calculates a precise value of cosh^-1(x) for any given x-input in IEEE74-float format.
For inputs <1.0f this function returns +NaN.

GETTING STARTED
===============
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

This package contains:
 - The function's source code in x86-Assembly programming language (coshInv.asm)
 - A NASM-compiled version of the function in form of an object-file (coshInv.o)
 - The source code of a testbench programm in C programming language (rahmenprogramm.c)
 - A GCC-compiled executable version of the testbench using coshInv.o (coshInvTest.exe)
 - A batch-file that will build and launch the test (build+lauch.bat)
 - A batch-file that will only lauch a pre-built executable of the test (launch-only.bat)
 - This readme.txt

Prerequisites
-------------
To use the contents of this package, your computer must have:
 - A x86-compatible CPU-architecture
 - A Windows operating system

In order to recompile using build+launch.bat you must also have following compilers installed and added as global variables:
 - the latest version of NASM (2.13.03 or higher)
 - GCC C-compiler

Installing
----------
No installation needed. The contents of the package are ready-to-go.

Running the tests
-----------------
If you do not have NASM and/or GCC compilers, just run the pre-built test using launch-only.bat.
If you do have both compilers installed, it is better to recompile them before launch using build+launch.bat.

When run, the test will generate a number (default 100000) float inputs and run them through the coshInv function first and through the C math.h library's acosh function.
The results will the be printed in console side-by-side. Warnings will be printed if the results are not completely identical. Extra warnings will be given if a coshInv's result is considered wrong (more than .1% difference).

NOTICE:		while running tests during development, we discovered through testing with double-precision floating point numbers and a more streamlined formula using logarithms and sqare roots,
			that in most cases, whenever coshInv and acosh do not deliver exactly the same answer, neither are really precise. On those occasions, the acosh usually has a discrepancy of 3-4 on the last valid digit.


DEPLOYMENT
==========
This function can be used:
 - as a called funtion in x86-Assembly - best using source-code during compilation
 - as an external function in other programming languages - best using coshInv.o file

AUTHORS
=======
Adrian Kögl
Daniel Osipishin
Marc Sinner