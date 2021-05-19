rows:
   db 1,2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1
   db 3,4,5,1,2,3,4,3
   db 2,3,4,5,1,2,3
   db 5,1,2,3,4,5,1,2
   db 4,5,1,2,3,4,5

odd_ul_tiles:
   db 1,10
odd_ur_tiles:
   db 3,11
odd_ll_tiles:
   db 7,12
odd_lr_tiles:
   db 9,13

odd_empty_ul_tiles:
   db ALL_INK,28
odd_empty_uc_tiles:
   db ALL_INK,26,29,33
odd_empty_ur_tiles:
   db ALL_INK,27
odd_empty_ll_tiles:
   db ALL_INK,16
odd_empty_lc_tiles:
   db ALL_INK,14,17,30
odd_empty_lr_tiles:
   db ALL_INK,15

tile_offset:
   dw 0

fill_rows:
   ld ix,rows              ; row data index
   ld bc,4+2*32            ; (4,2)
   ld (tile_offset),bc
   ld b,7                  ; bubble counter
   ld c,5                  ; row counter
@odd_row_loop:
   ld de,(tile_offset)
   ld iy,tile_map
   add iy,de
   push iy                 ; stash iy on stack
   ld iy,COLOR_ATTR
   add iy,de               ; iy = color attributes for tile
   ld d,0                  ; corner bitmap
   ld e,$78                ; set brightness, white paper - e = white/black
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
   ld a,(ix-8)             ; get upper left spot
   or a
   jr z,@check_ur
   ld a,$08                ; upper left junction
   or d
   ld d,a
@check_ur:
   ld a,b                  ; check for right end
   or a
   jr z,@check_ll
   ld a,(ix-7)             ; get upper right spot
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
   jr z,@set_odd_tiles
   ld a,(ix+8)             ; get lower right spot
   or a
   jr z,@set_odd_tiles
   ld a,$01                ; lower right junction
   or d
   ld d,a
@set_odd_tiles:
   push bc                 ; stash bc on stack
   ld bc,0
   ld a,$10                ; check for bubble
   and d
   jr z,@empty_odd_tiles
   ld (iy+1),2             ; upper center
   ld (iy+32),4            ; middle left
   ld (iy+33),5            ; center
   ld (iy+34),6            ; middle right
   ld (iy+65),8            ; lower center
   ld hl,odd_lr_tiles
   rr d
   adc hl,bc               ; if carry is set, increment hl
   ld a,(hl)
   ld (iy+66),a            ; lower right
   ld hl,odd_ll_tiles
   rr d
   adc hl,bc               ; if carry is set, increment hl
   ld a,(hl)
   ld (iy+64),a            ; lower left
   ld hl,odd_ur_tiles
   rr d
   adc hl,bc               ; if carry is set, increment hl
   ld a,(hl)
   ld (iy+2),a             ; upper right
   ld hl,odd_ul_tiles
   rr d
   adc hl,bc               ; if carry is set, increment hl
   ld a,(hl)
   ld (iy),a               ; upper left
   pop bc                  ; restore bc
   jp @next_odd_bubble
@empty_odd_tiles:
   push bc                 ; stash bc on stack
   ld a,ALL_INK
   ld (iy+32),a            ; middle left
   ld (iy+33),a            ; center
   ld (iy+34),a            ; middle right
   ld bc,0
   ld a,$0c                ; mask out upper junction bits
   and d
   rr a
   rr a
   ld c,a                  ; bc = index into odd_empty_uc_tiles
   ld hl,odd_empty_uc_tiles
   add hl,bc
   ld e,(hl)
   ld (iy+1),e            ; upper center
   ld hl,odd_empty_ur_tiles
   ld bc,0
   rr a                   ; upper right bit in carry
   adc hl,bc              ; if carry set, increment hl
   ld e,(hl)
   ld (iy+2),e            ; upper right
   ld hl,odd_empty_ul_tiles
   rr a                   ; upper left bit in carry
   adc hl,bc              ; if carry set, increment hl
   ld e,(hl)
   ld (iy),e              ; upper left
   ld a,$03
   and d
   ld c,a
   ld hl,odd_empty_lc_tiles
   add hl,bc
   ld e,(hl)
   ld (iy+65),e            ; lower center
   ld hl,odd_empty_lr_tiles
   ld bc,0
   rr a                   ; lower right bit in carry
   adc hl,bc              ; if carry set, increment hl
   ld e,(hl)
   ld (iy+66),e           ; lower right
   ld hl,odd_empty_ll_tiles
   rr a                   ; lower left bit in carry
   adc hl,bc              ; if carry set, increment hl
   ld e,(hl)
   ld (iy+64),e           ; lower left
   pop bc                 ; restore bc
   jp @next_odd_bubble
@next_odd_bubble:
   inc ix
   dec b
   jp pe,@next_even_row
   ld de,(tile_offset)
   ld hl,3
   add de,hl
   ld (tile_offset),de
   jp @odd_row_loop
