BITS 32;

GLOBAL coshInv;

coshInv:
;placeholder for memory allocation, address in ESI
;X in EAX???

PUSH EAX
FLD DWORD [ESP]
FLD1
;FCOM
;FNSTSW AX
;AND AX, 1792;	1792 = 00000111_00000000
;JZ coshInvException
FST DWORD [ESP]
PUSH EAX
FST DWORD [ESP]

coshInvWhile:

FLD1			;starting value in f
MOV ECX, 2		;starting grade in f
CALL f
FSUB ST0, ST2
PUSH EAX
FSTP DWORD [ESP]

FLD ST0		;starting value un f'
MOV ECX, 3		;starting grade in f'
CALL f

FLD DWORD [ESP];
POP EAX;
FXCH;
FDIVP;
FSUBP;
FST DWORD [ESI];
MOV EAX, [ESI];
POP EBX;
CMP EAX, EBX;
JE coshInvExit;
POP ECX;
CMP EAX, ECX;
JE coshInvExit;
PUSH EBX;
PUSH EAX;
JMP coshInvWhile;

coshInvExit:
FXCH;
FSTP ST0;
RET;

coshInvException:
POP EAX;
FSTP ST0;
FSTP ST0;
PUSH DWORD [ESI]
MOV DWORD [ESI], 2147483647
FILD DWORD [ESI];	= 01111111_11111111_11111111_11111111 = NaN
POP DWORD [ESI]
RET;



f:
;Y at st(1), 1 at st(0), 2 in ECX
FLD1;
CALL taylor;
FST DWORD [ESI];
MOV EAX, [ESI];
FLD ST1;
FSTP DWORD [ESI];
MOV EBX, [ESI];
SHR EAX, 23;
SHR EBX, 23;
SUB BL, AL;
CMP BL, 23;
JGE fEnd;
FADD;
ADD ECX, 2;
JMP f;

fEnd:
RET;



taylor:
FLD ST2;
PUSH DWORD [ESI]
MOV DWORD [ESI],ECX
FILD DWORD [ESI];
POP DWORD [ESI]
FDIVP;
FMULP;
DEC ECX;
JZ taylorEnd;
JMP taylor;

taylorEnd:
RET;