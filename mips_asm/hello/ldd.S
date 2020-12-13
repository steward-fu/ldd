.set noreorder

.global init_module
.global cleanup_module

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
  addiu $sp, -4
  sw $ra, 0($sp)

  la $a0, msg_load
  jal printk
  nop

  lw $ra, 0($sp)
  addiu $sp, 4
  
  jr $ra
  move $v0, $0

cleanup_module:
  addiu $sp, -4
  sw $ra, 0($sp)

  la $a0, msg_unload
  jal printk
  nop
  
  lw $ra, 0($sp)
  addiu $sp, 4
  
  jr $ra
  move $v0, $0