@next_even_row:
   dec c
   ld b,6
   ld de,(tile_offset)
   ld hl,76
   add de,hl
   ld (tile_offset),de
@even_row_loop:
   ld de,(tile_offset)
   ld iy,tile_map
   add iy,de
   push iy                 ; stash iy on stack
   ld iy,COLOR_ATTR
   add iy,de               ; iy = color attributes for tile
   ld d,0                  ; side bitmap
   ld e,$78                ; set brightness, white paper - e = white/black
   ld a,(ix)               ; get bubble color
   or a
   jr z,@empty_even
   ld d,$02                ; bubble present
   or e                    ; a = white/color
   ld (iy),e               ; upper left side
   ld (iy+1),a             ; upper left center
   ld (iy+2),a             ; upper right center
   ld (iy+32),e            ; lower left side
   ld (iy+33),a            ; lower left center
   ld (iy+34),a            ; lower right center
   pop iy
   jr @check_even_left
@empty_even:
   ld (iy),e               ; upper left side
   ld (iy+1),e             ; upper left center
   ld (iy+2),e             ; upper right center
   ld (iy+32),e            ; lower left side
   ld (iy+33),e            ; lower left center
   ld (iy+34),e            ; lower right center
   pop iy
@check_even_left:
   ld a,6                  ; check for left end
   cp b
   jr z,@set_even_tiles
   ld a,(ix-1)             ; get left bubble color
   or a
   jr z,@set_even_tiles
   ld a,$01                ; left side junction
   or d
   ld d,a
@set_even_tiles:
   ld a,$02                ; check for bubble present
   and d
   jr z,@empty_even_tiles
   ld (iy+1),19            ; upper left center
   ld (iy+2),20            ; upper right center
   ld (iy+33),23           ; lower left center
   ld (iy+34),24           ; lower right center
   ld a,$01
   and d                   ; a = 1 -> left side junction
   jr z,@even_left_empty
   ld (iy),31              ; upper side junction
   ld (iy+32),32           ; lower side junction
   jr @next_even_bubble
@even_left_empty:
   ld (iy),18              ; upper left side
   ld (iy+32),22           ; lower left side
   jr @next_even_bubble
@empty_even_tiles:
   ld (iy+1),ALL_INK       ; upper left center
   ld (iy+2),ALL_INK       ; upper right center
   ld (iy+33),ALL_INK      ; lower left center
   ld (iy+34),ALL_INK      ; lower right center
   ld a,$01
   and d                   ; a = 1 -> left side junction
   jr z,@even_all_empty
   ld (iy),21              ; upper right side
   ld (iy+32),25           ; lower right side
   jr @next_even_bubble
@even_all_empty:
   ld (iy),ALL_INK         ; upper left side empty
   ld (iy+32),ALL_INK      ; lower left side empty
@next_even_bubble:
   inc ix
   dec b
   jp pe,@next_odd_row
   ld de,(tile_offset)
   ld hl,3
   add de,hl
   ld (tile_offset),de
   jp @even_row_loop
@next_odd_row:
   ; TODO: last column of right end
   dec c
   jp pe,@under_last_row
   ld b,7
   ld de,(tile_offset)
   ld hl,45
   add de,hl
   ld (tile_offset),de
   jp @odd_row_loop
@under_last_row:
   ld hl,COLOR_ATTR+5+17*32  ; (5,17)
   ld a,$78                ; white/black
   ld c,21
@under_color_loop:
   ld (hl),a
   dec
   jp po,@under_color_loop
   ld ix,rows+38           ; beginning of row 6
   ld iy,tile_map+6+17*32  ; tile map (6,17)
   ld b,6                  ; loop index (7 iterations)
   ld a,(ix)               ; get left bubble
   or a
   jr z,@under_left_empty
   ld (iy-1),26
   jr @under_tile_loop
   ld (iy-1),ALL_INK
@under_tile_loop:
   ld a,(ix)
   or a
   jr z,@under_empty
   ld (iy),27              ; lower left center
   ld (iy+1),28            ; lower right center
   ld a,b                  ; check for right end
   or a
   jr z,@under_no_right
   ld a,(ix+1)             ; check right bubble
   or a
   jr z,@under_no_right
   ld (iy+2),33            ; lower corner junction
   jr @next_under_bubble
@under_no_right:
   ld (iy+2),29            ; lower right corner
   jr @next_under_bubble
@under_empty:
   ld (iy),ALL_INK         ; lower left center
   ld (iy+1),ALL_INK       ; lower right center
   ld a,b                  ; check for right end
   or a
   jr z,@under_empty_no_right
   ld (iy+2),26            ; lower left corner, right bubble
   jr @next_under_bubble
@under_empty_no_right:
   ld (iy+2),ALL_INK       ; lower right corner
@next_under_bubble:
   dec b
   jp pe,@return
   inc ix
   ld de,3
   add iy,de
   jr @under_tile_loop
@return:
   ret
