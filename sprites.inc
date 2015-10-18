
ballSprite.height = 7
ballSprite.width = 7
ballSprite.hotspot_xy = 3
struc ballSprite z*, a*, b*, c* {
    db z,z,b,b,b,z,z
    db z,b,a,a,a,b,z
    db b,a,c,c,c,a,b
    db b,a,c,c,c,a,b
    db b,a,c,c,c,a,b
    db z,b,a,a,a,b,z
    db z,z,b,b,b,z,z
}
