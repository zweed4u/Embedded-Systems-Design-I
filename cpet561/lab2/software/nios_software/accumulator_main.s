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
  movia r5, 1
  movia r6, 0
  movia r7, 0
  movia r8, 0
  movia r9, 0
  movia r10, 0
  movia r11, 0
  movia r12, 0

  loop:
    ldb r11, 0(r2)
    ldb r12, 0(r4)
    #store contents of trigger into reg
    ldb r7, 0(r3)
    #Trigger high hit
    beq r5, r7, L0
    br loop

  L0:
    #store contents of trigger into reg
    ldb r7, 0(r3)
    #Trigger low hit
    beq r6, r7, L1
    bne r6, r7, L0

  L1:
    add r9, r11, r12
    stb r9, 0(r10)
    ldb r10, 0(r10)
    stb r10, 0(r4)
    #dummy jump to main
    beq r10, r10, main
