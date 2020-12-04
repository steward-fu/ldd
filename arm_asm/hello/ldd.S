.global init_module
.global cleanup_module

.extern printk

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
.align
__UNIQUE_ID_1: .asciz "author=Steward Fu"
.align
__UNIQUE_ID_2: .asciz "description=Linux Driver"
.align

.section .text
msg_load:   .asciz "hello, world!\n" 
.align
msg_unload: .asciz "unload it\n"
.align

.section .text
init_module:
  push {lr}
  ldr r0, =msg_load
  bl printk
  mov r0, #0
  pop {pc}

cleanup_module:
  push {lr}
  ldr r0, =msg_unload
  bl printk
  pop {pc}
.end
