
define brick.width brickSprite.width
define brick.height brickSprite.height

virtual at 0
    brickobj:
    .bricktype db ?
    .x dw ?
    .y dw ?
    align 8
    brickobj.size = $ - brickobj
end virtual

enum btype,\
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
