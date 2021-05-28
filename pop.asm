   DEVICE ZXSPECTRUM48

   org $8000

start:
   jp init

; Memory Segments
SCREEN_MEM  = $4000
COLOR_ATTR  = $5800
DBL_BUFFER  = $E000
ATTR_BUFFER = DBL_BUFFER+$1800
DBLBUF_SIZE = $1B00

; Character Codes
ENTER       = $0D

tiles:
   include tiles.asm

tile_map:
   block (32 * 24),1

   include bubbles.asm
   include video.asm

init:
   call fill_rows
   call render_tiles
   call copy_dbl_buffer
nada:
   jp nada ; TODO not just be an infinite loop!
   ret


; Deployment
LENGTH      = $ - start

; option 1: tape
   include TapLib.asm
   MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
   SAVESNA "pop.sna", start
