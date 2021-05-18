; Tiles for Pop
   db 0,0,0,0,0,0,0,0                 ; Tile 0 - all paper
; Odd-row bubbles
   db $ff,$f8,$e0,$c0,$c0,$80,$80,$80 ; Tile 1
   db 0,0,0,0,0,$18,$7e,$ff
   db $ff,$1f,$07,$03,$03,$01,$01,$01
   db $01,$03,$03,$07,$07,$03,$03,$01
   db $ff,$ff,$e7,$df,$df,$ff,$ff,$ff
   db $80,$c0,$c0,$e0,$e0,$c0,$c0,$80
   db $80,$80,$80,$c0,$c0,$e0,$f8,$ff
   db $ff,$7e,$18,0,0,0,0,0
   db $ff,$1f,$07,$03,$03,$01,$01,$01
; Even/Odd junctures
   db 0,0,0,0,$c0,$80,$80,$80         ; Tile 10
   db 0,0,0,0,$03,$01,$01,$01
   db $80,$80,$80,$c0,0,0,0,0
   db $01,$01,$01,$03,0,0,0,0
; Even-row bubbles
   db $ff,$ff,$ff,$ff,$ff,$ff,$fe,$fc ; Tile 14
   db $ff,$ff,$ff,$ff,$f0,$80,0,0
   db $ff,$ff,$ff,$ff,$0f,$01,0,0
   db $ff,$ff,$ff,$ff,$ff,$ff,$7f,$3f
   db $fc,$f8,$f8,$f8,$f0,$f0,$f0,$f0
   db 0,$01,$07,$0f,$1f,$3f,$3e,$7d
   db 0,$80,$e0,$f0,$f8,$fc,$7c,$fe
   db $3f,$1f,$1f,$1f,$0f,$0f,$0f,$0f
   db $f0,$f0,$f0,$f0,$f8,$f8,$f8,$fc
   db $7d,$3f,$3f,$1f,$0f,$07,$01,0
   db $fe,$fc,$fc,$f8,$f0,$e0,$80,0
   db $0f,$0f,$0f,$0f,$1f,$1f,$1f,$3f
   db $fc,$fe,$ff,$ff,$ff,$ff,$ff,$ff
   db 0,0,$80,$f0,$ff,$ff,$ff,$ff
   db 0,0,$01,$0f,$ff,$ff,$ff,$ff
   db $3f,$7f,$ff,$ff,$ff,$ff,$ff,$ff
; Even/Even junctures
   db $ff,$ff,$ff,$ff,$ff,$ff,$7e,$3c ; Tile 30
   db $3c,$18,$18,$18,0,0,0,0
   db 0,0,0,0,$18,$18,$18,$3c
   db $3c,$7e,$ff,$ff,$ff,$ff,$ff,$ff
