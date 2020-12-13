.global init_module
.global cleanup_module

.equ BUTTON,   27
.equ USR3_LED, ((32 * 1) + 24)
.equ PERIOD,   (100 / 4)

.equ timer_list.entry,    0
.equ timer_list.expires,  8
.equ timer_list.function, 12
.equ timer_list.data,     16
.equ timer_list.flags,    20

.struct 0
timer_list_s:
  i0: .struct . + 8
  i1: .struct . + 4
  i2: .struct . + 4
  i3: .struct . + 4
  i4: .struct . + 4
timer_list_e:
timer_list_l = timer_list_e - timer_list_s

.section .modinfo, "ae"
__UNIQUE_ID_0: .asciz "license=GPL"
__UNIQUE_ID_1: .asciz "author=Steward Fu"
__UNIQUE_ID_2: .asciz "description=Linux Driver"

.section .data
led_name: .asciz "USR3"
btn_name: .asciz "BTN"
led_desc: .dcb 4
btn_desc: .dcb 4
timer:    .space timer_list_l

.align 2
.section .text
timer_handler:
  push {lr}
  ldr r0, =btn_desc
  ldr r0, [r0]
  bl gpiod_get_raw_value
  mov r1, r0

  ldr r0, =led_desc
  ldr r0, [r0]
  bl gpiod_set_raw_value
  
  ldr r0, =timer
  ldr r1, =jiffies
  ldr r1, [r1]
  add r1, #PERIOD
  bl mod_timer
  pop {pc}

init_module:
  push {r4, lr}

  mov r0, #BUTTON
  ldr r1, =btn_name
  bl gpio_request

  mov r0, #USR3_LED
  ldr r1, =led_name
  bl gpio_request

  mov r0, #BUTTON
  bl gpio_to_desc
  mov r4, r0
  ldr r1, =btn_desc
  str r4, [r1]

  mov r0, r4
  bl gpiod_direction_input

  mov r0, #USR3_LED
  bl gpio_to_desc
  mov r4, r0
  ldr r1, =led_desc
  str r4, [r1]

  mov r0, r4
  mov r1, #1
  bl gpiod_direction_output_raw

  ldr r0, =timer
  mov r1, #0
  mov r2, #0
  mov r3, #0
  bl init_timer_key

  ldr r0, =timer
  add r0, #timer_list.function
  ldr r1, =timer_handler
  str r1, [r0]

  ldr r0, =timer
  add r0, #timer_list.data
  mov r1, #0
  str r1, [r0]

  ldr r0, =timer
  ldr r2, =jiffies
  ldr r1, [r2]
  add r1, #PERIOD
  ldr r3, =timer_handler
  bl mod_timer

  mov r0, #0
  pop {r4, pc}

cleanup_module:
  push {lr}
  ldr r0, =timer
  bl del_timer
  mov r0, #BUTTON
  bl gpio_free
  mov r0, #USR3_LED
  bl gpio_free
  pop {pc}
.end

