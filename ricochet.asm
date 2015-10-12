
macro enum eName*, [members*] {
    common
        local i
        i = 1
    forward
        eName#.#members = i
        i = i + 1
}

; Compare st(0) to st(1), set ZF, PF, and CF accordingly, and pop twice.
; DOSBox does not support FCOMI instructions, so they must be synthesized.
macro fcomipp protect {
    if protect ~ eq
        pop ax
    end if
    
    fcompp
    fstsw ax
    sahf
    
    if protect ~ eq
        pop ax
    end if
}

enum target,\
    dos,\
    mikeos

define _target target.dos

if _target = target.dos
    display 'Building for DOS', 0x0D, 0x0A
    org 0x100
else if _target = target.mikeos
    display 'Building for MikeOS', 0x0D, 0x0A
    org 32768
end if

include 'main.asm'
include 'ball.asm'
include 'old-files/string.asm'
    string.teletype
    string.reverse
    string.numberToString
