/*
Name: Yolie Reyes
Wildcat ID#: 011234614
Program 7 C Implementation of RGB switching LED 
EECE 237 Fall 2021

*/

//Includes tell what header files and libraries to use
#include "tm4c123gh6pm.h"
#include <stdint.h>
#include <stdio.h>

/* Some Notes:
	* Debugger will crash if you use "Run" in debug mode right away.
			Step into the program first, then hit Run
	* Your code might not start executing if you do Translate, Build, Load as usual.
			If you're having issues, try using debug mode, stepping in a line or two, then exit debug. Your code should execute automatically after that.
	* Function and variable names are CASE SENSITIVE! 
			You must keep the same spelling and capitalization when you define/call them, or there will be errors 
	* DO NOT USE REGULAR INTEGERS! (int)
			They will not work! Keil will not give an error/warning either!
	* |= is a OR assign operation 
	* &= is an AND assign operation
	* != is a NOT assign operation
*/


//FUNCTION PROTOTYPES GO UNDER HERE
//Not the whole function, just the return type, name, and types of any parameters
void PORT_F_INIT(void);
void setLED(uint32_t);

//GLOBAL VARIABLES GO UNDER HERE
//Can be access from anywhere in your code 
//Don't use them unless you have to
volatile uint32_t temp;		// just exists to wast time during the delay function

//MAIN FUNCTION
//This is where your code starts executing
//Should do most of your work in functions
//Your program will stop executing once "return 0" executes, if it ever does
int main (void) 
{
	PORT_F_INIT();	//FUNCTION to initialize port F
	
	while(1){
			uint32_t color = 0x02; 		//variable to hold current light value
			setLED(color);						//turn on red LED, delay, then turn the LED off
			color = 0x04; 						//set color for blue (0x04)
			setLED(color);						//turn on blue LED, delay, then turn the LED off
			color = 0x08; 						//set color for green (0x08)
			setLED(color);						//turn on red LED, delay, then turn the LED off
	}
	
	return 0;
}

//FUNCTION DEFINITIONS GO UNDER HERE
//This is where you actually write your functions
void  PORT_F_INIT(){
	//Don't have to load addresses and data separately in c
	// can read, write, etc. directly
	SYSCTL_RCGCGPIO_R |= 0X20;
	
	GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY; //	Unloack PORTF
	GPIO_PORTF_CR_R = 0XFF;						//SET ALL 8 LOWER BITS TO 1
																		//ENABLES WRITING TO ALL BITS IN THE pur_r REGISTER
	GPIO_PORTF_AMSEL_R =0;						//clear the bits to deactivate the analog function of this port
	GPIO_PORTF_PCTL_R =0;							//Each nibble (4bits) controls the configuration of a single pin
																		//SET ALL TO 0 to configure the port as GPIO
	GPIO_PORTF_AFSEL_R = 0;						//Clear the bits in the Alternate Function register
	GPIO_PORTF_PUR_R = 0X11;					//enable weak pull-up on PF0 and PF4
	GPIO_PORTF_DIR_R = 0X0E;					//Configure PORTF PIN 1,2,3 DIGITAL OUT PUT (1)
																		//ALSO CONFIGURES PORTF pin0,4 as digital input (0)
	GPIO_PORTF_DEN_R = 0XFF;					//enable PORTF pin 0,1,2,3,4 as digital pins
																		//Activate LED pins (1-3) and switch pins (0,4)
}

void setLED( uint32_t color) {
	uint32_t max = 0x00ffffff;				//maximum counter length for delay loop
	GPIO_PORTF_DATA_R |= color;				//turn on LED with an OR
	
	for(uint32_t i =0; i < max; i++) { temp = 0;}	//|= is an OR operation and an assignment, eg. R1 = R1 OR R2 (delay loop)
	
	GPIO_PORTF_DATA_R &= 0x11;				//turn off LED with an AND
																		//&= is an AND operation and an assignment, eg. R1 = R! AND R2
	
}
