   DEVICE ZXSPECTRUM48

   org $8000

start:
   jp init

; Memory Segments
SCREEN_MEM  = $4000
COLOR_ATTR  = $5800

; Character Codes
ENTER       = $0D

tiles:
   include tiles.asm

tile_map:
   block (32 * 24),0

   include bubbles.asm
   include video.asm

init:
   call fill_rows
dbg:
   nop
   jr dbg
   call render_tiles
   jp init ; TODO not just be an infinite loop!
   ret


; Deployment
LENGTH      = $ - start

; option 1: tape
   include TapLib.asm
   MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
   SAVESNA "pop.sna", start
