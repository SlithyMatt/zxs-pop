   DEVICE ZXSPECTRUM48

   org $8000

start:
   jp init

; Memory Segments
SCREEN_MEM  = $4000
COLOR_ATTR  = $5800
DBL_BUFFER  = $E000
ATTR_BUFFER = DBL_BUFFER+$1800
DBLBUF_SIZE = $1B00
IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD

; Character Codes
ENTER       = $0D

tiles:
   include tiles.asm

tile_map:
   block (32 * 24),0

   include bubbles.asm
   include video.asm
   include cannon.asm

init:
   call init_im2           ; initialize Interrupt Mode 2
   call init_tilemap       ; initialize tilemap outside bubble chamber
@main_loop:
   call fill_rows
   call render_tiles
   jr @main_loop ; TODO not just be an infinite loop!
   ret


init_im2:
   di                         ; disable interrupts
   ld de,IM2_TABLE            ; de = beginning of 257 bytes to set to $FD
   ld hl,IM2_VECTOR           ; hl = vector location ($FDFD)
   ld a,d                     ;
   ld i,a                     ; i = custom IM2 table page
   ld a,l                     ; a = $FD
@loop:
   ld (de),a                  ; set byte in IM2 table to $FD
   inc e                      ; de = next byte (unless e = 0)
   jr nz,@loop                ; loop until whole page is set to $FD (e = 0)
   inc d                      ; de = 257th byte of table
   ld (de),a                  ; set last byte to $FD
   ld (hl),$C3                ; place unconditional JP opcode at vector
   inc l                      ; hl = vector + 1
   ld (hl),low im2_handler    ; low byte of custom handler address
   inc l                      ; hl = vector + 2
   ld (hl),high im2_handler   ; high byte of custom handler address
   im 2                       ; set interrupt mode 2
   ei                         ; re-enable interrupts
   ret

im2_handler:
   di                         ; disable other interrupts
   ; stash all registers to stack
   push af
   push bc
   push de
   push hl
   ex af,af'                  ; exchange AF and AF'
   exx                        ; exchange BE,DE,HL with BE',DE',HL'
   push af
   push bc
   push de
   push hl
   push ix
   push iy

   ; Interrupt routine:
   call copy_dbl_buffer
   call cannon_tick

   ; restore all registers from stack
   pop iy
   pop ix
   pop hl
   pop de
   pop bc
   pop af
   ex af,af'                  ; exchange AF and AF'
   exx                        ; exchange BE,DE,HL with BE',DE',HL'
   pop hl
   pop de
   pop bc
   pop af
   ei                         ; re-enable interrupts
   ret

scoreboard:
   db 26,15,15,6,7,8,15

score:
   ;block(8),0
   db 0,0,0,0,4,0,9,6

cannon:
   db 0,128,0,0,129,0
   db 0,130,2,3,131,0
   db 132,133,4,5,134,135
   db 136,137,138,139,140,141


init_tilemap:
   ld de,tile_map+7   ; de = tilemap(7,0)
   ld hl,scoreboard
   ld bc,7
   ldir
   call fill_score
   ld de,tile_map+22  ; de = tilemap(21,0)
   ld a,15
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld a,27
   ld (de),a
   ld de,ATTR_BUFFER+7  ; de = color(7,0)
   ld a,$42          ; black/red
   ld b,18
@scoreboard_color_loop:
   ld (de),a
   inc de
   dec b
   jr nz,@scoreboard_color_loop
   ld ix,tile_map+7+32      ; ix = tilemap(7,1)
   ld iy,ATTR_BUFFER+7+32  ; iy = color(7,1)
   ex af,af'               ; a' = black/red
   ld a,9                  ; a = girder tile
   ld b,19
   ld de,32
@girder_loop:
   ld (ix),a
   ld (ix+17),a
   ex af,af'               ; get af'
   ld (iy),a
   ld (iy+17),a
   ex af,af'               ; stash af'
   add ix,de
   add iy,de
   dec b
   jr nz,@girder_loop
   ld a,28                 ; chamber lower corners
   ld (ix),a
   ld (ix+17),a
   inc a                   ; chamber left bottom (29)
   ld (ix+1),a
   ld (ix+2),a
   ld (ix+3),a
   ld (ix+4),a
   inc a                   ; chamber left bottom ramp (30)
   ld (ix+5),a
   inc a                   ; chamber right bottom ramp (31)
   ld (ix+12),a
   ld a,127                ; chamber right bottom
   ld (ix+13),a
   ld (ix+14),a
   ld (ix+15),a
   ld (ix+16),a
   ld a,$17                ; dark red/gray
   ld (iy),a               ; chamber LL corner
   ld (iy+17),a            ; chamber LR corner
   ld a,$07                ; black/gray
   ld (iy+1),a             ; chamber left bottom
   ld (iy+2),a
   ld (iy+3),a
   ld (iy+4),a
   ld (iy+5),a             ; chamber left bottom ramp
   ld (iy+12),a            ; chamber right bottom ramp
   ld (iy+13),a            ; chamber right bottom
   ld (iy+14),a
   ld (iy+15),a
   ld (iy+16),a
   ld hl,tile_map+13+20*32 ; hl = tilemap (13,20)
   ld de,cannon
   ld b,6
   ld c,4
@cannon_row_loop:
   ld a,(de)
   ld (hl),a
   inc hl
   inc de
   dec b
   jr nz,@cannon_row_loop
   push de
   ld de,26
   add hl,de
   pop de
   ld b,6
   dec c
   jr nz,@cannon_row_loop
   ld hl,ATTR_BUFFER+13+20*32 ; hl = color (13,20)
   ld a,$02                ; black/dark red
   ld b,6
   ld c,4
@cannon_color_loop:
   ld (hl),a
   inc hl
   dec b
   jr nz,@cannon_color_loop
   ld de,26
   add hl,de
   ld b,6
   dec c
   jr nz,@cannon_color_loop
   ld ix,ATTR_BUFFER+15+21*32 ; ix = color (15,21)
   ld a,$44             ; black/green TODO: change to black/black
   ld (ix),a
   ld (ix+1),a
   ld (ix+32),a
   ld (ix+33),a
   ret

fill_score:
   ld de,tile_map+14  ; de = tilemap(13,0)
   ld hl,score
   ld b,0
   ld c,7
@score_tile_loop:
   ld a,b
   or (hl)
   jr z,@blank_lead
   ld b,1
   ld a,(hl)
   or $10
   jr @set_score_tile
@blank_lead:
   ld a,15
@set_score_tile:
   ld (de),a
   inc hl
   inc de
   dec c
   jr nz,@score_tile_loop
   ld a,(hl)
   or $10
   ld (de),a
   ret

   org DBL_BUFFER
   block (32*192),0  ; screen bitmap
   block (32*24),$47 ; color attributes (black/white)


; Deployment
LENGTH      = $ - start

; option 1: tape
   include TapLib.asm
   MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
   SAVESNA "pop.sna", start
