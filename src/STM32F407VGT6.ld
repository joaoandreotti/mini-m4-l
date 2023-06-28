ENTRY(Reset_Handler)


/*
_estack = 0x20002000;
*/

MEMORY
{
  FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM(rxw)  : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
  .text : {
    *(.main)
  } > FLASH

  .data : {
  } > FLASH

  .bss : {
  } > FLASH
}
