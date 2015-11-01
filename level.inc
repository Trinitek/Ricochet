
define level.width 10
define level.height 15

postpone {
    leveldata:
    .1:
        db 3                        ; number of brick types
        db btype.RED                ; 1 = RED
        db btype.GREEN              ; 2 = GREEN
        db btype.BLUE               ; 3 = BLUE
        db 0,0,0,0,0,0,0,0,0,0      ; level map
        db 0,0,0,0,0,0,0,0,0,0
        db 1,1,1,1,1,1,1,1,1,1
        db 2,2,2,2,2,2,2,2,2,2
        db 3,3,3,3,3,3,3,3,3,3
        db 2,2,2,2,2,2,2,2,2,2
        db 1,1,1,1,1,1,1,1,1,1
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
}
