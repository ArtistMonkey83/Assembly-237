; Name
; Wildcat ID Number
; Assignment Name/Number
; EECE 237 Fall 2021

BASE_MEMORY EQU 0x20000000			;Tiva base memory address
;------------DO NOT REMOVE--------------------------- 
        AREA    |.text|, CODE, READONLY, ALIGN=2 
        THUMB 
        GET tm4c123gh6pm.s
        EXPORT  Start 
;------------DO NOT REMOVE--------------------------- 

Start;----------write your code below this line!-----	
	
	MOV R0, #0x05
	BL sleep
	
	MOV R2,#10
	MOV R3,#0X03
	BL adder

loop	B loop
;pass R0 by value because its value doesn't change after the function exits
sleep
	PUSH {R0}		;five is on the stack and will remain there after the count subroutine
count				;to make an infinate loop make a label and then branch to it
	SUB R0,R0,#1	;subtracting one from R0 and overwriting
	CMP R0,#0		;subtracting 0 from R0 R0-0
	BNE count		;as long as the branch is not equal continue looping
	POP{R0}			;restore old value for R0 from stack
	BX LR			;Branch exchange/exit
	;BEQ count		;Delay loop executes as long as Branch is not == zero
	;B count			;this will always jump because this branch is non conditional
adder