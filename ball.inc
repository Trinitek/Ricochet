
define ball.width 1                 ; width/height of the hotspot, not the sprite
define ball.height 1
define ball.angleMax 2.62           ; (5pi)/6
define ball.angleMin 0.52           ; pi/6

bitfield d,\
    X,\
    Y

bitfield r,\
    HMIN,\
    HMAX,\
    VMIN,\
    VMAX,\
    VPADDLELEFT,\
    VPADDLERIGHT,\
    HPADDLE
