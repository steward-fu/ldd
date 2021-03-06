.global init_module
.global cleanup_module

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.equ cdev.kobj,  0
.equ cdev.owner, 36
.equ cdev.ops,   40
.equ cdev.list,  44
.equ cdev.dev,   52
.equ cdev.count, 56
 
.struct 0
cdev_s:
  c0: .struct . + 36
  c1: .struct . + 4
  c2: .struct . + 4
  c3: .struct . + 8
  c4: .struct . + 4
  c5: .struct . + 4
cdev_e:
cdev_l = cdev_e - cdev_s

.equ file_operations.owner,             0
.equ file_operations.llseek,            4
.equ file_operations.read,              8
.equ file_operations.write,             12
.equ file_operations.read_iter,         16
.equ file_operations.write_iter,        20
.equ file_operations.iterate,           24
.equ file_operations.iterate_shared,    28
.equ file_operations.poll,              32
.equ file_operations.unlocked_ioctl,    36
.equ file_operations.compat_ioctl,      40
.equ file_operations.mmap,              44
.equ file_operations.open,              48
.equ file_operations.flush,             52
.equ file_operations.release,           56
.equ file_operations.fsync,             60
.equ file_operations.fasync,            64
.equ file_operations.lock,              68
.equ file_operations.sendpage,          72
.equ file_operations.get_unmapped_area, 76
.equ file_operations.check_flags,       80
.equ file_operations.setfl,             84
.equ file_operations.flock,             88
.equ file_operations.splice_write,      92
.equ file_operations.splice_read,       96
.equ file_operations.setlease,          100
.equ file_operations.fallocate,         104
.equ file_operations.show_fdinfo,       108
.equ file_operations.mmap_capabilities, 112
.equ file_operations.copy_file_range,   116
.equ file_operations.clone_file_range,  120
.equ file_operations.dedupe_file_range, 124

.struct 0
file_operations_s:
  i0: .struct . + 4
  i1: .struct . + 4
  i2: .struct . + 4
  i3: .struct . + 4
  i4: .struct . + 4
  i5: .struct . + 4
  i6: .struct . + 4
  i7: .struct . + 4
  i8: .struct . + 4
  i9: .struct . + 4
  i10: .struct . + 4
  i11: .struct . + 4
  i12: .struct . + 4
  i13: .struct . + 4
  i14: .struct . + 4
  i15: .struct . + 4
  i16: .struct . + 4
  i17: .struct . + 4
  i18: .struct . + 4
  i19: .struct . + 4
  i20: .struct . + 4
  i21: .struct . + 4
  i22: .struct . + 4
  i23: .struct . + 4
  i24: .struct . + 4
  i25: .struct . + 4
  i26: .struct . + 4
  i27: .struct . + 4
  i28: .struct . + 4
  i29: .struct . + 4
  i30: .struct . + 4
  i31: .struct . + 4
file_operations_e:
file_operations_l = file_operations_e - file_operations_s

.section .data
base:      .dcb 4
mycdev:    .space cdev_l
myfops:    .space file_operations_l
chr_name:  .asciz "myfile"
fmt:       .asciz "major:%d, minor:%d\n"
open_msg:  .asciz "myopen\n"
close_msg: .asciz "myclose\n"

.align 2
.section .text
myopen:
  push {lr}
  ldr r0, =open_msg
  bl printk
  mov r0, #0
  pop {pc}

myclose:
  push {lr}
  ldr r0, =close_msg
  bl printk
  mov r0, #0
  pop {pc}

init_module:
  push {r4, lr}

  ldr r0, =myfops
  add r1, r0, #file_operations.open
  ldr r2, =myopen
  str r2, [r1]
  add r1, r0, #file_operations.release
  ldr r2, =myclose
  str r2, [r1]

  ldr r0, =base
  mov r1, #0
  mov r2, #1
  ldr r3, =chr_name
  bl alloc_chrdev_region
  ldr r4, =base

  ldr r0, =mycdev
  ldr r1, =myfops
  bl cdev_init

  ldr r0, =mycdev
  ldr r1, [r4]
  mov r2, #1
  bl cdev_add

  ldr r0, =fmt
  ldr r1, [r4]
  ubfx r2, r1, #0, #0x14
  mov r1, r1, asr#20
  bl printk

  mov r0, #0
  pop {r4, pc}

cleanup_module:
  push {lr}
  ldr r0, =mycdev
  bl cdev_del
  ldr r0, =base
  ldr r0, [r0]
  mov r1, #1
  bl unregister_chrdev_region
  pop {pc}
.end
