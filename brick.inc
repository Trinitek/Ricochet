
define brick.width brickSprite.width
define brick.height brickSprite.height

virtual at 0
    brickobj:
        .bricktype db ?             ; enum btype
        .x dw ?
        .y dw ?
    brickobj.size = $ - brickobj
end virtual

enum btype,\
    NULL,\
    RED,\
    GREEN,\
    BLUE

colormap REDBRICK,\
    c.LIGHTRED,\
    c.DARKRED,\
    c.RED
    
colormap GREENBRICK,\
    c.LIGHTGREEN,\
    c.DARKGREEN,\
    c.GREEN
    
colormap BLUEBRICK,\
    c.LIGHTBLUE,\
    c.DARKBLUE,\
    c.BLUE
