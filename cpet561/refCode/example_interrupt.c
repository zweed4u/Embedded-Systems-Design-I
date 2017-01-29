#include <sys/alt_irq.h>                // for IRQ support function
#include "nios_std_types.h"             // for standard embedded types
#include "system.h"                     // for Qsys #defines

#define PIO_DATA_REG_OFFSET         0
#define PIO_DATA_DIR_REG_OFFSET     1
#define PIO_INT_MASK_REG_OFFSET     2
#define PIO_EDGE_CAP_REG_OFFSET     3

#define KEY1_BIT_MASK               0x1         // bit 0
#define KEY2_BIT_MASK               0x2         // bit 1
#define KEY3_BIT_MASK               0x4         // bit 2

uint32* switchesPtr = (uint32*)SWITCHES_BASE; // may want or need volatile
uint32* grnLedsPtr  = (uint32*)GRN_LEDS_BASE;
uint32* redLedsPtr  = (uint32*)RED_LEDS_BASE;
uint32* bcdPortPtr  = (uint32*)BCD_NUMBER_BASE;

static uint32 sRunningSum  = 0;
static uint8  sSwitchValue = 0;

static uint32 sKey1Pressed = FALSE;
static uint32 sKey2Pressed = FALSE;
static uint32 sKey3Pressed = FALSE;

volatile uint32* pushButtonPtr = (uint32*)(PUSHBUTTON_BASE);

void pushButtonIsr(void *context)
{
  uint32 reg_value   = 0;
  uint32 reg_value   = 0;

  // reset key pressed flags
  sKey1Pressed = FALSE;
  sKey2Pressed = FALSE;
  sKey3Pressed = FALSE;

  // read the Edge Capture register
  reg_value = *(pushbuttonsPtr + PIO_EDGE_CAP_REG_OFFSET);

  // determine which push button was pressed
  // assume more than one could be pressed at the same time
  if (KEY1_BIT_MASK == (reg_value & KEY1_BIT_MASK))
  {
    // read the switches
    sSwitchValue = (uint8)*switchesPtr;

    sKey1Pressed = TRUE;
  } /* if */

  if (KEY2_BIT_MASK == (reg_value & KEY2_BIT_MASK))
  {
    sKey2Pressed = TRUE;
  } /* if */

  if (KEY3_BIT_MASK == (reg_value & KEY3_BIT_MASK))
  {
    sKey3Pressed = TRUE;
  } /* if */

  // clear the interrupt bits set by writing back value read
  *(pushbuttonsPtr + PIO_EDGE_CAP_REG_OFFSET) = reg_value;

} /* pushButtonIsr */

int main(void)
{

  // Turn all LEDS off
  *redLedsPtr = 0;
  *grnLedsPtr = 0;
  *bcdPortPtr = 0;

  // register the Interrupt Service Handler
  alt_ic_isr_register(PUSHBUTTON_IRQ_INTERRUPT_CONTROLLER_ID, PUSHBUTTON_IRQ,
                      pushButtonIsr, 0, 0);

  // ------------------------------------------------------------------
  // clear edge capture register of pushButtonPtr and then unmask
  // interrupt for KEY1_BIT_MASK
  // ------------------------------------------------------------------
  *(pushButtonPtr + PIO_EDGE_CAP_REG_OFFSET) = (KEY1_BIT_MASK);
  *(pushButtonPtr + PIO_INT_MASK_REG_OFFSET) = (KEY1_BIT_MASK);

  // loop forever
  while (1)
  {
    if (sKey1Pressed)
    {
      // update running sum & grn LEDs
      sRunningSum += sSwitchValue;
      *(grnLedsPtr + PIO_DATA_REG_OFFSET) = sSwitchValue;

      sKey1Pressed = FALSE;
    } /* if KEY1_BIT_MASK pressed */
    else
    {
      // update the green leds with switch value
      *(grnLedsPtr + PIO_DATA_REG_OFFSET) = *(switchesPtr + PIO_DATA_REG_OFFSET);
    } /* else */

    // output sum to red LEDs
    *(redLedsPtr + PIO_DATA_REG_OFFSET)  = sRunningSum;

    // convert sum to bcd number
    bcd_value = HexToBcd(sRunningSum);

    // send bcd value to 7-seg port
    *(bcdPortPtr  + PIO_DATA_REG_OFFSET) = bcd_value;
  } /* while */

  return (0);
} /* main */

