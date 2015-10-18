
paletteIndex_ = 0

macro color cName*, r*, g*, b* {
    c.#cName = paletteIndex_
    postpone \{
        if ~ defined c_palette_ | defined @f
            @@:
            c_palette_:
        end if
        c.#cName#.palette: db r shr 2, g shr 2, b shr 2
    \}
    paletteIndex_ = paletteIndex_ + 1
}

color ALPHA, 0, 0, 0
color BLACK, 0, 0, 0
color BLUE, 0, 0, 255
color DARKBLUE, 0, 0, 127
color LIGHTBLUE, 127, 127, 255
