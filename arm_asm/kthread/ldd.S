.global init_module
.global cleanup_module

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.section .data
kthread_name: .asciz "mykthread"
kthread_msg1: .asciz "kthread_handler++\n"
kthread_msg2: .asciz "kthread_handler--\n"
mykthread:    .dcb 4

.align 2
.section .text
kthread_handler:
  push {lr}
  ldr r0, =kthread_msg1
  bl printk
loop:
  bl kthread_should_stop
  cmp r0, #0
  bne kthread_exit
  mov r0, #100
  bl msleep
  b loop

kthread_exit:
  ldr r0, =kthread_msg2
  bl printk
  pop {pc}

init_module:
  push {lr}

  ldr r0, =kthread_handler
  mov r1, #0
  mov r2, #0xffffffff
  ldr r3, =kthread_name
  bl kthread_create_on_node
  ldr r1, =mykthread
  str r0, [r1]

  bl wake_up_process

  mov r0, #0
  pop {pc}

cleanup_module:
  push {lr}
  ldr r0, =mykthread
  ldr r0, [r0]
  bl kthread_stop
  pop {pc}
.end
