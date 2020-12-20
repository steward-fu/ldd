.global init_module
.global cleanup_module

.equ BUTTON,               27
.equ IRQF_TRIGGER_RISING,  1
.equ POCKETBEAGLE_SOFTIRQ, 10

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.section .data
btn_irq:     .dcb 4
irq_name:    .asciz "gpio_irq"
softirq_msg: .asciz "softirq_handler\n"

.align 2
.section .text
softirq_handler:
  push {lr}
  ldr r0, =softirq_msg
  bl printk
  pop {pc}

irq_handler:
  push {lr}
  mov r0, #POCKETBEAGLE_SOFTIRQ
  bl raise_softirq
  mov r0, #1
  pop {pc}

init_module:
  push {r4, r5, lr}

  mov r0, #BUTTON
  bl gpio_to_desc
  bl gpiod_to_irq
  ldr r1, =btn_irq
  str r0, [r1]

  ldr r1, =irq_handler
  mov r2, #0
  mov r3, #IRQF_TRIGGER_RISING
  ldr r4, =irq_name
  mov r5, #0
  push {r4, r5}
  bl request_threaded_irq
  pop {r4, r5}

  mov r0, #POCKETBEAGLE_SOFTIRQ
  ldr r1, =softirq_handler
  bl open_softirq

  mov r0, #0
  pop {r4, r5, pc}

cleanup_module:
  push {lr}
  ldr r0, =btn_irq
  ldr r0, [r0]
  mov r1, #0
  bl free_irq
  mov r0, #POCKETBEAGLE_SOFTIRQ
  bl raise_softirq_irqoff
  pop {pc}
.end

