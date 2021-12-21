* FILE......: data.constants.asm
* Purpose...: Stevie Editor - data segment (constants)

***************************************************************
*                      Constants
********|*****|*********************|**************************


***************************************************************
* Textmode (80 columns, 30 rows) - F18A
*--------------------------------------------------------------
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=1: M1 \ TEXT MODE
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=0: 8x8 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
* ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************
stevie.80x30:
        byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80


***************************************************************
* TI Basic mode (32 columns/24 rows)
*--------------------------------------------------------------
tibasic.32x24:
        byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=0: M1 \ Graphics 1 mode
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color



***************************************************************
* TI Basic mode (32 columns/30 rows) - F18A
*--------------------------------------------------------------
tibasic.32x30:
        byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=0: M1 \ Graphics 1 mode
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color
* ;
* ; The table by itself is not sufficient for turning on 30 rows
* ; mode. You also need to unlock the F18a and set VR49 (>31) to
* ; value >40.


***************************************************************
* Sprite Attribute Table
*--------------------------------------------------------------
romsat:                             
                                    ; YX, initial shape and color
        data  >0000,>0001           ; Cursor
        data  >0000,>0101           ; Current line indicator     < 
        data  >0820,>0201           ; Current column indicator   v
nosprite:        
        data  >d000                 ; End-of-Sprites list


***************************************************************
* SAMS page layout table for Stevie (16 words)
*--------------------------------------------------------------
mem.sams.layout.data:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a
        data  >b000,>0020           ; >b000-bfff, SAMS page >20
                                    ;   Index can allocate
                                    ;   pages >20 to >3f.                                    
        data  >c000,>0040           ; >c000-cfff, SAMS page >40
                                    ;   Editor buffer can allocate
                                    ;   pages >40 to >ff.                                
        data  >d000,>000d           ; >d000-dfff, SAMS page >0d
        data  >e000,>000e           ; >e000-efff, SAMS page >0e
        data  >f000,>000f           ; >f000-ffff, SAMS page >0f        


***************************************************************
* SAMS page layout table for calling external progam (16 words)
*--------------------------------------------------------------
mem.sams.external:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a
        data  >b000,>0030           ; >b000-bfff, SAMS page >30
        data  >c000,>0031           ; >c000-cfff, SAMS page >31
        data  >d000,>0032           ; >d000-dfff, SAMS page >32
        data  >e000,>0033           ; >e000-effef, SAMS page >33
        data  >f000,>0034           ; >f000-ffff, SAMS page >34


***************************************************************
* SAMS page layout table for TI Basic (16 words)
*--------------------------------------------------------------
mem.sams.tibasic:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a
        data  >b000,>000b           ; >b000-bfff, SAMS page >0b
        data  >c000,>000c           ; >c000-cfff, SAMS page >0c
        data  >d000,>000d           ; >d000-dfff, SAMS page >0d
        data  >e000,>000e           ; >e000-efff, SAMS page >0e
        data  >f000,>000f           ; >f000-ffff, SAMS page >0f



***************************************************************
* Stevie color schemes table   
*--------------------------------------------------------------
* Word 1
* A  MSB  high-nibble    Foreground color text line in frame buffer
* B  MSB  low-nibble     Background color text line in frame buffer
* C  LSB  high-nibble    Foreground color top/bottom line 
* D  LSB  low-nibble     Background color top/bottom line
*
* Word 2
* E  MSB  high-nibble    Foreground color cmdb pane
* F  MSB  low-nibble     Background color cmdb pane
* G  LSB  high-nibble    Cursor foreground color cmdb pane
* H  LSB  low-nibble     Cursor foreground color frame buffer
*
* Word 3
* I  MSB  high-nibble    Foreground color busy top/bottom line
* J  MSB  low-nibble     Background color busy top/bottom line
* K  LSB  high-nibble    Foreground color marked line in frame buffer 
* L  LSB  low-nibble     Background color marked line in frame buffer
*
* Word 4
* M  MSB  high-nibble    Foreground color command buffer header line
* N  MSB  low-nibble     Background color command buffer header line
* O  LSB  high-nibble    Foreground color line+column indicator frame buffer
* P  LSB  low-nibble     Foreground color ruler frame buffer
*
* Colors
* 0  Transparant
* 1  black
* 2  Green
* 3  Light Green
* 4  Blue
* 5  Light Blue
* 6  Dark Red 
* 7  Cyan
* 8  Red
* 9  Light Red
* A  Yellow
* B  Light Yellow
* C  Dark Green
* D  Magenta
* E  Grey
* F  White
*--------------------------------------------------------------
tv.colorscheme.entries   equ 10 ; Entries in table

tv.colorscheme.table:                  
        ;                             ; #  
        ;      ABCD  EFGH  IJKL  MNOP ; -
        data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
        data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
        data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
        data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
        data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
        data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
        data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
        data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow 
        data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
        data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue 
        even

tv.tabs.table:
        byte  0,7,12,25               ; \   Default tab positions as used
        byte  30,45,59,79             ; |   in Editor/Assembler module.
        byte  >ff,0,0,0               ; |   
        byte  0,0,0,0                 ; |   Up to 20 positions supported.
        byte  0,0,0,0                 ; /   >ff means end-of-list.
        even