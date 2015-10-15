
struc ballSprite z, a, b {
    db z,a,a,a,z
    db a,a,b,a,a
    db a,b,b,b,a
    db a,a,b,a,a
    db z,a,a,a,z
}

sprites:
    .ball ballSprite 0, 9, 13
