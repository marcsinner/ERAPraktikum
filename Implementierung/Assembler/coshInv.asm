BITS 32

GLOBAL coshInv;

coshInv:
;this function returns the float representation of cosh^-1(x)
;put the float representation of x on top of the CPU-stack just before calling this function
;the output is left on top of the FPU-stack (st0)
;for x >= 1.0f, this returns the most precise float representation of cosh^-1(x) possible
;for x < 1.0f, this returns NaN

MOV EAX, [ESP + 4]	;location of the call argument (x)
FLD DWORD [ESP + 4]

SHR EAX, 23			;logical right shift by 23 moves the exponent part (bits #30 - #23) of float to AL
CMP EAX, 255		;float bit #31 (sign) is now #8, EAX > 255 <-> x < 0
JG coshInvInputException
AND EAX, 000000ffh	;removes the sign bit, only exponent part left
CMP EAX, 127		;if EAX < 127 => exponent is negative, therefore EAX < 127 <-> 0 <= x < 1
JL coshInvInputException
;in total: if x < 1 return NaN

PUSH 89				;starting at 89 avoids overflow
FILD DWORD [ESP]
FST DWORD [ESP]		;store 2 copies of y onto CPU stack for exit condition
PUSH EAX
FST DWORD [ESP]

coshInvWhile:
;a while-loop, performing Newton's method to solve cosh(y) - x = 0
;the solution of this equation is also the result of y = cosh^-1(x)
;x is runtime-constant, solve y
;Newton's method: approximate a solution of zero-point-equation, using a recursive formula: y(n+1) = y(n) - f(y(n))/f'(y(n))
;y(0) freely choosabe, must be between the same extremes as the solution
;cosh only has one extreme at y = 0, with the restriction of x >= 1 Newton's method will always deliver the correct and positive outcome
;the loop ends, when (y(n) == y(n - 1) OR y(n) == y(n - 2)) == true
;this condition means that maximum precision is achieved and no infinite loops can occur

;st0 = y, st1 = x
;CPU stack is 	lastLastY
;				lastY

FLD1			;starting value in f (1.0f)
MOV EAX, 2		;starting grade in f (2)
CALL f			;f called with (1, 2) ==> f(y)
FSUB ST0, ST2	;cosh(y)-x
PUSH EAX
FSTP DWORD [ESP];store f(y) onto CPU-stack

FLD ST0			;starting value un f' (y)
MOV EAX, 3		;starting grade in f' (3)
CALL f			;f called with (y, 3) ==> f'(y)

FLD DWORD [ESP]	;load f(y) back onto FPU-stack
FXCH
FDIVP			;f(y) / f'(y)
FSUBP			;newY = y - f(y) / f'(y)
FST DWORD [ESP]	;replace f(y) with newY at CPU-stack top
POP EAX			;newY in EAX
POP EBX			;lastY in EBX
POP ECX			;lastLastY in ECX
CMP EAX, EBX	;if newY == lastY ==> maximum precision reached, end program
JE coshInvExit
CMP EAX, ECX	;same here. comparison to 2 last values to avoid endless loops of +-0.0000001
JE coshInvExit
PUSH EBX		;store last y ==> will be second to last next iteration
PUSH EAX		;store new y ==> will be last next iteration
JMP coshInvWhile

coshInvExit:
;st(0) = final y, st(1) = x
FXCH
FSTP ST0		;remove x from under y
RET				;end of the function

coshInvInputException:
;occurs when input x < 1.0f
;returns a NaN value
FSTP ST0		;delete input
PUSH DWORD 7FFFFFFFh	;hex value of NaN
FLD DWORD [ESP]
POP EAX
RET

f:
;depending on the input (see below) computes either f(y) = cosh(y) - x OR f'(y) = sinh(x)
;																	^this -x happens externally in the calling function coshInvWhile
;a Taylor series is used to develop both functions
;cosh(y) = 1 + y^2/2! + y^4/4! + y^6/6! + ... + y^(2n)/(2n)! + ...
;sinh(y) = y + y^3/3! + y^5/5! + y^7/7! + ... + y^(2n + 1)/(2n + 1)! + ...
;a function can be chosen by specifying the inputs:

;Y at st1
;for f(y): st0 = 1, EAX = 2
;for f'(y): st0 = y, EAX = 3

MOV EBX, EAX		;copy grade to EBX for taylor
CALL taylor
PUSH EBX
FST DWORD [ESP]		;copy currentTaylor to EBX
MOV EBX, [ESP]
FLD ST1				;copy currentOutput onto fstack
FSTP DWORD [ESP]	;move currentOutput to ECX
POP ECX
SHR EBX, 23			;right logic shift 23 ==> lowest byte contains exponent
SHR ECX, 23
AND EBX, 000000ffh
AND ECX, 000000ffh
SUB ECX, EBX
CMP ECX, 23			;when diff > 23 ==> further computing has no point
JGE fEnd
FADD				;currentOutput += currentTaylor
ADD EAX, 2			;go through grades at step == 2 until max precision
JMP f

fEnd:
FADD				;effectively destroy currentTaylor
RET



taylor:
;computes an element of a Taylot series y^n/n!
;to avoid float overflow, the value is gradually scaled up using:
;y^n/n! = y/n * y/(n - 1) * y/(n - 2) * ... * y/2 * y/1
;this ensures overflow is never possible, as long as the y is kept lower than 91 (which is achieved through the input approximation)

;st0 = current f value, st1 = y
;element grade in EBX

FLD1				;initial output value (to multiply y/EBX with)
PUSH EBX			;"reserve" ESP for copying

taylorWhile:
FLD ST2				;copy y onto fstack
MOV [ESP], EBX
FILD DWORD [ESP]	;load current grade onto fstack
FDIVP				;y / currentGrade
FMULP				;output * (y / currentGrade)
DEC EBX				;go through every grade from max downto 1
JZ taylorEnd		;end at currentGrade == 0
JMP taylorWhile		

taylorEnd:
POP EBX				;clear stack
RET