
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

macro colormap cmName*, [colors*] {
    common
        postpone \{
            cm.#cmName:
        \}
    forward
        postpone \{
            db colors
        \}
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
color RED, 255, 0, 0
color DARKRED, 127, 0, 0
color LIGHTRED, 255, 127, 127
color GREEN, 0, 255, 0
color DARKGREEN, 0, 127, 0
color LIGHTGREEN, 127, 255, 127
