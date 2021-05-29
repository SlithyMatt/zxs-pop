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

   ; Interrupt routine:
   call copy_dbl_buffer

   ; restore all registers from stack
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
   block(8),0

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
