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

init:
   call fill_rows
   call render_tiles
   ret


render_tiles:

   ret

; Deployment
LENGTH      = $ - start

; option 1: tape
include TapLib.asm
MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
SAVESNA "pop.sna", start
