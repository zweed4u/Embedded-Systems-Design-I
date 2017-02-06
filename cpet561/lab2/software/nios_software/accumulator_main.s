# ---------------------------------------------------------------
# Assembly language program that reads data from the switches,
# that are memory mapped to location 0x00011000, and displays
# it on the LEDs, which are memory mapped to location 0x00011010
# ---------------------------------------------------------------

.text

# -define a macro to move a 32 bit address to a register

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# -define constants - address of i/o for these peripherals
.equ I_SWITCH_BASE,      0x00011020
.equ I_TRIGGER_BASE,     0x00011010
.equ O_ACCUMULATOR_BASE, 0x00011000

#Define the main program
.global main
#load r2 and r3 and r4 with the addresses
main:
  movia r2, I_SWITCH_BASE
  movia r3, I_TRIGGER_BASE
  movia r4, O_ACCUMULATOR_BASE
  movia r5, 0
  movia r6, 0
  movia r7, 0

#beq - two forever loops - JMP to sections
loop:
  #load r5 with whats in the switches
  ldbio r5, 0(r2)
  #load r6 with whats currently in accum
  ldbio r6, 0(r4)
  #add values of r6 and r5 put in r7
  add r7, r6, r5
  #store sum in accum base - contents of r7 - 52?
  ldbio r8, 0(r7)
  stbio r8, 0(r4)
  br    loop
