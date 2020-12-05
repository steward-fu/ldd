.global init_module
.global cleanup_module

.extern printk
.extern free_irq
.extern gpio_to_desc
.extern gpiod_to_irq
.extern request_threaded_irq

.equ BUTTON, 27
.equ IRQF_TRIGGER_RISING, 1

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
.align
__UNIQUE_ID_1: .asciz "author=Steward Fu"
.align
__UNIQUE_ID_2: .asciz "description=Linux Driver"
.align

.section .data
btn_irq:  .dcb 4
.align
irq_name: .asciz "gpio_irq"
.align
irq_msg:  .asciz "irq_handler\n"
.align

.section .text
irq_handler:
  push {lr}
  ldr r0, =irq_msg
  bl printk
  mov r0, #1
  pop {pc}

init_module:
  push {r4, r5, lr}

  mov r0, #BUTTON
  bl gpio_to_desc
  bl gpiod_to_irq
  ldr r1, =btn_irq
  str r0, [r1]

  sub sp, #8
  ldr r1, =irq_handler
  mov r2, #0
  mov r3, #IRQF_TRIGGER_RISING
  ldr r4, =irq_name
  mov r5, #0
  str r4, [sp, #0]
  str r5, [sp, #4]
  bl request_threaded_irq
  add sp, #8

  mov r0, #0
  pop {r4, r5, pc}

cleanup_module:
  push {lr}
  ldr r0, =btn_irq
  ldr r0, [r0]
  mov r1, #0
  bl free_irq
  pop {pc}
.end

