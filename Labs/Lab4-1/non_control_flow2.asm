main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        addi    a5,zero,19
        sw      a5,-20(s0)
        addi    a5,zero,14
        sw      a5,-24(s0)
        lw      a4,-24(s0)
        lw      a5,-20(s0)
        add     a5,a4,a5
        addi    a0,zero,0
        not     a0,a0
        or      a0,zero,a0
        add    t3, a0, a5
        or     t2, a4, t3
        sll    t4, t3, t2
        li      a7, 10
        ecall
