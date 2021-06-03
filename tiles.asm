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
   db $af,$9f,$af,$9f,$af,$9f,$af,$80 ; Tile 11 - press shaft bottom
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
   db $00,$18,$3c,$3c,$18,$99,$ff,$ff ; tile 28 - chambler lower corner
   db $22,$22,$22,$77,$ff,$ff,$ff,$ff ; tile 29 - chamber left bottom
   db 0,0,0,0,$c0,$f0,$fc,$ff         ; tile 30 - chamber left ramp
   db 0,0,0,0,$03,$0f,$3f,$ff         ; tile 31 - chamber right ramp

   ; ASCII
   block (95*8),0  ; TODO: define custom characters

   ; More graphics
   db $44,$44,$44,$ee,$ff,$ff,$ff,$ff  ; tile 127 - chamber right bottom
   db 0,0,0,$0e,$0f,$07,$03,$03        ; tile 128 - cannon left top - 0
   db 0,0,0,$70,$f0,$e0,$c0,$c0        ; tile 129 - cannon right top - 0
   db $07,$06,$0e,$0c,$5c,$5c,$d8,$d8  ; tile 130 - cannon left middle - 0
   db $e0,$60,$70,$30,$3a,$3a,$1b,$1b  ; tile 131 - cannon right middle - 0
   db $00,$01,$01,$01,$01,$03,$03,$03  ; tile 132 - cannon base
   db $d8,$d8,$dc,$dc,$cc,$ee,$66,$77  ; tile 133 - "
   db $1b,$1b,$3b,$3b,$33,$77,$66,$ee  ; tile 134 - "
   db $00,$80,$80,$80,$80,$c0,$c0,$c0  ; tile 135 - "
   db $07,$06,$06,$0e,$0d,$18,$7f,$ff  ; tile 136 - "
   db $33,$39,$1c,$2e,$47,$83,$ff,$ff  ; tile 137 - "
   db $80,$e0,$fc,$3f,$8f,$e0,$ff,$ff  ; tile 138 - "
   db $01,$07,$3f,$fc,$f1,$07,$ff,$ff  ; tile 139 - "
   db $cc,$9c,$38,$74,$e2,$c1,$ff,$ff  ; tile 140 - "
   db $e0,$60,$60,$70,$b0,$18,$fe,$ff  ; tile 141 - "
   db 0,0,0,$07,$07,$07,$03,$03        ; tile 142 - cannon 3.5
   db 0,0,0,0,$80,0,0,0                ; tile 143 - "
   db 0,0,0,0,$70,$f0,$e0,$c0          ; tile 144 - "
   db $c0,$e0,$60,$70,$32,$3a,$1b,$1b  ; tile 145 - "
   db 0,0,0,0,$0e,$0f,$07,$03          ; tile 146 - cannon -3.5
   db 0,0,0,0,$01,0,0,0                ; tile 147 - "
   db 0,0,0,$e0,$e0,$e0,$c0,$c0        ; tile 148 - "
   db $03,$07,$06,$0e,$4c,$5c,$d8,$d8  ; tile 149 - "
   db 0,0,$03,$07,$03,$01,$01,$03      ; tile 150 - cannon 7
   db 0,0,$80,$80,$80,$80,$80,$80      ; tile 151 - "
   db 0,0,0,0,0,$38,$78,$70            ; tile 152 - "
   db $60,$60,$70,$30,$3a,$3a,$1b,$1b  ; tile 153 - "
   db 0,0,0,0,0,$1c,$1e,$0e            ; tile 154 - cannon -7
   db 0,0,$01,$01,$01,$01,$01,$01      ; tile 155 - "
   db 0,0,$c0,$e0,$c0,$80,$80,$c0      ; tile 156 - "
   db $06,$06,$0e,$0e,$5c,$5c,$d8,$d8  ; tile 157 - "
   db $0,0,$03,$03,$01,0,$01,$03       ; tile 158 - cannon 10.5
   db 0,0,$80,$c0,$c0,$c0,$c0,$80      ; tile 159 - "
   db 0,0,0,0,0,0,$18,$3c              ; tile 160 - "
   db $38,$70,$70,$30,$3a,$3a,$1b,$1b  ; tile 161 - "
   db 0,0,$01,$03,$03,$03,$03,$01      ; tile 162 - cannon -10.5
   db 0,0,$c0,$c0,$80,0,$80,$c0        ; tile 163 - "
   db $1c,$0e,$0e,$0c,$5c,$5c,$d8,$d8  ; tile 164 - "
   db 0,0,$01,0,0,0,$01,$03            ; tile 165 - cannon 14
   db 0,$e0,$e0,$e0,$60,$e0,$c0,$80    ; tile 166 - "
   db 0,0,0,0,0,0,$0c,$1e              ; tile 167 - "
   db $38,$30,$30,$30,$3a,$3a,$1b,$1b  ; tile 168 - "
   db 0,0,0,0,0,0,$30,$78              ; tile 169 - cannon -14
   db 0,$07,$07,$07,$06,$07,$03,$01    ; tile 170 - "
   db 0,0,$80,0,0,0,$80,$c0            ; tile 171 - "
   db $1c,$0c,$0c,$0c,$5c,$5c,$d8,$d8  ; tile 172 - "
   db 0,0,0,0,0,0,$01,$03              ; tile 173 - cannon 17.5, etc.
   db $c0,$f0,$f0,$70,$70,$e0,$e0,$c0  ; tile 174 - cannon 17.5
   db 0,0,0,0,0,0,0,$1e                ; tile 175 - "
   db $1c,$38,$30,$30,$32,$3a,$1b,$1b  ; tile 176 - "
   db 0,0,0,0,0,0,0,$78                ; tile 177 - cannon -17.5
   db $03,$0f,$0f,$0e,$0e,$07,$07,$03  ; tile 178 - "
   db 0,0,0,0,0,0,$80,$c0              ; tile 179 - cannon -17.5, etc.
   db $38,$1c,$0c,$0c,$4c,$5c,$d8,$d8  ; tile 180 - cannon -17.5
   db 0,$70,$f8,$78,$70,$f0,$e0,$c0    ; tile 181 - cannon 21
   db $1c,$3e,$38,$70,$72,$32,$33,$3b  ; tile 182 - "
   db 0,$0e,$0f,$0e,$0e,$07,$07,$03    ; tile 183 - cannon -21
   db $38,$7c,$1c,$0e,$4e,$4c,$cc,$dc  ; tile 184 - "
   db 0,$38,$38,$1c,$1c,$78,$f0,$c0    ; tile 185 - cannon -24.5
   db 0,$0e,$1f,$1c,$3a,$32,$33,$3b    ; tile 186 - "
   db 0,$1c,$1c,$38,$38,$1e,$0f,$03    ; tile 187 - cannon -24.5
   db 0,$70,$f8,$38,$5c,$4c,$cc,$dc    ; tile 188 - "
   db $08,$1c,$0e,$0e,$1c,$7c,$f0,$c0  ; tile 189 - cannon 28
   db 0,0,$0f,$1f,$1e,$3a,$3b,$3b      ; tile 190 - "
   db $10,$38,$70,$70,$38,$3e,$0f,$03  ; tile 191 - cannon -28
   db 0,0,$f0,$f8,$78,$5c,$dc,$dc      ; tile 192 - "
   db $0c,$1e,$0e,$0e,$1c,$7c,$f8,$e0  ; tile 193 - cannon 31.5
   db 0,0,$04,$1e,$3f,$3a,$3b,$3b      ; tile 194 - "
   db $30,$78,$70,$70,$38,$3e,$1f,$03  ; tile 195 - cannon -31.5
   db 0,0,$20,$78,$fc,$5c,$dc,$dc      ; tile 196 - "
   db $0c,$0e,$0f,$0e,$1e,$7c,$f0,$c0  ; tile 197 - cannon 35
   db 0,0,0,$0e,$1f,$3f,$3b,$3b        ; tile 198 - "
   db $30,$70,$f0,$70,$78,$3e,$0f,$03  ; tile 199 - cannon -35
   db 0,0,0,$70,$f8,$dc,$dc,$dc        ; tile 200 - "
   db $03,$03,$03,$03,$0f,$7e,$f8,$c0  ; tile 201 - cannon 38.5
   db 0,$80,$80,$80,0,0,0,0            ; tile 202 - "
   db 0,0,0,0,$0e,$0f,$1f,$3b          ; tile 203 - "
   db 0,$01,$01,$01,0,0,0,0            ; tile 204 - cannon -38.5
   db $c0,$c0,$c0,$c0,$f0,$7e,$1f,$03  ; tile 205 - "
   db 0,0,0,0,$70,$f0,$f8,$dc          ; tile 206 - "
   db $01,$01,$01,$03,$0f,$3e,$f8,$e0  ; tile 207 - cannon 42
   db $80,$c0,$c0,$c0,$80,0,0,0        ; tile 208 - "
   db 0,0,0,0,0,$0e,$1f,$3f            ; tile 209 - "
   db $01,$03,$03,$03,$01,0,0,0        ; tile 210 - cannon -42
   db $80,$80,$80,$c0,$f0,$7c,$1f,$07  ; tile 211 - "
   db 0,0,0,0,0,$70,$f8,$fc            ; tile 212 - "
   db 0,0,0,$03,$0f,$3e,$f8,$e0        ; tile 213 - cannon 45.5
   db $c0,$e0,$e0,$c0,$80,0,0,0        ; tile 214 - "
   db 0,0,0,0,0,0,$0e,$1f              ; tile 215 - "
   db $03,$07,$07,$03,$01,0,0,0        ; tile 216 - cannon -45.5
   db 0,0,0,$c0,$f0,$7c,$1f,$07        ; tile 217 - "
   db 0,0,0,0,0,0,$70,$f8              ; tile 218 - "
