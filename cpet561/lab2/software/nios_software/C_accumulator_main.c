/*
 * accumulator_main.c
 *
 *  Created on: Jan 19, 2017
 *      Author: zdw7287
 */

#include "system.h"
int main(void)
{
	unsigned char *switchesBase_ptr = (unsigned char *) I_SWITCH_BASE;
	unsigned char *triggerBase_ptr = (unsigned char *) I_TRIGGER_BASE;
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
