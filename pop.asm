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
   call fill_rows
   call render_tiles
   ret

tile_offset:
   dw 0

fill_rows:
   ld ix,rows              ; row data index
   ld bc,4+2*32            ; (4,2)
   ld (tile_offset),bc
   ld iy,tile_map
   add iy,bc               ; tile_map(4,2)
   ld b,7                  ; bubble counter
   ld c,5                  ; row counter
@row_loop:
   ld d,0                  ; corner bitmap
   ld e,$78                ; set brightness, white paper - e = white/black
   ld a,c
   and $01                 ; check for odd row
   jp z,@even_row
   push ix                 ; stash iy on stack
   push bc                 ; stash bc on stack
   ld bc,(tile_offset)
   ld iy,COLOR_ATTR
   add iy,bc               ; iy = color attributes for tile
   pop bc                  ; restore bc
   ld a,(ix)               ; get bubble color
   or a                    ; check if zero (no bubble)
   jp z,@empty_odd
   ld d,$10                ; bubble present
   and $07                 ; mask out any invalid bits for ink color
   or e                    ; a = white/color
   ld (iy),e               ; upper left
   ld (iy+1),a             ; upper center
   ld (iy+2),e             ; upper right
   ld (iy+32),a            ; middle left
   ld (iy+33),a            ; center
   ld (iy+34),a            ; middle right
   ld (iy+64),e            ; lower left
   ld (iy+65),a            ; lower center
   ld (iy+66),e            ; lower right
   pop iy                  ; restore iy
   jr @check_top
@empty_odd:
   ld (iy),e               ; upper left
   ld (iy+1),e             ; upper center
   ld (iy+2),e             ; upper right
   ld (iy+32),e            ; middle left
   ld (iy+33),e            ; center
   ld (iy+34),e            ; middle right
   ld (iy+64),e            ; lower left
   ld (iy+65),e            ; lower center
   ld (iy+66),e            ; lower right
   pop iy                  ; restore iy
@check_top:
   ld a,5                  ; check for top row
   cp c
   jr z,@check_ll
   ld a,7                  ; check for left end
   cp b
   jr z,@check_ur
   ld a,(ix-9)             ; get upper left spot
   or a
   jr z,@check_ur
   ld a,$08                ; upper left junction
   or d
   ld d,a
@check_ur:
   ld a,b                  ; check for right end
   or a
   jr z,@check_ll
   ld a,(ix-8)             ; get upper right spot
   or a
   jr z,@check_ll
   ld a,$04                ; upper right junction
   or d
   ld d,a
@check_ll:
   ld a,7                  ; check for left end
   cp b
   jr z,@check_lr
   ld a,(ix+7)             ; get lower left spot
   or a
   jr z,@check_lr
   ld a,$02                ; lower left junction
   or d
   ld d,a
@check_lr:
   ld a,b                  ; check for right end
   or a
   jr z,@set_even_tiles
   ld a,(ix+8)             ; get lower right spot
   or a
   jr z,@set_even_tiles
   ld a,$01                ; lower right junction
   or d
   ld d,a
@set_even_tiles:
   ld a,$10                ; check for bubble
   and d
   jr z,@empty_even_tiles
   

@empty_even_tiles:



@odd_ul:
   ld (iy),1               ; upper left, no junction
   jr @odd_uc
@odd_junc_ul:
   ld (iy),10              ; upper left, junction
@odd_uc:
   ld (iy+1),2               ; upper center
   ld a,b                  ; check for right end
   or a
   jr z,@odd_ur
   ld a,(ix-8)             ; get upper right spot
   or a
   jr nz,@odd_junc_ur      ; upper right junction is non-zero
@odd_ur:
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
   ld a,7                  ; check for left end
   cp b
   jr z,@odd_ll
   ld a,(ix+7)             ; get lower left spot
   or a
   jr nz,@odd_junc_ll
@odd_ll:
   ld (iy),7               ; lower left, no junction
   jr @odd_lc
@odd_junc_ur:
   ld (iy),12              ; lower left, junction
@odd_lc:
   ld (iy+1),8             ; lower center
   ld a,b                  ; check for right end
   or a
   jr z,@odd_lr
   ld a,(ix+8)             ; get lower right spot
   or a
   jr nz,@odd_junc_lr
@odd_lr:
   ld (iy+2),9             ; lower right, no junction
   jp @next_bubble
@odd_junc_lr:
   ld (iy+2),13            ; lower right, junction
   jp @next_bubble
@empty_odd:
   ld a,5                  ; check for top row
   cp c
   jr z,@empty_top
   ld a,7                  ; check for left end
   cp b
   jr z,@empty_ul
   ld a,(ix-9)             ; get upper left spot
   or a
   jr z,@empty_ul
   ld (iy),28              ; odd lower right center
   jr @check_ur
@empty_ul:
   ld (iy),0               ; empty tile
@check_ur:
   ld a,b                  ; check for right end
   or a
   jr z,@empty_ur
   ld a,(ix-8)             ; get upper right spot
   or a
   jr z,@empty_ur

   ld (iy+1),29            ; odd lower right corner
   jr @empty_middle
@empty_ur:
   ld ()


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

render_tiles:

   ret

; Deployment
LENGTH      = $ - start

; option 1: tape
include TapLib.asm
MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
SAVESNA "pop.sna", start
