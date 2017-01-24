/*
 * lights_main.c
 *
 *  Created on: Jan 19, 2017
 *      Author: gageec
 */

#include "system.h"

int main(void)
{
	unsigned char *switchesBase_ptr = (unsigned char *) SWITCHES_BASE;
	unsigned char *ledsBase_ptr = (unsigned char *) LEDS_BASE;
	unsigned char switch_val;

	while (1) {
		switch_val = *switchesBase_ptr;
		*ledsBase_ptr = switch_val;
	}
}
