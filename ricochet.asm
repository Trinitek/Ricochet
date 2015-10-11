
macro enum eName*, [members*] {
    common
        local i
        i = 1
    forward
        eName#.#members = i
        i = i + 1
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
