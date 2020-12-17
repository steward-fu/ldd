.global main

.section .data
dev_name: .asciz "/dev/myfile"

.align 2
.section .text
main:
  push {r4, lr}
  ldr r0, =dev_name
  mov r1, #2
  bl open
  mov r4, r0

  ldr r1, =0xc0050000
  mov r2, #0
  bl ioctl

  mov r0, r4
  bl close

  mov r0, #0
  pop {r4, pc}

