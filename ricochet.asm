
macro enum eName*, [members*] {
    common
        local i
        i = 0
    forward
        eName#.#members = i
        i = i + 1
}

macro bitfield bName*, [members*] {
    common
        enum bName#.bit, members
        local i
        i = 1
    forward
        bName#.#members = i
        i = i * 2
}

enum target,\
    dos,\
    mikeos

;define _target target.dos

if ~ defined _target
    display '!! No build target specified!', 0x0D, 0x0A
    err
else if _target = target.dos
    display 'Building for DOS', 0x0D, 0x0A
    org 0x100
else if _target = target.mikeos
    display 'Building for MikeOS', 0x0D, 0x0A
    org 32768
end if

include 'ball.inc'
include 'field.inc'
include 'palette.inc'
include 'sprites.inc'

include 'main.asm'
include 'ball.asm'
include 'canvas.asm'
include 'sprites.asm'
include 'palette.asm'

postpone {
    align 16
    endOfProgram:
}
