
define paddle.width 40
define paddle.height paddleBodySprite.height

if paddle.width <= 0
    display '!! paddle.width cannot be less than or equal to 0!', 0x0D, 0x0A
    err
end if

enum pside,\
    NULL,\
    LEFT,\
    RIGHT
