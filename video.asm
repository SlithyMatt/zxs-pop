refresh_rectangle:
   db 0,0,32,24            ; x_start, y_start, x_end, y_end

rectangle_width:
   db 0

set_rectangle: ; BC = start x,y; DE = end x,y
   ld a,(refresh_rectangle)
   cp b
   jr nc,@check_c
   ld a,b
   ld (refresh_rectangle),a
@check_c:
   ld a,(refresh_rectangle+1)
   cp c
   jr nc,@check_d
   ld a,c
   ld (refresh_rectangle+1),a
@check_d:
   ld a,(refresh_rectangle+2)
   cp d
   jr nc,@check_e
   ld a,d
   ld (refresh_rectangle+2),a
@check_e:
   ld a,(refresh_rectangle+3)
   cp e
   jr nc,@done_set_rec
   ld a,e
   ld (refresh_rectangle+3),a
@done_set_rec:
   ret

render_tiles:
   ld ix,tile_map          ; ix = tile index
   ld d,0
   ld a,(refresh_rectangle+1)
   ld e,a
   sla e
   rl d
   sla e
   rl d
   sla e
   rl d
   sla e
   rl d
   sla e
   rl d
   ld a,(refresh_rectangle)
   or e
   ld e,a
   add ix,de
   ld hl,DBL_BUFFER        ; bc = start of tile
   sla d
   sla d
   sla d
   ld a,$40
   or d
   ld d,a
   add hl,de
   push hl
   pop bc
   ld a,(refresh_rectangle)
   ld d,a
   ld a,(refresh_rectangle+2)
   sub d
   ld (rectangle_width),a
   ld d,a                  ; d = rectangle width
   ld a,(refresh_rectangle+1)
   ld e,a
   ld a,(refresh_rectangle+3)
   sub e
   ld e,a                  ; e = rectangle height
@tile_loop:
   push bc                 ; stash bc on stack
   ld b,0
   ld c,(ix)               ; bc = tile index
   sla c
   rl b
   sla c
   rl b
   sla c
   rl b                    ; bc = tile index*8
   ld hl,tiles
   add hl,bc               ; hl = tile starting address
   pop bc                  ; restore bc
@write_loop:
   ld a,(hl)
   inc hl
   ld (bc),a
   inc b
   ld a,$07
   and b
   jr nz,@write_loop
   ld a,(rectangle_width)
   cp 32
   jr z,@full_width
   
@full_width:
   ld a,b
   sub 8
   ld b,a                  ; bc = start of tile, again
   inc c                   ; bc = start of next tile (if c > 0)
   jr nz,@next
   ld a,b
   add 8
   ld b,a                  ; bc = start of next tile (for sure this time)
@next:
   inc ix
   dec de
   ld a,0
   or d
   or e
   jp nz,@tile_loop
@end_render:
   ret

copy_dbl_buffer:
   ld de,SCREEN_MEM
   ld hl,DBL_BUFFER
   ld bc,DBLBUF_SIZE
   ldir
   ret
