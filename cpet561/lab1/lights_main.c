/*
 * lights_main.c
 *
 *  Created on: Jan 19, 2017
 *      Author: gageec
 */

#include "system.h"

int main(void)
{
	unsigned char *switchesBase_ptr = (unsigned char *) SWITCHES_BASE;	//create & declare a pointer to casted variable found in system.h - address = switches_base
	unsigned char *ledsBase_ptr = (unsigned char *) LEDS_BASE;			//create & declare a pointer to casted variable found in system.h - address = leds_base
	unsigned char switch_val;											//create 1 byte variable

	while (1) {
		switch_val = *switchesBase_ptr;		//switch_val gets data of the address where switchesBase_ptr points to 
		*ledsBase_ptr = switch_val;			//set the data to switch_val for the address where ledsBase_ptr points to
	}
}
