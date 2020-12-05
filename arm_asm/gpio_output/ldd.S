.global init_module
.global cleanup_module

.extern printk
.extern msleep
.extern gpio_free
.extern gpio_request
.extern gpio_to_desc
.extern gpiod_set_raw_value
.extern gpiod_direction_output_raw

.equ USR3_LED, ((32 * 1) + 24)

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
.align
__UNIQUE_ID_1: .asciz "author=Steward Fu"
.align
__UNIQUE_ID_2: .asciz "description=Linux Driver"
.align

.section .text
led_name: .asciz "USR3"
.align

.section .text
init_module:
  push {r4, r5, lr}

  mov r0, #USR3_LED
  ldr r1, =led_name
  bl gpio_request

  mov r0, #USR3_LED
  bl gpio_to_desc
  mov r5, r0

  mov r0, r5
  mov r1, #1
  bl gpiod_direction_output_raw

  mov r4, #3
loop:
  mov r0, r5
  mov r1, #0
  bl gpiod_set_raw_value

  mov r0, #1000
  bl msleep

  mov r0, r5
  mov r1, #1
  bl gpiod_set_raw_value

  mov r0, #1000
  bl msleep

  subs r4, #1
  bne loop

  mov r0, #USR3_LED
  bl gpio_free

  mov r0, #0
  pop {r4, r5, pc}

cleanup_module:
  push {lr}
  pop {pc}
.end

