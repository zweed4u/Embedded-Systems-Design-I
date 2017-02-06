# ---------------------------------------------------------------
# Assembly language program that reads data from the switches,
# that are memory mapped to location 0x00011000, and displays
# it on the LEDs, which are memory mapped to location 0x00011010
# ---------------------------------------------------------------

.text

# define a macro to move a 32 bit address to a register

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# define constants - address of i/o for these peripherals
.equ Switches, 0x00011000
.equ LEDs,     0x00011010

#Define the main program
.global main
main: 	#load r2 and r3 with the addresses
  movia r2, Switches
  movia r3, LEDs

loop: 	#read from r2 and store to r3 - pointer-esque () denotes use of the contents as pointer, go to that address in mem annd use those contents, 0 is an offest how many address to jump after lookup of r2 number
  ldbio r4, 0(r2)
  stbio r4, 0(r3)
  br    loop
