.arch armv5t
.fpu softvfp
.eabi_attribute 20, 1
.eabi_attribute 21, 1
.eabi_attribute 23, 3
.eabi_attribute 24, 1
.eabi_attribute 25, 1
.eabi_attribute 26, 2
.eabi_attribute 30, 4
.eabi_attribute 34, 0
.eabi_attribute 18, 4
.file   "fac.c"
.text
.align  2
.global fac
.syntax unified
.arm
.type   fac, %function
fac:
@ args = 0, pretend = 0, frame = 0
@ frame_needed = 0, uses_anonymous_args = 0
@ link register save eliminated.
mov     r3, r0
mov     r0, #1
.L3:
cmp     r3, #1
mul     r0, r3, r0
bxle    lr
sub     r3, r3, #1
b       .L3
.size   fac, .-fac
.section        .text.startup,"ax",%progbits
.align  2
.global main
.syntax unified
.arm
.type   main, %function
main:
@ args = 0, pretend = 0, frame = 16
@ frame_needed = 0, uses_anonymous_args = 0
push    {r0, r1, r2, r3, r4, lr}
ldr     r3, .L8
mov     r4, #0
ldr     r3, [r3]
str     r3, [sp, #12]
mov     r3, #0
mov     r3, #3
str     r3, [sp, #4]
ldr     r0, [sp, #4]
strh    r4, [sp, #8]    @ movhi
bl      fac
add     r0, r0, #48
mov     r2, #2
strb    r0, [sp, #8]
add     r1, sp, #8
mov     r0, r4
bl      write
ldr     r3, .L8
ldr     r2, [r3]
ldr     r3, [sp, #12]
eors    r2, r3, r2
mov     r3, #0
beq     .L6
bl      __stack_chk_fail
.L6:
mov     r0, r4
add     sp, sp, #16
@ sp needed
pop     {r4, pc}
.L9:
.align  2
.L8:
.word   __stack_chk_guard
.size   main, .-main
.ident  "GCC: (Ubuntu 13.2.0-4ubuntu3) 13.2.0"
.section        .note.GNU-stack,"",%progbits
q
