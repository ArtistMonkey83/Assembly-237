; Name
; Wildcat ID Number
; Assignment Name/Number
; EECE 237 Fall 2021

BASE_MEMORY EQU 0x20000000			;Tiva base memory address
;PORTF constants for reference 	
RED     EQU 0x03					;Red LED - 1st bit (001x), like a macro/#define in c
SW2		EQU 0x10
BLUE	EQU 0X04
PURPLE	EQU 0X06
SW1		EQU 0X01	
;------------DO NOT REMOVE--------------------------- 
        AREA    |.text|, CODE, READONLY, ALIGN=2 
        THUMB 
        GET tm4c123gh6pm.s
        EXPORT  Start 
;------------DO NOT REMOVE--------------------------- 

Start;----------write your code below this line!-----
		BL		PORT_F_INIT		;Function: Initializes Lights Port F, I/O, etc. Leave this alone!
		;LDR R4, =RED
		LDR R1, =GPIO_PORTF_DATA_R ;PLACING ADDRESS IN R1 the location of the current LEDs are
cycle	LDR R0, [R1] ;Loading the data in R1 into R0
	
	;xxxS1 GBRS2
	;0000  0000
	;sw2 is bit 0 we need to poll
		
		
		AND R0,R0,#0xF1 ;check to see whats on, turn off? R0 is where the data is and is the destination
	;0xF1
	;1111 0001 F1
	;0001 1010 F0 And is == 1 when both are 1 otherwise it is 0!
	;0001 0000 Sumation Sw1 is on! R0 has the current state of the switches!

;going to compare and see if switch is pressed
		CMP R0, #SW2 ;compare SW2 and R0
				 ;CMP -> subtraction
				 ;R0- 0x10, depending on result, set flags
		BEQ switch2 ;if switch2 is on
		
		CMP R0, #SW1 ; compare SW1 and R0
		BEQ switch1  ; if switch1 is on jump to switch1 protocol
		
		; if the switches are not pressed do the following
		ORR R0, R0, #PURPLE ;R4
		STR R0,[R1];r0 into r1 once this is stored the light will turn on
		B cycle
switch2	;switch2 is pressed and this code will execute we get here from the BEQ in line 41.
		ORR R0, R0, #BLUE
		STR R0, [R1] ; store the value of blue in register 1.
	B cycle
switch1	;switch1 is pressed and this code will execute we get here from the BEQ in line 44.
		ORR R0, R0, #RED
		STR R0, [R1]	; Store the value of red in register 1.
	B cycle
		
  
	
	
loop	B loop						;end w/ infinite loop; jumps to label "loop" and repeats this line forever

ERR									;Error state, if something bad happens, go here.
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
