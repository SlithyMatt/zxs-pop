rows:
   db 1,2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1
   db 3,4,5,1,2,3,4,3
   db 2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1,2
   db 4,5,1,2,3,4,5
   db 1,2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1
   db 3,4,5,1,2,3,4,3

fill_rows:
   ld ix,rows              ; row data index
   ld de,8+2*32            ; tile offset (8,2)
   ld b,8                  ; bubble counter
   ld c,9                  ; row counter
@row_loop:
   ld iy,ATTR_BUFFER
   add iy,de               ; iy = color attributes for tile
   ld a,(ix)               ; get bubble color
   and $07                 ; mask out any invalid bits for ink color
   or $40                  ; a = black/color
   ld (iy),a               ; upper left
   ld (iy+1),a             ; upper right
   ld (iy+32),a            ; lower left
   ld (iy+33),a            ; lower right
   ld iy,tile_map
   add iy,de
   ld a,(ix)               ; check for bubble
   or a
   jr z,@empty_tiles
   ld (iy),2               ; upper left
   ld (iy+1),3             ; upper right
   ld (iy+32),4            ; lower left
   ld (iy+33),5            ; lower right
   jp @next_bubble
@empty_tiles:
   ld a,ALL_INK
   ld (iy),a               ; upper left
   ld (iy+1),a             ; upper right
   ld (iy+32),a            ; lower left
   ld (iy+33),a            ; lower right
@next_bubble:
   inc ix
   dec b
   ld a,0
   cp b
   jp z,@next_row
   inc de
   inc de                  ; go to next tile offset
   jp @row_loop
@next_row:
   dec c                   ; decrement row counter
   ld hl,51                ; tile offset difference
   add hl,de
   ex de,hl                ; update tile offset to start of next row
   ld a,0
   cp c
   jr z,@return
   bit 0,c
   jr z,@next_even
   ld b,8                  ; re-init bubble counter for odd row
   jp @row_loop
@next_even:
   ld b,7                  ; re-init bubble counter for even row
   jp @row_loop
@return:
   ret
