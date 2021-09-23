; Name Yolanda Reyes
; Wildcat ID Number 011234614
; Assignment Name/Number Rainbow LED/Project 3
; EECE 237 Fall 2021

BASE_MEMORY EQU 0x20000000			;Tiva base memory address
;PORTF constants for reference 	
		
		;Yokiam "colors" in Yo'eme
SIKI      EQU 0x02					;Red LED - 1st bit (001x), like a macro/#define in c
TEWELI	  EQU 0x04					;8 4 2 1  Powers of two, the four bits that control color
SIALI     EQU 0x08					;0 0 1 0  Putting a value in the 2^1  
SAWAI	  EQU 0x0A					;This two in line 10 makes the LED red
;AQUA	  EQU 0x0C
PURPLE	  EQU 0x06
TOSALI	  EQU 0x0f
CHUKUI	  EQU 0x00  
;------------DO NOT REMOVE--------------------------- 
        AREA    |.text|, CODE, READONLY, ALIGN=2 
        THUMB 
        GET tm4c123gh6pm.s
        EXPORT  Start 
;------------DO NOT REMOVE--------------------------- 

Start;----------write your code below this line!-----

	BL		PORT_F_INIT			;Function: Initializes Port F, I/O, etc. Leave this alone!
otra_vez   						;Like the song that never ends!
LDR R4, =SIKI					;Yo'eme for Red Seek E
	LDR R1, =GPIO_PORTF_DATA_R 	;PLACING ADDRESS IN R1
	LDR R0, [R1]				;Loading register R0 with the data stored in R1 == GPIO_PORTF_DATA_R
	
	MOV R5, #0x0500000 			;Delay by decrementing #0x0500000 			
	
	AND R0,R0,#0xF1 			;Check to see whats on, and then turn off?
;Notes from Professor for line 35
	;0xF1 = 1111 0001 
	;AND
	;PORTF = 0000 1100 blue green lights are 4 and 8 bit and they are on
	;Clearing bits unless both are on! then we can use OR to set bits	
	
	ORR R0, R0,R4  				;WHAT IS GOING ON HERE????!?!?!?!
;Notizen von Professorin fur Zeile 42
	;     GBR      	G==green bit, B==blue bit, R==red bit
	;0000 0001 		== R0 OR all lights are off
	;0000 0010 		== 0x02 RED
	;----------		Perform the OR operation
	;0000 0011 == Now the bit for red is on!
	; R0 = code for RED	
	
	STR R0,[R1]					;R0 into R1
;Notas de la profesora para la linea 51
	;In the STR the destination is on the right in brackets!
	;R0 = red light on
	;R1-> PORT F -> LIGHTS	
	
delay1							;BNEs jumpe here to continue decrementing our R5 which is acting like a counter
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't on we will stay in the loop
	
	BNE delay1					;As long as R5 isn't == 0 it will loop back to line 40 and continue executing code at line 41

;CYCLE_TEWELI Tey well e "blue,azul,bleue(u),blau"
	LDR R4, =TEWELI				;Load the value for BLUE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into R1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And  operations will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0	
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0500000 			;Delay by counting down from #0x0500000
	
delay2
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay2					;As long as R5 isn't == 0 it will loop
	
;CYCLE_PURPLE "morado,violette(let),violett"
	LDR R4, =PURPLE				;Load the value for PURPLE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0500000 			;Delay by counting down resetting the counter for the next delay to take place

delay3
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay3					;As long as R5 isn't == 0 it will loop
	
;CYCLE_SIALI See Ally "green,
	LDR R4, =SIALI				;Load the value for GREEN variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R  ;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0500000 			;Delay by counting down #0x0500000
	
delay4
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay4					;As long as R5 isn't == 0 it will loop
	
;CYCLE_SAWAI Sa Way "yellow,amarilla(o),jaune,Gelb"
	LDR R4, =SAWAI				;Load the value for YELLOW variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de reference 
	
	MOV R5, #0x0500000 			;Delay by counting down #0x0500000 

delay5
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay5					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay6
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay6					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay7
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay7					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay8
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay8					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay9
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay9				;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay10
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay10					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay11
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay11					;As long as R5 isn't == 0 it will loop

;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay12
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay12					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay13
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay13					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay14
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay14					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay15
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay15					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay16
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay16					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay17
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay17					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay18
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay18					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay19
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay19					;As long as R5 isn't == 0 it will loop
	
;CYCLE_TOSALI Toe sal E	"white,blanco,blanche(c),weib"
	LDR R4, =TOSALI				;Load the value for WHITE variable into register R4 
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 

	MOV R5, #0x0050000 			;Delay by counting down
	
delay20
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay20					;As long as R5 isn't == 0 it will loop	
		
