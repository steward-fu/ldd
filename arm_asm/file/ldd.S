.include "/home/steward/Data/Github/ldd/arm_asm/file/ldd.inc"

.section .data
dev:    .zero         4; .align
cdev:   .zero         4; .align
major:  .zero         1; .align
buffer: .zero       255; .align
fops:   .zero fops_size; .align

.section .text
name: .asciz "ldd"; .align

.section .text
ldd_open:
  push {lr}
  text reg0, "open\n"
  bl printk
  mov r0, #0
  pop {pc}

ldd_close:
  push {lr}
  text reg0, "close\n"
  bl printk
  mov r0, #0
  pop {pc}

ldd_read:
  push {r4, r5, lr}
  mov r4, r1
  mov r5, r2

  text reg0, "read\n"
  bl printk

  ldr r0, =buffer
  bl strlen
  mov r5, r0
  
  mov r0, r4
  ldr r1, =buffer
  mov r2, r5
  bl __copy_to_user

  mov r0, r5
  pop {r4, r5, pc}

ldd_write:
  push {r4, r5, lr}
  mov r4, r1
  mov r5, r2

  text reg0, "write\n"
  bl printk

  ldr r0, =buffer
  mov r1, r4
  mov r2, r5
  bl __copy_from_user

  text reg0, "buffer: %s\n"
  ldr r1, =buffer
  bl printk

  mov r0, r5
  pop {r4, r5, pc}

cleanup_module:
  push {lr}
  ldr r0, =cdev
  ldr r0, [r0]
  bl cdev_del

  ldr r0, =dev
  ldr r0, [r0]
  byte reg1, 1
  bl unregister_chrdev_region

  text reg0, "unload it\n"
  bl printk
  pop {pc}

init_module:
  push {lr}
  text reg0, "load it\n"
  bl printk

  set_fops fops, fops_open, ldd_open
  set_fops fops, fops_read, ldd_read
  set_fops fops, fops_write, ldd_write
  set_fops fops, fops_release, ldd_close

  ldr r0, =dev
  byte reg1, 0
  byte reg2, 1
  ldr r3, =name
  bl alloc_chrdev_region

  bl cdev_alloc
  ldr r1, =cdev
  str r0, [r1]

  set_cdev cdev, cdev_fops, fops

  ldr r0, =cdev
  ldr r0, [r0]
  ldr r1, =dev
  ldr r1, [r1]
  byte reg2, 1
  bl cdev_add

  MAJOR dev
  ldr r1, =major
  str r0, [r1]

  text reg0, "major: %d\n"
  ldr r1, =major
  ldr r1, [r1]
  bl printk
  
  mov r0, #0
  pop {pc}
  .end

