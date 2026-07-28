@ crt0.s — Startup code and interrupt handler (0x100–0x3A3)
@
@ This is included as raw binary data for now to guarantee
@ a byte-identical match. As we annotate and understand each
@ section, we'll replace .incbin ranges with real assembly.
@
@ Layout:
@   0x100–0x203: Game metadata / function pointer table
@   0x204–0x237: _crt0_entry — stack setup, IRQ install, jump to AgbMain
@   0x238–0x243: Literal pool (stack addresses, IRQ vector, AgbMain ptr)
@   0x248–0x398: IntrMain — interrupt dispatcher (ARM mode)
@   0x39C–0x3A3: Literal pool for IntrMain

    .text
    .arm

    .incbin "baserom.gba", 0x100, (0x3A4 - 0x100)
