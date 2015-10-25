
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
color BLUE20, 0, 0, 51
color BLUE40, 0, 0, 102
color BLUE60, 0, 0, 153
color BLUE80, 0, 0, 204
color WHITE20, 51, 51, 51
color WHITE40, 102, 102, 102
color WHITE60, 153, 153, 153
color WHITE80, 204, 204, 204
color WHITE, 255, 255, 255
color AQUA, 0, 255, 255
