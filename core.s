.syntax unified
.cpu cortex-m4
.thumb

.type interrupt_table, %object
interrupt_table:
    .word __stack
    .word reset_handler

.type reset_handler, %function
reset_handler:
  ldr  r0, =__stack
  mov  sp, r0
  b reset_handler
