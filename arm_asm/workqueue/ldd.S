.global init_module
.global cleanup_module

.extern printk
.extern free_irq
.extern gpio_to_desc
.extern gpiod_to_irq
.extern queue_work_on
.extern destroy_workqueue
.extern request_threaded_irq
.extern __alloc_workqueue_key

.equ BUTTON, 27
.equ IRQF_TRIGGER_RISING, 1

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
.align
__UNIQUE_ID_1: .asciz "author=Steward Fu"
.align
__UNIQUE_ID_2: .asciz "description=Linux Driver"
.align

.equ work_struct.data,       0
.equ work_struct.entry,      4
.equ work_struct.entry.next, 4
.equ work_struct.entry.prev, 8
.equ work_struct.func,       12

.struct 0
work_struct_s:
  i0: .struct . + 4
  i1: .struct . + 8
  i2: .struct . + 4
work_struct_e:
work_struct_l = work_struct_e - work_struct_s

.section .data
btn_irq:     .dcb 4
.align
irq_name:    .asciz "gpio_irq"
.align
work_name:   .asciz "myworkqueue"
.align
work_msg:    .asciz "workqueue_handler\n"
.align
mywork:      .space work_struct_l
.align
myworkqueue: .dcb 4
.align

.section .text
workqueue_handler:
  push {lr}
  ldr r0, =work_msg
  bl printk
  pop {pc}

irq_handler:
  push {lr}
  mov r0, #2
  ldr r1, =myworkqueue
  ldr r1, [r1]
  ldr r2, =mywork
  bl queue_work_on
  mov r0, #1
  pop {pc}

init_module:
  push {r4, r5, lr}

  ldr r0, =work_name
  mov r1, #0
  mov r2, #0
  mov r3, #0
  mov r4, #0
  push {r4}
  bl __alloc_workqueue_key
  pop {r4}
  ldr r1, =myworkqueue
  str r0, [r1]

  ldr r0, =mywork
  add r0, #work_struct.data
  ldr r1, =#0xffffffe0
  str r1, [r0]
  
  ldr r0, =mywork
  add r0, #work_struct.entry @next
  mov r1, r0
  str r1, [r0]
  add r0, #work_struct.entry @prev
  str r1, [r0]
  
  ldr r0, =mywork
  add r0, #work_struct.func
  ldr r1, =workqueue_handler
  str r1, [r0]

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
  ldr r0, =myworkqueue
  ldr r0, [r0]
  bl destroy_workqueue
  pop {pc}
.end

