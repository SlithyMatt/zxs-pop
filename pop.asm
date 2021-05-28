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
   block (32 * 24),1

   include bubbles.asm
   include video.asm

init:
   call init_im2           ; initialize Interrupt Mode 2
@loop:
   call fill_rows
   call render_tiles
   jr @loop ; TODO not just be an infinite loop!
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
   pop af
   pop bc
   pop de
   pop hl
   ex af,af'                  ; exchange AF and AF'
   exx                        ; exchange BE,DE,HL with BE',DE',HL'
   pop af
   pop bc
   pop de
   pop hl
   ei                         ; re-enable interrupts
   ret

; Deployment
LENGTH      = $ - start

; option 1: tape
   include TapLib.asm
   MakeTape ZXSPECTRUM48, "pop.tap", "pop", start, LENGTH, start

; option 2: snapshot
   SAVESNA "pop.sna", start
