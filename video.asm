render_tiles:
   ld ix,tile_map          ; ix = tile index
   ld bc,DBL_BUFFER        ; bc = start of tile
   ld de,32*24             ; de = loop index
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
   ret

copy_dbl_buffer:
   ld de,SCREEN_MEM
   ld hl,DBL_BUFFER
   ld bc,DBLBUF_SIZE
   ldir
   ret
