.syntax unified
.cpu cortex-m4
.thumb

isr_vector:
  .word 0x20002000
  .word Reset_Handler

Reset_Handler:
  ldr   r0, =0x20002000
  mov   sp, r0
  bl main
