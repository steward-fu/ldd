.global init_module
.global cleanup_module

.equ BUTTON,              27
.equ IRQF_TRIGGER_RISING, 1
.equ TASKLET_STATE_SCHED, 0
.equ TASKLET_STATE_RUN,   1

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.equ tasklet.next,  0
.equ tasklet.state, 4
.equ tasklet.count, 8
.equ tasklet.func,  12
.equ tasklet.data,  16

.struct 0
tasklet_s:
  i0: .struct . + 4
  i1: .struct . + 4
  i2: .struct . + 4
  i3: .struct . + 4
  i4: .struct . + 4
tasklet_e:
tasklet_l = tasklet_e - tasklet_s

.section .data
btn_irq:  .dcb 4
irq_name: .asciz "gpio_irq"
task_msg: .asciz "tasklet_handler\n"
mytask:   .space tasklet_l

.align 2
.section .text
tasklet_handler:
  push {lr}
  ldr r0, =task_msg
  bl printk
  pop {pc}

irq_handler:
  push {lr}
  mov r0, #TASKLET_STATE_SCHED
  ldr r1, =mytask
  add r1, #tasklet.state
  bl _test_and_set_bit
  cmp r0, #0
  bne irq_exit
  ldr r0, =mytask
  bl __tasklet_schedule
irq_exit:
  mov r0, #1
  pop {pc}

init_module:
  push {r4, r5, lr}

  ldr r0, =mytask
  ldr r1, =tasklet_handler
  mov r2, #0
  bl tasklet_init

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

  mov r0, #0
  pop {r4, r5, pc}

cleanup_module:
  push {lr}
  ldr r0, =btn_irq
  ldr r0, [r0]
  mov r1, #0
  bl free_irq
  ldr r0, =mytask
  bl tasklet_kill
  pop {pc}
.end

