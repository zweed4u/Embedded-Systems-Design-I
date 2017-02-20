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
#define numBytes 5
unsigned long *ramBase_ptr = (unsigned long *) INFERRED_RAM_BASE;	// Pointer to the base address of Inferred RAM
unsigned char *ledBase_ptr = (unsigned char *) LEDS_BASE;			// Pointer to LED base memory location
unsigned char *triggerBase_ptr = (unsigned char *) KEY1_BASE;		// Pointer to Key1 base memory location
int randomNum = 0;													// Global pattern variable
int randomStore[numBytes];											// Array for storing the random pattern

/* Returns a random number using the epoch as seed. */
int getRandomPattern(void){
	randomNum = rand();
	randomNum = (randomNum%100);
	return (randomNum); //Store each in array to check after
}
/* Return 0 or 1, for False or True respectively, if memory passes test.
 * Params: ramLocation_ptr - location of the RAM wanted to check.
 * numBytesToCheck - Size in bytes of RAM wanted to check. */
int ramConfidenceTest(unsigned long *ramLocation_ptr, unsigned int numBytesToCheck){
	//verify the write to ram here
	return 1; //Pass for now
}
/* Write random values ram
 * Params: ramLocation_ptr - location of the RAM wanted to check.
 * numBytesToCheck - Size in bytes of RAM wanted to check. */
void writeToRAM(unsigned long *ramLocation_ptr, unsigned int numBytesToCheck){
	int i = 0;
	while (numBytesToCheck){ //While we still need to write more bytes
		getRandomPattern();
		randomStore[i] = randomNum;
		*(ramLocation_ptr + i) = randomNum; // +4 columns
		i++; //increment counter for mem address from base and array of pattern
		numBytesToCheck--; //Decrement bytes for how many more to write to
	}
}

int main(void)
{
	int pass = 0; //initialize passing variable to failure
	srand((unsigned)time(NULL)); // Fetch current epoch and use as seed
	writeToRAM(ramBase_ptr, numByte); //Write values to RAM
	//pass = ramCon...
	ramConfidenceTest(ramBase_ptr, numBytes); //Verify correct values written
	return(0);
}
