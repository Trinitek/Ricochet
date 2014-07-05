..\smlrcw -verbose ricochet.c ricochet.asm
pause

rem -flat16 == no code-from-data separation for .COM files (compatible w/ FASM)
rem -seg16t == (default) wraps code and data into separate segment blocks
rem -seg16 == wraps code and data into separate generic section blocks