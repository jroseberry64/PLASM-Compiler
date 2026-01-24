.segment "CODE"

; ==============================================================
; NOTE: 
;
; For now we have to manually jump to the PLASM procedure we
; want to be the "main" procedure. This will be automated in 
; the beta version, but for now this also demonstrates how to
; integrate PLASM code with your own hand written assembly code.
; ==============================================================
@start:
    jsr test1 

.include "test1.asm"
.include "X16Kernal_IO.asm"
.include "X16_VERA.asm"
.include "String.asm"

; ========================
; MANUALLY ADDED TEST DATA
; ========================

Str: .ASCIIZ "press f12 and type: 'v 0138a5' to see byte $55 in 16 byte incr (emu only)"
Str3: .ASCIIZ "cmpstrnt passed"
Str4: .ASCIIZ "lenstrnt passed"
Str5: .ASCIIZ "clearmem passed"
Str6: .ASCIIZ "fillmem passed"

Str2: .ASCIIZ "please press enter to continue test..."
ErrStr: .ASCIIZ "*womp womp*...test case failed..."

CmpStr1: .ASCIIZ "string"
CmpStr2: .ASCIIZ "string"
CmpStr3: .ASCIIZ "strng"

DataBuff: .byte $FF, $FF, $FF, $FF

DummySprData:
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55
.byte $55, $55, $55, $55, $55, $55, $55, $55