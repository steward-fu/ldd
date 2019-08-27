.include "ldd.inc"

.section .data
fd:     .zero 4;   .align
buffer: .zero 255; .align

.section .text
dev_name: .asciz "/dev/ldd"; .align

.global main
main:
  push {lr}
  ldr r0, =dev_name
  byte reg1, O_RDWR
  bl open
  ldr r1, =fd
  str r0, [r1]

  cmp r0, #-1
  bne do_file

  text reg0, "failed to open driver\n"
  bl printf
  b do_exit

do_file:
  ldr r0, =buffer
  text reg1, "I am error"
  bl strcpy

  ldr r0, =buffer
  bl strlen
  mov r2, r0

  ldr r0, =fd
  ldr r0, [r0]
  ldr r1, =buffer
  bl write

  ldr r0, =buffer
  byte reg1, 0
  byte reg2, 255
  bl memset

  ldr r0, =fd
  ldr r0, [r0]
  ldr r1, =buffer
  byte reg2, 255
  bl read

  ldr r0, =fd
  ldr r0, [r0]
  bl close

  text reg0, "RD: %s\n"
  ldr r1, =buffer
  bl printf

do_exit:
  mov r0, #0
  pop {pc}
 .end

