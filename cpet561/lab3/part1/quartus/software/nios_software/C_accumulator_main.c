/*
 * accumulator_main.c
 *
 *  Created on: Feb 15, 2017
 *      Author: zdw7287
 */

#include "system.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
unsigned long randomNum; // Global

/* Returns a random number using the epoch as seed. */
unsigned long getRandomPattern(void){
	srand((unsigned)time(NULL)); // Fetch current epoch and use as seed
	randomNum = rand();
	return randomNum;
}

int main(void)
{
	unsigned char *ledBase_ptr = (unsigned char *) LEDS_BASE; // Pointer to LED base memory location
	unsigned char *triggerBase_ptr = (unsigned char *) KEY1_BASE; // Pointer to Key1 base memory location
	unsigned long *accumulatorBase_ptr = (unsigned char *) O_ACCUMULATOR_BASE;
	unsigned long accumulator_val;


	accumulator_val=0; //initialize to 0

	while (1) {
		while(*triggerBase_ptr == 1) //wait for high
			;
		while(*triggerBase_ptr == 0) //wait for low
			;
		accumulator_val=(accumulator_val+*switchesBase_ptr); //contents of accumulator set to what is in the accumulator + what is on the switches
		*accumulatorBase_ptr=accumulator_val; //write content to accumulator
	}
	return(0);
}
