.data
F12OUT:
    .ascii      "xxxxxxxxx\n"
    len = . - F12OUT
B2A:
    .ascii     "0123456789"

F12DIV: .long 0
F12MOD: .long 0

.text
.globl _start
_start:

    mov     r0, #5
    mov     r1, #1

FLoop:                      @ Calculate 12!
    mul     r1,r0,r1
    subs    r0,r0,#1
    bne     FLoop

    ldr     r0, =F12DIV     @ Store 12! in F12DIV
    str     r1,[r0]
    ldr     r4,=B2A
    ldr     r5,=F12OUT
    add     r5,r5,#8        @ Point r5 to last x in F12OUT

DLoop:
    ldr     r1, =F12DIV
    ldr     r0,[r1]
    bl      MOD10           @ Find value of F12DIV MOD 10
    ldr     r1, =F12MOD
    str     r0,[r1]

    ldrb    r6,[r4,r0]      @ Convert to char in B2A
    strb    r6,[r5]         @ Store in F12OUT
    sub     r5,r5,#1        @ Decrement r5

    ldr     r1, =F12DIV
    ldr     r0,[r1]
    bl      DIV10           @ Find value of F12DIV DIV 10
    ldr     r1, =F12DIV     @ Save back to F12DIV
    str     r0,[r1]
    cmp     r0,#0
    bne     DLoop           @ Repeat until F12DIV is Zero

    /* syscall write(int fd, const void *buf, size_t count) */
    mov     r0, #1      /* fd -> stdout */
    ldr     r1, =F12OUT /* buf ->  */
    ldr     r2, =len    /* count -> len(msg) */
    mov     r7, #4      /* write is syscall #4 */
    swi     0           /* invoke syscall */

    /* syscall exit(int status) */
    eor     r0, r0      /* status -> 0 */
    mov     r7, #1      /* exit is syscall #1 */
    swi     0           /* invoke syscall */

MOD10:
    movw    r3, #52429
    movt    r3, 52428
    movs    r2, #10
    umull   r1, r3, r3, r0
    lsrs    r3, r3, #3
    mls     r0, r2, r3, r0
    bx      lr

DIV10:
    movw    r3, #52429
    movt    r3, 52428
    umull   r3, r0, r3, r0
    lsrs    r0, r0, #3
    bx      lr
