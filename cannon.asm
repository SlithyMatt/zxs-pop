cannon_left_key:
   db $fe,$02  ; Z
cannon_right_key:
   db $fe,$04  ; X
cannon_fire_key:
   db $7f,$01  ; Space

cannon_position: ; pos = (deg + 45.5)/3.5
   db 13 ; 0 degrees

CANNON_MAXPOS = 26 ; 45.5 degrees

cannon_tiles:
   ; (14,20), (15,20), (16,20), (17,20)
   ; (14,21), (15,21), (16,21), (17,21)
   db 0,216,217,179 ; -45.5
   db 218,4,5,131
   db 0,210,211,179 ; -42
   db 212,4,5,131
   db 0,204,205,179 ; -38.5
   db 206,4,5,131
   db 0,0,199,179 ; -35
   db 200,4,5,131
   db 0,0,195,179 ; -31.5
   db 196,4,5,131
   db 0,0,191,179 ; -28
   db 192,4,5,131
   db 0,0,187,179 ; -24.5
   db 188,4,5,131
   db 0,0,183,179 ; -21
   db 184,4,5,131
   db 177,0,178,179 ; -17.5
   db 180,4,5,131
   db 169,0,170,171 ; -14
   db 172,4,5,131
   db 160,0,162,163 ; -10.5
   db 164,4,5,131
   db 154,0,155,56 ; -7
   db 157,4,5,131
   db 146,0,147,148 ; -3.5
   db 149,4,5,131
   db 128,0,0,129 ; -0
   db 130,4,5,131
   db 142,143,0,144 ; 3.5
   db 130,4,5,145
   db 150,151,0,152 ; 7
   db 130,4,5,153
   db 158,159,0,160 ; 10.5
   db 130,4,5,161
   db 165,166,0,167 ; 14
   db 130,4,5,168
   db 173,174,0,175 ; 17.5
   db 130,4,5,176
   db 173,181,0,0 ; 21
   db 130,4,5,182
   db 173,185,0,0 ; 24.5
   db 130,4,5,186
   db 173,189,0,0 ; 28
   db 130,4,5,190
   db 173,193,0,0 ; 31.5
   db 130,4,5,194
   db 173,197,0,0 ; 35
   db 130,4,5,198
   db 173,201,202,0 ; 38.5
   db 130,4,5,203
   db 173,207,208,0 ; 42
   db 130,4,5,209
   db 173,213,214,0 ; 45.5
   db 130,4,5,215

cannon_tick:
   ; check for keys
   ld a,(cannon_left_key)
   in a,($FE)                 ; read key row
   ld hl,cannon_left_key+1
   and (hl)                   ; check key bit
   jr nz,@check_cannon_right  ; check right key if not clear
   ld a,(cannon_position)
   or a
   jr z,@check_cannon_right   ; can't go left, check right
   dec a                      ; move left
   ld (cannon_position),a     ; set new position
   jr @check_cannon_fire
@check_cannon_right:
   ld a,(cannon_right_key)
   in a,($FE)                 ; read key row
   ld hl,cannon_right_key+1
   and (hl)                   ; check key bit
   jr nz,@check_cannon_fire   ; check fire key if not clear
   ld a,(cannon_position)
   cp CANNON_MAXPOS
   jr z,@check_cannon_fire    ; can't go right check fire
   inc a                      ; move right
   ld (cannon_position),a     ; set new position
@check_cannon_fire:
   ; TODO check if bubble in trajectory
   ld a,(cannon_fire_key)
   in a,($FE)                 ; read key row
   ld hl,cannon_fire_key+1
   and (hl)                   ; check key bit
   jr nz,@set_cannon_tiles    ; just set tiles if not clear
   ; TODO set bubble trajectory
@set_cannon_tiles:
   ld a,(cannon_position)
   sla
   sla
   sla
   ld d,0
   ld e,a                     ; de = position index * 8
   ld hl,cannon_tiles
   add hl,de
   ex de,hl                   ; de = cannon tiles at position
   ld hl,tile_map+14+20*32    ; hl = tilemap(14,20)
   ld b,4
   ld c,2
@cannon_tile_loop:
   ld a,(de)
   ld (hl),a
   inc de
   inc hl
   dec b
   jr nz,@cannon_tile_loop    ; loop until row is done
   dec c
   jr z,@return_cannon_tick
   push de
   ld de,28
   add hl,de                  ; hl = next row
   pop de
   ld b,4
   jr @cannon_tile_loop
@return_cannon_tick:
   ret
