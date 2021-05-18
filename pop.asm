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

tile_map:
   block (32 * 24),0

init:
   ld ix,rows              ; row data index
   ld iy,(tile_map+4+2*32) ; tile map(4,2)
   ld hl,($5800+4+2*32)    ; color attributes(4,2)
   ld b,7                  ; bubble counter
   ld c,5                  ; row counter
@row_loop:
   ld a,c
   and $01                 ; check for odd row
   jr z,@even_row
   ld a,(ix)               ; get bubble color
   or a                    ; check if zero (no bubble)
   jr z,@empty_odd

   ld a,5                  ; check for top row
   cp c
   jr z,@top_row
   ld a,7                  ; check for left end
   cp b
   jr z,@odd_left
   ld a,(ix-9)             ; get upper left spot
   or a
   jr nz,@odd_junc_ul      ; upper left junction if non-zero
@odd_left:
   ld (iy),1               ; upper left, no junction
   jr @odd_uc
@odd_junc_ul:
   ld (iy),10              ; upper left, junction
@odd_uc:
   ld (iy+1),2               ; upper center
   ld a,b                  ; check for right end
   or a
   jr z,@odd_right_u
   ld a,(ix-8)             ; get upper right spot
   or a
   jr nz,@odd_junc_ur      ; upper right junction is non-zero
@odd_right_u:
   ld (iy+2),3             ; upper right, no junction
   jr @odd_middle
@odd_junc_ur:
   ld (iy+2),11            ; upper right, junction
   jr @odd_middle
@top_row:
   ld (iy),1               ; upper left, no junction
   ld (iy+1),2             ; upper center
   ld (iy+2),3             ; upper right, no junction
@odd_middle:
   ld de,32                ; go to next row
   add iy,de
   ld (iy),4               ; middle left
   ld (iy+1),5             ; center
   ld (iy+2),6             ; middle right
   add iy,de               ; go to next row
   ld a,b                  ; check for right end
   or a
   jr z,@odd_right_l
   ld a,(ix+7)             ; get lower left spot
   or a
   jr nz,@odd_junc_ll
@odd_right_l:
   ld (iy),7               ; lower left, no junction
   jr @odd_lc
@odd_junc_ur:
   ld (iy),12              ; lower left, junction
@odd_lc:
   ld (iy+1),8             ; lower center
   


@top_row:

@empty_odd:


@even_row:


@next_bubble:
   dec b
   jp pe,@next_row


@next_row:
   dec c
   jp pe,@return
   ld b,7


@return:
   ret

; Deployment
LENGTH      equ $ - start

; option 1: tape
include TapLib.asm
MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
SAVESNA "pop.sna", start
