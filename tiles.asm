ALL_PAPER = 0
ALL_INK   = 1

; Tiles for Pop
   db 0,0,0,0,0,0,0,0                 ; Tile 0 - all paper
   db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ; Tile 1 - all ink
   db $07,$1f,$3f,$7f,$7f,$ff,$bf,$bf ; Tile 2 - bubble UL
   db $e0,$f8,$fc,$fe,$fe,$ff,$ff,$ff ; Tile 3 - bubble UR
   db $bf,$bf,$bf,$5f,$5f,$27,$18,$07 ; Tile 4 - bubble LL
   db $ff,$ff,$ff,$fe,$fe,$fc,$38,$e0 ; Tile 5 - bubble LR
