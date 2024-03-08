fac:                                    // @fac
        mov     w8, w0
        mov     w0, #1                          // =0x1
.LBB0_1:                                // =>This Inner Loop Header: Depth=1
        mul     w0, w0, w8
        cmp     w8, #2
        b.lt    .LBB0_3
        sub     w8, w8, #1
        b       .LBB0_1
.LBB0_3:
        ret
main:                                   // @main
        sub     sp, sp, #32
        stp     x29, x30, [sp, #16]             // 16-byte Folded Spill
        add     x29, sp, #16
        mov     w8, #3                          // =0x3
        stur    w8, [x29, #-4]
        ldur    w0, [x29, #-4]
        bl      fac
        adrp    x8, :got:stdout
        add     w0, w0, #48
        ldr     x8, [x8, :got_lo12:stdout]
        ldr     x1, [x8]
        bl      putc
        mov     w0, wzr
        ldp     x29, x30, [sp, #16]             // 16-byte Folded Reload
        add     sp, sp, #32
        ret
