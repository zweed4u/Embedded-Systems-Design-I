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

#beq - two forever loops - JMP to sections
loop:
  loop:
    1 & 0(r3)
    br    loop
  loop:
    0 & 0(r3)
    br    loop
  #accumulator val reg gets current contents plus switch contents
  add r5, r5, 0(r2)
  ldbio r4, 0(r5)
  stbio r4, 0(r5)
  br    loop
