.global init_module
.global cleanup_module
.extern printk
 
.section .modinfo, "ax"
__mod_kernel_version: .asciz "kernel_version=4.1.18";    .align
__mod_license:        .asciz "license=GPL";              .align
__mod_author:         .asciz "author=Steward_Fu";        .align
__mod_description:    .asciz "description=Linux Driver"; .align
 
.section .text
msg_load:   .asciz "hello, world!\n"; .align
msg_unload: .asciz "unload it\n";     .align

.section .text
cleanup_module:
  push {lr}
  ldr r0, =msg_unload
  bl printk
  pop {pc}
 
init_module:
  push {lr}
  ldr r0, =msg_load
  bl printk
  mov r0, #0
  pop {pc}
.end

