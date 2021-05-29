bubble_rows:
   db 1,2,3,4,5,6,2,3
   db 5,1,2,0,4,5,6
   db 3,4,5,1,2,3,4,3
   db 2,0,0,5,6,2,3
   db 5,1,2,3,4,0,6,2
   db 4,5,1,2,3,4,5
   db 6,2,0,4,5,1,2,3
   db 5,1,2,3,4,5,6

press_depth:
   dw 0 ; 0-16

fill_rows:
   call draw_press
   ld ix,bubble_rows       ; row data index
   ld de,8+2*32            ; tile offset (8,2)
   ld hl,(press_depth)
   ld a,5
@depth_mult_32:
   sla l
   rl h
   dec a
   jr nz,@depth_mult_32
   add hl,de
   ex de,hl                ; de = adjusted start of bubble tiles
   ld b,8                  ; bubble counter
   ld c,8                  ; row counter
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
   jp z,@next_row
   inc de
   inc de                  ; go to next tile offset
   jp @row_loop
@next_row:
   ld hl,51                ; tile offset difference
   add hl,de
   ex de,hl                ; update tile offset to start of next row
   dec c                   ; decrement row counter
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

draw_press:
   ld de,tile_map+8*32     ; de = tilemap(8,1)
   ld hl,ATTR_BUFFER+8*32  ; hl = color(8,1)
   ld a,(press_depth)
   or a
   jr z,@draw_plate
   ld b,a
@shaft_loop:
   call shaft_color
   call shaft_space
   dec b
   jr z,@end_shaft
   ld a,10
   ld (de),a
   ld a,ALL_INK
   inc de
   ld (de),a
   inc de
   call shaft_space
   ld ix,16
   add ix,de
   push ix
   ld de,16
   add hl,de
   pop de
   jr @shaft_loop
@end_shaft:
   ld a,11
   ld (de),a
   ld a,ALL_INK
   inc de
   ld (de),a
   inc de
   call shaft_space
   ld ix,16
   add ix,de
   push ix
   ld de,16
   add hl,de
   pop de
@draw_plate:
   call shaft_color
   ld a,12
   ld (de),a
   ld a,13
   ld c,14
   inc de
@plate_loop:
   ld (de),a
   inc de
   dec c
   jr nz,@plate_loop
   ld a,14
   ld (de),a
   ret

shaft_space:
   ld a,ALL_PAPER
   ld c,7
@shaft_space_loop:
   ld (de),a
   inc de
   dec c
   jr nz,@shaft_space_loop
   ret

shaft_color:
   ld a,$07          ; black/gray
   ld c,16
@shaft_color_loop:
   ld (hl),a
   inc hl
   dec c
   jr nz,@shaft_color_loop
   ret
