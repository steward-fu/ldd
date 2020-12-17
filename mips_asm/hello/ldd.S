.set noreorder

.global init_module
.global cleanup_module

.macro push arg:req
  addiu $sp, -4
  sw \arg, 0($sp)
.endm

.macro pop arg:req
  lw \arg, 0($sp)
  addiu $sp, 4
.endm

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.section .text
msg_load:   .asciz "hello, world!\n" 
msg_unload: .asciz "unload it\n"

.align 2
.section .text
init_module:
  push $ra
  la $a0, msg_load
  jal printk
  nop
  pop $ra
  jr $ra
  move $v0, $0

cleanup_module:
  push $ra
  la $a0, msg_unload
  jal printk
  nop
  pop $ra 
  jr $ra
  move $v0, $0
