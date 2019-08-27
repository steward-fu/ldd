.equiv fops_owner,             0
.equiv fops_llseek,            1
.equiv fops_read,              2
.equiv fops_write,             3
.equiv fops_aio_read,          4
.equiv fops_aio_write,         5
.equiv fops_readdir,           6
.equiv fops_poll,              7
.equiv fops_ioctl,             8
.equiv fops_unlocked_ioctl,    9
.equiv fops_compat_ioctl,      10
.equiv fops_mmap,              11
.equiv fops_open,              12
.equiv fops_flush,             13
.equiv fops_release,           14
.equiv fops_fsync,             15
.equiv fops_aio_fsync,         16
.equiv fops_fasync,            17
.equiv fops_lock,              18
.equiv fops_sendpage,          19
.equiv fops_get_unmapped_area, 20
.equiv fops_check_flags,       21
.equiv fops_dir_notify,        22
.equiv fops_flock,             23
.equiv fops_splice_write,      24
.equiv fops_splice_read,       25
.equiv fops_setlease,          26
.equiv fops_index,             27
.equiv fops_size,              (fops_index << 2)

.equiv cdev_owner,     9
.equiv cdev_fops,      10
.equiv cdev_size,      (kobj_size + 4 + 4 + list_head_size + 4 + 4)
.equiv kobj_size,      36
.equiv list_head_size, 8

.equiv O_RDONLY, 0
.equiv O_WRONLY, 1
.equiv O_RDWR,   2

.equiv reg0, 0
.equiv reg1, 1
.equiv reg2, 2
.equiv reg3, 3

.equiv MINORBITS, 20
.equiv MINORMASK, ((1 << MINORBITS) - 1)

.macro MAJOR arg:req
  ldr r0, =\arg
  ldr r0, [r0]
  lsr r0, r0, #MINORBITS 
.endm

.macro MINOR arg:req
  ldr r0, =\arg
  ldr r0, [r0]
  and r0, r0, #MINORMASK
.endm

.macro MKDEV ma:req, mi:req
  mov r1, #mi
  mov r0, #ma
  lsl r0, #MINORBITS
  or r0, r0, r1
.endm

.macro move_reg where:req
  .if \where == reg0
    mov r0, r4
  .elseif \where == reg1
    mov r1, r4
  .elseif \where == reg2
    mov r2, r4
  .elseif \where == reg3
    mov r3, r4
  .endif
.endm

.macro text where:req, arg:req
  push {r4}
  b l_str\@
  _tmp\@: .asciz "\arg"; .align
l_str\@:
  ldr r4, =_tmp\@
  move_reg \where
  pop {r4}
.endm

.macro word where:req, arg:req
  push {r4}
  b l_str\@
  _tmp\@: .word \arg; .align
l_str\@:
  ldr r4, =_tmp\@
  ldr r4, [r4]
  move_reg \where 
  pop {r4}
.endm

.macro byte where:req, arg:req
  push {r4}
  b l_str\@
  _tmp\@: .byte \arg; .align
l_str\@:
  ldr r4, =_tmp\@
  ldr r4, [r4]
  move_reg \where 
  pop {r4}
.endm

.macro set_fops base:req, index:req, addr:req
  ldr r2, =\addr
  ldr r0, =\base
  mov r1, #\index
  add r0, r0, r1, lsl #2
  str r2, [r0]
.endm

.macro set_cdev base:req, index:req, addr:req
  ldr r2, =\addr
  ldr r0, =\base
  ldr r0, [r0]
  mov r1, #\index
  add r0, r0, r1, lsl #2
  str r2, [r0]
.endm

.section .modinfo, "ax"
__module_kernel_version: .asciz "kernel_version=4.1.18";    .align 
__module_license:        .asciz "license=GPL";              .align 
__module_author:         .asciz "author=Steward";           .align 
__module_description:    .asciz "description=Linux Driver"; .align

.global init_module
.global cleanup_module

