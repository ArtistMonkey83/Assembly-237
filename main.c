/*
Name: Yolie Reyes
Asignment Name/Number: Program 8 Stop light in C
EECE 237 Fall 2021
*/
#include "tm4c123gh6pm.h"
#include <stdint.h>
#include <stdio.h>

//FUNCTION PROTOTYPES GO UNDER HERE
//Not the whole function, just the return type, name, and types of any parameters
void PORT_F_INIT(void);
void setLED(uint32_t);
void SysTick_INIT(void);
void SysTick_Handler(void);
void changeReload(uint32_t);
void checkButtons(void);

//GLOBAL VARIABLES GO UNDER HERE
//Can be accessed from anywhere in your code
//Don't use them unless you have to
const uint32_t RED = 0x02;					//This value will set the LEDs to RED
const uint32_t YELLOW = 0x0A;				//This value will set the LEDs to YELLOW
const uint32_t GREEN = 0x08;				//This value will set the LEDs to GREEN
const uint32_t SW1 = 0x01;					//This value will indicate that SW1 is pressed
const uint32_t SW2 = 0x10;					//This value will indicate that SW2 is pressed
const uint32_t MAXRELOAD = 0x00FFFFFF;	//This value will "delay", using the SysTick counter, by about a second
const uint32_t HALFRELOAD = 0x007FFFFF;	//This value will "delay", using the SysTick counter, by about half a second


//MAIN FUNCTION
//This is where your code starts executing
//Should do most of your work in functions
//Your program will stop executing once "return 0" executes, if it ever does
//This program will start with a red LED and then cycle through yellow, green and then back to red
//If either Switch 1 or 2 are pressed, otherwise will just display red till a button is pressed
int main (void)
{
	uint32_t color = RED;		//This will be used to initialize LEDs to display RED
	PORT_F_INIT();          //Function to initialize port F
	setLED(color);					//Setting the color with setLED function
	SysTick_INIT();					//Initialize the SysTick counter

	while(1) { }						//Infinite loop

	return 0;								//Exits our program if we ever reach here, which we shouldn't because of the while loop being set to true with a 1
}

//FUNCTION DEFINITIONS GO UNDER HERE
//This is where you actually write your functions


//This is the function that initializes the LEDs
void PORT_F_INIT() {

	//Don't have to load addresses and data seperately in C
	//Can read, write ect. directly
	SYSCTL_RCGCGPIO_R |=0x20;

	GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY;    //Unlock PORTF
	GPIO_PORTF_CR_R = 0xFF;								//setbuf all 8 lower bits to 1
																				//Enables writing to all bits in the PUR_R Register
	GPIO_PORTF_AMSEL_R = 0;								//clear the bits to deactivate the Analog function of this port
	GPIO_PORTF_PCTL_R = 0;								/*Each nibble (4bits) controls the configuration of a single pin.
																					Set all to 0 to configure the port as GPIO*/
	GPIO_PORTF_AFSEL_R = 0;								//clear the bits in the Alternate Function register
	GPIO_PORTF_PUR_R = 0x11;							//Enable weak pull-up resistors on PF0 and PF4
	GPIO_PORTF_DIR_R = 0x0E;							/* Configure PORTF Pin 1, 2, and 3 digital output (1)
																					Also configures PORTF Pin 0, 4 as digital input (0)*/
	GPIO_PORTF_DEN_R = 0xFF;							/*Enable PORTF Pin 0, 1, 2, 3, 4 as digital pins
																					Activate LED pins (1-3) and switch pin (0,4)*/
}

//This is the function that sets the LEDs to a particular color
void setLED(uint32_t color) {		//We initialially set in main that scope's color variable == RED(0x02)
  GPIO_PORTF_DATA_R &=0xF1;			// 0 0 0 Sw2   G B R Sw1 therefore we want 0xF1(1111 0001) which will clear LEDs
	GPIO_PORTF_DATA_R |= color;		//With the values cleared using the AND operation we can now set it to the color we want initially it is == 0x02 RED

}

//This function enables the SysTick counter protocols
void SysTick_INIT()  {
	NVIC_ST_CTRL_R = 0;    						//Pause the timer
	NVIC_ST_RELOAD_R = HALFRELOAD;		//Set the reload value
	NVIC_ST_CURRENT_R = 0;						//Reset the current value
	NVIC_ST_CTRL_R = 0x00000007;			//Turn the timer back on 0x00000007

}

//This function initializes the protocols for using the SysTick, a system provided counter.
void SysTick_Handler() {
	uint32_t currentData = GPIO_PORTF_DATA_R;		//Set currentData to hold the address of the Data Register
	currentData &= 0x0E;												//Using AND clears the bits of interest currently set in the Data Register

	if (currentData == YELLOW) {								//When the LEDs are displaying 0x0A(10) we want to cycle to GREEN and wait a second
		setLED(GREEN);														//Sets the LEDs to GREEN
		changeReload(MAXRELOAD);									//Changes the timer value to the maximum about one second
	} else if (currentData == GREEN) {					//If the LEDs are not displaying a yellow value check and see if the LEDs are displaying GREEN
		setLED(RED);															//Set the LEDs to display RED because we need to cycle back to red
		changeReload(HALFRELOAD);									//Change the time value to the halfsecond setting
	} else if (currentData == RED) {						//We execute this else if statement's code if we are currently displaying RED
		checkButtons();														//Check buttons function to see if either Sw1 or Sw2 are pressed, starting the cycle over.
		changeReload(HALFRELOAD);									//Set a timer of halfsecond, otherwise do nothing because nothing is pressed and we wait.
	}
}

//This function updates the reload value of our SysTick counter
void changeReload (uint32_t reload) {
	NVIC_ST_CTRL_R = 0;													//Pauses the timer by setting the register value to 0s
	NVIC_ST_RELOAD_R = reload;									//Reset the value by using the passed by value variable reload
	NVIC_ST_CTRL_R = 0x00000007;								//Restart SysTick, 0x00000007 will turn on the bit associated with Control Register such as ENABLE, COUNTFLAG AND CLKSOURCE
}

//This function will check to see if Sw1 or Sw2 are pressed, the pressing of these buttons will start the cycle through the stoplight colors.
void checkButtons() {
	uint32_t currentData = GPIO_PORTF_DATA_R;		//Set currentData to the address of the Data Register
	currentData &= 0xF1;												//Performing AND operation with 0xF1 will use 1111 0001 clearing the GBR LED bits

	while ( currentData == SW1 | currentData == SW2){ //We need to check if either switches are pressed, we perform the same action regardless of which is pressed
		if (currentData == SW1) {
			GPIO_PORTF_DATA_R &= 0xF1;										//Performing a logical AND operation with the 0xF1 value leaves everything but clears the LED bits
			GPIO_PORTF_DATA_R |= YELLOW;									//Performing a logical OR operation with the YELLOW value turns on the Yellow LEDs
		} else if (currentData == SW2 ) {
			GPIO_PORTF_DATA_R &= 0xF1;
			GPIO_PORTF_DATA_R |= YELLOW;
		}
		currentData = GPIO_PORTF_DATA_R;								//Set the address of the Data Register
		currentData &= 0xF1;														//Performing a logical AND operation with the 0xF1 value leaves everything but clears the LED bits
	}
	currentData &= 0xF1;
}
