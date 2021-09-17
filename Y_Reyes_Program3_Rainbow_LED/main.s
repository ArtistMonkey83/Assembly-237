; Name Yolanda Reyes
; Wildcat ID Number 011234614
; Assignment Name/Number Program 2 Rainbow LED
; EECE 237 Fall 2021

BASE_MEMORY EQU 0x20000000			;Tiva base memory address
;PORTF constants for reference 	
RED       EQU 0x02					;Red LED - 1st bit (001x), like a macro/#define in c
BLUE	  EQU 0x04					;8 4 2 1
GREEN     EQU 0x08					;0 0 1 0  this two in the line makes the LED red 
YELLOW	  EQU 0x0A					;
AQUA	  EQU 0x0C
PURPLE	  EQU 0x06
WHITE	  EQU 0x0f
BLACK	  EQU 0x00
	
volatile uint32_t tick = 0;
	
;------------DO NOT REMOVE--------------------------- 
        AREA    |.text|, CODE, READONLY, ALIGN=2 
        THUMB 
        GET tm4c123gh6pm.s
        EXPORT  Start 
;------------DO NOT REMOVE--------------------------- 

Start;----------write your code below this line!-----
	BL		PORT_F_INIT				;Function: Initializes Port F, I/O, etc. Leave this alone! branch instruction
	LDR R4, =BLACK	;load the value for RED variable into register R4 with is 0x02, 0010 == 2
	LDR R1, =GPIO_PORTF_DATA_R ;Loads the address of the Port F data register into F1
	LDR R0, [R1]	;R1 -> PORTF -> LIGHTS (state of) Gets the address of current state of the lights
	AND R0,R0,#0xF1 ;check to see whats on, turn off? And will clear bits.
	;0xF1 = 1111 0001 
	;AND
	;PORTF = 0000 1100 blue green lights are 4 and 8 bit and they are on
	;clearing bits unless both are on! then we can use OR to set bits
	
	ORR R0, R0,R4  ; R4 has the color we want to change to, R0
	;     GBR
	;0000 0001 == R0 OR all lights are off
	;0000 0010 == 0x02 RED
	;----------
	;0000 0011 == Now the bit for red is on!
	; R0 = code for RED
	
	STR R0,[R1]		;r0 into r1 we need brackets to access the data de reference 
	;In the STR the destination is on the right in brackets!
	;R0 = red light on
	;R1-> PORT F -> LIGHTS
	
	BL 	DELAY_1
	
loop	B loop						;end w/ infinite loop; jumps to label "loop" and repeats this line forever

ERR									;Error state, if something bad happens, go here.
	B   ERR

;------------------------------------------------------------------
;-----------------Yolie's Subroutines Start Here-------------------
;------------------------------------------------------------------

             ;-----------Delay Round 1-------------

DELAY_1
	//Author : cortex-m.com
//Function : Periodic mode milliseconds delay
 
#include "TM4C123.h"                    // Device header
 
void timer0A_delayMs(int ttime);
 
int main (void)
{
    /* enable clock to GPIOF at clock gating control register */
    SYSCTL->RCGCGPIO |= 0x20;
    /* enable the GPIO pins for the LED (PF3, 2 1) as output */
    GPIOF->DIR = 0x0E;
    /* enable the GPIO pins for digital function */
    GPIOF->DEN = 0x0E;
 
    while(1)
    {
        GPIOF->DATA = 2;        /* turn on red LED */
        timer0A_delayMs(500);   /* TimerA 500 msec delay */
        GPIOF->DATA = 0;        /* turn off red LED */
        timer0A_delayMs(500);   /* TimerA 500 msec delay */
    }
 
}
 
/* multiple of millisecond delay using periodic mode */
void timer0A_delayMs(int ttime)
{
    int i;
    SYSCTL->RCGCTIMER |= 1;     /* enable clock to Timer Block 0 */
 
    TIMER0->CTL = 0;            /* disable Timer before initialization */
    TIMER0->CFG = 0x04;         /* 16-bit option */
    TIMER0->TAMR = 0x02;        /* periodic mode and down-counter */
    TIMER0->TAILR = 16000 - 1;  /* Timer A interval load value register */
    TIMER0->ICR = 0x1;          /* clear the TimerA timeout flag*/
    TIMER0->CTL |= 0x01;        /* enable Timer A after initialization */
 
    for(i = 0; i < ttime; i++) { while ((TIMER0->RIS & 0x1) == 0) ;      /* wait for TimerA timeout flag */
        TIMER0->ICR = 0x1;      /* clear the TimerA timeout flag */
    }
}



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