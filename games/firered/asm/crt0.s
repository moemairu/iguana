@ asm/crt0.s — GBA startup code and interrupt handler
    .text
    .arm
    .align 2

@ ─── Metadata & Vector Table (0x100–0x203) ──────────────────────────────────
    .global RomHeaderPokemonFirered
RomHeaderPokemonFirered:
    .4byte 0x00000004, 0x00000002, 0x656B6F70, 0x206E6F6D
    .4byte 0x20646572, 0x73726576, 0x006E6F69, 0x00000000
    .4byte 0x00000000, 0x00000000, 0x082350AC, 0x0823654C
    .4byte 0x0823730C, 0x082380CC, 0x083D37A0, 0x083D3E80
    .4byte 0x083D4038, 0x08245EE0, 0x08247094, 0x084556F8
    .4byte 0x00000EE0, 0x00001000, 0x00000018, 0x000005F8
    .4byte 0x00003A18, 0x0000003C, 0x00000838, 0x00000839
    .4byte 0x00000182, 0x0A0A0A07, 0x0C060C0C, 0x0C121006
    .4byte 0x08010B0F, 0x0000000C, 0x00000F24, 0x00003D68
    .4byte 0x00000034, 0x00000038, 0x00000009, 0x0000000A
    .4byte 0x00000000, 0x00000008, 0x000000AD, 0x000000AD
    .4byte 0x000030BB, 0x000030A7, 0x00000000, 0x08254784
    .4byte 0x0824FC40, 0x0824FB08, 0x083DB028, 0x08250C04
    .4byte 0x0826056C, 0x082605CC, 0x000000A8, 0x0000082C
    .4byte 0x0000083B, 0x3A0D1E2A, 0x00001E2B, 0x00000298
    .4byte 0x0000309C, 0x000030EC, 0x00000034, 0x00000000
    .4byte 0xFFFFFFFF

@ ─── Entry Point (0x204) ────────────────────────────────────────────────────
    .global _start_crt0
_start_crt0:
    mov     r0, #0x12       @ IRQ mode
    msr     cpsr_fc, r0
    ldr     sp, [pc, #40]   @ IRQ Stack (points to 0x23C)
    
    mov     r0, #0x1f       @ System mode
    msr     cpsr_fc, r0
    ldr     sp, [pc, #24]   @ System Stack (points to 0x238)
    
    ldr     r1, [pc, #28]   @ INTR_VECTOR (points to 0x240)
    add     r0, pc, #32     @ PC + 32 = IntrMain
    str     r0, [r1]
    
    ldr     r1, [pc, #20]   @ AgbMain (points to 0x244)
    mov     lr, pc
    bx      r1
    b       _start_crt0

    .4byte 0x03007E40
    .4byte 0x03007FA0
    .4byte 0x03007FFC
    .4byte 0x080003A5

@ ─── Interrupt Dispatcher (0x248) ───────────────────────────────────────────
    .global IntrMain
IntrMain:
    mov     r3, #0x4000000
    add     r3, r3, #0x200
    ldr     r2, [r3]
    ldrh    r1, [r3, #8]
    mrs     r0, SPSR
    push    {r0, r1, r2, r3, lr}
    mov     r0, #0
    strh    r0, [r3, #8]
    and     r1, r2, r2, lsr #16
    mov     ip, #0
    
    ands    r0, r1, #4
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    mov     r0, #1
    strh    r0, [r3, #8]
    
    ands    r0, r1, #128
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #64
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #2
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #1
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #8
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #16
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #32
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #256
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #512
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #1024
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #2048
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #4096
    bne     .L_intr_dispatch
    add     ip, ip, #4
    
    ands    r0, r1, #8192
    strneb  r0, [r3, #-380]
.L_intr_loop:
    bne     .L_intr_loop

.L_intr_dispatch:
    strh    r0, [r3, #2]
    bic     r2, r2, r0
    ldr     r0, [pc, #108]  @ points to 0x39C
    ldr     r0, [r0]
    ldrb    r0, [r0, #10]
    mov     r1, #8
    lsl     r0, r1, r0
    orr     r0, r0, #8192
    orr     r1, r0, #198
    and     r1, r1, r2
    strh    r1, [r3]
    mrs     r3, CPSR
    bic     r3, r3, #223
    orr     r3, r3, #31
    msr     CPSR_fc, r3
    ldr     r1, [pc, #60]   @ points to 0x3A0
    add     r1, r1, ip
    ldr     r0, [r1]
    stmfd   sp!, {lr}
    add     lr, pc, #0
    bx      r0
    ldmfd   sp!, {lr}
    mrs     r3, CPSR
    bic     r3, r3, #223
    orr     r3, r3, #146
    msr     CPSR_fc, r3
    pop     {r0, r1, r2, r3, lr}
    strh    r2, [r3]
    strh    r1, [r3, #8]
    msr     SPSR_fc, r0
    bx      lr

    .4byte 0x03007438
    .4byte 0x03003540
