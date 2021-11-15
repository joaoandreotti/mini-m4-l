__stack = 0x20001000;

MEMORY
{
  FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM(rxw)  : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
  . = 0x08000000;

  .interrupt_table :
  {
    *(.interrupt_table)
  } > FLASH

  .text :
  {
    *(.text)
    *(.text.*)
    *(.glue_7t)
    *(.glue_7)
    *(.gcc*)
  } > FLASH
}
