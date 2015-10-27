
ballSprite.height = 7
ballSprite.width = 7
ballSprite.hotspot_xy = 3           ; offset from top left
struc ballSprite z*, a*, b*, c* {
    db z,z,b,b,b,z,z
    db z,b,a,a,a,b,z
    db b,a,c,c,c,a,b
    db b,a,c,c,c,a,b
    db b,a,c,c,c,a,b
    db z,b,a,a,a,b,z
    db z,z,b,b,b,z,z
}

vertWallSprite.height = 1
vertWallSprite.width = 9
horizWallSprite.height = 9
horizWallSprite.width = 1
struc hvWallSprite a*, b*, c*, d*, e*, f*, g*, h*, i* {
    db a,b,c,d,e,f,g,h,i
}

leftCornerSprite.height = 9
leftCornerSprite.width = 9
struc leftCornerSprite a*, b*, c*, d*, e*, f*, g*, h*, i* {
    db a,a,a,a,a,a,a,a,a
    db a,b,b,b,b,b,b,b,b
    db a,b,c,c,c,c,c,c,c
    db a,b,c,d,d,d,d,d,d
    db a,b,c,d,e,e,e,e,e
    db a,b,c,d,e,f,f,f,f
    db a,b,c,d,e,f,g,g,g
    db a,b,c,d,e,f,g,h,h
    db a,b,c,d,e,f,g,h,i
}

rightCornerSprite.height = 9
rightCornerSprite.width = 9
struc rightCornerSprite a*, b*, c*, d*, e*, f*, g*, h*, i* {
    db a,a,a,a,a,a,a,a,i
    db b,b,b,b,b,b,b,h,i
    db c,c,c,c,c,c,g,h,i
    db d,d,d,d,d,f,g,h,i
    db e,e,e,e,e,f,g,h,i
    db f,f,f,d,e,f,g,h,i
    db g,g,c,d,e,f,g,h,i
    db h,b,c,d,e,f,g,h,i
    db a,b,c,d,e,f,g,h,i
}

leftPaddleCapSprite.height = 9
leftPaddleCapSprite.width = 5
struc leftPaddleCapSprite z*, a*, b*, c*, d* {
    db z,z,a,a,a
    db z,a,b,c,d
    db a,b,c,d,a
    db a,b,c,d,d
    db a,b,c,d,a
    db a,b,c,d,d
    db a,b,c,d,a
    db z,a,b,c,d
    db z,z,a,a,a
}

rightPaddleCapSprite.height = 9
rightPaddleCapSprite.width = 5
struc rightPaddleCapSprite z*, a*, b*, c*, d* {
    db a,a,a,z,z
    db d,c,b,a,z
    db a,d,c,b,a
    db d,d,c,b,a
    db a,d,c,b,a
    db d,d,c,b,a
    db a,d,c,b,a
    db d,c,b,a,z
    db a,a,a,z,z
}

paddleBodySprite.height = 9
paddleBodySprite.width = 1
struc paddleBodySprite a*, b*, c* {
    db a,b,c,b,c,b,c,b,a
}
