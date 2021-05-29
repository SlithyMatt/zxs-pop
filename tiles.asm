ALL_PAPER = 0
ALL_INK   = 1

; Tiles for Pop
   db 0,0,0,0,0,0,0,0                 ; Tile 0 - all paper
   db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ; Tile 1 - all ink

; bubbles - normal
   db $07,$1f,$3f,$7f,$7f,$ff,$bf,$bf ; Tile 2 - bubble UL
   db $e0,$f8,$fc,$fe,$fe,$ff,$ff,$ff ; Tile 3 - bubble UR
   db $bf,$bf,$bf,$5f,$5f,$27,$18,$07 ; Tile 4 - bubble LL
   db $ff,$ff,$ff,$fe,$fe,$fc,$38,$e0 ; Tile 5 - bubble LR

; SCORE (tiles 6,7,8)
   db $ff,$00,$39,$22,$3a,$0a,$39,$ff
   db $ff,$00,$93,$2a,$2b,$2a,$92,$ff
   db $ff,$00,$38,$a2,$30,$a2,$b8,$ff

   db $e3,$f3,$db,$cf,$c7,$cf,$db,$f3 ; Tile 9 - vertical girder
   db $af,$9f,$af,$9f,$af,$9f,$af,$9f ; Tile 10 - press shaft
   db $af,$9f,$af,$9f,$af,$9f,$af,$83 ; Tile 11 - press shaft bottom
   db $3f,$67,$df,$bf,$bf,$df,$60,$3f ; tile 12 - press plate left
   db $ff,$ff,$ff,$ff,$ff,$ff,$00,$ff ; tile 13 - press plate middle
   db $fc,$e6,$fb,$fd,$fd,$fb,$06,$fc ; tile 14 - press plate right

   db $ff,0,0,0,0,0,0,$ff ; tile 15 - scoreboard blank
; Scoreboard numbers 0-9 (tiles 16-25 / $10-$19)
   db $ff,$00,$18,$24,$24,$24,$18,$ff ; 0
   db $ff,$00,$08,$18,$08,$08,$1c,$ff ; 1
   db $ff,$00,$18,$24,$08,$10,$3c,$ff ; 2
   db $ff,$00,$18,$24,$08,$24,$18,$ff ; 3
   db $ff,$00,$24,$24,$3c,$04,$04,$ff ; 4
   db $ff,$00,$3c,$20,$38,$04,$38,$ff ; 5
   db $ff,$00,$1c,$20,$38,$24,$18,$ff ; 6
   db $ff,$00,$3c,$04,$08,$10,$20,$ff ; 7
   db $ff,$00,$18,$24,$18,$24,$18,$ff ; 8
   db $ff,$00,$18,$24,$1c,$04,$38,$ff ; 9

   db $0f,$3f,$7b,$7b,$ef,$cf,$db,$f3 ; tile 26 - chamber UL corner
   db $f0,$fc,$de,$f6,$df,$cf,$db,$f3 ; tile 27 - chamber UR corner
