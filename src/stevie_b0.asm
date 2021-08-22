***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b0.asm               ; Version %%build_date%%
*
* Bank 0 "Jill"
*
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
                                    ; grows downwards to >2000
***************************************************************
* BANK 0
********|*****|*********************|**************************
bankid  equ   bank0.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Copy spectra2 core library from ROM to >2000 - >2fff
********|*****|*********************|**************************
        li    r0,reloc.sp2          ; Start of code to relocate
        li    r1,>2000
        li    r2,256                ; Copy 4K (256 * 16 bytes)
        bl    @kickstart.copy       ; Copy memory
***************************************************************
* Step 3: Copy spectra2 extended library from ROM to >f000 - >ffff
********|*****|*********************|**************************
        li    r0,reloc.sp2ext       ; Start of code to relocate
        li    r1,>f000
        li    r2,16                 ; Copy 128 bytes (16 * 16 bytes)
        bl    @kickstart.copy       ; Copy memory        
***************************************************************
* Step 4: Copy Stevie resident modules from ROM to >3000 - >3fff
********|*****|*********************|**************************
        li    r0,reloc.stevie       ; Start of code to relocate
        li    r1,>3000
        li    r2,256                ; Copy 4K (256 * 16 bytes)
        bl    @kickstart.copy       ; Copy memory
***************************************************************
* Step 5: Start SP2 kernel (runs in low MEMEXP)
********|*****|*********************|**************************
        b     @runlib               ; Start spectra2 library        
        ;------------------------------------------------------
        ; Assert. Should not get here! Crash and burn!
        ;------------------------------------------------------
        li    r0,$                  ; Current location
        mov   r0,@>ffce             ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system           
***************************************************************
* Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
********|*****|*********************|**************************
        ; "main" in low MEMEXP is automatically called by SP2 runlib.

***************************************************************
* Copy routine 
********|*****|*********************|**************************
kickstart.copy:
        ;------------------------------------------------------
        ; Copy memory to destination
        ; r0 = Source CPU address
        ; r1 = Target CPU address
        ; r2 = Bytes to copy/16
        ;------------------------------------------------------
!       mov   *r0+,*r1+             ; Copy word 1
        mov   *r0+,*r1+             ; Copy word 2
        mov   *r0+,*r1+             ; Copy word 3
        mov   *r0+,*r1+             ; Copy word 4
        mov   *r0+,*r1+             ; Copy word 5
        mov   *r0+,*r1+             ; Copy word 6
        mov   *r0+,*r1+             ; Copy word 7
        mov   *r0+,*r1+             ; Copy word 8
        dec   r2
        jne   -!                    ; Loop until done
        b     *r11                  ; Return to caller


***************************************************************
* Code data: Relocated code SP2 >2000 - >2f1f (3840 bytes max)
********|*****|*********************|**************************
reloc.sp2:
        ;------------------------------------------------------
        ; spectra2 core library
        ;------------------------------------------------------
        xorg  >2000                 ; Relocate to >2000
        copy  "%%spectra2%%/runlib.asm"
                                    ; Spectra 2                                 
        ;------------------------------------------------------
        ; Memory full check
        ;------------------------------------------------------
        .print "***** PC relocated SP2 library @ >2000 - ", $, "(dec)"

        .ifgt $, >2f1f
              .error '***** Aborted. SP2 library too large!'
        .endif
        ;------------------------------------------------------
        ; spectra2 extended library (handle yourself)
        ;------------------------------------------------------        
reloc.sp2ext:                
        aorg  >7000                 ; >7000 in cartridge space        
        xorg  >f000                 ; Relocate to >f000

        copy  "%%spectra2%%/modules/cpu_scrpad_backrest.asm"
                                    ; Spectra 2 extended    


***************************************************************
* Code data: Relocated Stevie modules >3000 - >3fff (4K max)
********|*****|*********************|**************************
reloc.stevie:
        xorg  >3000                 ; Relocate Stevie modules to >3000
        ;------------------------------------------------------
        ; Activate bank 1 and branch to >6046
        ;------------------------------------------------------
main:        
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Resident Stevie modules: >3000 - >3fff
        ;------------------------------------------------------
        copy  "ram.resident.3000.asm"

        .ifgt $, >3fff
              .error '***** Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif     
        ;------------------------------------------------------
        ; Bank full check
        ;------------------------------------------------------
        .ifgt $, >7fff
              .error 'Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif

*--------------------------------------------------------------
* Video mode configuration for SP2
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table        
sprpdt  equ   >2800                 ; VDP sprite pattern table