;CYCLE_CHUKUI Shoe coo E "black,negra(o),noire(r),Schwarz"
	LDR R4, =CHUKUI				;Load the value for BLACK(OFF) variable into register R4
	LDR R1, =GPIO_PORTF_DATA_R 	;Loads the address of the Port F data register into F1
	LDR R0, [R1]				;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	
	AND R0,R0,#0xF1 			;Check to see whats on, turn off? And will clear bits.
	ORR R0, R0,R4  				;R4 has the color we want to change to, R0
	STR R0,[R1]					;R0 into R1 we need brackets to access the data de-reference 
	
	MOV R5, #0x0050000 			;Delay by counting down #0x0050000

delay21
	SUB R5,R5,#1 				;WILL OVERWRITE R5 WITH A DECREMENTED BY ONE VALUE!! == R5--/R5=R5-1 
	CMP R5, #0					;Check the zero flag, if it isn't we will stay in the loop
	
	BNE delay21					;As long as R5 isn't == 0 it will loop
	
	BL otra_vez
	
loop	B loop					;End w/ infinite loop; jumps to label "loop" and repeats this line forever

ERR								;Error state, if something bad happens, go here.
	B   ERR



;------------------------------------------------------------------
;----------------------Subroutines Start Here----------------------
;------------------------------------------------------------------


;----------GPIO Port F Initialization --------------
;Sets up GPIO Port F to work with the Tiva LaunchPad Switches and LEDs
;Input: None
;Output: None
;Modifies R0, R1
;DO NOT REMOVE OR ALTER THIS!
PORT_F_INIT
	; 1) Activate Clock for Port F by using one of the system control registers
	LDR R1, =SYSCTL_RCGC2_R			 ;Get the address of the RCGC2_R Register and load into R1
	LDR R0, [R1]					 ;Load the contents of the RCGC2_R Register into R0
									 ;The first 6 bits of this register control the activation of the
									 ;GPIO clocks, setting them to a 1 will turn them on.
	ORR R0, #0x20					 ;Masks the current state of the RCGC2_R register to set bit 5 to a 1
	STR R0, [R1]				     ;Load the changed contents of R0 back into RCGC2_R register
	NOP
	NOP								 ;Small delay for the clock to activate, cannot make any changes until this
									 ;is done
	; 2) Unlock the lock register for PORTF
	LDR R1, =GPIO_PORTF_LOCK_R	     ;Load the address of the PORTF Lock register into R1
	LDR R0, =GPIO_LOCK_KEY			 ;Load the lock key value into R0
	STR R0, [R1]					 ;Load R0 into the address stored in R1
	
	LDR R1, =GPIO_PORTF_CR_R		 ;Load the address of the PORTF Commit register into R1
	LDR R0, [R1]					 ;
	ORR R0, #0xFF					 ;Set all 8 lower bits to 1, enables writing to all bits in the PUR_R Register
	STR R0, [R1]					 ;
	
	; 3) Disable analog functionality
	LDR R1, =GPIO_PORTF_AMSEL_R		 ;Load the address of the PORTF Analog Mode Select register into R1
	LDR R0, [R1]					 ;
	AND R0, #0x00					 ;Clear the bits to deactivate the Analog function of this port
	STR R0, [R1]
	
	; 4) Clear the bits in the GPIO Port Control register so that the port can be used as a GPIO
	LDR R1, =GPIO_PORTF_PCTL_R	     ;Load the address of PortF Control register into R1
	LDR R0, = 0x00000000	  		 ;Each nibble controls the configuration of a single pin. Set all to 0 to  
									 ;configure the port as GPIO
	STR R0, [R1]				     ;
	
	; 5) Set the Direction register
	LDR R1, =GPIO_PORTF_DIR_R		 ;Load the address of the PORTF Direction register into R1
	LDR R0, [R1]				     ;			
	ORR R0, #0x0E					 ;Set PF0, PF4-7 as input, set PF1-3 as output
	STR R0, [R1]					 ;
	
	; 6) Clear the bits in the Alternate Function register
	LDR R1, =GPIO_PORTF_AFSEL_R		 ;Load the address of the PORTF Alternate Function register into R1
	LDR R0, [R1]					 ;
	AND R0, #0x00					 ;Clear the bits
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTF_PUR_R       ; pull-up resistors for PF4,PF0
    MOV R0, #0x11                   ; enable weak pull-up on PF0 and PF4
    STR R0, [R1]  
	
	; 7) Enable the Digital port
	
	LDR R1, =GPIO_PORTF_DEN_R		 ;Load the address of the PORTF Digital Enable register into R1
	LDR R0, [R1]					 ;
	ORR R0, #0xFF					 ;Enable all 8 bits
	STR R0, [R1]					 ;
	
	BX LR							 ;Branch redirect to the location specified by the Link Register (LR)
									 ;LR has the return address
	B ERR							 ;Something bad happened				
	
	
	
;------------DO NOT REMOVE-------------------------------------
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
;------------DO NOT REMOVE------------------------------------