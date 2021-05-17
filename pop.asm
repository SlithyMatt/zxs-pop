DEVICE ZXSPECTRUM48

org $8000

start:
jp init

; Character Codes
ENTER       equ $0D

tiles:
include tiles.asm

rows:
   db 1,2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1,0
   db 3,4,5,1,2,3,4,3
   db 2,3,4,5,1,2,3,0
   db 5,1,2,3,4,5,1,2
   db 4,5,1,2,3,4,5,0

init:


ret

; Deployment
LENGTH      equ $ - start

; option 1: tape
include TapLib.asm
MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
SAVESNA "pop.sna", start
