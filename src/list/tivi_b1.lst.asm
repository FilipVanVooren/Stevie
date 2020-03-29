XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.asm.10901
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi_b1.asm                 ; Version 200329-10901
0010               
0011               
0012               ***************************************************************
0013               * BANK 1 - TiVi support modules
0014               ********|*****|*********************|**************************
0015                       aorg  >6000
0016                       save  >6000,>7fff           ; Save bank 1
0017                       copy  "equates.asm"         ; Equates TiVi configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.asm                 ; Version 200329-10901
0010               *--------------------------------------------------------------
0011               * TiVi memory layout.
0012               * See file "modules/memory.asm" for further details.
0013               *
0014               * Mem range   Bytes    SAMS   Purpose
0015               * =========   =====    ====   ==================================
0016               * 2000-3fff   8192            Spectra2 library
0017               * 6000-7fff   8192            bank 0: spectra2 library + copy code
0018               *                             bank 1: TiVi program code
0019               * a000-afff   4096            Scratchpad/GPL backup, TiVi structures
0020               * b000-bfff   4096            Command buffer
0021               * c000-cfff   4096     yes    Main index
0022               * d000-dfff   4096     yes    Shadow SAMS pages index
0023               * e000-efff   4096     yes    Editor buffer 4k
0024               * f000-ffff   4096     yes    Editor buffer 4k
0025               *
0026               * TiVi VDP layout
0027               *
0028               * Mem range   Bytes    Hex    Purpose
0029               * =========   =====   ====    =================================
0030               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0031               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0032               * 0fc0                        PCT - Pattern Color Table
0033               * 1000                        PDT - Pattern Descriptor Table
0034               * 1800                        SPT - Sprite Pattern Table
0035               * 2000                        SAT - Sprite Attribute List
0036               *--------------------------------------------------------------
0037               * Skip unused spectra2 code modules for reduced code size
0038               *--------------------------------------------------------------
0039      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0040      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0041      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0042      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0043      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0044      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0045      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0046      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0047      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0048      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0049      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0050      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0051      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0052      0001     skip_random_generator     equ  1    ; Skip random functions
0053      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0054               *--------------------------------------------------------------
0055               * SPECTRA2 / TiVi startup options
0056               *--------------------------------------------------------------
0057      0001     debug                     equ  1    ; Turn on spectra2 debugging
0058      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0059      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0060      6030     kickstart.code1           equ  >6030; Uniform aorg entry address accross banks
0061      6050     kickstart.code2           equ  >6050; Uniform aorg entry address start of code
0062      A000     cpu.scrpad.tgt            equ  >a000; Destination cpu.scrpad.backup/restore
0063               
0064               *--------------------------------------------------------------
0065               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0066               *--------------------------------------------------------------
0067               ;               equ  >8342          ; >8342-834F **free***
0068      8350     parm1           equ  >8350          ; Function parameter 1
0069      8352     parm2           equ  >8352          ; Function parameter 2
0070      8354     parm3           equ  >8354          ; Function parameter 3
0071      8356     parm4           equ  >8356          ; Function parameter 4
0072      8358     parm5           equ  >8358          ; Function parameter 5
0073      835A     parm6           equ  >835a          ; Function parameter 6
0074      835C     parm7           equ  >835c          ; Function parameter 7
0075      835E     parm8           equ  >835e          ; Function parameter 8
0076      8360     outparm1        equ  >8360          ; Function output parameter 1
0077      8362     outparm2        equ  >8362          ; Function output parameter 2
0078      8364     outparm3        equ  >8364          ; Function output parameter 3
0079      8366     outparm4        equ  >8366          ; Function output parameter 4
0080      8368     outparm5        equ  >8368          ; Function output parameter 5
0081      836A     outparm6        equ  >836a          ; Function output parameter 6
0082      836C     outparm7        equ  >836c          ; Function output parameter 7
0083      836E     outparm8        equ  >836e          ; Function output parameter 8
0084      8370     timers          equ  >8370          ; Timer table
0085      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0086      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0087               *--------------------------------------------------------------
0088               * Scratchpad backup 1               @>a000-a0ff     (256 bytes)
0089               * Scratchpad backup 2               @>a100-a1ff     (256 bytes)
0090               *--------------------------------------------------------------
0091      A000     scrpad.backup1  equ  >a000          ; Backup GPL layout
0092      A100     scrpad.backup2  equ  >a100          ; Backup spectra2 layout
0093               *--------------------------------------------------------------
0094               * TiVi Editor shared structures     @>a200-a27f     (128 bytes)
0095               *--------------------------------------------------------------
0096      A200     tv.top          equ  >a200          ; Structure begin
0097      A200     tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
0098      A202     tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
0099      A204     tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
0100      A206     tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
0101      A208     tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
0102      A20A     tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
0103      A20C     tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
0104      A20E     tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
0105      A210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0106      A212     tv.colorscheme  equ  tv.top + 18    ; Current color scheme (0-4)
0107      A214     tv.curshape     equ  tv.top + 20    ; Cursor shape and color
0108      A216     tv.pane.focus   equ  tv.top + 22    ; Identify pane that has focus
0109      A216     tv.end          equ  tv.top + 22    ; End of structure
0110      0000     pane.focus.fb   equ  0              ; Editor pane has focus
0111      0001     pane.focus.cmdb equ  1              ; Command buffer pane has focus
0112               *--------------------------------------------------------------
0113               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0114               *--------------------------------------------------------------
0115      A280     fb.struct       equ  >a280          ; Structure begin
0116      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0117      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0118      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0119                                                   ; line X in editor buffer).
0120      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0121                                                   ; (offset 0 .. @fb.scrrows)
0122      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0123      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0124      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0125      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0126      A290     fb.free         equ  fb.struct + 16 ; **** free ****
0127      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0128      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0129      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0130      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0131      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0132      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0133               *--------------------------------------------------------------
0134               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0135               *--------------------------------------------------------------
0136      A300     edb.struct        equ  >a300           ; Begin structure
0137      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0138      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0139      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0140      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0141      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0142      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0143      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0144      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0145                                                      ; with current filename.
0146      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0147                                                      ; with current file type.
0148      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0149      A314     edb.end           equ  edb.struct + 20 ; End of structure
0150               *--------------------------------------------------------------
0151               * File handling structures          @>a400-a4ff     (256 bytes)
0152               *--------------------------------------------------------------
0153      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0154      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0155      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0156      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0157      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0158      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0159      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0160      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0161      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0162      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0163      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0164      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0165      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0166      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0167      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0168      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0169      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0170      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0171      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0172      A496     fh.end            equ  fh.struct +150  ; End of structure
0173      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0174      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0175               *--------------------------------------------------------------
0176               * Command buffer structure          @>a500-a5ff     (256 bytes)
0177               *--------------------------------------------------------------
0178      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0179      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0180      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0181      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0182      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0183      A508     cmdb.yxtop      equ  cmdb.struct + 8   ; Screen YX of 1st row in cmdb pane
0184      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0185      A50C     cmdb.lines      equ  cmdb.struct + 12  ; Total lines in editor buffer
0186      A50E     cmdb.dirty      equ  cmdb.struct + 14  ; Editor buffer dirty (Text changed!)
0187      A510     cmdb.free       equ  cmdb.struct + 16  ; **** free ****
0188      A512     cmdb.end        equ  cmdb.struct + 18  ; End of structure
0189               *--------------------------------------------------------------
0190               * Free for future use               @>a600-a64f     (80 bytes)
0191               *--------------------------------------------------------------
0192      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0193               *--------------------------------------------------------------
0194               * Frame buffer                      @>a650-afff    (2480 bytes)
0195               *--------------------------------------------------------------
0196      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0197      09B0     fb.size         equ  2480              ; Frame buffer size
0198               *--------------------------------------------------------------
0199               * Command buffer                    @>b000-bfff    (4096 bytes)
0200               *--------------------------------------------------------------
0201      B000     cmdb.top        equ  >b000             ; Top of command buffer
0202      1000     cmdb.size       equ  4096              ; Command buffer size
0203               *--------------------------------------------------------------
0204               * Index                             @>c000-cfff    (4096 bytes)
0205               *--------------------------------------------------------------
0206      C000     idx.top         equ  >c000             ; Top of index
0207      1000     idx.size        equ  4096              ; Index size
0208               *--------------------------------------------------------------
0209               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0210               *--------------------------------------------------------------
0211      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0212      1000     idx.shadow.size equ  4096              ; Shadow index size
0213               *--------------------------------------------------------------
0214               * Editor buffer                     @>e000-efff    (4096 bytes)
0215               *                                   @>f000-ffff    (4096 bytes)
0216               *--------------------------------------------------------------
0217      E000     edb.top         equ  >e000             ; Editor buffer high memory
0218      2000     edb.size        equ  8192              ; Editor buffer size
0219               *--------------------------------------------------------------
0220               
0221               
**** **** ****     > tivi_b1.asm.10901
0018                       copy  "kickstart.asm"       ; Cartridge header
**** **** ****     > kickstart.asm
0001               * FILE......: kickstart.asm
0002               * Purpose...: Bankswitch routine for starting TiVi
0003               
0004               ***************************************************************
0005               * TiVi Cartridge Header & kickstart ROM bank 0
0006               ***************************************************************
0007               *
0008               *--------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * OUTPUT
0013               * none
0014               *--------------------------------------------------------------
0015               * Register usage
0016               * r0
0017               ***************************************************************
0018               
0019               *--------------------------------------------------------------
0020               * Cartridge header
0021               ********|*****|*********************|**************************
0022 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0023 6006 6010             data  $+10
0024 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0025 6010 0000             data  0                     ; No more items following
0026 6012 6030             data  kickstart.code1
0027               
0029               
0030 6014 1154             byte  17
0031 6015 ....             text  'TIVI 200329-10901'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > tivi_b1.asm.10901
0019               
0020                       aorg  >2000
0021                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *              the Texas Instruments TI-99/4A Home Computer
0010               *
0011               *                      2010-2020 by Filip Van Vooren
0012               *
0013               *              https://github.com/FilipVanVooren/spectra2.git
0014               *******************************************************************************
0015               * This file: runlib.a99
0016               *******************************************************************************
0017               * Use following equates to skip/exclude support modules and to control startup
0018               * behaviour.
0019               *
0020               * == Memory
0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0028               *
0029               * == VDP
0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0043               *
0044               * == Sound & speech
0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0048               *
0049               * ==  Keyboard
0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0052               *
0053               * == Utilities
0054               * skip_random_generator     equ  1  ; Skip random generator functions
0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0061               *
0062               * == Kernel/Multitasking
0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0066               *
0067               * == Startup behaviour
0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0070               *******************************************************************************
0071               
0072               *//////////////////////////////////////////////////////////////
0073               *                       RUNLIB SETUP
0074               *//////////////////////////////////////////////////////////////
0075               
0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
0002               * Purpose...: Equates for spectra2 memory layout
0003               
0004               ***************************************************************
0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0006               ********|*****|*********************|**************************
0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0022               ***************************************************************
0023      832A     by      equ   wyx                   ;      Cursor Y position
0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0026               ***************************************************************
**** **** ****     > runlib.asm
0077                       copy  "equ_registers.asm"        ; Equates runlib registers
**** **** ****     > equ_registers.asm
0001               * FILE......: registers.asm
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0011               * R9      Stack pointer
0012               * R10     Highest slot in use + Timer counter
0013               * R11     Subroutine return address
0014               * R12     CRU
0015               * R13     Copy of VDP status byte and counter for sound player
0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0017               * R15     VDP read/write address
0018               *--------------------------------------------------------------
0019               * Special purpose registers
0020               * R0      shift count
0021               * R12     CRU
0022               * R13     WS     - when using LWPI, BLWP, RTWP
0023               * R14     PC     - when using LWPI, BLWP, RTWP
0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0025               ***************************************************************
0026               * Define registers
0027               ********|*****|*********************|**************************
0028      0000     r0      equ   0
0029      0001     r1      equ   1
0030      0002     r2      equ   2
0031      0003     r3      equ   3
0032      0004     r4      equ   4
0033      0005     r5      equ   5
0034      0006     r6      equ   6
0035      0007     r7      equ   7
0036      0008     r8      equ   8
0037      0009     r9      equ   9
0038      000A     r10     equ   10
0039      000B     r11     equ   11
0040      000C     r12     equ   12
0041      000D     r13     equ   13
0042      000E     r14     equ   14
0043      000F     r15     equ   15
0044               ***************************************************************
0045               * Define register equates
0046               ********|*****|*********************|**************************
0047      0002     config  equ   r2                    ; Config register
0048      0003     xconfig equ   r3                    ; Extended config register
0049      0004     tmp0    equ   r4                    ; Temp register 0
0050      0005     tmp1    equ   r5                    ; Temp register 1
0051      0006     tmp2    equ   r6                    ; Temp register 2
0052      0007     tmp3    equ   r7                    ; Temp register 3
0053      0008     tmp4    equ   r8                    ; Temp register 4
0054      0009     stack   equ   r9                    ; Stack pointer
0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0057               ***************************************************************
0058               * Define MSB/LSB equates for registers
0059               ********|*****|*********************|**************************
0060      8300     r0hb    equ   ws1                   ; HI byte R0
0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0092               ********|*****|*********************|**************************
0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0103               ********|*****|*********************|**************************
0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0108               ***************************************************************
**** **** ****     > runlib.asm
0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
0002               * Purpose...: Equates for hardware port addresses
0003               
0004               ***************************************************************
0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0006               ********|*****|*********************|**************************
0007      8400     sound   equ   >8400                 ; Sound generator address
0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0010      8802     vdps    equ   >8802                 ; VDP status register
0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0013      9802     grmra   equ   >9802                 ; GROM set read address
0014      9800     grmrd   equ   >9800                 ; GROM read byte
0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
**** **** ****     > runlib.asm
0079                       copy  "equ_param.asm"            ; Equates runlib parameters
**** **** ****     > equ_param.asm
0001               * FILE......: param.asm
0002               * Purpose...: Equates used for subroutine parameters
0003               
0004               ***************************************************************
0005               * Subroutine parameter equates
0006               ***************************************************************
0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0024               *--------------------------------------------------------------
0025               *   Speech player
0026               *--------------------------------------------------------------
0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
**** **** ****     > runlib.asm
0080               
0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 2000 C13B  30 swbnk   mov   *r11+,tmp0
0026 2002 C17B  30         mov   *r11+,tmp1
0027 2004 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 2006 C155  26         mov   *tmp1,tmp1
0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
**** **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               ---------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 200A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 200C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 200E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2010 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2012 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 2014 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 2016 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 2018 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 201A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 201C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 201E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2020 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2022 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 2024 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 2026 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 2028 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 202A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 202C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 202E D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      200A     hb$00   equ   w$0000                ; >0000
0035      201C     hb$01   equ   w$0100                ; >0100
0036      201E     hb$02   equ   w$0200                ; >0200
0037      2020     hb$04   equ   w$0400                ; >0400
0038      2022     hb$08   equ   w$0800                ; >0800
0039      2024     hb$10   equ   w$1000                ; >1000
0040      2026     hb$20   equ   w$2000                ; >2000
0041      2028     hb$40   equ   w$4000                ; >4000
0042      202A     hb$80   equ   w$8000                ; >8000
0043      202E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      200A     lb$00   equ   w$0000                ; >0000
0048      200C     lb$01   equ   w$0001                ; >0001
0049      200E     lb$02   equ   w$0002                ; >0002
0050      2010     lb$04   equ   w$0004                ; >0004
0051      2012     lb$08   equ   w$0008                ; >0008
0052      2014     lb$10   equ   w$0010                ; >0010
0053      2016     lb$20   equ   w$0020                ; >0020
0054      2018     lb$40   equ   w$0040                ; >0040
0055      201A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0086                       copy  "equ_config.asm"           ; Equates for bits in config register
**** **** ****     > equ_config.asm
0001               * FILE......: equ_config.asm
0002               * Purpose...: Equates for bits in config register
0003               
0004               ***************************************************************
0005               * The config register equates
0006               *--------------------------------------------------------------
0007               * Configuration flags
0008               * ===================
0009               *
0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0019               * ; 06  Timer: Block user hook          1=yes          0=no
0020               * ; 05  Speech synthesizer present      1=yes          0=no
0021               * ; 04  Speech player: busy             1=yes          0=no
0022               * ; 03  Speech player: enabled          1=yes          0=no
0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0024               * ; 01  F18A present                    1=on           0=off
0025               * ; 00  Subroutine state flag           1=on           0=off
0026               ********|*****|*********************|**************************
0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
0032               
**** **** ****     > runlib.asm
0087                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
0001               * FILE......: cpu_crash.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               ***************************************************************
0006               * cpu.crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @cpu.crash
0009               *--------------------------------------------------------------
0010               * Crash and halt system. Upon crash entry register contents are
0011               * copied to the memory region >ffe0 - >fffe and displayed after
0012               * resetting the spectra2 runtime library, video modes, etc.
0013               *
0014               * Diagnostics
0015               * >ffce  caller address
0016               *
0017               * Register contents
0018               * >ffdc  wp
0019               * >ffde  st
0020               * >ffe0  r0
0021               * >ffe2  r1
0022               * >ffe4  r2  (config)
0023               * >ffe6  r3
0024               * >ffe8  r4  (tmp0)
0025               * >ffea  r5  (tmp1)
0026               * >ffec  r6  (tmp2)
0027               * >ffee  r7  (tmp3)
0028               * >fff0  r8  (tmp4)
0029               * >fff2  r9  (stack)
0030               * >fff4  r10
0031               * >fff6  r11
0032               * >fff8  r12
0033               * >fffa  r13
0034               * >fffc  r14
0035               * >fffe  r15
0036               ********|*****|*********************|**************************
0037               cpu.crash:
0038 2030 022B  22         ai    r11,-4                ; Remove opcode offset
     2032 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 2034 C800  38         mov   r0,@>ffe0
     2036 FFE0 
0043 2038 C801  38         mov   r1,@>ffe2
     203A FFE2 
0044 203C C802  38         mov   r2,@>ffe4
     203E FFE4 
0045 2040 C803  38         mov   r3,@>ffe6
     2042 FFE6 
0046 2044 C804  38         mov   r4,@>ffe8
     2046 FFE8 
0047 2048 C805  38         mov   r5,@>ffea
     204A FFEA 
0048 204C C806  38         mov   r6,@>ffec
     204E FFEC 
0049 2050 C807  38         mov   r7,@>ffee
     2052 FFEE 
0050 2054 C808  38         mov   r8,@>fff0
     2056 FFF0 
0051 2058 C809  38         mov   r9,@>fff2
     205A FFF2 
0052 205C C80A  38         mov   r10,@>fff4
     205E FFF4 
0053 2060 C80B  38         mov   r11,@>fff6
     2062 FFF6 
0054 2064 C80C  38         mov   r12,@>fff8
     2066 FFF8 
0055 2068 C80D  38         mov   r13,@>fffa
     206A FFFA 
0056 206C C80E  38         mov   r14,@>fffc
     206E FFFC 
0057 2070 C80F  38         mov   r15,@>ffff
     2072 FFFF 
0058 2074 02A0  12         stwp  r0
0059 2076 C800  38         mov   r0,@>ffdc
     2078 FFDC 
0060 207A 02C0  12         stst  r0
0061 207C C800  38         mov   r0,@>ffde
     207E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2080 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2082 8300 
0067 2084 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2086 8302 
0068 2088 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     208A 4A4A 
0069 208C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     208E 2D68 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @putat                ; Show crash message
     2092 2410 
0078 2094 0000                   data >0000,cpu.crash.msg.crashed
     2096 216A 
0079               
0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
     209A 2996 
0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 20A4 06A0  32         bl    @putat                ; Show caller message
     20A6 2410 
0090 20A8 0100                   data >0100,cpu.crash.msg.caller
     20AA 2180 
0091               
0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
     20AE 2996 
0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 20B8 06A0  32         bl    @putat
     20BA 2410 
0102 20BC 0300                   byte 3,0
0103 20BE 219A                   data cpu.crash.msg.wp
0104 20C0 06A0  32         bl    @putat
     20C2 2410 
0105 20C4 0400                   byte 4,0
0106 20C6 21A0                   data cpu.crash.msg.st
0107 20C8 06A0  32         bl    @putat
     20CA 2410 
0108 20CC 1600                   byte 22,0
0109 20CE 21A6                   data cpu.crash.msg.source
0110 20D0 06A0  32         bl    @putat
     20D2 2410 
0111 20D4 1700                   byte 23,0
0112 20D6 21C0                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
     20DA 264E 
0117 20DC 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 20DE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20E0 FFDC 
0121 20E2 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 20E4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 20E6 0649  14         dect  stack
0127 20E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 20EA 0649  14         dect  stack
0129 20EC C645  30         mov   tmp1,*stack           ; Push tmp1
0130 20EE 0649  14         dect  stack
0131 20F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 20F2 C046  18         mov   tmp2,r1               ; Save register number
0137 20F4 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     20F6 0001 
0138 20F8 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 20FA 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 20FC 06A0  32         bl    @mknum
     20FE 29A0 
0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
     2108 2664 
0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     210E 23FE 
0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
     2114 2664 
0157 2116 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 2118 0281  22         ci    r1,10
     211A 000A 
0161 211C 1102  14         jlt   !
0162 211E 0620  34         dec   @wyx                  ; x=x-1
     2120 832A 
0163               
0164 2122 06A0  32 !       bl    @putstr
     2124 23FE 
0165 2126 2196                   data cpu.crash.msg.r
0166               
0167 2128 06A0  32         bl    @mknum
     212A 29A0 
0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
     2134 2912 
0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
     213E 2664 
0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 2142 06A0  32         bl    @putstr
     2144 23FE 
0187 2146 2198                   data cpu.crash.msg.marker
0188               
0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
     214A 2664 
0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2150 23FE 
0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 215A 06A0  32         bl    @down                 ; y=y+1
     215C 2654 
0202               
0203 215E 0586  14         inc   tmp2
0204 2160 0286  22         ci    tmp2,17
     2162 0011 
0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2168 2C76 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 216A 1553             byte  21
0214 216B ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 2180 1543             byte  21
0219 2181 ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 2196 0152             byte  1
0224 2197 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 2198 013E             byte  1
0229 2199 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 219A 042A             byte  4
0234 219B ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 21A0 042A             byte  4
0239 21A1 ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 21A6 1953             byte  25
0244 21A7 ....             text  'Source    tivi_b1.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 21C0 1642             byte  22
0249 21C1 ....             text  'Build-ID  200329-10901'
0250                       even
0251               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21D8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21DA 000E 
     21DC 0106 
     21DE 0204 
     21E0 0020 
0008               *
0009               * ; VDP#0 Control bits
0010               * ;      bit 6=0: M3 | Graphics 1 mode
0011               * ;      bit 7=0: Disable external VDP input
0012               * ; VDP#1 Control bits
0013               * ;      bit 0=1: 16K selection
0014               * ;      bit 1=1: Enable display
0015               * ;      bit 2=1: Enable VDP interrupt
0016               * ;      bit 3=0: M1 \ Graphics 1 mode
0017               * ;      bit 4=0: M2 /
0018               * ;      bit 5=0: reserved
0019               * ;      bit 6=1: 16x16 sprites
0020               * ;      bit 7=0: Sprite magnification (1x)
0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
0026               * ; VDP#7 Set screen background color
0027               
0028               
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 21E2 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21E4 000E 
     21E6 0106 
     21E8 00F4 
     21EA 0028 
0033               *
0034               * ; VDP#0 Control bits
0035               * ;      bit 6=0: M3 | Graphics 1 mode
0036               * ;      bit 7=0: Disable external VDP input
0037               * ; VDP#1 Control bits
0038               * ;      bit 0=1: 16K selection
0039               * ;      bit 1=1: Enable display
0040               * ;      bit 2=1: Enable VDP interrupt
0041               * ;      bit 3=1: M1 \ TEXT MODE
0042               * ;      bit 4=0: M2 /
0043               * ;      bit 5=0: reserved
0044               * ;      bit 6=1: 16x16 sprites
0045               * ;      bit 7=0: Sprite magnification (1x)
0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0051               * ; VDP#7 Set foreground/background color
0052               ***************************************************************
0053               
0054               
0055               ***************************************************************
0056               * Textmode (80 columns, 24 rows) - F18A
0057               *--------------------------------------------------------------
0058 21EC 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21EE 003F 
     21F0 0240 
     21F2 03F4 
     21F4 0050 
0059               *
0060               * ; VDP#0 Control bits
0061               * ;      bit 6=0: M3 | Graphics 1 mode
0062               * ;      bit 7=0: Disable external VDP input
0063               * ; VDP#1 Control bits
0064               * ;      bit 0=1: 16K selection
0065               * ;      bit 1=1: Enable display
0066               * ;      bit 2=1: Enable VDP interrupt
0067               * ;      bit 3=1: M1 \ TEXT MODE
0068               * ;      bit 4=0: M2 /
0069               * ;      bit 5=0: reserved
0070               * ;      bit 6=0: 8x8 sprites
0071               * ;      bit 7=0: Sprite magnification (1x)
0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0077               * ; VDP#7 Set foreground/background color
0078               ***************************************************************
0079               
0080               
0081               ***************************************************************
0082               * Textmode (80 columns, 30 rows) - F18A
0083               *--------------------------------------------------------------
0084 21F6 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21F8 003F 
     21FA 0240 
     21FC 03F4 
     21FE 0050 
0085               *
0086               * ; VDP#0 Control bits
0087               * ;      bit 6=0: M3 | Graphics 1 mode
0088               * ;      bit 7=0: Disable external VDP input
0089               * ; VDP#1 Control bits
0090               * ;      bit 0=1: 16K selection
0091               * ;      bit 1=1: Enable display
0092               * ;      bit 2=1: Enable VDP interrupt
0093               * ;      bit 3=1: M1 \ TEXT MODE
0094               * ;      bit 4=0: M2 /
0095               * ;      bit 5=0: reserved
0096               * ;      bit 6=0: 8x8 sprites
0097               * ;      bit 7=0: Sprite magnification (1x)
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
**** **** ****     > basic_cpu_vdp.asm
0001               * FILE......: basic_cpu_vdp.asm
0002               * Purpose...: Basic CPU & VDP functions used by other modules
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Support Machine Code for copy & fill functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ; Machine code for tight loop.
0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
0011               *--------------------------------------------------------------
0012               *       DATA  >????                 ; \ mcloop  mov   ...
0013 2200 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2202 16FD             data  >16fd                 ; |         jne   mcloop
0015 2204 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2206 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2208 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               *//////////////////////////////////////////////////////////////
0027               *                    STACK SUPPORT FUNCTIONS
0028               *//////////////////////////////////////////////////////////////
0029               
0030               ***************************************************************
0031               * POPR. - Pop registers & return to caller
0032               ***************************************************************
0033               *  B  @POPRG.
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  R11 must be at stack bottom
0037               ********|*****|*********************|**************************
0038 220A C0F9  30 popr3   mov   *stack+,r3
0039 220C C0B9  30 popr2   mov   *stack+,r2
0040 220E C079  30 popr1   mov   *stack+,r1
0041 2210 C039  30 popr0   mov   *stack+,r0
0042 2212 C2F9  30 poprt   mov   *stack+,r11
0043 2214 045B  20         b     *r11
0044               
0045               
0046               
0047               *//////////////////////////////////////////////////////////////
0048               *                   MEMORY FILL FUNCTIONS
0049               *//////////////////////////////////////////////////////////////
0050               
0051               ***************************************************************
0052               * FILM - Fill CPU memory with byte
0053               ***************************************************************
0054               *  bl   @film
0055               *  data P0,P1,P2
0056               *--------------------------------------------------------------
0057               *  P0 = Memory start address
0058               *  P1 = Byte to fill
0059               *  P2 = Number of bytes to fill
0060               *--------------------------------------------------------------
0061               *  bl   @xfilm
0062               *
0063               *  TMP0 = Memory start address
0064               *  TMP1 = Byte to fill
0065               *  TMP2 = Number of bytes to fill
0066               ********|*****|*********************|**************************
0067 2216 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 2218 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 221A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 221C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 221E 1604  14         jne   filchk                ; No, continue checking
0075               
0076 2220 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2222 FFCE 
0077 2224 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2226 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 2228 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     222A 830B 
     222C 830A 
0082               
0083 222E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2230 0001 
0084 2232 1602  14         jne   filchk2
0085 2234 DD05  32         movb  tmp1,*tmp0+
0086 2236 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 2238 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     223A 0002 
0091 223C 1603  14         jne   filchk3
0092 223E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 2240 DD05  32         movb  tmp1,*tmp0+
0094 2242 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 2244 C1C4  18 filchk3 mov   tmp0,tmp3
0099 2246 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2248 0001 
0100 224A 1605  14         jne   fil16b
0101 224C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 224E 0606  14         dec   tmp2
0103 2250 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2252 0002 
0104 2254 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2256 C1C6  18 fil16b  mov   tmp2,tmp3
0109 2258 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     225A 0001 
0110 225C 1301  14         jeq   dofill
0111 225E 0606  14         dec   tmp2                  ; Make TMP2 even
0112 2260 CD05  34 dofill  mov   tmp1,*tmp0+
0113 2262 0646  14         dect  tmp2
0114 2264 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2266 C1C7  18         mov   tmp3,tmp3
0119 2268 1301  14         jeq   fil.$$
0120 226A DD05  32         movb  tmp1,*tmp0+
0121 226C 045B  20 fil.$$  b     *r11
0122               
0123               
0124               ***************************************************************
0125               * FILV - Fill VRAM with byte
0126               ***************************************************************
0127               *  BL   @FILV
0128               *  DATA P0,P1,P2
0129               *--------------------------------------------------------------
0130               *  P0 = VDP start address
0131               *  P1 = Byte to fill
0132               *  P2 = Number of bytes to fill
0133               *--------------------------------------------------------------
0134               *  BL   @XFILV
0135               *
0136               *  TMP0 = VDP start address
0137               *  TMP1 = Byte to fill
0138               *  TMP2 = Number of bytes to fill
0139               ********|*****|*********************|**************************
0140 226E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 2270 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 2272 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 2274 0264  22 xfilv   ori   tmp0,>4000
     2276 4000 
0147 2278 06C4  14         swpb  tmp0
0148 227A D804  38         movb  tmp0,@vdpa
     227C 8C02 
0149 227E 06C4  14         swpb  tmp0
0150 2280 D804  38         movb  tmp0,@vdpa
     2282 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 2284 020F  20         li    r15,vdpw              ; Set VDP write address
     2286 8C00 
0155 2288 06C5  14         swpb  tmp1
0156 228A C820  54         mov   @filzz,@mcloop        ; Setup move command
     228C 2294 
     228E 8320 
0157 2290 0460  28         b     @mcloop               ; Write data to VDP
     2292 8320 
0158               *--------------------------------------------------------------
0162 2294 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0164               
0165               
0166               
0167               *//////////////////////////////////////////////////////////////
0168               *                  VDP LOW LEVEL FUNCTIONS
0169               *//////////////////////////////////////////////////////////////
0170               
0171               ***************************************************************
0172               * VDWA / VDRA - Setup VDP write or read address
0173               ***************************************************************
0174               *  BL   @VDWA
0175               *
0176               *  TMP0 = VDP destination address for write
0177               *--------------------------------------------------------------
0178               *  BL   @VDRA
0179               *
0180               *  TMP0 = VDP source address for read
0181               ********|*****|*********************|**************************
0182 2296 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     2298 4000 
0183 229A 06C4  14 vdra    swpb  tmp0
0184 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0185 22A0 06C4  14         swpb  tmp0
0186 22A2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22A4 8C02 
0187 22A6 045B  20         b     *r11                  ; Exit
0188               
0189               ***************************************************************
0190               * VPUTB - VDP put single byte
0191               ***************************************************************
0192               *  BL @VPUTB
0193               *  DATA P0,P1
0194               *--------------------------------------------------------------
0195               *  P0 = VDP target address
0196               *  P1 = Byte to write
0197               ********|*****|*********************|**************************
0198 22A8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22AA C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22AC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22AE 4000 
0204 22B0 06C4  14         swpb  tmp0                  ; \
0205 22B2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22B4 8C02 
0206 22B6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22B8 D804  38         movb  tmp0,@vdpa            ; /
     22BA 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22BC 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22BE D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22C0 045B  20         b     *r11                  ; Exit
0214               
0215               
0216               ***************************************************************
0217               * VGETB - VDP get single byte
0218               ***************************************************************
0219               *  bl   @vgetb
0220               *  data p0
0221               *--------------------------------------------------------------
0222               *  P0 = VDP source address
0223               *--------------------------------------------------------------
0224               *  bl   @xvgetb
0225               *
0226               *  tmp0 = VDP source address
0227               *--------------------------------------------------------------
0228               *  Output:
0229               *  tmp0 MSB = >00
0230               *  tmp0 LSB = VDP byte read
0231               ********|*****|*********************|**************************
0232 22C2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22C4 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22C6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22C8 8C02 
0238 22CA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22CC D804  38         movb  tmp0,@vdpa            ; /
     22CE 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22D0 D120  34         movb  @vdpr,tmp0            ; Read byte
     22D2 8800 
0244 22D4 0984  56         srl   tmp0,8                ; Right align
0245 22D6 045B  20         b     *r11                  ; Exit
0246               
0247               
0248               ***************************************************************
0249               * VIDTAB - Dump videomode table
0250               ***************************************************************
0251               *  BL   @VIDTAB
0252               *  DATA P0
0253               *--------------------------------------------------------------
0254               *  P0 = Address of video mode table
0255               *--------------------------------------------------------------
0256               *  BL   @XIDTAB
0257               *
0258               *  TMP0 = Address of video mode table
0259               *--------------------------------------------------------------
0260               *  Remarks
0261               *  TMP1 = MSB is the VDP target register
0262               *         LSB is the value to write
0263               ********|*****|*********************|**************************
0264 22D8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22DA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22DC C144  18         mov   tmp0,tmp1
0270 22DE 05C5  14         inct  tmp1
0271 22E0 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22E2 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22E4 FF00 
0273 22E6 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 22E8 C805  38         mov   tmp1,@wbase           ; Store calculated base
     22EA 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 22EC 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     22EE 8000 
0279 22F0 0206  20         li    tmp2,8
     22F2 0008 
0280 22F4 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     22F6 830B 
0281 22F8 06C5  14         swpb  tmp1
0282 22FA D805  38         movb  tmp1,@vdpa
     22FC 8C02 
0283 22FE 06C5  14         swpb  tmp1
0284 2300 D805  38         movb  tmp1,@vdpa
     2302 8C02 
0285 2304 0225  22         ai    tmp1,>0100
     2306 0100 
0286 2308 0606  14         dec   tmp2
0287 230A 16F4  14         jne   vidta1                ; Next register
0288 230C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     230E 833A 
0289 2310 045B  20         b     *r11
0290               
0291               
0292               ***************************************************************
0293               * PUTVR  - Put single VDP register
0294               ***************************************************************
0295               *  BL   @PUTVR
0296               *  DATA P0
0297               *--------------------------------------------------------------
0298               *  P0 = MSB is the VDP target register
0299               *       LSB is the value to write
0300               *--------------------------------------------------------------
0301               *  BL   @PUTVRX
0302               *
0303               *  TMP0 = MSB is the VDP target register
0304               *         LSB is the value to write
0305               ********|*****|*********************|**************************
0306 2312 C13B  30 putvr   mov   *r11+,tmp0
0307 2314 0264  22 putvrx  ori   tmp0,>8000
     2316 8000 
0308 2318 06C4  14         swpb  tmp0
0309 231A D804  38         movb  tmp0,@vdpa
     231C 8C02 
0310 231E 06C4  14         swpb  tmp0
0311 2320 D804  38         movb  tmp0,@vdpa
     2322 8C02 
0312 2324 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2326 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 2328 C10E  18         mov   r14,tmp0
0322 232A 0984  56         srl   tmp0,8
0323 232C 06A0  32         bl    @putvrx               ; Write VR#0
     232E 2314 
0324 2330 0204  20         li    tmp0,>0100
     2332 0100 
0325 2334 D820  54         movb  @r14lb,@tmp0lb
     2336 831D 
     2338 8309 
0326 233A 06A0  32         bl    @putvrx               ; Write VR#1
     233C 2314 
0327 233E 0458  20         b     *tmp4                 ; Exit
0328               
0329               
0330               ***************************************************************
0331               * LDFNT - Load TI-99/4A font from GROM into VDP
0332               ***************************************************************
0333               *  BL   @LDFNT
0334               *  DATA P0,P1
0335               *--------------------------------------------------------------
0336               *  P0 = VDP Target address
0337               *  P1 = Font options
0338               *--------------------------------------------------------------
0339               * Uses registers tmp0-tmp4
0340               ********|*****|*********************|**************************
0341 2340 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 2342 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 2344 C11B  26         mov   *r11,tmp0             ; Get P0
0344 2346 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2348 7FFF 
0345 234A 2120  38         coc   @wbit0,tmp0
     234C 202A 
0346 234E 1604  14         jne   ldfnt1
0347 2350 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2352 8000 
0348 2354 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2356 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 2358 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     235A 23C2 
0353 235C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     235E 9C02 
0354 2360 06C4  14         swpb  tmp0
0355 2362 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2364 9C02 
0356 2366 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2368 9800 
0357 236A 06C5  14         swpb  tmp1
0358 236C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     236E 9800 
0359 2370 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 2372 D805  38         movb  tmp1,@grmwa
     2374 9C02 
0364 2376 06C5  14         swpb  tmp1
0365 2378 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     237A 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 237C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 237E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     2380 2296 
0371 2382 05C8  14         inct  tmp4                  ; R11=R11+2
0372 2384 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 2386 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     2388 7FFF 
0374 238A C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     238C 23C4 
0375 238E C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     2390 23C6 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 2392 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 2394 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 2396 D120  34         movb  @grmrd,tmp0
     2398 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 239A 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     239C 202A 
0386 239E 1603  14         jne   ldfnt3                ; No, so skip
0387 23A0 D1C4  18         movb  tmp0,tmp3
0388 23A2 0917  56         srl   tmp3,1
0389 23A4 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23A6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23A8 8C00 
0394 23AA 0606  14         dec   tmp2
0395 23AC 16F2  14         jne   ldfnt2
0396 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23B0 020F  20         li    r15,vdpw              ; Set VDP write address
     23B2 8C00 
0398 23B4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23B6 7FFF 
0399 23B8 0458  20         b     *tmp4                 ; Exit
0400 23BA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23BC 200A 
     23BE 8C00 
0401 23C0 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23C2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23C4 0200 
     23C6 0000 
0406 23C8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23CA 01C0 
     23CC 0101 
0407 23CE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23D0 02A0 
     23D2 0101 
0408 23D4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23D6 00E0 
     23D8 0101 
0409               
0410               
0411               
0412               ***************************************************************
0413               * YX2PNT - Get VDP PNT address for current YX cursor position
0414               ***************************************************************
0415               *  BL   @YX2PNT
0416               *--------------------------------------------------------------
0417               *  INPUT
0418               *  @WYX = Cursor YX position
0419               *--------------------------------------------------------------
0420               *  OUTPUT
0421               *  TMP0 = VDP address for entry in Pattern Name Table
0422               *--------------------------------------------------------------
0423               *  Register usage
0424               *  TMP0, R14, R15
0425               ********|*****|*********************|**************************
0426 23DA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23DC C3A0  34         mov   @wyx,r14              ; Get YX
     23DE 832A 
0428 23E0 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23E2 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23E4 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 23E6 C3A0  34         mov   @wyx,r14              ; Get YX
     23E8 832A 
0435 23EA 024E  22         andi  r14,>00ff             ; Remove Y
     23EC 00FF 
0436 23EE A3CE  18         a     r14,r15               ; pos = pos + X
0437 23F0 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     23F2 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 23F4 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 23F6 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 23F8 020F  20         li    r15,vdpw              ; VDP write address
     23FA 8C00 
0444 23FC 045B  20         b     *r11
0445               
0446               
0447               
0448               ***************************************************************
0449               * Put length-byte prefixed string at current YX
0450               ***************************************************************
0451               *  BL   @PUTSTR
0452               *  DATA P0
0453               *
0454               *  P0 = Pointer to string
0455               *--------------------------------------------------------------
0456               *  REMARKS
0457               *  First byte of string must contain length
0458               ********|*****|*********************|**************************
0459 23FE C17B  30 putstr  mov   *r11+,tmp1
0460 2400 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 2402 C1CB  18 xutstr  mov   r11,tmp3
0462 2404 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2406 23DA 
0463 2408 C2C7  18         mov   tmp3,r11
0464 240A 0986  56         srl   tmp2,8                ; Right justify length byte
0465 240C 0460  28         b     @xpym2v               ; Display string
     240E 241E 
0466               
0467               
0468               ***************************************************************
0469               * Put length-byte prefixed string at YX
0470               ***************************************************************
0471               *  BL   @PUTAT
0472               *  DATA P0,P1
0473               *
0474               *  P0 = YX position
0475               *  P1 = Pointer to string
0476               *--------------------------------------------------------------
0477               *  REMARKS
0478               *  First byte of string must contain length
0479               ********|*****|*********************|**************************
0480 2410 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2412 832A 
0481 2414 0460  28         b     @putstr
     2416 23FE 
**** **** ****     > runlib.asm
0090               
0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
**** **** ****     > copy_cpu_vram.asm
0001               * FILE......: copy_cpu_vram.asm
0002               * Purpose...: CPU memory to VRAM copy support module
0003               
0004               ***************************************************************
0005               * CPYM2V - Copy CPU memory to VRAM
0006               ***************************************************************
0007               *  BL   @CPYM2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP start address
0011               *  P1 = RAM/ROM start address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYM2V
0015               *
0016               *  TMP0 = VDP start address
0017               *  TMP1 = RAM/ROM start address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 2418 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 241A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 241C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 241E 0264  22 xpym2v  ori   tmp0,>4000
     2420 4000 
0027 2422 06C4  14         swpb  tmp0
0028 2424 D804  38         movb  tmp0,@vdpa
     2426 8C02 
0029 2428 06C4  14         swpb  tmp0
0030 242A D804  38         movb  tmp0,@vdpa
     242C 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 242E 020F  20         li    r15,vdpw              ; Set VDP write address
     2430 8C00 
0035 2432 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2434 243C 
     2436 8320 
0036 2438 0460  28         b     @mcloop               ; Write data to VDP
     243A 8320 
0037 243C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0094               
0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
**** **** ****     > copy_vram_cpu.asm
0001               * FILE......: copy_vram_cpu.asm
0002               * Purpose...: VRAM to CPU memory copy support module
0003               
0004               ***************************************************************
0005               * CPYV2M - Copy VRAM to CPU memory
0006               ***************************************************************
0007               *  BL   @CPYV2M
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP source address
0011               *  P1 = RAM target address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYV2M
0015               *
0016               *  TMP0 = VDP source address
0017               *  TMP1 = RAM target address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 243E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2440 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2442 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2444 06C4  14 xpyv2m  swpb  tmp0
0027 2446 D804  38         movb  tmp0,@vdpa
     2448 8C02 
0028 244A 06C4  14         swpb  tmp0
0029 244C D804  38         movb  tmp0,@vdpa
     244E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2450 020F  20         li    r15,vdpr              ; Set VDP read address
     2452 8800 
0034 2454 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2456 245E 
     2458 8320 
0035 245A 0460  28         b     @mcloop               ; Read data from VDP
     245C 8320 
0036 245E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0098               
0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
**** **** ****     > copy_cpu_cpu.asm
0001               * FILE......: copy_cpu_cpu.asm
0002               * Purpose...: CPU to CPU memory copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       CPU COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYM2M - Copy CPU memory to CPU memory
0010               ***************************************************************
0011               *  BL   @CPYM2M
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = Memory source address
0015               *  P1 = Memory target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @XPYM2M
0019               *
0020               *  TMP0 = Memory source address
0021               *  TMP1 = Memory target address
0022               *  TMP2 = Number of bytes to copy
0023               ********|*****|*********************|**************************
0024 2460 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 2462 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2464 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2466 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2468 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 246A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     246C FFCE 
0034 246E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2470 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2472 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2474 0001 
0039 2476 1603  14         jne   cpym0                 ; No, continue checking
0040 2478 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 247A 04C6  14         clr   tmp2                  ; Reset counter
0042 247C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 247E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2480 7FFF 
0047 2482 C1C4  18         mov   tmp0,tmp3
0048 2484 0247  22         andi  tmp3,1
     2486 0001 
0049 2488 1618  14         jne   cpyodd                ; Odd source address handling
0050 248A C1C5  18 cpym1   mov   tmp1,tmp3
0051 248C 0247  22         andi  tmp3,1
     248E 0001 
0052 2490 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2492 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2494 202A 
0057 2496 1605  14         jne   cpym3
0058 2498 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     249A 24C0 
     249C 8320 
0059 249E 0460  28         b     @mcloop               ; Copy memory and exit
     24A0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24A2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24A4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24A6 0001 
0065 24A8 1301  14         jeq   cpym4
0066 24AA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24AC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24AE 0646  14         dect  tmp2
0069 24B0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24B2 C1C7  18         mov   tmp3,tmp3
0074 24B4 1301  14         jeq   cpymz
0075 24B6 D554  38         movb  *tmp0,*tmp1
0076 24B8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24BA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24BC 8000 
0081 24BE 10E9  14         jmp   cpym2
0082 24C0 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0106               
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
**** **** ****     > cpu_sams_support.asm
0001               * FILE......: cpu_sams_support.asm
0002               * Purpose...: Low level support for SAMS memory expansion card
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                SAMS Memory Expansion support
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ACCESS and MAPPING
0010               * (by the late Bruce Harisson):
0011               *
0012               * To use other than the default setup, you have to do two
0013               * things:
0014               *
0015               * 1. You have to "turn on" the card's memory in the
0016               *    >4000 block and write to the mapping registers there.
0017               *    (bl  @sams.page.set)
0018               *
0019               * 2. You have to "turn on" the mapper function to make what
0020               *    you've written into the >4000 block take effect.
0021               *    (bl  @sams.mapping.on)
0022               *--------------------------------------------------------------
0023               *  SAMS                          Default SAMS page
0024               *  Register     Memory bank      (system startup)
0025               *  =======      ===========      ================
0026               *  >4004        >2000-2fff          >002
0027               *  >4006        >3000-4fff          >003
0028               *  >4014        >a000-afff          >00a
0029               *  >4016        >b000-bfff          >00b
0030               *  >4018        >c000-cfff          >00c
0031               *  >401a        >d000-dfff          >00d
0032               *  >401c        >e000-efff          >00e
0033               *  >401e        >f000-ffff          >00f
0034               *  Others       Inactive
0035               *--------------------------------------------------------------
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * sams.page.get - Get SAMS page number for memory address
0042               ***************************************************************
0043               * bl   @sams.page.get
0044               *      data P0
0045               *--------------------------------------------------------------
0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
0047               *      register >4014 (bank >a000 - >afff)
0048               *--------------------------------------------------------------
0049               * bl   @xsams.page.get
0050               *
0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
0052               *        register >4014 (bank >a000 - >afff)
0053               *--------------------------------------------------------------
0054               * OUTPUT
0055               * waux1 = SAMS page number
0056               * waux2 = Address of affected SAMS register
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * r0, tmp0, r12
0060               ********|*****|*********************|**************************
0061               sams.page.get:
0062 24C2 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24C4 0649  14         dect  stack
0065 24C6 C64B  30         mov   r11,*stack            ; Push return address
0066 24C8 0649  14         dect  stack
0067 24CA C640  30         mov   r0,*stack             ; Push r0
0068 24CC 0649  14         dect  stack
0069 24CE C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24D0 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24D2 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24D4 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24D6 4000 
0077 24D8 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24DA 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 24DC 020C  20         li    r12,>1e00             ; SAMS CRU address
     24DE 1E00 
0082 24E0 04C0  14         clr   r0
0083 24E2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24E4 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 24E6 D100  18         movb  r0,tmp0
0086 24E8 0984  56         srl   tmp0,8                ; Right align
0087 24EA C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     24EC 833C 
0088 24EE 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 24F0 C339  30         mov   *stack+,r12           ; Pop r12
0094 24F2 C039  30         mov   *stack+,r0            ; Pop r0
0095 24F4 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 24F6 045B  20         b     *r11                  ; Return to caller
0097               
0098               
0099               
0100               
0101               ***************************************************************
0102               * sams.page.set - Set SAMS memory page
0103               ***************************************************************
0104               * bl   sams.page.set
0105               *      data P0,P1
0106               *--------------------------------------------------------------
0107               * P0 = SAMS page number
0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
0109               *      register >4014 (bank >a000 - >afff)
0110               *--------------------------------------------------------------
0111               * bl   @xsams.page.set
0112               *
0113               * tmp0 = SAMS page number
0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
0115               *        register >4014 (bank >a000 - >afff)
0116               *--------------------------------------------------------------
0117               * Register usage
0118               * r0, tmp0, tmp1, r12
0119               *--------------------------------------------------------------
0120               * SAMS page number should be in range 0-255 (>00 to >ff)
0121               *
0122               *  Page         Memory
0123               *  ====         ======
0124               *  >00             32K
0125               *  >1f            128K
0126               *  >3f            256K
0127               *  >7f            512K
0128               *  >ff           1024K
0129               ********|*****|*********************|**************************
0130               sams.page.set:
0131 24F8 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 24FA C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 24FC 0649  14         dect  stack
0135 24FE C64B  30         mov   r11,*stack            ; Push return address
0136 2500 0649  14         dect  stack
0137 2502 C640  30         mov   r0,*stack             ; Push r0
0138 2504 0649  14         dect  stack
0139 2506 C64C  30         mov   r12,*stack            ; Push r12
0140 2508 0649  14         dect  stack
0141 250A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 250C 0649  14         dect  stack
0143 250E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2510 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2512 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 2514 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2516 001E 
0153 2518 150A  14         jgt   !
0154 251A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     251C 0004 
0155 251E 1107  14         jlt   !
0156 2520 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2522 0012 
0157 2524 1508  14         jgt   sams.page.set.switch_page
0158 2526 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2528 0006 
0159 252A 1501  14         jgt   !
0160 252C 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 252E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2530 FFCE 
0165 2532 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2534 2030 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 2536 020C  20         li    r12,>1e00             ; SAMS CRU address
     2538 1E00 
0171 253A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 253C 06C0  14         swpb  r0                    ; LSB to MSB
0173 253E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 2540 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2542 4000 
0175 2544 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 2546 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 2548 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 254A C339  30         mov   *stack+,r12           ; Pop r12
0183 254C C039  30         mov   *stack+,r0            ; Pop r0
0184 254E C2F9  30         mov   *stack+,r11           ; Pop return address
0185 2550 045B  20         b     *r11                  ; Return to caller
0186               
0187               
0188               
0189               
0190               ***************************************************************
0191               * sams.mapping.on - Enable SAMS mapping mode
0192               ***************************************************************
0193               *  bl   @sams.mapping.on
0194               *--------------------------------------------------------------
0195               *  Register usage
0196               *  r12
0197               ********|*****|*********************|**************************
0198               sams.mapping.on:
0199 2552 020C  20         li    r12,>1e00             ; SAMS CRU address
     2554 1E00 
0200 2556 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 2558 045B  20         b     *r11                  ; Return to caller
0206               
0207               
0208               
0209               
0210               ***************************************************************
0211               * sams.mapping.off - Disable SAMS mapping mode
0212               ***************************************************************
0213               * bl  @sams.mapping.off
0214               *--------------------------------------------------------------
0215               * OUTPUT
0216               * none
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * r12
0220               ********|*****|*********************|**************************
0221               sams.mapping.off:
0222 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0223 255E 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 2560 045B  20         b     *r11                  ; Return to caller
0229               
0230               
0231               
0232               
0233               
0234               ***************************************************************
0235               * sams.layout
0236               * Setup SAMS memory banks
0237               ***************************************************************
0238               * bl  @sams.layout
0239               *     data P0
0240               *--------------------------------------------------------------
0241               * INPUT
0242               * P0 = Pointer to SAMS page layout table (16 words).
0243               *--------------------------------------------------------------
0244               * bl  @xsams.layout
0245               *
0246               * tmp0 = Pointer to SAMS page layout table (16 words).
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0, tmp1, tmp2, tmp3
0253               ********|*****|*********************|**************************
0254               sams.layout:
0255 2562 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 2564 0649  14         dect  stack
0258 2566 C64B  30         mov   r11,*stack            ; Save return address
0259 2568 0649  14         dect  stack
0260 256A C644  30         mov   tmp0,*stack           ; Save tmp0
0261 256C 0649  14         dect  stack
0262 256E C645  30         mov   tmp1,*stack           ; Save tmp1
0263 2570 0649  14         dect  stack
0264 2572 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 2574 0649  14         dect  stack
0266 2576 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 2578 0206  20         li    tmp2,8                ; Set loop counter
     257A 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 257C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 257E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 2580 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2582 24FC 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 2584 0606  14         dec   tmp2                  ; Next iteration
0283 2586 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 2588 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     258A 2552 
0289                                                   ; / activating changes.
0290               
0291 258C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 258E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 2590 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 2592 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 2594 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 2596 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.reset.layout
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.reset.layout
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.reset.layout:
0313 2598 0649  14         dect  stack
0314 259A C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 259C 06A0  32         bl    @sams.layout
     259E 2562 
0319 25A0 25A6                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.layout.exit:
0324 25A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 25A4 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 25A6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25A8 0002 
0331 25AA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25AC 0003 
0332 25AE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25B0 000A 
0333 25B2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25B4 000B 
0334 25B6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25B8 000C 
0335 25BA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25BC 000D 
0336 25BE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25C0 000E 
0337 25C2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25C4 000F 
0338               
0339               
0340               
0341               ***************************************************************
0342               * sams.copy.layout
0343               * Copy SAMS memory layout
0344               ***************************************************************
0345               * bl  @sams.copy.layout
0346               *     data P0
0347               *--------------------------------------------------------------
0348               * P0 = Pointer to 8 words RAM buffer for results
0349               *--------------------------------------------------------------
0350               * OUTPUT
0351               * RAM buffer will have the SAMS page number for each range
0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0353               *--------------------------------------------------------------
0354               * Register usage
0355               * tmp0, tmp1, tmp2, tmp3
0356               ***************************************************************
0357               sams.copy.layout:
0358 25C6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 25C8 0649  14         dect  stack
0361 25CA C64B  30         mov   r11,*stack            ; Push return address
0362 25CC 0649  14         dect  stack
0363 25CE C644  30         mov   tmp0,*stack           ; Push tmp0
0364 25D0 0649  14         dect  stack
0365 25D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 25D4 0649  14         dect  stack
0367 25D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 25D8 0649  14         dect  stack
0369 25DA C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 25DC 0205  20         li    tmp1,sams.copy.layout.data
     25DE 25FE 
0374 25E0 0206  20         li    tmp2,8                ; Set loop counter
     25E2 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.copy.layout.loop:
0379 25E4 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 25E6 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     25E8 24C4 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 25EA CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     25EC 833C 
0385               
0386 25EE 0606  14         dec   tmp2                  ; Next iteration
0387 25F0 16F9  14         jne   sams.copy.layout.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.copy.layout.exit:
0392 25F2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 25F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 25F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 25F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 25FA C2F9  30         mov   *stack+,r11           ; Pop r11
0397 25FC 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.copy.layout.data:
0402 25FE 2000             data  >2000                 ; >2000-2fff
0403 2600 3000             data  >3000                 ; >3000-3fff
0404 2602 A000             data  >a000                 ; >a000-afff
0405 2604 B000             data  >b000                 ; >b000-bfff
0406 2606 C000             data  >c000                 ; >c000-cfff
0407 2608 D000             data  >d000                 ; >d000-dfff
0408 260A E000             data  >e000                 ; >e000-efff
0409 260C F000             data  >f000                 ; >f000-ffff
0410               
**** **** ****     > runlib.asm
0114               
0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 260E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2610 FFBF 
0010 2612 0460  28         b     @putv01
     2614 2326 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2616 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2618 0040 
0018 261A 0460  28         b     @putv01
     261C 2326 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 261E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2620 FFDF 
0026 2622 0460  28         b     @putv01
     2624 2326 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2626 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2628 0020 
0034 262A 0460  28         b     @putv01
     262C 2326 
**** **** ****     > runlib.asm
0118               
0120                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 262E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2630 FFFE 
0011 2632 0460  28         b     @putv01
     2634 2326 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2636 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2638 0001 
0019 263A 0460  28         b     @putv01
     263C 2326 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 263E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2640 FFFD 
0027 2642 0460  28         b     @putv01
     2644 2326 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2646 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2648 0002 
0035 264A 0460  28         b     @putv01
     264C 2326 
**** **** ****     > runlib.asm
0122               
0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
**** **** ****     > vdp_cursor.asm
0001               * FILE......: vdp_cursor.asm
0002               * Purpose...: VDP cursor handling
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               VDP cursor movement functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * AT - Set cursor YX position
0011               ***************************************************************
0012               *  bl   @yx
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  INPUT
0016               *  P0 = New Cursor YX position
0017               ********|*****|*********************|**************************
0018 264E C83B  50 at      mov   *r11+,@wyx
     2650 832A 
0019 2652 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2654 B820  54 down    ab    @hb$01,@wyx
     2656 201C 
     2658 832A 
0028 265A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 265C 7820  54 up      sb    @hb$01,@wyx
     265E 201C 
     2660 832A 
0037 2662 045B  20         b     *r11
0038               
0039               
0040               ***************************************************************
0041               * setx - Set cursor X position
0042               ***************************************************************
0043               *  bl   @setx
0044               *  data p0
0045               *--------------------------------------------------------------
0046               *  Register usage
0047               *  TMP0
0048               ********|*****|*********************|**************************
0049 2664 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2666 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     2668 832A 
0051 266A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     266C 832A 
0052 266E 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
**** **** ****     > vdp_yx2px_calc.asm
0001               * FILE......: vdp_yx2px_calc.asm
0002               * Purpose...: Calculate pixel position for YX coordinate
0003               
0004               ***************************************************************
0005               * YX2PX - Get pixel position for cursor YX position
0006               ***************************************************************
0007               *  BL   @YX2PX
0008               *
0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
0010               *--------------------------------------------------------------
0011               *  INPUT
0012               *  @WYX   = Cursor YX position
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y pixel position
0016               *  TMP0LB = X pixel position
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  This subroutine does not support multicolor mode
0020               ********|*****|*********************|**************************
0021 2670 C120  34 yx2px   mov   @wyx,tmp0
     2672 832A 
0022 2674 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2676 06C4  14         swpb  tmp0                  ; Y<->X
0024 2678 04C5  14         clr   tmp1                  ; Clear before copy
0025 267A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 267C 20A0  38         coc   @wbit1,config         ; f18a present ?
     267E 2028 
0030 2680 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2682 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2684 833A 
     2686 26B0 
0032 2688 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 268A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 268C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 268E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2690 0500 
0037 2692 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2694 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2696 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2698 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 269A D105  18         movb  tmp1,tmp0
0051 269C 06C4  14         swpb  tmp0                  ; X<->Y
0052 269E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26A0 202A 
0053 26A2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26A4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26A6 201C 
0059 26A8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26AA 202E 
0060 26AC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26AE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26B0 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0130               
0134               
0138               
0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
**** **** ****     > vdp_f18a_support.asm
0001               * FILE......: vdp_f18a_support.asm
0002               * Purpose...: VDP F18A Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * f18unl - Unlock F18A VDP
0010               ***************************************************************
0011               *  bl   @f18unl
0012               ********|*****|*********************|**************************
0013 26B2 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26B4 06A0  32         bl    @putvr                ; Write once
     26B6 2312 
0015 26B8 391C             data  >391c                 ; VR1/57, value 00011100
0016 26BA 06A0  32         bl    @putvr                ; Write twice
     26BC 2312 
0017 26BE 391C             data  >391c                 ; VR1/57, value 00011100
0018 26C0 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26C2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26C6 2312 
0028 26C8 391C             data  >391c
0029 26CA 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********|*****|*********************|**************************
0040 26CC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26CE 06A0  32         bl    @cpym2v
     26D0 2418 
0042 26D2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26D4 2710 
     26D6 0006 
0043 26D8 06A0  32         bl    @putvr
     26DA 2312 
0044 26DC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26DE 06A0  32         bl    @putvr
     26E0 2312 
0046 26E2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 26E4 0204  20         li    tmp0,>3f00
     26E6 3F00 
0052 26E8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     26EA 229A 
0053 26EC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     26EE 8800 
0054 26F0 0984  56         srl   tmp0,8
0055 26F2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     26F4 8800 
0056 26F6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 26F8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 26FA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     26FC BFFF 
0060 26FE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2700 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2702 4000 
0063               f18chk_exit:
0064 2704 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2706 226E 
0065 2708 3F00             data  >3f00,>00,6
     270A 0000 
     270C 0006 
0066 270E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2710 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2712 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2714 0340             data  >0340                 ; 3f04   0340  idle
0074               
0075               
0076               ***************************************************************
0077               * f18rst - Reset f18a into standard settings
0078               ***************************************************************
0079               *  bl   @f18rst
0080               *--------------------------------------------------------------
0081               *  REMARKS
0082               *  This is used to leave the F18A mode and revert all settings
0083               *  that could lead to corruption when doing BLWP @0
0084               *
0085               *  There are some F18a settings that stay on when doing blwp @0
0086               *  and the TI title screen cannot recover from that.
0087               *
0088               *  It is your responsibility to set video mode tables should
0089               *  you want to continue instead of doing blwp @0 after your
0090               *  program cleanup
0091               ********|*****|*********************|**************************
0092 2716 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2718 06A0  32         bl    @putvr
     271A 2312 
0097 271C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 271E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2720 2312 
0100 2722 391C             data  >391c                 ; Lock the F18a
0101 2724 0458  20         b     *tmp4                 ; Exit
0102               
0103               
0104               
0105               ***************************************************************
0106               * f18fwv - Get F18A Firmware Version
0107               ***************************************************************
0108               *  bl   @f18fwv
0109               *--------------------------------------------------------------
0110               *  REMARKS
0111               *  Successfully tested with F18A v1.8, note that this does not
0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
0113               *  firmware to begin with.
0114               *--------------------------------------------------------------
0115               *  TMP0 High nibble = major version
0116               *  TMP0 Low nibble  = minor version
0117               *
0118               *  Example: >0018     F18a Firmware v1.8
0119               ********|*****|*********************|**************************
0120 2726 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2728 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     272A 2028 
0122 272C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 272E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2730 8802 
0127 2732 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2734 2312 
0128 2736 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2738 04C4  14         clr   tmp0
0130 273A D120  34         movb  @vdps,tmp0
     273C 8802 
0131 273E 0984  56         srl   tmp0,8
0132 2740 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0142               
0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
**** **** ****     > vdp_hchar.asm
0001               * FILE......: vdp_hchar.a99
0002               * Purpose...: VDP hchar module
0003               
0004               ***************************************************************
0005               * Repeat characters horizontally at YX
0006               ***************************************************************
0007               *  BL    @HCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 2742 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2744 832A 
0018 2746 D17B  28         movb  *r11+,tmp1
0019 2748 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 274A D1BB  28         movb  *r11+,tmp2
0021 274C 0986  56         srl   tmp2,8                ; Repeat count
0022 274E C1CB  18         mov   r11,tmp3
0023 2750 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2752 23DA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2754 020B  20         li    r11,hchar1
     2756 275C 
0028 2758 0460  28         b     @xfilv                ; Draw
     275A 2274 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 275C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     275E 202C 
0033 2760 1302  14         jeq   hchar2                ; Yes, exit
0034 2762 C2C7  18         mov   tmp3,r11
0035 2764 10EE  14         jmp   hchar                 ; Next one
0036 2766 05C7  14 hchar2  inct  tmp3
0037 2768 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0146               
0148                       copy  "vdp_vchar.asm"            ; VDP vchar functions
**** **** ****     > vdp_vchar.asm
0001               * FILE......: vdp_vchar.a99
0002               * Purpose...: VDP vchar module
0003               
0004               ***************************************************************
0005               * Repeat characters vertically at YX
0006               ***************************************************************
0007               *  BL    @VCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 276A C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     276C 832A 
0018 276E C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 2770 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     2772 833A 
0020 2774 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2776 23DA 
0021 2778 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 277A D1B7  28         movb  *tmp3+,tmp2
0023 277C 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 277E 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     2780 2296 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 2782 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 2784 A108  18         a     tmp4,tmp0             ; Next row
0033 2786 0606  14         dec   tmp2
0034 2788 16FA  14         jne   vchar2
0035 278A 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     278C 202C 
0036 278E 1303  14         jeq   vchar3                ; Yes, exit
0037 2790 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     2792 832A 
0038 2794 10ED  14         jmp   vchar1                ; Next one
0039 2796 05C7  14 vchar3  inct  tmp3
0040 2798 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 279A C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 279C C804  38         mov   tmp0,@wyx             ; Set cursor position
     279E 832A 
0051 27A0 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 27A2 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     27A4 833A 
0053 27A6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A8 23DA 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 27AA 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     27AC 2296 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 27AE D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 27B0 A120  34         a     @wcolmn,tmp0          ; Next row
     27B2 833A 
0063 27B4 0606  14         dec   tmp2
0064 27B6 16F9  14         jne   xvcha1
0065 27B8 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0150               
0154               
0158               
0162               
0166               
0170               
0174               
0176                       copy  "keyb_real.asm"            ; Real Keyboard support
**** **** ****     > keyb_real.asm
0001               * FILE......: keyb_real.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * REALKB - Scan keyboard in real mode
0010               ***************************************************************
0011               *  BL @REALKB
0012               *--------------------------------------------------------------
0013               *  Based on work done by Simon Koppelmann
0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
0015               ********|*****|*********************|**************************
0016 27BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BC 202A 
0017 27BE 020C  20         li    r12,>0024
     27C0 0024 
0018 27C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C4 2852 
0019 27C6 04C6  14         clr   tmp2
0020 27C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CA 04CC  14         clr   r12
0025 27CC 1F08  20         tb    >0008                 ; Shift-key ?
0026 27CE 1302  14         jeq   realk1                ; No
0027 27D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D2 2882 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D6 1302  14         jeq   realk2                ; No
0033 27D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DA 28B2 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27DE 1302  14         jeq   realk3                ; No
0039 27E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E2 28E2 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E4 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27E6 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27E8 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27EA E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27EC 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27EE 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27F0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F2 0006 
0052 27F4 0606  14 realk5  dec   tmp2
0053 27F6 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F8 0024 
0054 27FA 06C6  14         swpb  tmp2
0055 27FC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27FE 06C6  14         swpb  tmp2
0057 2800 020C  20         li    r12,6                 ; CRU read address
     2802 0006 
0058 2804 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 2806 0547  14         inv   tmp3                  ;
0060 2808 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     280A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 280C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 280E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 2810 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2812 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2814 0285  22         ci    tmp1,8
     2816 0008 
0069 2818 1AFA  14         jl    realk6
0070 281A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 281C 1BEB  14         jh    realk5                ; No, next column
0072 281E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2820 C206  18 realk8  mov   tmp2,tmp4
0077 2822 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2824 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2826 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 2828 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 282A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 282C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 282E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2830 202A 
0087 2832 1608  14         jne   realka                ; No, continue saving key
0088 2834 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2836 287C 
0089 2838 1A05  14         jl    realka
0090 283A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     283C 287A 
0091 283E 1B02  14         jh    realka                ; No, continue
0092 2840 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2842 E000 
0093 2844 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2846 833C 
0094 2848 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     284A 2014 
0095 284C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     284E 8C00 
0096 2850 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2852 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2854 0000 
     2856 FF0D 
     2858 203D 
0099 285A ....             text  'xws29ol.'
0100 2862 ....             text  'ced38ik,'
0101 286A ....             text  'vrf47ujm'
0102 2872 ....             text  'btg56yhn'
0103 287A ....             text  'zqa10p;/'
0104 2882 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2884 0000 
     2886 FF0D 
     2888 202B 
0105 288A ....             text  'XWS@(OL>'
0106 2892 ....             text  'CED#*IK<'
0107 289A ....             text  'VRF$&UJM'
0108 28A2 ....             text  'BTG%^YHN'
0109 28AA ....             text  'ZQA!)P:-'
0110 28B2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B4 0000 
     28B6 FF0D 
     28B8 2005 
0111 28BA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28BC 0804 
     28BE 0F27 
     28C0 C2B9 
0112 28C2 600B             data  >600b,>0907,>063f,>c1B8
     28C4 0907 
     28C6 063F 
     28C8 C1B8 
0113 28CA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28CC 7B02 
     28CE 015F 
     28D0 C0C3 
0114 28D2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D4 7D0E 
     28D6 0CC6 
     28D8 BFC4 
0115 28DA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28DC 7C03 
     28DE BC22 
     28E0 BDBA 
0116 28E2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E4 0000 
     28E6 FF0D 
     28E8 209D 
0117 28EA 9897             data  >9897,>93b2,>9f8f,>8c9B
     28EC 93B2 
     28EE 9F8F 
     28F0 8C9B 
0118 28F2 8385             data  >8385,>84b3,>9e89,>8b80
     28F4 84B3 
     28F6 9E89 
     28F8 8B80 
0119 28FA 9692             data  >9692,>86b4,>b795,>8a8D
     28FC 86B4 
     28FE B795 
     2900 8A8D 
0120 2902 8294             data  >8294,>87b5,>b698,>888E
     2904 87B5 
     2906 B698 
     2908 888E 
0121 290A 9A91             data  >9a91,>81b1,>b090,>9cBB
     290C 81B1 
     290E B090 
     2910 9CBB 
**** **** ****     > runlib.asm
0178               
0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
0001               * FILE......: cpu_hexsupport.asm
0002               * Purpose...: CPU create, display hex numbers module
0003               
0004               ***************************************************************
0005               * mkhex - Convert hex word to string
0006               ***************************************************************
0007               *  bl   @mkhex
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = Pointer to 16 bit word
0011               *  P1 = Pointer to string buffer
0012               *  P2 = Offset for ASCII digit
0013               *       MSB determines offset for chars A-F
0014               *       LSB determines offset for chars 0-9
0015               *  (CONFIG#0 = 1) = Display number at cursor YX
0016               *--------------------------------------------------------------
0017               *  Memory usage:
0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
0019               *  waux1, waux2, waux3
0020               *--------------------------------------------------------------
0021               *  Memory variables waux1-waux3 are used as temporary variables
0022               ********|*****|*********************|**************************
0023 2912 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2914 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2916 8340 
0025 2918 04E0  34         clr   @waux1
     291A 833C 
0026 291C 04E0  34         clr   @waux2
     291E 833E 
0027 2920 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2922 833C 
0028 2924 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2926 0205  20         li    tmp1,4                ; 4 nibbles
     2928 0004 
0033 292A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 292C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     292E 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2930 0286  22         ci    tmp2,>000a
     2932 000A 
0039 2934 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2936 C21B  26         mov   *r11,tmp4
0045 2938 0988  56         srl   tmp4,8                ; Right justify
0046 293A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     293C FFF6 
0047 293E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2940 C21B  26         mov   *r11,tmp4
0054 2942 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2944 00FF 
0055               
0056 2946 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2948 06C6  14         swpb  tmp2
0058 294A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 294C 0944  56         srl   tmp0,4                ; Next nibble
0060 294E 0605  14         dec   tmp1
0061 2950 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2952 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2954 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2956 C160  34         mov   @waux3,tmp1           ; Get pointer
     2958 8340 
0067 295A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 295C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 295E C120  34         mov   @waux2,tmp0
     2960 833E 
0070 2962 06C4  14         swpb  tmp0
0071 2964 DD44  32         movb  tmp0,*tmp1+
0072 2966 06C4  14         swpb  tmp0
0073 2968 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 296A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     296C 8340 
0078 296E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2970 2020 
0079 2972 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2974 C120  34         mov   @waux1,tmp0
     2976 833C 
0084 2978 06C4  14         swpb  tmp0
0085 297A DD44  32         movb  tmp0,*tmp1+
0086 297C 06C4  14         swpb  tmp0
0087 297E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2980 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2982 202A 
0092 2984 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2986 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2988 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     298A 7FFF 
0098 298C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     298E 8340 
0099 2990 0460  28         b     @xutst0               ; Display string
     2992 2400 
0100 2994 0610     prefix  data  >0610                 ; Length byte + blank
0101               
0102               
0103               
0104               ***************************************************************
0105               * puthex - Put 16 bit word on screen
0106               ***************************************************************
0107               *  bl   @mkhex
0108               *       data P0,P1,P2,P3
0109               *--------------------------------------------------------------
0110               *  P0 = YX position
0111               *  P1 = Pointer to 16 bit word
0112               *  P2 = Pointer to string buffer
0113               *  P3 = Offset for ASCII digit
0114               *       MSB determines offset for chars A-F
0115               *       LSB determines offset for chars 0-9
0116               *--------------------------------------------------------------
0117               *  Memory usage:
0118               *  tmp0, tmp1, tmp2, tmp3
0119               *  waux1, waux2, waux3
0120               ********|*****|*********************|**************************
0121 2996 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2998 832A 
0122 299A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     299C 8000 
0123 299E 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0182               
0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
**** **** ****     > cpu_numsupport.asm
0001               * FILE......: cpu_numsupport.asm
0002               * Purpose...: CPU create, display numbers module
0003               
0004               ***************************************************************
0005               * MKNUM - Convert unsigned number to string
0006               ***************************************************************
0007               *  BL   @MKNUM
0008               *  DATA P0,P1,P2
0009               *
0010               *  P0   = Pointer to 16 bit unsigned number
0011               *  P1   = Pointer to 5 byte string buffer
0012               *  P2HB = Offset for ASCII digit
0013               *  P2LB = Character for replacing leading 0's
0014               *
0015               *  (CONFIG:0 = 1) = Display number at cursor YX
0016               *-------------------------------------------------------------
0017               *  Destroys registers tmp0-tmp4
0018               ********|*****|*********************|**************************
0019 29A0 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A2 0005 
0020 29A4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A6 C155  26         mov   *tmp1,tmp1            ; /
0022 29A8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29AA 0228  22         ai    tmp4,4                ; Get end of buffer
     29AC 0004 
0024 29AE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B0 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B4 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29BA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29BC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29BE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C0 0607  14         dec   tmp3                  ; Decrease counter
0036 29C2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C4 0207  20         li    tmp3,4                ; Check first 4 digits
     29C6 0004 
0041 29C8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29CA C11B  26         mov   *r11,tmp0
0043 29CC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29CE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D2 05CB  14 mknum3  inct  r11
0047 29D4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D6 202A 
0048 29D8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29DA 045B  20         b     *r11                  ; Exit
0050 29DC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29DE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E0 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E2 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E6 7FFF 
0058 29E8 C10B  18         mov   r11,tmp0
0059 29EA 0224  22         ai    tmp0,-4
     29EC FFFC 
0060 29EE C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F0 0206  20         li    tmp2,>0500            ; String length = 5
     29F2 0500 
0062 29F4 0460  28         b     @xutstr               ; Display string
     29F6 2402 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1
0072               *--------------------------------------------------------------
0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
0074               *  p1   = Pointer to output variable
0075               *  p2   = Padding character to match against
0076               *--------------------------------------------------------------
0077               *  Copy unsigned number string into a length-padded, left
0078               *  justified string for display with putstr, putat, ...
0079               *
0080               *  The new string starts at index 5 in buffer, overwriting
0081               *  anything that is located there !
0082               *
0083               *  Before...:   XXXXX
0084               *  After....:   XXXXX|zY       where length byte z=1
0085               *               XXXXX|zYY      where length byte z=2
0086               *                 ..
0087               *               XXXXX|zYYYYY   where length byte z=5
0088               *--------------------------------------------------------------
0089               *  Destroys registers tmp0-tmp3
0090               ********|*****|*********************|**************************
0091               trimnum:
0092 29F8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29FA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29FC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29FE 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 2A00 0207  20         li    tmp3,5                ; Set counter
     2A02 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A04 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A06 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A08 0584  14         inc   tmp0                  ; Next character
0104 2A0A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A0C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A0E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A10 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A12 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A14 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A16 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A18 0607  14         dec   tmp3                  ; Last character ?
0120 2A1A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A1C 045B  20         b     *r11                  ; Return
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * PUTNUM - Put unsigned number on screen
0128               ***************************************************************
0129               *  BL   @PUTNUM
0130               *  DATA P0,P1,P2,P3
0131               *--------------------------------------------------------------
0132               *  P0   = YX position
0133               *  P1   = Pointer to 16 bit unsigned number
0134               *  P2   = Pointer to 5 byte string buffer
0135               *  P3HB = Offset for ASCII digit
0136               *  P3LB = Character for replacing leading 0's
0137               ********|*****|*********************|**************************
0138 2A1E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A20 832A 
0139 2A22 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A24 8000 
0140 2A26 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0190               
0194               
0198               
0202               
0206               
0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cpu.scrpad.backup - Backup scratchpad memory to >2000
0010               ***************************************************************
0011               *  bl   @cpu.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  r0-r2, but values restored before exit
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to destination range
0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0018               *
0019               *  Expects current workspace to be in scratchpad memory.
0020               ********|*****|*********************|**************************
0021               cpu.scrpad.backup:
0022 2A28 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2A2A A000 
0023 2A2C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2A2E A002 
0024 2A30 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A32 A004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A34 0200  20         li    r0,>8306              ; Scratpad source address
     2A36 8306 
0029 2A38 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A3A A006 
0030 2A3C 0202  20         li    r2,62                 ; Loop counter
     2A3E 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A40 CC70  46         mov   *r0+,*r1+
0036 2A42 CC70  46         mov   *r0+,*r1+
0037 2A44 0642  14         dect  r2
0038 2A46 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A48 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A4A 83FE 
     2A4C A0FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A4E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A50 A000 
0045 2A52 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A54 A002 
0046 2A56 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A58 A004 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A5A 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               ***************************************************************
0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0056               ***************************************************************
0057               *  bl   @cpu.scrpad.restore
0058               *--------------------------------------------------------------
0059               *  Register usage
0060               *  r0-r2, but values restored before exit
0061               *--------------------------------------------------------------
0062               *  Restore scratchpad from memory area
0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0064               *  Current workspace can be outside scratchpad when called.
0065               ********|*****|*********************|**************************
0066               cpu.scrpad.restore:
0067                       ;------------------------------------------------------
0068                       ; Restore scratchpad >8300 - >8304
0069                       ;------------------------------------------------------
0070 2A5C C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A5E A000 
     2A60 8300 
0071 2A62 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A64 A002 
     2A66 8302 
0072 2A68 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A6A A004 
     2A6C 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A6E C800  38         mov   r0,@cpu.scrpad.tgt
     2A70 A000 
0077 2A72 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A74 A002 
0078 2A76 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A78 A004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A7A 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A7C A006 
0083 2A7E 0201  20         li    r1,>8306
     2A80 8306 
0084 2A82 0202  20         li    r2,62
     2A84 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A86 CC70  46         mov   *r0+,*r1+
0090 2A88 CC70  46         mov   *r0+,*r1+
0091 2A8A 0642  14         dect  r2
0092 2A8C 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A8E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A90 A0FE 
     2A92 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A94 C020  34         mov   @cpu.scrpad.tgt,r0
     2A96 A000 
0099 2A98 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A9A A002 
0100 2A9C C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2A9E A004 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2AA0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > cpu_scrpad_paging.asm
0001               * FILE......: cpu_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cpu.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.pgout
0013               *       DATA p0
0014               *
0015               *  P0 = CPU memory destination
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu.scrpad.pgout
0018               *  TMP1 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  Register usage
0021               *  tmp0-tmp2 = Used as temporary registers
0022               *  tmp3      = Copy of CPU memory destination
0023               ********|*****|*********************|**************************
0024               cpu.scrpad.pgout:
0025 2AA2 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2AA4 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2AA6 8300 
0031 2AA8 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2AAA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2AAC 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2AAE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2AB0 0606  14         dec   tmp2
0038 2AB2 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2AB4 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2AB6 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2AB8 2ABE 
0044                                                   ; R14=PC
0045 2ABA 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2ABC 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2ABE 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2AC0 2A5C 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2AC2 045B  20         b     *r11                  ; Return to caller
0062               
0063               
0064               ***************************************************************
0065               * cpu.scrpad.pgin - Page in scratchpad memory
0066               ***************************************************************
0067               *  bl   @cpu.scrpad.pgin
0068               *  DATA p0
0069               *  P0 = CPU memory source
0070               *--------------------------------------------------------------
0071               *  bl   @memx.scrpad.pgin
0072               *  TMP1 = CPU memory source
0073               *--------------------------------------------------------------
0074               *  Register usage
0075               *  tmp0-tmp2 = Used as temporary registers
0076               ********|*****|*********************|**************************
0077               cpu.scrpad.pgin:
0078 2AC4 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2AC6 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2AC8 8300 
0084 2ACA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2ACC 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2ACE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2AD0 0606  14         dec   tmp2
0090 2AD2 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AD4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AD6 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2AD8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0211               
0213                       copy  "equ_fio.asm"              ; File I/O equates
**** **** ****     > equ_fio.asm
0001               * FILE......: equ_fio.asm
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations
0006               ************************************@**************************
0007      0000     io.op.open       equ >00            ; OPEN
0008      0001     io.op.close      equ >01            ; CLOSE
0009      0002     io.op.read       equ >02            ; READ
0010      0003     io.op.write      equ >03            ; WRITE
0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
0012      0005     io.op.load       equ >05            ; LOAD
0013      0006     io.op.save       equ >06            ; SAVE
0014      0007     io.op.delfile    equ >07            ; DELETE FILE
0015      0008     io.op.scratch    equ >08            ; SCRATCH
0016      0009     io.op.status     equ >09            ; STATUS
0017               ***************************************************************
0018               * File types - All relative files are fixed length
0019               ************************************@**************************
0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0026               ***************************************************************
0027               * File types - Sequential files
0028               ************************************@**************************
0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0041               
0042               ***************************************************************
0043               * File error codes - Bits 13-15 in PAB byte 1
0044               ************************************@**************************
0045      0000     io.err.no_error_occured             equ 0
0046                       ; Error code 0 with condition bit reset, indicates that
0047                       ; no error has occured
0048               
0049      0000     io.err.bad_device_name              equ 0
0050                       ; Device indicated not in system
0051                       ; Error code 0 with condition bit set, indicates a
0052                       ; device not present in system
0053               
0054      0001     io.err.device_write_prottected      equ 1
0055                       ; Device is write protected
0056               
0057      0002     io.err.bad_open_attribute           equ 2
0058                       ; One or more of the OPEN attributes are illegal or do
0059                       ; not match the file's actual characteristics.
0060                       ; This could be:
0061                       ;   * File type
0062                       ;   * Record length
0063                       ;   * I/O mode
0064                       ;   * File organization
0065               
0066      0003     io.err.illegal_operation            equ 3
0067                       ; Either an issued I/O command was not supported, or a
0068                       ; conflict with the OPEN mode has occured
0069               
0070      0004     io.err.out_of_table_buffer_space    equ 4
0071                       ; The amount of space left on the device is insufficient
0072                       ; for the requested operation
0073               
0074      0005     io.err.eof                          equ 5
0075                       ; Attempt to read past end of file.
0076                       ; This error may also be given for non-existing records
0077                       ; in a relative record file
0078               
0079      0006     io.err.device_error                 equ 6
0080                       ; Covers all hard device errors, such as parity and
0081                       ; bad medium errors
0082               
0083      0007     io.err.file_error                   equ 7
0084                       ; Covers all file-related error like: program/data
0085                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
**** **** ****     > fio_dsrlnk.asm
0001               * FILE......: fio_dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  P0 = 8 or 10 (a)
0016               *--------------------------------------------------------------
0017               *  Output:
0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0019               *--------------------------------------------------------------
0020               ; Spectra2 scratchpad memory needs to be paged out before.
0021               ; You need to specify following equates in main program
0022               ;
0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0025               ;
0026               ; Scratchpad memory usage
0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
0028               ; >8356            Pointer to PAB
0029               ; >83D0            CRU address of current device
0030               ; >83D2            DSR entry address
0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
0032               ;
0033               ; Credits
0034               ; Originally appeared in Miller Graphics The Smart Programmer.
0035               ; This version based on version of Paolo Bagnaresi.
0036               *--------------------------------------------------------------
0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********|*****|*********************|**************************
0041 2ADA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2ADC 2ADE             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2ADE C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2AE0 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2AE2 8322 
0049 2AE4 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2AE6 2026 
0050 2AE8 C020  34         mov   @>8356,r0             ; get ptr to pab
     2AEA 8356 
0051 2AEC C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2AEE 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AF0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AF2 06C0  14         swpb  r0                    ;
0059 2AF4 D800  38         movb  r0,@vdpa              ; send low byte
     2AF6 8C02 
0060 2AF8 06C0  14         swpb  r0                    ;
0061 2AFA D800  38         movb  r0,@vdpa              ; send high byte
     2AFC 8C02 
0062 2AFE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2B00 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B02 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2B04 0704  14         seto  r4                    ; init counter
0070 2B06 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2B08 A420 
0071 2B0A 0580  14 !       inc   r0                    ; point to next char of name
0072 2B0C 0584  14         inc   r4                    ; incr char counter
0073 2B0E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2B10 0007 
0074 2B12 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2B14 80C4  18         c     r4,r3                 ; end of name?
0077 2B16 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2B18 06C0  14         swpb  r0                    ;
0082 2B1A D800  38         movb  r0,@vdpa              ; send low byte
     2B1C 8C02 
0083 2B1E 06C0  14         swpb  r0                    ;
0084 2B20 D800  38         movb  r0,@vdpa              ; send high byte
     2B22 8C02 
0085 2B24 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B26 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2B28 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2B2A 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2B2C 2BEE 
0093 2B2E 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B30 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B32 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B34 04E0  34         clr   @>83d0
     2B36 83D0 
0102 2B38 C804  38         mov   r4,@>8354             ; save name length for search
     2B3A 8354 
0103 2B3C 0584  14         inc   r4                    ; adjust for dot
0104 2B3E A804  38         a     r4,@>8356             ; point to position after name
     2B40 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B42 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B44 83E0 
0110 2B46 04C1  14         clr   r1                    ; version found of dsr
0111 2B48 020C  20         li    r12,>0f00             ; init cru addr
     2B4A 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B4C C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B4E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B50 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B52 022C  22         ai    r12,>0100             ; next rom to turn on
     2B54 0100 
0125 2B56 04E0  34         clr   @>83d0                ; clear in case we are done
     2B58 83D0 
0126 2B5A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B5C 2000 
0127 2B5E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B60 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B62 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B64 1D00  20         sbo   0                     ; turn on rom
0134 2B66 0202  20         li    r2,>4000              ; start at beginning of rom
     2B68 4000 
0135 2B6A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B6C 2BEA 
0136 2B6E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B70 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B72 A40A 
0146 2B74 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B76 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B78 83D2 
0152                                                   ; subprogram
0153               
0154 2B7A 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B7C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B7E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B80 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B82 83D2 
0163                                                   ; subprogram
0164               
0165 2B84 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B86 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B88 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B8A D160  34         movb  @>8355,r5             ; get length as counter
     2B8C 8355 
0175 2B8E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B90 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B92 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B94 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B96 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B98 A420 
0186 2B9A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B9C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2B9E 0605  14         dec   r5                    ; loop until full length checked
0191 2BA0 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2BA2 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2BA4 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2BA6 0581  14         inc   r1                    ; next version found
0203 2BA8 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2BAA 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2BAC 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2BAE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BB0 A400 
0212 2BB2 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2BB4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BB6 8322 
0214                                                   ; (8 or >a)
0215 2BB8 0281  22         ci    r1,8                  ; was it 8?
     2BBA 0008 
0216 2BBC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2BBE D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BC0 8350 
0218                                                   ; Get error byte from @>8350
0219 2BC2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2BC4 06C0  14         swpb  r0                    ;
0227 2BC6 D800  38         movb  r0,@vdpa              ; send low byte
     2BC8 8C02 
0228 2BCA 06C0  14         swpb  r0                    ;
0229 2BCC D800  38         movb  r0,@vdpa              ; send high byte
     2BCE 8C02 
0230 2BD0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BD2 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BD4 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BD6 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BD8 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BDA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BDC A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BDE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2BE0 06C1  14         swpb  r1                    ; put error in hi byte
0252 2BE2 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2BE4 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2BE6 2026 
0254 2BE8 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2BEA AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2BEC 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2BEE ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
**** **** ****     > runlib.asm
0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0011               ;                                   ;         Bit 13-15 used by DSR for returning
0012               ;                                   ;         file error details to DSRLNK
0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
0015               ;       byte  0                     ;  5    - Character count (bytes read)
0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
0018               ; -------------------------------------------------------------
0019               ;       byte  11                    ;  9    - File descriptor length
0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
0021               ;       even
0022               ***************************************************************
0023               
0024               
0025               ***************************************************************
0026               * file.open - Open File for procesing
0027               ***************************************************************
0028               *  bl   @file.open
0029               *  data P0
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *--------------------------------------------------------------
0033               *  bl   @xfile.open
0034               *
0035               *  R0 = Address of PAB in VDP RAM
0036               *--------------------------------------------------------------
0037               *  Output:
0038               *  tmp0 LSB = VDP PAB byte 1 (status)
0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0040               *  tmp2     = Status register contents upon DSRLNK return
0041               ********|*****|*********************|**************************
0042               file.open:
0043 2BF0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BF2 C04B  18         mov   r11,r1                ; Save return address
0049 2BF4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BF6 A428 
0050 2BF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BFA 04C5  14         clr   tmp1                  ; io.op.open
0052 2BFC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BFE 22AC 
0053               file.open_init:
0054 2C00 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C02 0009 
0055 2C04 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C06 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2C08 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C0A 2ADA 
0061 2C0C 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2C0E 1029  14         jmp   file.record.pab.details
0067                                                   ; Get status and return to caller
0068                                                   ; Status register bits are unaffected
0069               
0070               
0071               
0072               ***************************************************************
0073               * file.close - Close currently open file
0074               ***************************************************************
0075               *  bl   @file.close
0076               *  data P0
0077               *--------------------------------------------------------------
0078               *  P0 = Address of PAB in VDP RAM
0079               *--------------------------------------------------------------
0080               *  bl   @xfile.close
0081               *
0082               *  R0 = Address of PAB in VDP RAM
0083               *--------------------------------------------------------------
0084               *  Output:
0085               *  tmp0 LSB = VDP PAB byte 1 (status)
0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0087               *  tmp2     = Status register contents upon DSRLNK return
0088               ********|*****|*********************|**************************
0089               file.close:
0090 2C10 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2C12 C04B  18         mov   r11,r1                ; Save return address
0096 2C14 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C16 A428 
0097 2C18 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2C1A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C1C 0001 
0099 2C1E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C20 22AC 
0100               file.close_init:
0101 2C22 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C24 0009 
0102 2C26 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C28 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2C2A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C2C 2ADA 
0108 2C2E 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C30 1018  14         jmp   file.record.pab.details
0114                                                   ; Get status and return to caller
0115                                                   ; Status register bits are unaffected
0116               
0117               
0118               
0119               
0120               
0121               ***************************************************************
0122               * file.record.read - Read record from file
0123               ***************************************************************
0124               *  bl   @file.record.read
0125               *  data P0
0126               *--------------------------------------------------------------
0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0128               *--------------------------------------------------------------
0129               *  bl   @xfile.record.read
0130               *
0131               *  R0 = Address of PAB in VDP RAM
0132               *--------------------------------------------------------------
0133               *  Output:
0134               *  tmp0 LSB = VDP PAB byte 1 (status)
0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0136               *  tmp2     = Status register contents upon DSRLNK return
0137               ********|*****|*********************|**************************
0138               file.record.read:
0139 2C32 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C34 C04B  18         mov   r11,r1                ; Save return address
0145 2C36 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C38 A428 
0146 2C3A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C3C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C3E 0002 
0148 2C40 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C42 22AC 
0149               file.record.read_init:
0150 2C44 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C46 0009 
0151 2C48 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C4A 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C4C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C4E 2ADA 
0157 2C50 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C52 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C54 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C56 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C58 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C5A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C5C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C5E 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C60 1000  14         nop
0195               
0196               
0197               
0198               ***************************************************************
0199               * file.record.pab.details - Return PAB details to caller
0200               ***************************************************************
0201               * Called internally via JMP/B by file operations
0202               *--------------------------------------------------------------
0203               *  Output:
0204               *  tmp0 LSB = VDP PAB byte 1 (status)
0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0206               *  tmp2     = Status register contents upon DSRLNK return
0207               ********|*****|*********************|**************************
0208               
0209               ********|*****|*********************|**************************
0210               file.record.pab.details:
0211 2C62 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C64 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C66 A428 
0219 2C68 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C6A 0005 
0220 2C6C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C6E 22C4 
0221 2C70 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C72 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0226                                                   ; as returned by DSRLNK
0227               *--------------------------------------------------------------
0228               * Exit
0229               *--------------------------------------------------------------
0230               ; If an error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=tmp2) is set to 1.
0232               ;
0233               ; If no error occured during the IO operation, then the
0234               ; equal bit in the saved status register (=tmp2) is set to 0.
0235               ;
0236               ; Upon return from this IO call you should basically test with:
0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0239               ;
0240               ; Then look for further details in the copy of VDP PAB byte 1
0241               ; in register tmp0, bits 13-15
0242               ;
0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0244               ;                                   ; calls, skip for type >A subprograms!)
0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0246               ;       jeq   my_error_handler
0247               *--------------------------------------------------------------
0248               file.record.pab.details.exit:
0249 2C74 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                            TIMERS
0220               *//////////////////////////////////////////////////////////////
0221               
0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
**** **** ****     > timers_tmgr.asm
0001               * FILE......: timers_tmgr.asm
0002               * Purpose...: Timers / Thread scheduler
0003               
0004               ***************************************************************
0005               * TMGR - X - Start Timers/Thread scheduler
0006               ***************************************************************
0007               *  B @TMGR
0008               *--------------------------------------------------------------
0009               *  REMARKS
0010               *  Timer/Thread scheduler. Normally called from MAIN.
0011               *  This is basically the kernel keeping everything togehter.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2C76 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C78 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C7A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C7C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C7E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C80 2026 
0029 2C82 1602  14         jne   tmgr1a                ; No, so move on
0030 2C84 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C86 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C88 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C8A 202A 
0035 2C8C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C8E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C90 201A 
0048 2C92 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C94 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C96 2018 
0050 2C98 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C9A 0460  28         b     @kthread              ; Run kernel thread
     2C9C 2D14 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2C9E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2CA0 201E 
0056 2CA2 13EB  14         jeq   tmgr1
0057 2CA4 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CA6 201C 
0058 2CA8 16E8  14         jne   tmgr1
0059 2CAA C120  34         mov   @wtiusr,tmp0
     2CAC 832E 
0060 2CAE 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CB0 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CB2 2D12 
0065 2CB4 C10A  18         mov   r10,tmp0
0066 2CB6 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CB8 00FF 
0067 2CBA 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CBC 2026 
0068 2CBE 1303  14         jeq   tmgr5
0069 2CC0 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CC2 003C 
0070 2CC4 1002  14         jmp   tmgr6
0071 2CC6 0284  22 tmgr5   ci    tmp0,50
     2CC8 0032 
0072 2CCA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CCC 1001  14         jmp   tmgr8
0074 2CCE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CD0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CD2 832C 
0079 2CD4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CD6 FF00 
0080 2CD8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CDA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CDC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CDE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CE0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CE2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CE4 830C 
     2CE6 830D 
0089 2CE8 1608  14         jne   tmgr10                ; No, get next slot
0090 2CEA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CEC FF00 
0091 2CEE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CF0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CF2 8330 
0096 2CF4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CF6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CF8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CFA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CFC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2CFE 8315 
     2D00 8314 
0103 2D02 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D04 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D06 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D08 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D0A 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D0C 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D0E FF00 
0109 2D10 10B4  14         jmp   tmgr1
0110 2D12 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
**** **** ****     > timers_kthread.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / The kernel thread
0003               
0004               
0005               ***************************************************************
0006               * KTHREAD - The kernel thread
0007               *--------------------------------------------------------------
0008               *  REMARKS
0009               *  You should not call the kernel thread manually.
0010               *  Instead control it via the CONFIG register.
0011               *
0012               *  The kernel thread is responsible for running the sound
0013               *  player and doing keyboard scan.
0014               ********|*****|*********************|**************************
0015 2D14 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D16 201A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2D18 06A0  32         bl    @realkb               ; Scan full keyboard
     2D1A 27BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D1C 0460  28         b     @tmgr3                ; Exit
     2D1E 2C9E 
**** **** ****     > runlib.asm
0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
**** **** ****     > timers_hooks.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / User hooks
0003               
0004               
0005               ***************************************************************
0006               * MKHOOK - Allocate user hook
0007               ***************************************************************
0008               *  BL    @MKHOOK
0009               *  DATA  P0
0010               *--------------------------------------------------------------
0011               *  P0 = Address of user hook
0012               *--------------------------------------------------------------
0013               *  REMARKS
0014               *  The user hook gets executed after the kernel thread.
0015               *  The user hook must always exit with "B @HOOKOK"
0016               ********|*****|*********************|**************************
0017 2D20 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D22 832E 
0018 2D24 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D26 201C 
0019 2D28 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C7A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D2A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D2C 832E 
0029 2D2E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D30 FEFF 
0030 2D32 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0225               
0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
**** **** ****     > timers_alloc.asm
0001               * FILE......: timer_alloc.asm
0002               * Purpose...: Timers / Timer allocation
0003               
0004               
0005               ***************************************************************
0006               * MKSLOT - Allocate timer slot(s)
0007               ***************************************************************
0008               *  BL    @MKSLOT
0009               *  BYTE  P0HB,P0LB
0010               *  DATA  P1
0011               *  ....
0012               *  DATA  EOL                        ; End-of-list
0013               *--------------------------------------------------------------
0014               *  P0 = Slot number, target count
0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
0016               ********|*****|*********************|**************************
0017 2D34 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D36 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D38 C184  18         mov   tmp0,tmp2
0023 2D3A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D3C A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D3E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D40 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D42 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D44 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D46 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D48 202C 
0035 2D4A 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D4C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D4E 05CB  14 mkslo1  inct  r11
0041 2D50 045B  20         b     *r11                  ; Exit
0042               
0043               
0044               ***************************************************************
0045               * CLSLOT - Clear single timer slot
0046               ***************************************************************
0047               *  BL    @CLSLOT
0048               *  DATA  P0
0049               *--------------------------------------------------------------
0050               *  P0 = Slot number
0051               ********|*****|*********************|**************************
0052 2D52 C13B  30 clslot  mov   *r11+,tmp0
0053 2D54 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D56 A120  34         a     @wtitab,tmp0          ; Add table base
     2D58 832C 
0055 2D5A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D5C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D5E 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0229               
0230               
0231               
0232               *//////////////////////////////////////////////////////////////
0233               *                    RUNLIB INITIALISATION
0234               *//////////////////////////////////////////////////////////////
0235               
0236               ***************************************************************
0237               *  RUNLIB - Runtime library initalisation
0238               ***************************************************************
0239               *  B  @RUNLIB
0240               *--------------------------------------------------------------
0241               *  REMARKS
0242               *  if R0 in WS1 equals >4a4a we were called from the system
0243               *  crash handler so we return there after initialisation.
0244               
0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0246               *  after clearing scratchpad memory. This has higher priority
0247               *  as crash handler flag R0.
0248               ********|*****|*********************|**************************
0250 2D60 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D62 2A28 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D64 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D66 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D68 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D6A 0000 
0261 2D6C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D6E 8300 
0262 2D70 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D72 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D74 0202  20 runli2  li    r2,>8308
     2D76 8308 
0267 2D78 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D7A 0282  22         ci    r2,>8400
     2D7C 8400 
0269 2D7E 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D80 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D82 FFFF 
0274 2D84 1602  14         jne   runli4                ; No, continue
0275 2D86 0420  54         blwp  @0                    ; Yes, bye bye
     2D88 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D8A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D8C 833C 
0280 2D8E 04C1  14         clr   r1                    ; Reset counter
0281 2D90 0202  20         li    r2,10                 ; We test 10 times
     2D92 000A 
0282 2D94 C0E0  34 runli5  mov   @vdps,r3
     2D96 8802 
0283 2D98 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D9A 202A 
0284 2D9C 1302  14         jeq   runli6
0285 2D9E 0581  14         inc   r1                    ; Increase counter
0286 2DA0 10F9  14         jmp   runli5
0287 2DA2 0602  14 runli6  dec   r2                    ; Next test
0288 2DA4 16F7  14         jne   runli5
0289 2DA6 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DA8 1250 
0290 2DAA 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2DAC 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DAE 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2DB0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2DB2 2200 
0296 2DB4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2DB6 8322 
0297 2DB8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2DBA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2DBC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2DBE 04C1  14 runli9  clr   r1
0304 2DC0 04C2  14         clr   r2
0305 2DC2 04C3  14         clr   r3
0306 2DC4 0209  20         li    stack,>8400           ; Set stack
     2DC6 8400 
0307 2DC8 020F  20         li    r15,vdpw              ; Set VDP write address
     2DCA 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2DCC 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DCE 4A4A 
0316 2DD0 1605  14         jne   runlia
0317 2DD2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DD4 226E 
0318 2DD6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DD8 0000 
     2DDA 3FFF 
0323 2DDC 06A0  32 runlia  bl    @filv
     2DDE 226E 
0324 2DE0 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DE2 00F4 
     2DE4 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2DE6 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DE8 26B2 
0332 2DEA 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DEC 26CC 
0333 2DEE 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DF0 26C2 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0339               *       <<skipped>>
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 2DF2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DF4 22D8 
0347 2DF6 21F6             data  spvmod                ; Equate selected video mode table
0348 2DF8 0204  20         li    tmp0,spfont           ; Get font option
     2DFA 000C 
0349 2DFC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 2DFE 1304  14         jeq   runlid                ; Yes, skip it
0351 2E00 06A0  32         bl    @ldfnt
     2E02 2340 
0352 2E04 1100             data  fntadr,spfont         ; Load specified font
     2E06 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 2E08 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E0A 4A4A 
0357 2E0C 1602  14         jne   runlie                ; No, continue
0358 2E0E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E10 2090 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 2E12 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E14 0040 
0363 2E16 0460  28         b     @main                 ; Give control to main program
     2E18 6050 
**** **** ****     > tivi_b1.asm.10901
0022                                                   ; Relocated spectra2 in low memory expansion
0023                                                   ; was loaded into RAM from bank 0.
0024                                                   ;
0025                                                   ; Only including it here, so that all
0026                                                   ; references get satisfied during assembly.
0027               ***************************************************************
0028               * TiVi entry point after spectra2 initialisation
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code2
0031               main:
0032 6050 04E0  34         clr   @>6002                ; Jump to bank 1
     6052 6002 
0033 6054 0460  28         b     @main.tivi            ; Start editor
     6056 6058 
0034                       ;-----------------------------------------------------------------------
0035                       ; Include files
0036                       ;-----------------------------------------------------------------------
0037                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: TiVi Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            TiVi Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * main
0011               * Initialize editor
0012               ***************************************************************
0013               * b   @main.tivi
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * -
0023               *--------------------------------------------------------------
0024               * Notes
0025               * Main entry point for TiVi editor
0026               ***************************************************************
0027               
0028               
0029               ***************************************************************
0030               * Main
0031               ********|*****|*********************|**************************
0032               main.tivi:
0033 6058 20A0  38         coc   @wbit1,config         ; F18a detected?
     605A 2028 
0034 605C 1302  14         jeq   main.continue
0035 605E 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6060 0000 
0036               
0037               main.continue:
0038 6062 06A0  32         bl    @scroff               ; Turn screen off
     6064 260E 
0039 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26B2 
0040 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 2312 
0041 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0042                       ;------------------------------------------------------
0043                       ; Initialize VDP SIT
0044                       ;------------------------------------------------------
0045 6070 06A0  32         bl    @filv
     6072 226E 
0046 6074 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6076 0020 
     6078 09B0 
0047 607A 06A0  32         bl    @scron                ; Turn screen on
     607C 2616 
0048                       ;------------------------------------------------------
0049                       ; Initialize low + high memory expansion
0050                       ;------------------------------------------------------
0051 607E 06A0  32         bl    @film
     6080 2216 
0052 6082 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6084 0000 
     6086 6000 
0053                       ;------------------------------------------------------
0054                       ; Load SAMS default memory layout
0055                       ;------------------------------------------------------
0056 6088 06A0  32         bl    @mem.setup.sams.layout
     608A 66CA 
0057                                                   ; Initialize SAMS layout
0058                       ;------------------------------------------------------
0059                       ; Setup cursor, screen, etc.
0060                       ;------------------------------------------------------
0061 608C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608E 262E 
0062 6090 06A0  32         bl    @s8x8                 ; Small sprite
     6092 263E 
0063               
0064 6094 06A0  32         bl    @cpym2m
     6096 2460 
0065 6098 721A                   data romsat,ramsat,4  ; Load sprite SAT
     609A 8380 
     609C 0004 
0066               
0067 609E C820  54         mov   @romsat+2,@tv.curshape
     60A0 721C 
     60A2 A214 
0068                                                   ; Save cursor shape & color
0069               
0070 60A4 06A0  32         bl    @cpym2v
     60A6 2418 
0071 60A8 1800                   data sprpdt,cursors,3*8
     60AA 721E 
     60AC 0018 
0072                                                   ; Load sprite cursor patterns
0073               
0074 60AE 06A0  32         bl    @cpym2v
     60B0 2418 
0075 60B2 1008                   data >1008,patterns,11*8
     60B4 7236 
     60B6 0058 
0076                                                   ; Load character patterns
0077               *--------------------------------------------------------------
0078               * Initialize
0079               *--------------------------------------------------------------
0080 60B8 06A0  32         bl    @tivi.init            ; Initialize TiVi editor config
     60BA 66BE 
0081 60BC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60BE 6B50 
0082 60C0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60C2 696A 
0083 60C4 06A0  32         bl    @idx.init             ; Initialize index
     60C6 6892 
0084 60C8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60CA 6760 
0085                       ;-------------------------------------------------------
0086                       ; Setup editor tasks & hook
0087                       ;-------------------------------------------------------
0088 60CC 0204  20         li    tmp0,>0200
     60CE 0200 
0089 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60D2 8314 
0090               
0091 60D4 06A0  32         bl    @at
     60D6 264E 
0092 60D8 0100                   data  >0100           ; Cursor YX position = >0000
0093               
0094 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0095 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0096               
0097 60E2 06A0  32         bl    @mkslot
     60E4 2D34 
0098 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 6FAC 
0099 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 7096 
0100 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 70CA 
0101 60F2 FFFF                   data eol
0102               
0103 60F4 06A0  32         bl    @mkhook
     60F6 2D20 
0104 60F8 6F7C                   data hook.keyscan     ; Setup user hook
0105               
0106 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2C76 
0107               
0108               
**** **** ****     > tivi_b1.asm.10901
0038                       copy  "edkey.asm"           ; Actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Process keyboard key press
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 60FE C160  34         mov   @waux1,tmp1           ; Get key value
     6100 833C 
0010 6102 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6104 FF00 
0011 6106 0707  14         seto  tmp3                  ; EOL marker
0012               
0013 6108 C1A0  34         mov   @tv.pane.focus,tmp2
     610A A216 
0014 610C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     610E 0000 
0015 6110 1307  14         jeq   edkey.key.process.loadmap.editor
0016                                                   ; Yes, so load editor keymap
0017               
0018 6112 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6114 0001 
0019 6116 1307  14         jeq   edkey.key.process.loadmap.cmdb
0020                                                   ; Yes, so load CMDB keymap
0021                       ;-------------------------------------------------------
0022                       ; Pane without focus, crash
0023                       ;-------------------------------------------------------
0024 6118 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     611A FFCE 
0025 611C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     611E 2030 
0026                       ;-------------------------------------------------------
0027                       ; Use editor keyboard map
0028                       ;-------------------------------------------------------
0029               edkey.key.process.loadmap.editor:
0030 6120 0206  20         li    tmp2,keymap_actions.editor
     6122 76BA 
0031 6124 1003  14         jmp   edkey.key.check_next
0032                       ;-------------------------------------------------------
0033                       ; Use CMDB keyboard map
0034                       ;-------------------------------------------------------
0035               edkey.key.process.loadmap.cmdb:
0036 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 777C 
0037 612A 1600  14         jne   edkey.key.check_next
0038                       ;-------------------------------------------------------
0039                       ; Iterate over keyboard map for matching action key
0040                       ;-------------------------------------------------------
0041               edkey.key.check_next:
0042 612C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0043 612E 1309  14         jeq   edkey.key.process.addbuffer
0044                                                   ; Yes, means no action key pressed, so
0045                                                   ; add character to buffer
0046                       ;-------------------------------------------------------
0047                       ; Check for action key match
0048                       ;-------------------------------------------------------
0049 6130 8585  30         c     tmp1,*tmp2            ; Action key matched?
0050 6132 1303  14         jeq   edkey.key.process.action
0051                                                   ; Yes, do action
0052 6134 0226  22         ai    tmp2,6                ; Skip current entry
     6136 0006 
0053 6138 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0054                       ;-------------------------------------------------------
0055                       ; Trigger keyboard action
0056                       ;-------------------------------------------------------
0057               edkey.key.process.action:
0058 613A 0226  22         ai    tmp2,4                ; Move to action address
     613C 0004 
0059 613E C196  26         mov   *tmp2,tmp2            ; Get action address
0060 6140 0456  20         b     *tmp2                 ; Process key action
0061                       ;-------------------------------------------------------
0062                       ; Add character to buffer
0063                       ;-------------------------------------------------------
0064               edkey.key.process.addbuffer:
0065 6142 0460  28         b    @edkey.action.char     ; Add character to buffer
     6144 65CE 
**** **** ****     > tivi_b1.asm.10901
0039                       copy  "edkey.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.mov.asm
0001               
0002               
0003               * FILE......: edkey.mov.asm
0004               * Purpose...: Actions for movement keys
0005               
0006               
0007               *---------------------------------------------------------------
0008               * Cursor left
0009               *---------------------------------------------------------------
0010               edkey.action.left:
0011 6146 C120  34         mov   @fb.column,tmp0
     6148 A28C 
0012 614A 1306  14         jeq   !                     ; column=0 ? Skip further processing
0013                       ;-------------------------------------------------------
0014                       ; Update
0015                       ;-------------------------------------------------------
0016 614C 0620  34         dec   @fb.column            ; Column-- in screen buffer
     614E A28C 
0017 6150 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6152 832A 
0018 6154 0620  34         dec   @fb.current
     6156 A282 
0019                       ;-------------------------------------------------------
0020                       ; Exit
0021                       ;-------------------------------------------------------
0022 6158 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     615A 6FA0 
0023               
0024               
0025               *---------------------------------------------------------------
0026               * Cursor right
0027               *---------------------------------------------------------------
0028               edkey.action.right:
0029 615C 8820  54         c     @fb.column,@fb.row.length
     615E A28C 
     6160 A288 
0030 6162 1406  14         jhe   !                     ; column > length line ? Skip processing
0031                       ;-------------------------------------------------------
0032                       ; Update
0033                       ;-------------------------------------------------------
0034 6164 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6166 A28C 
0035 6168 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     616A 832A 
0036 616C 05A0  34         inc   @fb.current
     616E A282 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040 6170 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6172 6FA0 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Cursor up
0045               *---------------------------------------------------------------
0046               edkey.action.up:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current line if dirty
0049                       ;-------------------------------------------------------
0050 6174 8820  54         c     @fb.row.dirty,@w$ffff
     6176 A28A 
     6178 202C 
0051 617A 1604  14         jne   edkey.action.up.cursor
0052 617C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     617E 699A 
0053 6180 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6182 A28A 
0054                       ;-------------------------------------------------------
0055                       ; Move cursor
0056                       ;-------------------------------------------------------
0057               edkey.action.up.cursor:
0058 6184 C120  34         mov   @fb.row,tmp0
     6186 A286 
0059 6188 1509  14         jgt   edkey.action.up.cursor_up
0060                                                   ; Move cursor up if fb.row > 0
0061 618A C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     618C A284 
0062 618E 130A  14         jeq   edkey.action.up.set_cursorx
0063                                                   ; At top, only position cursor X
0064                       ;-------------------------------------------------------
0065                       ; Scroll 1 line
0066                       ;-------------------------------------------------------
0067 6190 0604  14         dec   tmp0                  ; fb.topline--
0068 6192 C804  38         mov   tmp0,@parm1
     6194 8350 
0069 6196 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6198 67D2 
0070 619A 1004  14         jmp   edkey.action.up.set_cursorx
0071                       ;-------------------------------------------------------
0072                       ; Move cursor up
0073                       ;-------------------------------------------------------
0074               edkey.action.up.cursor_up:
0075 619C 0620  34         dec   @fb.row               ; Row-- in screen buffer
     619E A286 
0076 61A0 06A0  32         bl    @up                   ; Row-- VDP cursor
     61A2 265C 
0077                       ;-------------------------------------------------------
0078                       ; Check line length and position cursor
0079                       ;-------------------------------------------------------
0080               edkey.action.up.set_cursorx:
0081 61A4 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61A6 6B32 
0082 61A8 8820  54         c     @fb.column,@fb.row.length
     61AA A28C 
     61AC A288 
0083 61AE 1207  14         jle   edkey.action.up.exit
0084                       ;-------------------------------------------------------
0085                       ; Adjust cursor column position
0086                       ;-------------------------------------------------------
0087 61B0 C820  54         mov   @fb.row.length,@fb.column
     61B2 A288 
     61B4 A28C 
0088 61B6 C120  34         mov   @fb.column,tmp0
     61B8 A28C 
0089 61BA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61BC 2666 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.up.exit:
0094 61BE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61C0 67B6 
0095 61C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C4 6FA0 
0096               
0097               
0098               
0099               *---------------------------------------------------------------
0100               * Cursor down
0101               *---------------------------------------------------------------
0102               edkey.action.down:
0103 61C6 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     61C8 A286 
     61CA A304 
0104 61CC 1330  14         jeq   !                     ; Yes, skip further processing
0105                       ;-------------------------------------------------------
0106                       ; Crunch current row if dirty
0107                       ;-------------------------------------------------------
0108 61CE 8820  54         c     @fb.row.dirty,@w$ffff
     61D0 A28A 
     61D2 202C 
0109 61D4 1604  14         jne   edkey.action.down.move
0110 61D6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61D8 699A 
0111 61DA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61DC A28A 
0112                       ;-------------------------------------------------------
0113                       ; Move cursor
0114                       ;-------------------------------------------------------
0115               edkey.action.down.move:
0116                       ;-------------------------------------------------------
0117                       ; EOF reached?
0118                       ;-------------------------------------------------------
0119 61DE C120  34         mov   @fb.topline,tmp0
     61E0 A284 
0120 61E2 A120  34         a     @fb.row,tmp0
     61E4 A286 
0121 61E6 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     61E8 A304 
0122 61EA 1312  14         jeq   edkey.action.down.set_cursorx
0123                                                   ; Yes, only position cursor X
0124                       ;-------------------------------------------------------
0125                       ; Check if scrolling required
0126                       ;-------------------------------------------------------
0127 61EC C120  34         mov   @fb.scrrows,tmp0
     61EE A298 
0128 61F0 0604  14         dec   tmp0
0129 61F2 8120  34         c     @fb.row,tmp0
     61F4 A286 
0130 61F6 1108  14         jlt   edkey.action.down.cursor
0131                       ;-------------------------------------------------------
0132                       ; Scroll 1 line
0133                       ;-------------------------------------------------------
0134 61F8 C820  54         mov   @fb.topline,@parm1
     61FA A284 
     61FC 8350 
0135 61FE 05A0  34         inc   @parm1
     6200 8350 
0136 6202 06A0  32         bl    @fb.refresh
     6204 67D2 
0137 6206 1004  14         jmp   edkey.action.down.set_cursorx
0138                       ;-------------------------------------------------------
0139                       ; Move cursor down a row, there are still rows left
0140                       ;-------------------------------------------------------
0141               edkey.action.down.cursor:
0142 6208 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     620A A286 
0143 620C 06A0  32         bl    @down                 ; Row++ VDP cursor
     620E 2654 
0144                       ;-------------------------------------------------------
0145                       ; Check line length and position cursor
0146                       ;-------------------------------------------------------
0147               edkey.action.down.set_cursorx:
0148 6210 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6212 6B32 
0149               
0150 6214 8820  54         c     @fb.column,@fb.row.length
     6216 A28C 
     6218 A288 
0151 621A 1207  14         jle   edkey.action.down.exit
0152                                                   ; Exit
0153                       ;-------------------------------------------------------
0154                       ; Adjust cursor column position
0155                       ;-------------------------------------------------------
0156 621C C820  54         mov   @fb.row.length,@fb.column
     621E A288 
     6220 A28C 
0157 6222 C120  34         mov   @fb.column,tmp0
     6224 A28C 
0158 6226 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6228 2666 
0159                       ;-------------------------------------------------------
0160                       ; Exit
0161                       ;-------------------------------------------------------
0162               edkey.action.down.exit:
0163 622A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     622C 67B6 
0164 622E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6230 6FA0 
0165               
0166               
0167               
0168               *---------------------------------------------------------------
0169               * Cursor beginning of line
0170               *---------------------------------------------------------------
0171               edkey.action.home:
0172 6232 C120  34         mov   @wyx,tmp0
     6234 832A 
0173 6236 0244  22         andi  tmp0,>ff00
     6238 FF00 
0174 623A C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     623C 832A 
0175 623E 04E0  34         clr   @fb.column
     6240 A28C 
0176 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6244 67B6 
0177 6246 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6248 6FA0 
0178               
0179               *---------------------------------------------------------------
0180               * Cursor end of line
0181               *---------------------------------------------------------------
0182               edkey.action.end:
0183 624A C120  34         mov   @fb.row.length,tmp0
     624C A288 
0184 624E C804  38         mov   tmp0,@fb.column
     6250 A28C 
0185 6252 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6254 2666 
0186 6256 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6258 67B6 
0187 625A 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     625C 6FA0 
0188               
0189               
0190               
0191               *---------------------------------------------------------------
0192               * Cursor beginning of word or previous word
0193               *---------------------------------------------------------------
0194               edkey.action.pword:
0195 625E C120  34         mov   @fb.column,tmp0
     6260 A28C 
0196 6262 1324  14         jeq   !                     ; column=0 ? Skip further processing
0197                       ;-------------------------------------------------------
0198                       ; Prepare 2 char buffer
0199                       ;-------------------------------------------------------
0200 6264 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6266 A282 
0201 6268 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0202 626A 1003  14         jmp   edkey.action.pword_scan_char
0203                       ;-------------------------------------------------------
0204                       ; Scan backwards to first character following space
0205                       ;-------------------------------------------------------
0206               edkey.action.pword_scan
0207 626C 0605  14         dec   tmp1
0208 626E 0604  14         dec   tmp0                  ; Column-- in screen buffer
0209 6270 1315  14         jeq   edkey.action.pword_done
0210                                                   ; Column=0 ? Skip further processing
0211                       ;-------------------------------------------------------
0212                       ; Check character
0213                       ;-------------------------------------------------------
0214               edkey.action.pword_scan_char
0215 6272 D195  26         movb  *tmp1,tmp2            ; Get character
0216 6274 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0217 6276 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0218 6278 0986  56         srl   tmp2,8                ; Right justify
0219 627A 0286  22         ci    tmp2,32               ; Space character found?
     627C 0020 
0220 627E 16F6  14         jne   edkey.action.pword_scan
0221                                                   ; No space found, try again
0222                       ;-------------------------------------------------------
0223                       ; Space found, now look closer
0224                       ;-------------------------------------------------------
0225 6280 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6282 2020 
0226 6284 13F3  14         jeq   edkey.action.pword_scan
0227                                                   ; Yes, so continue scanning
0228 6286 0287  22         ci    tmp3,>20ff            ; First character is space
     6288 20FF 
0229 628A 13F0  14         jeq   edkey.action.pword_scan
0230                       ;-------------------------------------------------------
0231                       ; Check distance travelled
0232                       ;-------------------------------------------------------
0233 628C C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     628E A28C 
0234 6290 61C4  18         s     tmp0,tmp3
0235 6292 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6294 0002 
0236 6296 11EA  14         jlt   edkey.action.pword_scan
0237                                                   ; Didn't move enough so keep on scanning
0238                       ;--------------------------------------------------------
0239                       ; Set cursor following space
0240                       ;--------------------------------------------------------
0241 6298 0585  14         inc   tmp1
0242 629A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0243                       ;-------------------------------------------------------
0244                       ; Save position and position hardware cursor
0245                       ;-------------------------------------------------------
0246               edkey.action.pword_done:
0247 629C C805  38         mov   tmp1,@fb.current
     629E A282 
0248 62A0 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62A2 A28C 
0249 62A4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62A6 2666 
0250                       ;-------------------------------------------------------
0251                       ; Exit
0252                       ;-------------------------------------------------------
0253               edkey.action.pword.exit:
0254 62A8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62AA 67B6 
0255 62AC 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62AE 6FA0 
0256               
0257               
0258               
0259               *---------------------------------------------------------------
0260               * Cursor next word
0261               *---------------------------------------------------------------
0262               edkey.action.nword:
0263 62B0 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0264 62B2 C120  34         mov   @fb.column,tmp0
     62B4 A28C 
0265 62B6 8804  38         c     tmp0,@fb.row.length
     62B8 A288 
0266 62BA 1428  14         jhe   !                     ; column=last char ? Skip further processing
0267                       ;-------------------------------------------------------
0268                       ; Prepare 2 char buffer
0269                       ;-------------------------------------------------------
0270 62BC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62BE A282 
0271 62C0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0272 62C2 1006  14         jmp   edkey.action.nword_scan_char
0273                       ;-------------------------------------------------------
0274                       ; Multiple spaces mode
0275                       ;-------------------------------------------------------
0276               edkey.action.nword_ms:
0277 62C4 0708  14         seto  tmp4                  ; Set multiple spaces mode
0278                       ;-------------------------------------------------------
0279                       ; Scan forward to first character following space
0280                       ;-------------------------------------------------------
0281               edkey.action.nword_scan
0282 62C6 0585  14         inc   tmp1
0283 62C8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0284 62CA 8804  38         c     tmp0,@fb.row.length
     62CC A288 
0285 62CE 1316  14         jeq   edkey.action.nword_done
0286                                                   ; Column=last char ? Skip further processing
0287                       ;-------------------------------------------------------
0288                       ; Check character
0289                       ;-------------------------------------------------------
0290               edkey.action.nword_scan_char
0291 62D0 D195  26         movb  *tmp1,tmp2            ; Get character
0292 62D2 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0293 62D4 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0294 62D6 0986  56         srl   tmp2,8                ; Right justify
0295               
0296 62D8 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     62DA FFFF 
0297 62DC 1604  14         jne   edkey.action.nword_scan_char_other
0298                       ;-------------------------------------------------------
0299                       ; Special handling if multiple spaces found
0300                       ;-------------------------------------------------------
0301               edkey.action.nword_scan_char_ms:
0302 62DE 0286  22         ci    tmp2,32
     62E0 0020 
0303 62E2 160C  14         jne   edkey.action.nword_done
0304                                                   ; Exit if non-space found
0305 62E4 10F0  14         jmp   edkey.action.nword_scan
0306                       ;-------------------------------------------------------
0307                       ; Normal handling
0308                       ;-------------------------------------------------------
0309               edkey.action.nword_scan_char_other:
0310 62E6 0286  22         ci    tmp2,32               ; Space character found?
     62E8 0020 
0311 62EA 16ED  14         jne   edkey.action.nword_scan
0312                                                   ; No space found, try again
0313                       ;-------------------------------------------------------
0314                       ; Space found, now look closer
0315                       ;-------------------------------------------------------
0316 62EC 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62EE 2020 
0317 62F0 13E9  14         jeq   edkey.action.nword_ms
0318                                                   ; Yes, so continue scanning
0319 62F2 0287  22         ci    tmp3,>20ff            ; First characer is space?
     62F4 20FF 
0320 62F6 13E7  14         jeq   edkey.action.nword_scan
0321                       ;--------------------------------------------------------
0322                       ; Set cursor following space
0323                       ;--------------------------------------------------------
0324 62F8 0585  14         inc   tmp1
0325 62FA 0584  14         inc   tmp0                  ; Column++ in screen buffer
0326                       ;-------------------------------------------------------
0327                       ; Save position and position hardware cursor
0328                       ;-------------------------------------------------------
0329               edkey.action.nword_done:
0330 62FC C805  38         mov   tmp1,@fb.current
     62FE A282 
0331 6300 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6302 A28C 
0332 6304 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6306 2666 
0333                       ;-------------------------------------------------------
0334                       ; Exit
0335                       ;-------------------------------------------------------
0336               edkey.action.nword.exit:
0337 6308 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     630A 67B6 
0338 630C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     630E 6FA0 
0339               
0340               
0341               
0342               
0343               *---------------------------------------------------------------
0344               * Previous page
0345               *---------------------------------------------------------------
0346               edkey.action.ppage:
0347                       ;-------------------------------------------------------
0348                       ; Sanity check
0349                       ;-------------------------------------------------------
0350 6310 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6312 A284 
0351 6314 1316  14         jeq   edkey.action.ppage.exit
0352                       ;-------------------------------------------------------
0353                       ; Special treatment top page
0354                       ;-------------------------------------------------------
0355 6316 8804  38         c     tmp0,@fb.scrrows   ; topline > rows on screen?
     6318 A298 
0356 631A 1503  14         jgt   edkey.action.ppage.topline
0357 631C 04E0  34         clr   @fb.topline           ; topline = 0
     631E A284 
0358 6320 1003  14         jmp   edkey.action.ppage.crunch
0359                       ;-------------------------------------------------------
0360                       ; Adjust topline
0361                       ;-------------------------------------------------------
0362               edkey.action.ppage.topline:
0363 6322 6820  54         s     @fb.scrrows,@fb.topline
     6324 A298 
     6326 A284 
0364                       ;-------------------------------------------------------
0365                       ; Crunch current row if dirty
0366                       ;-------------------------------------------------------
0367               edkey.action.ppage.crunch:
0368 6328 8820  54         c     @fb.row.dirty,@w$ffff
     632A A28A 
     632C 202C 
0369 632E 1604  14         jne   edkey.action.ppage.refresh
0370 6330 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6332 699A 
0371 6334 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6336 A28A 
0372                       ;-------------------------------------------------------
0373                       ; Refresh page
0374                       ;-------------------------------------------------------
0375               edkey.action.ppage.refresh:
0376 6338 C820  54         mov   @fb.topline,@parm1
     633A A284 
     633C 8350 
0377 633E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6340 67D2 
0378                       ;-------------------------------------------------------
0379                       ; Exit
0380                       ;-------------------------------------------------------
0381               edkey.action.ppage.exit:
0382 6342 04E0  34         clr   @fb.row
     6344 A286 
0383 6346 04E0  34         clr   @fb.column
     6348 A28C 
0384 634A 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     634C 0100 
0385 634E C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     6350 832A 
0386 6352 0460  28         b     @edkey.action.up      ; Do rest of logic
     6354 6174 
0387               
0388               
0389               
0390               *---------------------------------------------------------------
0391               * Next page
0392               *---------------------------------------------------------------
0393               edkey.action.npage:
0394                       ;-------------------------------------------------------
0395                       ; Sanity check
0396                       ;-------------------------------------------------------
0397 6356 C120  34         mov   @fb.topline,tmp0
     6358 A284 
0398 635A A120  34         a     @fb.scrrows,tmp0
     635C A298 
0399 635E 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6360 A304 
0400 6362 150D  14         jgt   edkey.action.npage.exit
0401                       ;-------------------------------------------------------
0402                       ; Adjust topline
0403                       ;-------------------------------------------------------
0404               edkey.action.npage.topline:
0405 6364 A820  54         a     @fb.scrrows,@fb.topline
     6366 A298 
     6368 A284 
0406                       ;-------------------------------------------------------
0407                       ; Crunch current row if dirty
0408                       ;-------------------------------------------------------
0409               edkey.action.npage.crunch:
0410 636A 8820  54         c     @fb.row.dirty,@w$ffff
     636C A28A 
     636E 202C 
0411 6370 1604  14         jne   edkey.action.npage.refresh
0412 6372 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6374 699A 
0413 6376 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6378 A28A 
0414                       ;-------------------------------------------------------
0415                       ; Refresh page
0416                       ;-------------------------------------------------------
0417               edkey.action.npage.refresh:
0418 637A 0460  28         b     @edkey.action.ppage.refresh
     637C 6338 
0419                                                   ; Same logic as previous page
0420                       ;-------------------------------------------------------
0421                       ; Exit
0422                       ;-------------------------------------------------------
0423               edkey.action.npage.exit:
0424 637E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6380 6FA0 
0425               
0426               
0427               
0428               
0429               *---------------------------------------------------------------
0430               * Goto top of file
0431               *---------------------------------------------------------------
0432               edkey.action.top:
0433                       ;-------------------------------------------------------
0434                       ; Crunch current row if dirty
0435                       ;-------------------------------------------------------
0436 6382 8820  54         c     @fb.row.dirty,@w$ffff
     6384 A28A 
     6386 202C 
0437 6388 1604  14         jne   edkey.action.top.refresh
0438 638A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     638C 699A 
0439 638E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6390 A28A 
0440                       ;-------------------------------------------------------
0441                       ; Refresh page
0442                       ;-------------------------------------------------------
0443               edkey.action.top.refresh:
0444 6392 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     6394 A284 
0445 6396 04E0  34         clr   @parm1
     6398 8350 
0446 639A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     639C 67D2 
0447                       ;-------------------------------------------------------
0448                       ; Exit
0449                       ;-------------------------------------------------------
0450               edkey.action.top.exit:
0451 639E 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63A0 A286 
0452 63A2 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63A4 A28C 
0453 63A6 0204  20         li    tmp0,>0100
     63A8 0100 
0454 63AA C804  38         mov   tmp0,@wyx             ; Set VDP cursor on line 1, column 0
     63AC 832A 
0455 63AE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63B0 6FA0 
0456               
0457               
0458               
0459               *---------------------------------------------------------------
0460               * Goto bottom of file
0461               *---------------------------------------------------------------
0462               edkey.action.bot:
0463                       ;-------------------------------------------------------
0464                       ; Crunch current row if dirty
0465                       ;-------------------------------------------------------
0466 63B2 8820  54         c     @fb.row.dirty,@w$ffff
     63B4 A28A 
     63B6 202C 
0467 63B8 1604  14         jne   edkey.action.bot.refresh
0468 63BA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63BC 699A 
0469 63BE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63C0 A28A 
0470                       ;-------------------------------------------------------
0471                       ; Refresh page
0472                       ;-------------------------------------------------------
0473               edkey.action.bot.refresh:
0474 63C2 8820  54         c     @edb.lines,@fb.scrrows
     63C4 A304 
     63C6 A298 
0475                                                   ; Skip if whole editor buffer on screen
0476 63C8 1212  14         jle   !
0477 63CA C120  34         mov   @edb.lines,tmp0
     63CC A304 
0478 63CE 6120  34         s     @fb.scrrows,tmp0
     63D0 A298 
0479 63D2 C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     63D4 A284 
0480 63D6 C804  38         mov   tmp0,@parm1
     63D8 8350 
0481 63DA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63DC 67D2 
0482                       ;-------------------------------------------------------
0483                       ; Exit
0484                       ;-------------------------------------------------------
0485               edkey.action.bot.exit:
0486 63DE 04E0  34         clr   @fb.row               ; Editor line 0
     63E0 A286 
0487 63E2 04E0  34         clr   @fb.column            ; Editor column 0
     63E4 A28C 
0488 63E6 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     63E8 0100 
0489 63EA C804  38         mov   tmp0,@wyx             ; Set cursor
     63EC 832A 
0490 63EE 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     63F0 6FA0 
**** **** ****     > tivi_b1.asm.10901
0040                       copy  "edkey.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.mod.asm
0001               * FILE......: edkey.mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 63F2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63F4 A306 
0010 63F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63F8 67B6 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 63FA C120  34         mov   @fb.current,tmp0      ; Get pointer
     63FC A282 
0015 63FE C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6400 A288 
0016 6402 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 6404 8820  54         c     @fb.column,@fb.row.length
     6406 A28C 
     6408 A288 
0022 640A 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 640C C120  34         mov   @fb.current,tmp0      ; Get pointer
     640E A282 
0028 6410 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 6412 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 6414 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 6416 0606  14         dec   tmp2
0036 6418 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 641A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     641C A28A 
0041 641E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6420 A296 
0042 6422 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6424 A288 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 6426 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6428 6FA0 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 642A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     642C A306 
0055 642E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6430 67B6 
0056 6432 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6434 A288 
0057 6436 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 6438 C120  34         mov   @fb.current,tmp0      ; Get pointer
     643A A282 
0063 643C C1A0  34         mov   @fb.colsline,tmp2
     643E A28E 
0064 6440 61A0  34         s     @fb.column,tmp2
     6442 A28C 
0065 6444 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 6446 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 6448 0606  14         dec   tmp2
0072 644A 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 644C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     644E A28A 
0077 6450 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6452 A296 
0078               
0079 6454 C820  54         mov   @fb.column,@fb.row.length
     6456 A28C 
     6458 A288 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 645A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     645C 6FA0 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 645E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6460 A306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 6462 C120  34         mov   @edb.lines,tmp0
     6464 A304 
0097 6466 1604  14         jne   !
0098 6468 04E0  34         clr   @fb.column            ; Column 0
     646A A28C 
0099 646C 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     646E 642A 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 6470 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6472 67B6 
0104 6474 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6476 A28A 
0105 6478 C820  54         mov   @fb.topline,@parm1
     647A A284 
     647C 8350 
0106 647E A820  54         a     @fb.row,@parm1        ; Line number to remove
     6480 A286 
     6482 8350 
0107 6484 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6486 A304 
     6488 8352 
0108 648A 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     648C 68D4 
0109 648E 0620  34         dec   @edb.lines            ; One line less in editor buffer
     6490 A304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 6492 C820  54         mov   @fb.topline,@parm1
     6494 A284 
     6496 8350 
0114 6498 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     649A 67D2 
0115 649C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     649E A296 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 64A0 C120  34         mov   @fb.topline,tmp0
     64A2 A284 
0120 64A4 A120  34         a     @fb.row,tmp0
     64A6 A286 
0121 64A8 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64AA A304 
0122 64AC 1202  14         jle   edkey.action.del_line.exit
0123 64AE 0460  28         b     @edkey.action.up      ; One line up
     64B0 6174 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64B2 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64B4 6232 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 64B6 0204  20         li    tmp0,>2000            ; White space
     64B8 2000 
0139 64BA C804  38         mov   tmp0,@parm1
     64BC 8350 
0140               edkey.action.ins_char:
0141 64BE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64C0 A306 
0142 64C2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64C4 67B6 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64C6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64C8 A282 
0147 64CA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64CC A288 
0148 64CE 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 64D0 8820  54         c     @fb.column,@fb.row.length
     64D2 A28C 
     64D4 A288 
0154 64D6 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 64D8 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 64DA 61E0  34         s     @fb.column,tmp3
     64DC A28C 
0162 64DE A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 64E0 C144  18         mov   tmp0,tmp1
0164 64E2 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 64E4 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64E6 A28C 
0166 64E8 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 64EA D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 64EC 0604  14         dec   tmp0
0173 64EE 0605  14         dec   tmp1
0174 64F0 0606  14         dec   tmp2
0175 64F2 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 64F4 D560  46         movb  @parm1,*tmp1
     64F6 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 64F8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64FA A28A 
0184 64FC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FE A296 
0185 6500 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6502 A288 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 6504 0460  28         b     @edkey.action.char.overwrite
     6506 65E0 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 6508 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     650A 6FA0 
0196               
0197               
0198               
0199               
0200               
0201               
0202               *---------------------------------------------------------------
0203               * Insert new line
0204               *---------------------------------------------------------------
0205               edkey.action.ins_line:
0206 650C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     650E A306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 6510 8820  54         c     @fb.row.dirty,@w$ffff
     6512 A28A 
     6514 202C 
0211 6516 1604  14         jne   edkey.action.ins_line.insert
0212 6518 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     651A 699A 
0213 651C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     651E A28A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6520 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6522 67B6 
0219 6524 C820  54         mov   @fb.topline,@parm1
     6526 A284 
     6528 8350 
0220 652A A820  54         a     @fb.row,@parm1        ; Line number to insert
     652C A286 
     652E 8350 
0221               
0222 6530 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6532 A304 
     6534 8352 
0223 6536 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6538 6908 
0224 653A 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     653C A304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 653E C820  54         mov   @fb.topline,@parm1
     6540 A284 
     6542 8350 
0229 6544 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6546 67D2 
0230 6548 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     654A A296 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 654C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     654E 6FA0 
0236               
0237               
0238               
0239               
0240               
0241               
0242               *---------------------------------------------------------------
0243               * Enter
0244               *---------------------------------------------------------------
0245               edkey.action.enter:
0246                       ;-------------------------------------------------------
0247                       ; Crunch current line if dirty
0248                       ;-------------------------------------------------------
0249 6550 8820  54         c     @fb.row.dirty,@w$ffff
     6552 A28A 
     6554 202C 
0250 6556 1606  14         jne   edkey.action.enter.upd_counter
0251 6558 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     655A A306 
0252 655C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     655E 699A 
0253 6560 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6562 A28A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 6564 C120  34         mov   @fb.topline,tmp0
     6566 A284 
0259 6568 A120  34         a     @fb.row,tmp0
     656A A286 
0260 656C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     656E A304 
0261 6570 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 6572 05A0  34         inc   @edb.lines            ; Total lines++
     6574 A304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 6576 C120  34         mov   @fb.scrrows,tmp0
     6578 A298 
0271 657A 0604  14         dec   tmp0
0272 657C 8120  34         c     @fb.row,tmp0
     657E A286 
0273 6580 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 6582 C120  34         mov   @fb.scrrows,tmp0
     6584 A298 
0278 6586 C820  54         mov   @fb.topline,@parm1
     6588 A284 
     658A 8350 
0279 658C 05A0  34         inc   @parm1
     658E 8350 
0280 6590 06A0  32         bl    @fb.refresh
     6592 67D2 
0281 6594 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 6596 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6598 A286 
0287 659A 06A0  32         bl    @down                 ; Row++ VDP cursor
     659C 2654 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 659E 06A0  32         bl    @fb.get.firstnonblank
     65A0 684A 
0293 65A2 C120  34         mov   @outparm1,tmp0
     65A4 8360 
0294 65A6 C804  38         mov   tmp0,@fb.column
     65A8 A28C 
0295 65AA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65AC 2666 
0296 65AE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65B0 6B32 
0297 65B2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65B4 67B6 
0298 65B6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65B8 A296 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65BA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65BC 6FA0 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 65BE 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65C0 A30A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 65C2 0204  20         li    tmp0,2000
     65C4 07D0 
0317               edkey.action.ins_onoff.loop:
0318 65C6 0604  14         dec   tmp0
0319 65C8 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 65CA 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65CC 70CA 
0325               
0326               
0327               
0328               
0329               *---------------------------------------------------------------
0330               * Process character
0331               *---------------------------------------------------------------
0332               edkey.action.char:
0333 65CE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65D0 A306 
0334 65D2 D805  38         movb  tmp1,@parm1           ; Store character for insert
     65D4 8350 
0335 65D6 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     65D8 A30A 
0336 65DA 1302  14         jeq   edkey.action.char.overwrite
0337                       ;-------------------------------------------------------
0338                       ; Insert mode
0339                       ;-------------------------------------------------------
0340               edkey.action.char.insert:
0341 65DC 0460  28         b     @edkey.action.ins_char
     65DE 64BE 
0342                       ;-------------------------------------------------------
0343                       ; Overwrite mode
0344                       ;-------------------------------------------------------
0345               edkey.action.char.overwrite:
0346 65E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65E2 67B6 
0347 65E4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     65E6 A282 
0348               
0349 65E8 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     65EA 8350 
0350 65EC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65EE A28A 
0351 65F0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65F2 A296 
0352               
0353 65F4 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     65F6 A28C 
0354 65F8 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     65FA 832A 
0355                       ;-------------------------------------------------------
0356                       ; Update line length in frame buffer
0357                       ;-------------------------------------------------------
0358 65FC 8820  54         c     @fb.column,@fb.row.length
     65FE A28C 
     6600 A288 
0359 6602 1103  14         jlt   edkey.action.char.exit
0360                                                   ; column < length line ? Skip processing
0361               
0362 6604 C820  54         mov   @fb.column,@fb.row.length
     6606 A28C 
     6608 A288 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 660A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     660C 6FA0 
**** **** ****     > tivi_b1.asm.10901
0041                       copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
**** **** ****     > edkey.misc.asm
0001               * FILE......: edkey.misc.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 660E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6610 2716 
0010 6612 0420  54         blwp  @0                    ; Exit
     6614 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6616 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6618 6FA0 
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Show/Hide command buffer pane
0022               ********|*****|*********************|**************************
0023               edkey.action.cmdb.toggle:
0024 661A C120  34         mov   @cmdb.visible,tmp0
     661C A502 
0025 661E 1603  14         jne   edkey.action.cmdb.hide
0026                       ;-------------------------------------------------------
0027                       ; Show pane
0028                       ;-------------------------------------------------------
0029               edkey.action.cmdb.show:
0030 6620 06A0  32         bl    @cmdb.show            ; Show command buffer pane
     6622 6B86 
0031 6624 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 6626 06A0  32         bl    @cmdb.hide            ; Hide command buffer pane
     6628 6BB8 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 662A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     662C 6FA0 
0042               
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Framebuffer down 1 row
0047               *---------------------------------------------------------------
0048               edkey.action.fbdown:
0049 662E 05A0  34         inc   @fb.scrrows
     6630 A298 
0050 6632 0720  34         seto  @fb.dirty
     6634 A296 
0051               
0052 6636 045B  20         b     *r11
0053               
0054               
0055               *---------------------------------------------------------------
0056               * Cycle colors
0057               ********|*****|*********************|**************************
0058               edkey.action.color.cycle:
0059 6638 0649  14         dect  stack
0060 663A C64B  30         mov   r11,*stack            ; Push return address
0061               
0062 663C C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     663E A212 
0063 6640 0284  22         ci    tmp0,3                ; 4th entry reached?
     6642 0003 
0064 6644 1102  14         jlt   !
0065 6646 04C4  14         clr   tmp0
0066 6648 1001  14         jmp   edkey.action.color.switch
0067 664A 0584  14 !       inc   tmp0
0068               *---------------------------------------------------------------
0069               * Do actual color switch
0070               ********|*****|*********************|**************************
0071               edkey.action.color.switch:
0072 664C C804  38         mov   tmp0,@tv.colorscheme  ; Save color scheme index
     664E A212 
0073 6650 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
0074 6652 0224  22         ai    tmp0,tv.data.colorscheme
     6654 728E 
0075                                                   ; Add base for color scheme data table
0076 6656 D154  26         movb  *tmp0,tmp1            ; Get foreground / background color
0077                       ;-------------------------------------------------------
0078                       ; Dump cursor FG color to sprite table (SAT)
0079                       ;-------------------------------------------------------
0080 6658 C185  18         mov   tmp1,tmp2             ; Get work copy
0081 665A 0946  56         srl   tmp2,4                ; Move nibble to right
0082 665C 0246  22         andi  tmp2,>0f00
     665E 0F00 
0083 6660 D806  38         movb  tmp2,@ramsat+3        ; Update FG color in sprite table (SAT)
     6662 8383 
0084 6664 D806  38         movb  tmp2,@tv.curshape+1   ; Save cursor color
     6666 A215 
0085                       ;-------------------------------------------------------
0086                       ; Dump color combination to VDP color table
0087                       ;-------------------------------------------------------
0088 6668 0985  56         srl   tmp1,8                ; MSB to LSB
0089 666A 0265  22         ori   tmp1,>0700
     666C 0700 
0090 666E C105  18         mov   tmp1,tmp0
0091 6670 06A0  32         bl    @putvrx
     6672 2314 
0092 6674 C2F9  30         mov   *stack+,r11           ; Pop R11
0093 6676 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6678 6FA0 
**** **** ****     > tivi_b1.asm.10901
0042                       copy  "edkey.file.asm"      ; Actions for file related keys
**** **** ****     > edkey.file.asm
0001               * FILE......: edkey.fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               edkey.action.buffer0:
0006 667A 0204  20         li   tmp0,fdname0
     667C 7336 
0007 667E 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 6680 0204  20         li   tmp0,fdname1
     6682 7346 
0010 6684 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6686 0204  20         li   tmp0,fdname2
     6688 7356 
0013 668A 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 668C 0204  20         li   tmp0,fdname3
     668E 7364 
0016 6690 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 6692 0204  20         li   tmp0,fdname4
     6694 7372 
0019 6696 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6698 0204  20         li   tmp0,fdname5
     669A 7380 
0022 669C 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 669E 0204  20         li   tmp0,fdname6
     66A0 738E 
0025 66A2 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 66A4 0204  20         li   tmp0,fdname7
     66A6 739C 
0028 66A8 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 66AA 0204  20         li   tmp0,fdname8
     66AC 73AA 
0031 66AE 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 66B0 0204  20         li   tmp0,fdname9
     66B2 73B8 
0034 66B4 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66B6 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66B8 6E28 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66BA 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66BC 6382 
**** **** ****     > tivi_b1.asm.10901
0043                       copy  "tivi.asm"            ; Main editor configuration
**** **** ****     > tivi.asm
0001               * FILE......: tivi.asm
0002               * Purpose...: TiVi Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize main editor
0012               ***************************************************************
0013               * bl @tivi.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ***************************************************************
0026               tivi.init:
0027 66BE 0649  14         dect  stack
0028 66C0 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 66C2 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     66C4 A212 
0033               
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               tivi.init.exit:
0038 66C6 0460  28         b     @poprt                ; Return to caller
     66C8 2212 
**** **** ****     > tivi_b1.asm.10901
0044                       copy  "mem.asm"             ; Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: TiVi Editor - Memory management (SAMS)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Memory Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.setup.sams.layout
0010               * Setup SAMS memory pages for TiVi
0011               ***************************************************************
0012               * bl  @mem.setup.sams.layout
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ***************************************************************
0020               mem.setup.sams.layout:
0021 66CA 0649  14         dect  stack
0022 66CC C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 66CE 06A0  32         bl    @sams.layout
     66D0 2562 
0027 66D2 66D8                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 66D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0033 66D6 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 66D8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >00
     66DA 0002 
0039 66DC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >01
     66DE 0003 
0040 66E0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >02
     66E2 000A 
0041 66E4 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >03
     66E6 000B 
0042 66E8 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >04
     66EA 000C 
0043 66EC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >05
     66EE 000D 
0044 66F0 E000             data  >e000,>0010           ; >e000-efff, SAMS page >10
     66F2 0010 
0045 66F4 F000             data  >f000,>0011           ; >f000-ffff, SAMS page >11
     66F6 0011 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * mem.edb.sams.pagein
0052               * Activate editor buffer SAMS page for line
0053               ***************************************************************
0054               * bl  @mem.edb.sams.pagein
0055               *     data p0
0056               *--------------------------------------------------------------
0057               * p0 = Line number in editor buffer
0058               *--------------------------------------------------------------
0059               * bl  @xmem.edb.sams.pagein
0060               *
0061               * tmp0 = Line number in editor buffer
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * outparm1 = Pointer to line in editor buffer
0065               * outparm2 = SAMS page
0066               *--------------------------------------------------------------
0067               * Register usage
0068               * tmp0, tmp1, tmp2, tmp3
0069               ***************************************************************
0070               mem.edb.sams.pagein:
0071 66F8 C13B  30         mov   *r11+,tmp0            ; Get p0
0072               xmem.edb.sams.pagein:
0073 66FA 0649  14         dect  stack
0074 66FC C64B  30         mov   r11,*stack            ; Push return address
0075 66FE 0649  14         dect  stack
0076 6700 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 6702 0649  14         dect  stack
0078 6704 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 6706 0649  14         dect  stack
0080 6708 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 670A 0649  14         dect  stack
0082 670C C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Sanity check
0085                       ;------------------------------------------------------
0086 670E 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6710 A304 
0087 6712 1104  14         jlt   mem.edb.sams.pagein.lookup
0088                                                   ; All checks passed, continue
0089                                                   ;--------------------------
0090                                                   ; Sanity check failed
0091                                                   ;--------------------------
0092 6714 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6716 FFCE 
0093 6718 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     671A 2030 
0094                       ;------------------------------------------------------
0095                       ; Lookup SAMS page for line in parm1
0096                       ;------------------------------------------------------
0097               mem.edb.sams.pagein.lookup:
0098 671C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     671E 694C 
0099                                                   ; \ i  parm1    = Line number
0100                                                   ; | o  outparm1 = Pointer to line
0101                                                   ; / o  outparm2 = SAMS page
0102               
0103 6720 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6722 8362 
0104 6724 C160  34         mov   @outparm1,tmp1        ; Memory address
     6726 8360 
0105 6728 1315  14         jeq   mem.edb.sams.pagein.exit
0106                                                   ; Nothing to page-in if empty line
0107                       ;------------------------------------------------------
0108                       ; 1. Determine if requested SAMS page is already active
0109                       ;------------------------------------------------------
0110 672A 0245  22         andi  tmp1,>f000            ; Reduce address to 4K chunks
     672C F000 
0111 672E 04C6  14         clr   tmp2                  ; Offset in SAMS shadow registers table
0112 6730 0207  20         li    tmp3,sams.copy.layout.data + 6
     6732 2604 
0113                                                   ; Entry >b000  in SAMS memory range table
0114                       ;------------------------------------------------------
0115                       ; Loop over memory ranges
0116                       ;------------------------------------------------------
0117               mem.edb.sams.pagein.compare.loop:
0118 6734 8177  30         c     *tmp3+,tmp1           ; Does memory range match?
0119 6736 1308  14         jeq   !                     ; Yes, now check SAMS page
0120               
0121 6738 05C6  14         inct  tmp2                  ; Next range
0122 673A 0286  22         ci    tmp2,12               ; All ranges checked?
     673C 000C 
0123 673E 16FA  14         jne   mem.edb.sams.pagein.compare.loop
0124                                                   ; Not yet, check next range
0125                       ;------------------------------------------------------
0126                       ; Invalid memory range. Should never get here
0127                       ;------------------------------------------------------
0128 6740 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6742 FFCE 
0129 6744 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6746 2030 
0130                       ;------------------------------------------------------
0131                       ; 2. Determine if requested SAMS page is already active
0132                       ;------------------------------------------------------
0133 6748 0226  22 !       ai    tmp2,tv.sams.2000     ; Add offset for SAMS shadow register
     674A A200 
0134 674C 8116  26         c     *tmp2,tmp0            ; Requested SAMS page already active?
0135 674E 1302  14         jeq   mem.edb.sams.pagein.exit
0136                                                   ; Yes, so exit
0137                       ;------------------------------------------------------
0138                       ; Activate requested SAMS page
0139                       ;-----------------------------------------------------
0140 6750 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6752 24FC 
0141                                                   ; \ i  tmp0 = SAMS page
0142                                                   ; / i  tmp1 = Memory address
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               mem.edb.sams.pagein.exit:
0147 6754 C1F9  30         mov   *stack+,tmp3          ; Pop tmp1
0148 6756 C1B9  30         mov   *stack+,tmp2          ; Pop tmp1
0149 6758 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 675A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 675C C2F9  30         mov   *stack+,r11           ; Pop r11
0152 675E 045B  20         b     *r11                  ; Return to caller
0153               
**** **** ****     > tivi_b1.asm.10901
0045                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: TiVi Editor - Framebuffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * fb.init
0010               * Initialize framebuffer
0011               ***************************************************************
0012               *  bl   @fb.init
0013               *--------------------------------------------------------------
0014               *  INPUT
0015               *  none
0016               *--------------------------------------------------------------
0017               *  OUTPUT
0018               *  none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               ********|*****|*********************|**************************
0023               fb.init
0024 6760 0649  14         dect  stack
0025 6762 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 6764 0204  20         li    tmp0,fb.top
     6766 A650 
0030 6768 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     676A A280 
0031 676C 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     676E A284 
0032 6770 04E0  34         clr   @fb.row               ; Current row=0
     6772 A286 
0033 6774 04E0  34         clr   @fb.column            ; Current column=0
     6776 A28C 
0034               
0035 6778 0204  20         li    tmp0,80
     677A 0050 
0036 677C C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     677E A28E 
0037               
0038 6780 0204  20         li    tmp0,27
     6782 001B 
0039 6784 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
     6786 A298 
0040 6788 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     678A A29A 
0041               
0042 678C 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     678E A216 
0043 6790 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     6792 A296 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 6794 06A0  32         bl    @film
     6796 2216 
0048 6798 A650             data  fb.top,>00,fb.size    ; Clear it all the way
     679A 0000 
     679C 09B0 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 679E 0460  28         b     @poprt                ; Return to caller
     67A0 2212 
0054               
0055               
0056               
0057               
0058               ***************************************************************
0059               * fb.row2line
0060               * Calculate line in editor buffer
0061               ***************************************************************
0062               * bl @fb.row2line
0063               *--------------------------------------------------------------
0064               * INPUT
0065               * @fb.topline = Top line in frame buffer
0066               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0067               *--------------------------------------------------------------
0068               * OUTPUT
0069               * @outparm1 = Matching line in editor buffer
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * tmp2,tmp3
0073               *--------------------------------------------------------------
0074               * Formula
0075               * outparm1 = @fb.topline + @parm1
0076               ********|*****|*********************|**************************
0077               fb.row2line:
0078 67A2 0649  14         dect  stack
0079 67A4 C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67A6 C120  34         mov   @parm1,tmp0
     67A8 8350 
0084 67AA A120  34         a     @fb.topline,tmp0
     67AC A284 
0085 67AE C804  38         mov   tmp0,@outparm1
     67B0 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67B2 0460  28         b    @poprt                 ; Return to caller
     67B4 2212 
0091               
0092               
0093               
0094               
0095               ***************************************************************
0096               * fb.calc_pointer
0097               * Calculate pointer address in frame buffer
0098               ***************************************************************
0099               * bl @fb.calc_pointer
0100               *--------------------------------------------------------------
0101               * INPUT
0102               * @fb.top       = Address of top row in frame buffer
0103               * @fb.topline   = Top line in frame buffer
0104               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0105               * @fb.column    = Current column in frame buffer
0106               * @fb.colsline  = Columns per line in frame buffer
0107               *--------------------------------------------------------------
0108               * OUTPUT
0109               * @fb.current   = Updated pointer
0110               *--------------------------------------------------------------
0111               * Register usage
0112               * tmp2,tmp3
0113               *--------------------------------------------------------------
0114               * Formula
0115               * pointer = row * colsline + column + deref(@fb.top.ptr)
0116               ********|*****|*********************|**************************
0117               fb.calc_pointer:
0118 67B6 0649  14         dect  stack
0119 67B8 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 67BA C1A0  34         mov   @fb.row,tmp2
     67BC A286 
0124 67BE 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     67C0 A28E 
0125 67C2 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     67C4 A28C 
0126 67C6 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     67C8 A280 
0127 67CA C807  38         mov   tmp3,@fb.current
     67CC A282 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 67CE 0460  28         b    @poprt                 ; Return to caller
     67D0 2212 
0133               
0134               
0135               
0136               
0137               ***************************************************************
0138               * fb.refresh
0139               * Refresh frame buffer with editor buffer content
0140               ***************************************************************
0141               * bl @fb.refresh
0142               *--------------------------------------------------------------
0143               * INPUT
0144               * @parm1 = Line to start with (becomes @fb.topline)
0145               *--------------------------------------------------------------
0146               * OUTPUT
0147               * none
0148               *--------------------------------------------------------------
0149               * Register usage
0150               * tmp0,tmp1,tmp2
0151               ********|*****|*********************|**************************
0152               fb.refresh:
0153 67D2 0649  14         dect  stack
0154 67D4 C64B  30         mov   r11,*stack            ; Push return address
0155 67D6 0649  14         dect  stack
0156 67D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0157 67DA 0649  14         dect  stack
0158 67DC C645  30         mov   tmp1,*stack           ; Push tmp1
0159 67DE 0649  14         dect  stack
0160 67E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Update SAMS shadow registers in RAM
0163                       ;------------------------------------------------------
0164 67E2 06A0  32         bl    @sams.copy.layout     ; Copy SAMS memory layout
     67E4 25C6 
0165 67E6 A200                   data tv.sams.2000     ; \ i  p0 = Pointer to 8 words RAM buffer
0166                                                   ; /
0167                       ;------------------------------------------------------
0168                       ; Setup starting position in index
0169                       ;------------------------------------------------------
0170 67E8 C820  54         mov   @parm1,@fb.topline
     67EA 8350 
     67EC A284 
0171 67EE 04E0  34         clr   @parm2                ; Target row in frame buffer
     67F0 8352 
0172                       ;------------------------------------------------------
0173                       ; Check if already at EOF
0174                       ;------------------------------------------------------
0175 67F2 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     67F4 8350 
     67F6 A304 
0176 67F8 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0177                       ;------------------------------------------------------
0178                       ; Unpack line to frame buffer
0179                       ;------------------------------------------------------
0180               fb.refresh.unpack_line:
0181 67FA 06A0  32         bl    @edb.line.unpack      ; Unpack line
     67FC 6A42 
0182                                                   ; \ i  parm1 = Line to unpack
0183                                                   ; / i  parm2 = Target row in frame buffer
0184               
0185 67FE 05A0  34         inc   @parm1                ; Next line in editor buffer
     6800 8350 
0186 6802 05A0  34         inc   @parm2                ; Next row in frame buffer
     6804 8352 
0187                       ;------------------------------------------------------
0188                       ; Last row in editor buffer reached ?
0189                       ;------------------------------------------------------
0190 6806 8820  54         c     @parm1,@edb.lines
     6808 8350 
     680A A304 
0191 680C 1113  14         jlt   !                     ; no, do next check
0192                                                   ; yes, erase until end of frame buffer
0193                       ;------------------------------------------------------
0194                       ; Erase until end of frame buffer
0195                       ;------------------------------------------------------
0196               fb.refresh.erase_eob:
0197 680E C120  34         mov   @parm2,tmp0           ; Current row
     6810 8352 
0198 6812 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6814 A298 
0199 6816 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0200 6818 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     681A A28E 
0201               
0202 681C C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0203 681E 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0204               
0205 6820 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6822 A28E 
0206 6824 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6826 A280 
0207               
0208 6828 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0209 682A 0205  20         li    tmp1,32               ; Clear with space
     682C 0020 
0210               
0211 682E 06A0  32         bl    @xfilm                ; \ Fill memory
     6830 221C 
0212                                                   ; | i  tmp0 = Memory start address
0213                                                   ; | i  tmp1 = Byte to fill
0214                                                   ; / i  tmp2 = Number of bytes to fill
0215 6832 1004  14         jmp   fb.refresh.exit
0216                       ;------------------------------------------------------
0217                       ; Bottom row in frame buffer reached ?
0218                       ;------------------------------------------------------
0219 6834 8820  54 !       c     @parm2,@fb.scrrows
     6836 8352 
     6838 A298 
0220 683A 11DF  14         jlt   fb.refresh.unpack_line
0221                                                   ; No, unpack next line
0222                       ;------------------------------------------------------
0223                       ; Exit
0224                       ;------------------------------------------------------
0225               fb.refresh.exit:
0226 683C 0720  34         seto  @fb.dirty             ; Refresh screen
     683E A296 
0227 6840 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0228 6842 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0229 6844 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0230 6846 C2F9  30         mov   *stack+,r11           ; Pop r11
0231 6848 045B  20         b     *r11                  ; Return to caller
0232               
0233               
0234               ***************************************************************
0235               * fb.get.firstnonblank
0236               * Get column of first non-blank character in specified line
0237               ***************************************************************
0238               * bl @fb.get.firstnonblank
0239               *--------------------------------------------------------------
0240               * OUTPUT
0241               * @outparm1 = Column containing first non-blank character
0242               * @outparm2 = Character
0243               ********|*****|*********************|**************************
0244               fb.get.firstnonblank:
0245 684A 0649  14         dect  stack
0246 684C C64B  30         mov   r11,*stack            ; Save return address
0247                       ;------------------------------------------------------
0248                       ; Prepare for scanning
0249                       ;------------------------------------------------------
0250 684E 04E0  34         clr   @fb.column
     6850 A28C 
0251 6852 06A0  32         bl    @fb.calc_pointer
     6854 67B6 
0252 6856 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6858 6B32 
0253 685A C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     685C A288 
0254 685E 1313  14         jeq   fb.get.firstnonblank.nomatch
0255                                                   ; Exit if empty line
0256 6860 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6862 A282 
0257 6864 04C5  14         clr   tmp1
0258                       ;------------------------------------------------------
0259                       ; Scan line for non-blank character
0260                       ;------------------------------------------------------
0261               fb.get.firstnonblank.loop:
0262 6866 D174  28         movb  *tmp0+,tmp1           ; Get character
0263 6868 130E  14         jeq   fb.get.firstnonblank.nomatch
0264                                                   ; Exit if empty line
0265 686A 0285  22         ci    tmp1,>2000            ; Whitespace?
     686C 2000 
0266 686E 1503  14         jgt   fb.get.firstnonblank.match
0267 6870 0606  14         dec   tmp2                  ; Counter--
0268 6872 16F9  14         jne   fb.get.firstnonblank.loop
0269 6874 1008  14         jmp   fb.get.firstnonblank.nomatch
0270                       ;------------------------------------------------------
0271                       ; Non-blank character found
0272                       ;------------------------------------------------------
0273               fb.get.firstnonblank.match:
0274 6876 6120  34         s     @fb.current,tmp0      ; Calculate column
     6878 A282 
0275 687A 0604  14         dec   tmp0
0276 687C C804  38         mov   tmp0,@outparm1        ; Save column
     687E 8360 
0277 6880 D805  38         movb  tmp1,@outparm2        ; Save character
     6882 8362 
0278 6884 1004  14         jmp   fb.get.firstnonblank.exit
0279                       ;------------------------------------------------------
0280                       ; No non-blank character found
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.nomatch:
0283 6886 04E0  34         clr   @outparm1             ; X=0
     6888 8360 
0284 688A 04E0  34         clr   @outparm2             ; Null
     688C 8362 
0285                       ;------------------------------------------------------
0286                       ; Exit
0287                       ;------------------------------------------------------
0288               fb.get.firstnonblank.exit:
0289 688E 0460  28         b    @poprt                 ; Return to caller
     6890 2212 
**** **** ****     > tivi_b1.asm.10901
0046                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: TiVi Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * The index contains 2 major parts:
0010               *
0011               * 1) Main index (c000 - cfff)
0012               *
0013               *    Size of index page is 4K and allows indexing of 2048 lines.
0014               *    Each index slot (1 word) contains the pointer to the line
0015               *    in the editor buffer.
0016               *
0017               * 2) Shadow SAMS pages index (d000 - dfff)
0018               *
0019               *    Size of index page is 4K and allows indexing of 2048 lines.
0020               *    Each index slot (1 word) contains the SAMS page where the
0021               *    line in the editor buffer resides
0022               *
0023               *
0024               * The editor buffer itself always resides at (e000 -> ffff) for
0025               * a total of 8kb.
0026               * First line in editor buffer starts at offset 2 (c002), this
0027               * allows the index to contain "null" pointers, aka empty lines
0028               * without reference to editor buffer.
0029               ***************************************************************
0030               
0031               
0032               ***************************************************************
0033               * idx.init
0034               * Initialize index
0035               ***************************************************************
0036               * bl @idx.init
0037               *--------------------------------------------------------------
0038               * INPUT
0039               * none
0040               *--------------------------------------------------------------
0041               * OUTPUT
0042               * none
0043               *--------------------------------------------------------------
0044               * Register usage
0045               * tmp0
0046               ***************************************************************
0047               idx.init:
0048 6892 0649  14         dect  stack
0049 6894 C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 6896 0204  20         li    tmp0,idx.top
     6898 C000 
0054 689A C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     689C A302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 689E 06A0  32         bl    @film
     68A0 2216 
0059 68A2 C000             data  idx.top,>00,idx.size  ; Clear main index
     68A4 0000 
     68A6 1000 
0060               
0061 68A8 06A0  32         bl    @film
     68AA 2216 
0062 68AC D000             data  idx.shadow.top,>00,idx.shadow.size
     68AE 0000 
     68B0 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 68B2 0460  28         b     @poprt                ; Return to caller
     68B4 2212 
0069               
0070               
0071               
0072               ***************************************************************
0073               * idx.entry.update
0074               * Update index entry - Each entry corresponds to a line
0075               ***************************************************************
0076               * bl @idx.entry.update
0077               *--------------------------------------------------------------
0078               * INPUT
0079               * @parm1    = Line number in editor buffer
0080               * @parm2    = Pointer to line in editor buffer
0081               * @parm3    = SAMS page
0082               *--------------------------------------------------------------
0083               * OUTPUT
0084               * @outparm1 = Pointer to updated index entry
0085               *--------------------------------------------------------------
0086               * Register usage
0087               * tmp0,tmp1,tmp2
0088               *--------------------------------------------------------------
0089               idx.entry.update:
0090 68B6 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     68B8 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 68BA C160  34         mov   @parm2,tmp1
     68BC 8352 
0095 68BE 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 68C0 C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     68C2 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 68C4 0A14  56         sla   tmp0,1                ; line number * 2
0107 68C6 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     68C8 C000 
0108 68CA C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     68CC D000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 68CE C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     68D0 8360 
0115 68D2 045B  20         b     *r11                  ; Return
0116               
0117               
0118               ***************************************************************
0119               * idx.entry.delete
0120               * Delete index entry - Close gap created by delete
0121               ***************************************************************
0122               * bl @idx.entry.delete
0123               *--------------------------------------------------------------
0124               * INPUT
0125               * @parm1    = Line number in editor buffer to delete
0126               * @parm2    = Line number of last line to check for reorg
0127               *--------------------------------------------------------------
0128               * OUTPUT
0129               * @outparm1 = Pointer to deleted line (for undo)
0130               *--------------------------------------------------------------
0131               * Register usage
0132               * tmp0,tmp2
0133               *--------------------------------------------------------------
0134               idx.entry.delete:
0135 68D4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     68D6 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 68D8 0A14  56         sla   tmp0,1                ; line number * 2
0140 68DA C824  54         mov   @idx.top(tmp0),@outparm1
     68DC C000 
     68DE 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 68E0 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     68E2 8352 
0146 68E4 61A0  34         s     @parm1,tmp2           ; Calculate loop
     68E6 8350 
0147 68E8 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 68EA 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 68EC C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     68EE C002 
     68F0 C000 
0157 68F2 C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     68F4 D002 
     68F6 D000 
0158 68F8 05C4  14         inct  tmp0                  ; Next index entry
0159 68FA 0606  14         dec   tmp2                  ; tmp2--
0160 68FC 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 68FE 04E4  34         clr   @idx.top(tmp0)
     6900 C000 
0167 6902 04E4  34         clr   @idx.shadow.top(tmp0)
     6904 D000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 6906 045B  20         b     *r11                  ; Return
0173               
0174               
0175               ***************************************************************
0176               * idx.entry.insert
0177               * Insert index entry
0178               ***************************************************************
0179               * bl @idx.entry.insert
0180               *--------------------------------------------------------------
0181               * INPUT
0182               * @parm1    = Line number in editor buffer to insert
0183               * @parm2    = Line number of last line to check for reorg
0184               *--------------------------------------------------------------
0185               * OUTPUT
0186               * NONE
0187               *--------------------------------------------------------------
0188               * Register usage
0189               * tmp0,tmp2
0190               *--------------------------------------------------------------
0191               idx.entry.insert:
0192 6908 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     690A 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 690C 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 690E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6910 8352 
0201 6912 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6914 8350 
0202 6916 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 6918 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     691A C000 
     691C C002 
0207                                                   ; Move pointer
0208 691E 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     6920 C000 
0209               
0210 6922 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     6924 D000 
     6926 D002 
0211                                                   ; Move SAMS page
0212 6928 04E4  34         clr   @idx.shadow.top+0(tmp0)
     692A D000 
0213                                                   ; Clear new index entry
0214 692C 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 692E 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 6930 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6932 C000 
     6934 C002 
0222                                                   ; Move pointer
0223               
0224 6936 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     6938 D000 
     693A D002 
0225                                                   ; Move SAMS page
0226               
0227 693C 0644  14         dect  tmp0                  ; Previous index entry
0228 693E 0606  14         dec   tmp2                  ; tmp2--
0229 6940 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 6942 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     6944 C004 
0232 6946 04E4  34         clr   @idx.shadow.top+4(tmp0)
     6948 D004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 694A 045B  20         b     *r11                  ; Return
0239               
0240               
0241               
0242               ***************************************************************
0243               * idx.pointer.get
0244               * Get pointer to editor buffer line content
0245               ***************************************************************
0246               * bl @idx.pointer.get
0247               *--------------------------------------------------------------
0248               * INPUT
0249               * @parm1 = Line number in editor buffer
0250               *--------------------------------------------------------------
0251               * OUTPUT
0252               * @outparm1 = Pointer to editor buffer line content
0253               * @outparm2 = SAMS page
0254               *--------------------------------------------------------------
0255               * Register usage
0256               * tmp0,tmp1,tmp2
0257               *--------------------------------------------------------------
0258               idx.pointer.get:
0259 694C 0649  14         dect  stack
0260 694E C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 6950 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6952 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 6954 0A14  56         sla   tmp0,1                ; line number * 2
0269 6956 C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     6958 C000 
0270 695A C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     695C D000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 695E C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6960 8360 
0277 6962 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6964 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 6966 0460  28         b     @poprt                ; Return to caller
     6968 2212 
**** **** ****     > tivi_b1.asm.10901
0047                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: TiVi Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Editor Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * edb.init
0010               * Initialize Editor buffer
0011               ***************************************************************
0012               * bl @edb.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               edb.init:
0026 696A 0649  14         dect  stack
0027 696C C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 696E 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     6970 E002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 6972 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     6974 A300 
0035 6976 C804  38         mov   tmp0,@edb.next_free.ptr
     6978 A308 
0036                                                   ; Set pointer to next free line in
0037                                                   ; editor buffer
0038               
0039 697A 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     697C A30A 
0040 697E 04E0  34         clr   @edb.lines            ; Lines=0
     6980 A304 
0041 6982 04E0  34         clr   @edb.rle              ; RLE compression off
     6984 A30C 
0042               
0043 6986 0204  20         li    tmp0,txt.newfile      ; "New file"
     6988 72F6 
0044 698A C804  38         mov   tmp0,@edb.filename.ptr
     698C A30E 
0045               
0046 698E 0204  20         li    tmp0,txt.filetype.none
     6990 731C 
0047 6992 C804  38         mov   tmp0,@edb.filetype.ptr
     6994 A310 
0048               
0049               edb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 6996 0460  28         b     @poprt                ; Return to caller
     6998 2212 
0054               
0055               
0056               
0057               ***************************************************************
0058               * edb.line.pack
0059               * Pack current line in framebuffer
0060               ***************************************************************
0061               *  bl   @edb.line.pack
0062               *--------------------------------------------------------------
0063               * INPUT
0064               * @fb.top       = Address of top row in frame buffer
0065               * @fb.row       = Current row in frame buffer
0066               * @fb.column    = Current column in frame buffer
0067               * @fb.colsline  = Columns per line in frame buffer
0068               *--------------------------------------------------------------
0069               * OUTPUT
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * tmp0,tmp1,tmp2
0073               *--------------------------------------------------------------
0074               * Memory usage
0075               * rambuf   = Saved @fb.column
0076               * rambuf+2 = Saved beginning of row
0077               * rambuf+4 = Saved length of row
0078               ********|*****|*********************|**************************
0079               edb.line.pack:
0080 699A 0649  14         dect  stack
0081 699C C64B  30         mov   r11,*stack            ; Save return address
0082                       ;------------------------------------------------------
0083                       ; Get values
0084                       ;------------------------------------------------------
0085 699E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     69A0 A28C 
     69A2 8390 
0086 69A4 04E0  34         clr   @fb.column
     69A6 A28C 
0087 69A8 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     69AA 67B6 
0088                       ;------------------------------------------------------
0089                       ; Prepare scan
0090                       ;------------------------------------------------------
0091 69AC 04C4  14         clr   tmp0                  ; Counter
0092 69AE C160  34         mov   @fb.current,tmp1      ; Get position
     69B0 A282 
0093 69B2 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     69B4 8392 
0094               
0095                       ;------------------------------------------------------
0096                       ; Scan line for >00 byte termination
0097                       ;------------------------------------------------------
0098               edb.line.pack.scan:
0099 69B6 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0100 69B8 0986  56         srl   tmp2,8                ; Right justify
0101 69BA 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0102 69BC 0584  14         inc   tmp0                  ; Increase string length
0103 69BE 10FB  14         jmp   edb.line.pack.scan    ; Next character
0104               
0105                       ;------------------------------------------------------
0106                       ; Prepare for storing line
0107                       ;------------------------------------------------------
0108               edb.line.pack.prepare:
0109 69C0 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     69C2 A284 
     69C4 8350 
0110 69C6 A820  54         a     @fb.row,@parm1        ; /
     69C8 A286 
     69CA 8350 
0111               
0112 69CC C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     69CE 8394 
0113               
0114                       ;------------------------------------------------------
0115                       ; 1. Update index
0116                       ;------------------------------------------------------
0117               edb.line.pack.update_index:
0118 69D0 C120  34         mov   @edb.next_free.ptr,tmp0
     69D2 A308 
0119 69D4 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     69D6 8352 
0120               
0121 69D8 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     69DA 24C4 
0122                                                   ; \ i  tmp0  = Memory address
0123                                                   ; | o  waux1 = SAMS page number
0124                                                   ; / o  waux2 = Address of SAMS register
0125               
0126 69DC C820  54         mov   @waux1,@parm3
     69DE 833C 
     69E0 8354 
0127 69E2 06A0  32         bl    @idx.entry.update     ; Update index
     69E4 68B6 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132               
0133                       ;------------------------------------------------------
0134                       ; 2. Switch to required SAMS page
0135                       ;------------------------------------------------------
0136 69E6 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     69E8 A312 
     69EA 8354 
0137 69EC 1308  14         jeq   !                     ; Yes, skip setting page
0138               
0139 69EE C120  34         mov   @parm3,tmp0           ; get SAMS page
     69F0 8354 
0140 69F2 C160  34         mov   @edb.next_free.ptr,tmp1
     69F4 A308 
0141                                                   ; Pointer to line in editor buffer
0142 69F6 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     69F8 24FC 
0143                                                   ; \ i  tmp0 = SAMS page
0144                                                   ; / i  tmp1 = Memory address
0145               
0146 69FA C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     69FC A438 
0147               
0148                       ;------------------------------------------------------
0149                       ; 3. Set line prefix in editor buffer
0150                       ;------------------------------------------------------
0151 69FE C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6A00 8392 
0152 6A02 C160  34         mov   @edb.next_free.ptr,tmp1
     6A04 A308 
0153                                                   ; Address of line in editor buffer
0154               
0155 6A06 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6A08 A308 
0156               
0157 6A0A C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6A0C 8394 
0158 6A0E 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0159 6A10 06C6  14         swpb  tmp2
0160 6A12 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0161 6A14 06C6  14         swpb  tmp2
0162 6A16 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0163               
0164                       ;------------------------------------------------------
0165                       ; 4. Copy line from framebuffer to editor buffer
0166                       ;------------------------------------------------------
0167               edb.line.pack.copyline:
0168 6A18 0286  22         ci    tmp2,2
     6A1A 0002 
0169 6A1C 1603  14         jne   edb.line.pack.copyline.checkbyte
0170 6A1E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0171 6A20 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0172 6A22 1007  14         jmp   !
0173               edb.line.pack.copyline.checkbyte:
0174 6A24 0286  22         ci    tmp2,1
     6A26 0001 
0175 6A28 1602  14         jne   edb.line.pack.copyline.block
0176 6A2A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0177 6A2C 1002  14         jmp   !
0178               edb.line.pack.copyline.block:
0179 6A2E 06A0  32         bl    @xpym2m               ; Copy memory block
     6A30 2466 
0180                                                   ; \ i  tmp0 = source
0181                                                   ; | i  tmp1 = destination
0182                                                   ; / i  tmp2 = bytes to copy
0183               
0184 6A32 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6A34 8394 
     6A36 A308 
0185                                                   ; Update pointer to next free line
0186               
0187                       ;------------------------------------------------------
0188                       ; Exit
0189                       ;------------------------------------------------------
0190               edb.line.pack.exit:
0191 6A38 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6A3A 8390 
     6A3C A28C 
0192 6A3E 0460  28         b     @poprt                ; Return to caller
     6A40 2212 
0193               
0194               
0195               
0196               
0197               ***************************************************************
0198               * edb.line.unpack
0199               * Unpack specified line to framebuffer
0200               ***************************************************************
0201               *  bl   @edb.line.unpack
0202               *--------------------------------------------------------------
0203               * INPUT
0204               * @parm1 = Line to unpack in editor buffer
0205               * @parm2 = Target row in frame buffer
0206               *--------------------------------------------------------------
0207               * OUTPUT
0208               * none
0209               *--------------------------------------------------------------
0210               * Register usage
0211               * tmp0,tmp1,tmp2,tmp3,tmp4
0212               *--------------------------------------------------------------
0213               * Memory usage
0214               * rambuf    = Saved @parm1 of edb.line.unpack
0215               * rambuf+2  = Saved @parm2 of edb.line.unpack
0216               * rambuf+4  = Source memory address in editor buffer
0217               * rambuf+6  = Destination memory address in frame buffer
0218               * rambuf+8  = Length of RLE (decompressed) line
0219               * rambuf+10 = Length of RLE compressed line
0220               ********|*****|*********************|**************************
0221               edb.line.unpack:
0222 6A42 0649  14         dect  stack
0223 6A44 C64B  30         mov   r11,*stack            ; Save return address
0224                       ;------------------------------------------------------
0225                       ; Sanity check
0226                       ;------------------------------------------------------
0227 6A46 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6A48 8350 
     6A4A A304 
0228 6A4C 1104  14         jlt   !
0229 6A4E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6A50 FFCE 
0230 6A52 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A54 2030 
0231                       ;------------------------------------------------------
0232                       ; Save parameters
0233                       ;------------------------------------------------------
0234 6A56 C820  54 !       mov   @parm1,@rambuf
     6A58 8350 
     6A5A 8390 
0235 6A5C C820  54         mov   @parm2,@rambuf+2
     6A5E 8352 
     6A60 8392 
0236                       ;------------------------------------------------------
0237                       ; Calculate offset in frame buffer
0238                       ;------------------------------------------------------
0239 6A62 C120  34         mov   @fb.colsline,tmp0
     6A64 A28E 
0240 6A66 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6A68 8352 
0241 6A6A C1A0  34         mov   @fb.top.ptr,tmp2
     6A6C A280 
0242 6A6E A146  18         a     tmp2,tmp1             ; Add base to offset
0243 6A70 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6A72 8396 
0244                       ;------------------------------------------------------
0245                       ; Get pointer to line & page-in editor buffer page
0246                       ;------------------------------------------------------
0247 6A74 C120  34         mov   @parm1,tmp0
     6A76 8350 
0248 6A78 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     6A7A 66FA 
0249                                                   ; \ i  tmp0     = Line number
0250                                                   ; | o  outparm1 = Pointer to line
0251                                                   ; / o  outparm2 = SAMS page
0252               
0253 6A7C C820  54         mov   @outparm2,@edb.sams.page
     6A7E 8362 
     6A80 A312 
0254                                                   ; Save current SAMS page
0255               
0256 6A82 05E0  34         inct  @outparm1             ; Skip line prefix
     6A84 8360 
0257 6A86 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6A88 8360 
     6A8A 8394 
0258                       ;------------------------------------------------------
0259                       ; Get length of line to unpack
0260                       ;------------------------------------------------------
0261 6A8C 06A0  32         bl    @edb.line.getlength   ; Get length of line
     6A8E 6AFA 
0262                                                   ; \ i  parm1    = Line number
0263                                                   ; | o  outparm1 = Line length (uncompressed)
0264                                                   ; | o  outparm2 = Line length (compressed)
0265                                                   ; / o  outparm3 = SAMS page
0266               
0267 6A90 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     6A92 8362 
     6A94 839A 
0268 6A96 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     6A98 8360 
     6A9A 8398 
0269 6A9C 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line
0270                       ;------------------------------------------------------
0271                       ; Handle possible "line split" between 2 consecutive pages
0272                       ;------------------------------------------------------
0273 6A9E C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
     6AA0 8394 
0274 6AA2 C144  18         mov     tmp0,tmp1           ; Pointer to line
0275 6AA4 A160  34         a       @rambuf+8,tmp1      ; Add length of line
     6AA6 8398 
0276               
0277 6AA8 0244  22         andi    tmp0,>f000          ; Only keep high nibble
     6AAA F000 
0278 6AAC 0245  22         andi    tmp1,>f000          ; Only keep high nibble
     6AAE F000 
0279 6AB0 8144  18         c       tmp0,tmp1           ; Same segment?
0280 6AB2 1305  14         jeq     edb.line.unpack.clear
0281                                                   ; Yes, so skip
0282               
0283 6AB4 C120  34         mov     @outparm3,tmp0      ; Get SAMS page
     6AB6 8364 
0284 6AB8 0584  14         inc     tmp0                ; Next sams page
0285               
0286 6ABA 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
     6ABC 24FC 
0287                                                   ; | i  tmp0 = SAMS page number
0288                                                   ; / i  tmp1 = Memory Address
0289               
0290                       ;------------------------------------------------------
0291                       ; Erase chars from last column until column 80
0292                       ;------------------------------------------------------
0293               edb.line.unpack.clear:
0294 6ABE C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6AC0 8396 
0295 6AC2 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6AC4 8398 
0296               
0297 6AC6 04C5  14         clr   tmp1                  ; Fill with >00
0298 6AC8 C1A0  34         mov   @fb.colsline,tmp2
     6ACA A28E 
0299 6ACC 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6ACE 8398 
0300 6AD0 0586  14         inc   tmp2
0301               
0302 6AD2 06A0  32         bl    @xfilm                ; Fill CPU memory
     6AD4 221C 
0303                                                   ; \ i  tmp0 = Target address
0304                                                   ; | i  tmp1 = Byte to fill
0305                                                   ; / i  tmp2 = Repeat count
0306                       ;------------------------------------------------------
0307                       ; Prepare for unpacking data
0308                       ;------------------------------------------------------
0309               edb.line.unpack.prepare:
0310 6AD6 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6AD8 8398 
0311 6ADA 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0312 6ADC C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6ADE 8394 
0313 6AE0 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6AE2 8396 
0314                       ;------------------------------------------------------
0315                       ; Check before copy
0316                       ;------------------------------------------------------
0317               edb.line.unpack.copy.uncompressed:
0318 6AE4 0286  22         ci    tmp2,80               ; Check line length
     6AE6 0050 
0319 6AE8 1204  14         jle   !
0320 6AEA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AEC FFCE 
0321 6AEE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AF0 2030 
0322                       ;------------------------------------------------------
0323                       ; Copy memory block
0324                       ;------------------------------------------------------
0325 6AF2 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6AF4 2466 
0326                                                   ; \ i  tmp0 = Source address
0327                                                   ; | i  tmp1 = Target address
0328                                                   ; / i  tmp2 = Bytes to copy
0329                       ;------------------------------------------------------
0330                       ; Exit
0331                       ;------------------------------------------------------
0332               edb.line.unpack.exit:
0333 6AF6 0460  28         b     @poprt                ; Return to caller
     6AF8 2212 
0334               
0335               
0336               
0337               
0338               ***************************************************************
0339               * edb.line.getlength
0340               * Get length of specified line
0341               ***************************************************************
0342               *  bl   @edb.line.getlength
0343               *--------------------------------------------------------------
0344               * INPUT
0345               * @parm1 = Line number
0346               *--------------------------------------------------------------
0347               * OUTPUT
0348               * @outparm1 = Length of line (uncompressed)
0349               * @outparm2 = Length of line (compressed)
0350               * @outparm3 = SAMS page
0351               *--------------------------------------------------------------
0352               * Register usage
0353               * tmp0,tmp1,tmp2
0354               ********|*****|*********************|**************************
0355               edb.line.getlength:
0356 6AFA 0649  14         dect  stack
0357 6AFC C64B  30         mov   r11,*stack            ; Save return address
0358                       ;------------------------------------------------------
0359                       ; Initialisation
0360                       ;------------------------------------------------------
0361 6AFE 04E0  34         clr   @outparm1             ; Reset uncompressed length
     6B00 8360 
0362 6B02 04E0  34         clr   @outparm2             ; Reset compressed length
     6B04 8362 
0363 6B06 04E0  34         clr   @outparm3             ; Reset SAMS bank
     6B08 8364 
0364                       ;------------------------------------------------------
0365                       ; Get length
0366                       ;------------------------------------------------------
0367 6B0A 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6B0C 694C 
0368                                                   ; \ i  parm1    = Line number
0369                                                   ; | o  outparm1 = Pointer to line
0370                                                   ; / o  outparm2 = SAMS page
0371               
0372 6B0E C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6B10 8360 
0373 6B12 130D  14         jeq   edb.line.getlength.exit
0374                                                   ; Exit early if NULL pointer
0375 6B14 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     6B16 8362 
     6B18 8364 
0376                       ;------------------------------------------------------
0377                       ; Process line prefix
0378                       ;------------------------------------------------------
0379 6B1A 04C5  14         clr   tmp1
0380 6B1C D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0381 6B1E 06C5  14         swpb  tmp1
0382 6B20 C805  38         mov   tmp1,@outparm2        ; Save length
     6B22 8362 
0383               
0384 6B24 04C5  14         clr   tmp1
0385 6B26 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0386 6B28 06C5  14         swpb  tmp1
0387 6B2A C805  38         mov   tmp1,@outparm1        ; Save length
     6B2C 8360 
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               edb.line.getlength.exit:
0392 6B2E 0460  28         b     @poprt                ; Return to caller
     6B30 2212 
0393               
0394               
0395               
0396               
0397               ***************************************************************
0398               * edb.line.getlength2
0399               * Get length of current row (as seen from editor buffer side)
0400               ***************************************************************
0401               *  bl   @edb.line.getlength2
0402               *--------------------------------------------------------------
0403               * INPUT
0404               * @fb.row = Row in frame buffer
0405               *--------------------------------------------------------------
0406               * OUTPUT
0407               * @fb.row.length = Length of row
0408               *--------------------------------------------------------------
0409               * Register usage
0410               * tmp0
0411               ********|*****|*********************|**************************
0412               edb.line.getlength2:
0413 6B32 0649  14         dect  stack
0414 6B34 C64B  30         mov   r11,*stack            ; Save return address
0415                       ;------------------------------------------------------
0416                       ; Calculate line in editor buffer
0417                       ;------------------------------------------------------
0418 6B36 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6B38 A284 
0419 6B3A A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6B3C A286 
0420                       ;------------------------------------------------------
0421                       ; Get length
0422                       ;------------------------------------------------------
0423 6B3E C804  38         mov   tmp0,@parm1
     6B40 8350 
0424 6B42 06A0  32         bl    @edb.line.getlength
     6B44 6AFA 
0425 6B46 C820  54         mov   @outparm1,@fb.row.length
     6B48 8360 
     6B4A A288 
0426                                                   ; Save row length
0427                       ;------------------------------------------------------
0428                       ; Exit
0429                       ;------------------------------------------------------
0430               edb.line.getlength2.exit:
0431 6B4C 0460  28         b     @poprt                ; Return to caller
     6B4E 2212 
0432               
**** **** ****     > tivi_b1.asm.10901
0048                       copy  "cmdb.asm"            ; Command Buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: TiVi Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Command Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cmdb.init
0011               * Initialize Command Buffer
0012               ***************************************************************
0013               * bl @cmdb.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * none
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               cmdb.init:
0027 6B50 0649  14         dect  stack
0028 6B52 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6B54 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6B56 B000 
0033 6B58 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6B5A A500 
0034               
0035 6B5C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6B5E A502 
0036 6B60 0204  20         li    tmp0,8
     6B62 0008 
0037 6B64 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6B66 A504 
0038 6B68 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6B6A A506 
0039               
0040 6B6C 04E0  34         clr   @cmdb.yxtop           ; Screen Y of 1st row in cmdb pane
     6B6E A508 
0041 6B70 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6B72 A50C 
0042 6B74 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6B76 A50E 
0043                       ;------------------------------------------------------
0044                       ; Clear command buffer
0045                       ;------------------------------------------------------
0046 6B78 06A0  32         bl    @film
     6B7A 2216 
0047 6B7C B000             data  cmdb.top,>00,cmdb.size
     6B7E 0000 
     6B80 1000 
0048                                                   ; Clear it all the way
0049               cmdb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 6B82 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B84 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               ***************************************************************
0060               * cmdb.show
0061               * Show command buffer pane
0062               ***************************************************************
0063               * bl @cmdb.show
0064               *--------------------------------------------------------------
0065               * INPUT
0066               * none
0067               *--------------------------------------------------------------
0068               * OUTPUT
0069               * none
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * none
0073               *--------------------------------------------------------------
0074               * Notes
0075               ********|*****|*********************|**************************
0076               cmdb.show:
0077 6B86 0649  14         dect  stack
0078 6B88 C64B  30         mov   r11,*stack            ; Save return address
0079 6B8A 0649  14         dect  stack
0080 6B8C C644  30         mov   tmp0,*stack           ; Push tmp0
0081                       ;------------------------------------------------------
0082                       ; Show command buffer pane
0083                       ;------------------------------------------------------
0084 6B8E C120  34         mov   @fb.scrrows.max,tmp0
     6B90 A29A 
0085 6B92 6120  34         s     @cmdb.scrrows,tmp0
     6B94 A504 
0086 6B96 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6B98 A298 
0087               
0088 6B9A 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0089 6B9C 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0090 6B9E C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer top row
     6BA0 A508 
0091               
0092 6BA2 0720  34         seto  @cmdb.visible         ; Show pane
     6BA4 A502 
0093               
0094 6BA6 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6BA8 0001 
0095 6BAA C804  38         mov   tmp0,@tv.pane.focus   ; /
     6BAC A216 
0096               
0097 6BAE 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BB0 A296 
0098               
0099               cmdb.show.exit:
0100                       ;------------------------------------------------------
0101                       ; Exit
0102                       ;------------------------------------------------------
0103 6BB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 6BB4 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 6BB6 045B  20         b     *r11                  ; Return to caller
0106               
0107               
0108               
0109               ***************************************************************
0110               * cmdb.hide
0111               * Hide command buffer pane
0112               ***************************************************************
0113               * bl @cmdb.show
0114               *--------------------------------------------------------------
0115               * INPUT
0116               * none
0117               *--------------------------------------------------------------
0118               * OUTPUT
0119               * none
0120               *--------------------------------------------------------------
0121               * Register usage
0122               * none
0123               *--------------------------------------------------------------
0124               * Hiding the command buffer automatically passes pane focus
0125               * to frame buffer.
0126               ********|*****|*********************|**************************
0127               cmdb.hide:
0128 6BB8 0649  14         dect  stack
0129 6BBA C64B  30         mov   r11,*stack            ; Save return address
0130                       ;------------------------------------------------------
0131                       ; Hide command buffer pane
0132                       ;------------------------------------------------------
0133 6BBC C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6BBE A29A 
     6BC0 A298 
0134                                                   ; Resize framebuffer
0135               
0136 6BC2 04E0  34         clr   @cmdb.visible         ; Hide pane
     6BC4 A502 
0137 6BC6 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BC8 A296 
0138 6BCA 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6BCC A216 
0139               
0140               cmdb.hide.exit:
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144 6BCE C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6BD0 045B  20         b     *r11                  ; Return to caller
0146               
0147               
0148               
0149               ***************************************************************
0150               * cmdb.refresh
0151               * Refresh command buffer content
0152               ***************************************************************
0153               * bl @cmdb.refresh
0154               *--------------------------------------------------------------
0155               * INPUT
0156               * none
0157               *--------------------------------------------------------------
0158               * OUTPUT
0159               * none
0160               *--------------------------------------------------------------
0161               * Register usage
0162               * none
0163               *--------------------------------------------------------------
0164               * Notes
0165               ********|*****|*********************|**************************
0166               cmdb.refresh:
0167 6BD2 0649  14         dect  stack
0168 6BD4 C64B  30         mov   r11,*stack            ; Save return address
0169 6BD6 0649  14         dect  stack
0170 6BD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0171 6BDA 0649  14         dect  stack
0172 6BDC C645  30         mov   tmp1,*stack           ; Push tmp1
0173 6BDE 0649  14         dect  stack
0174 6BE0 C646  30         mov   tmp2,*stack           ; Push tmp2
0175                       ;------------------------------------------------------
0176                       ; Show Command buffer content
0177                       ;------------------------------------------------------
0178 6BE2 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6BE4 832A 
     6BE6 A50A 
0179               
0180 6BE8 C820  54         mov   @cmdb.yxtop,@wyx
     6BEA A508 
     6BEC 832A 
0181 6BEE 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6BF0 23DA 
0182               
0183 6BF2 C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6BF4 A500 
0184 6BF6 0206  20         li    tmp2,7*80
     6BF8 0230 
0185               
0186 6BFA 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6BFC 241E 
0187                                                   ; | i  tmp0 = VDP target address
0188                                                   ; | i  tmp1 = RAM source address
0189                                                   ; / i  tmp2 = Number of bytes to copy
0190               
0191 6BFE C820  54         mov   @cmdb.yxsave,@wyx     ; Restore YX position
     6C00 A50A 
     6C02 832A 
0192               cmdb.refresh.exit:
0193                       ;------------------------------------------------------
0194                       ; Exit
0195                       ;------------------------------------------------------
0196 6C04 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6C06 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6C08 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6C0A C2F9  30         mov   *stack+,r11           ; Pop r11
0200 6C0C 045B  20         b     *r11                  ; Return to caller
0201               
**** **** ****     > tivi_b1.asm.10901
0049                       copy  "fh.read.sams.asm"    ; File handler read file
**** **** ****     > fh.read.sams.asm
0001               * FILE......: fh.read.sams.asm
0002               * Purpose...: File reader module (SAMS implementation)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.read.sams
0011               * Read file into editor buffer with SAMS support
0012               ***************************************************************
0013               *  bl   @fh.file.read.sams
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "loading indicator 1"
0018               * parm3 = Pointer to callback function "loading indicator 2"
0019               * parm4 = Pointer to callback function "loading indicator 3"
0020               * parm5 = Pointer to callback function "File I/O error handler"
0021               * parm6 = Not used yet (starting line in file)
0022               * parm7 = Not used yet (starting line in editor buffer)
0023               * parm8 = Not used yet (number of lines to read)
0024               *--------------------------------------------------------------
0025               * OUTPUT
0026               *--------------------------------------------------------------
0027               * Register usage
0028               * tmp0, tmp1, tmp2, tmp3, tmp4
0029               ********|*****|*********************|**************************
0030               fh.file.read.sams:
0031 6C0E 0649  14         dect  stack
0032 6C10 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6C12 04E0  34         clr   @fh.rleonload         ; No RLE compression!
     6C14 A444 
0037 6C16 04E0  34         clr   @fh.records           ; Reset records counter
     6C18 A42E 
0038 6C1A 04E0  34         clr   @fh.counter           ; Clear internal counter
     6C1C A434 
0039 6C1E 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6C20 A432 
0040 6C22 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 6C24 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6C26 A42A 
0042 6C28 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6C2A A42C 
0043               
0044 6C2C 0204  20         li    tmp0,3
     6C2E 0003 
0045 6C30 C804  38         mov   tmp0,@fh.sams.page    ; Set current SAMS page
     6C32 A438 
0046 6C34 C804  38         mov   tmp0,@fh.sams.hpage   ; Set highest SAMS page in use
     6C36 A43A 
0047                       ;------------------------------------------------------
0048                       ; Save parameters / callback functions
0049                       ;------------------------------------------------------
0050 6C38 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6C3A 8350 
     6C3C A436 
0051 6C3E C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
     6C40 8352 
     6C42 A43C 
0052 6C44 C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
     6C46 8354 
     6C48 A43E 
0053 6C4A C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
     6C4C 8356 
     6C4E A440 
0054 6C50 C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
     6C52 8358 
     6C54 A442 
0055                       ;------------------------------------------------------
0056                       ; Sanity check
0057                       ;------------------------------------------------------
0058 6C56 C120  34         mov   @fh.callback1,tmp0
     6C58 A43C 
0059 6C5A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C5C 6000 
0060 6C5E 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0061               
0062 6C60 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C62 7FFF 
0063 6C64 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0064               
0065 6C66 C120  34         mov   @fh.callback2,tmp0
     6C68 A43E 
0066 6C6A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C6C 6000 
0067 6C6E 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0068               
0069 6C70 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C72 7FFF 
0070 6C74 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0071               
0072 6C76 C120  34         mov   @fh.callback3,tmp0
     6C78 A440 
0073 6C7A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C7C 6000 
0074 6C7E 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0075               
0076 6C80 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C82 7FFF 
0077 6C84 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0078               
0079 6C86 1004  14         jmp   fh.file.read.sams.load1
0080                                                   ; All checks passed, continue.
0081                                                   ;--------------------------
0082                                                   ; Check failed, crash CPU!
0083                                                   ;--------------------------
0084               fh.file.read.crash:
0085 6C88 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C8A FFCE 
0086 6C8C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C8E 2030 
0087                       ;------------------------------------------------------
0088                       ; Show "loading indicator 1"
0089                       ;------------------------------------------------------
0090               fh.file.read.sams.load1:
0091 6C90 C120  34         mov   @fh.callback1,tmp0
     6C92 A43C 
0092 6C94 0694  24         bl    *tmp0                 ; Run callback function
0093                       ;------------------------------------------------------
0094                       ; Copy PAB header to VDP
0095                       ;------------------------------------------------------
0096               fh.file.read.sams.pabheader:
0097 6C96 06A0  32         bl    @cpym2v
     6C98 2418 
0098 6C9A 0A60                   data fh.vpab,fh.file.pab.header,9
     6C9C 6E1E 
     6C9E 0009 
0099                                                   ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101                       ; Append file descriptor to PAB header in VDP
0102                       ;------------------------------------------------------
0103 6CA0 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6CA2 0A69 
0104 6CA4 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6CA6 A436 
0105 6CA8 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0106 6CAA 0986  56         srl   tmp2,8                ; Right justify
0107 6CAC 0586  14         inc   tmp2                  ; Include length byte as well
0108 6CAE 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6CB0 241E 
0109                       ;------------------------------------------------------
0110                       ; Load GPL scratchpad layout
0111                       ;------------------------------------------------------
0112 6CB2 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6CB4 2AA2 
0113 6CB6 A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0114                       ;------------------------------------------------------
0115                       ; Open file
0116                       ;------------------------------------------------------
0117 6CB8 06A0  32         bl    @file.open
     6CBA 2BF0 
0118 6CBC 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0119 6CBE 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6CC0 2026 
0120 6CC2 1602  14         jne   fh.file.read.sams.record
0121 6CC4 0460  28         b     @fh.file.read.sams.error
     6CC6 6DE8 
0122                                                   ; Yes, IO error occured
0123                       ;------------------------------------------------------
0124                       ; Step 1: Read file record
0125                       ;------------------------------------------------------
0126               fh.file.read.sams.record:
0127 6CC8 05A0  34         inc   @fh.records           ; Update counter
     6CCA A42E 
0128 6CCC 04E0  34         clr   @fh.reclen            ; Reset record length
     6CCE A430 
0129               
0130 6CD0 06A0  32         bl    @file.record.read     ; Read file record
     6CD2 2C32 
0131 6CD4 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0132                                                   ; |           (without +9 offset!)
0133                                                   ; | o  tmp0 = Status byte
0134                                                   ; | o  tmp1 = Bytes read
0135                                                   ; | o  tmp2 = Status register contents
0136                                                   ; /           upon DSRLNK return
0137               
0138 6CD6 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6CD8 A42A 
0139 6CDA C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6CDC A430 
0140 6CDE C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6CE0 A42C 
0141                       ;------------------------------------------------------
0142                       ; 1a: Calculate kilobytes processed
0143                       ;------------------------------------------------------
0144 6CE2 A805  38         a     tmp1,@fh.counter
     6CE4 A434 
0145 6CE6 A160  34         a     @fh.counter,tmp1
     6CE8 A434 
0146 6CEA 0285  22         ci    tmp1,1024
     6CEC 0400 
0147 6CEE 1106  14         jlt   !
0148 6CF0 05A0  34         inc   @fh.kilobytes
     6CF2 A432 
0149 6CF4 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6CF6 FC00 
0150 6CF8 C805  38         mov   tmp1,@fh.counter
     6CFA A434 
0151                       ;------------------------------------------------------
0152                       ; 1b: Load spectra scratchpad layout
0153                       ;------------------------------------------------------
0154 6CFC 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     6CFE 2A28 
0155 6D00 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6D02 2AC4 
0156 6D04 A100                   data scrpad.backup2   ; / >2100->8300
0157                       ;------------------------------------------------------
0158                       ; 1c: Check if a file error occured
0159                       ;------------------------------------------------------
0160               fh.file.read.sams.check_fioerr:
0161 6D06 C1A0  34         mov   @fh.ioresult,tmp2
     6D08 A42C 
0162 6D0A 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6D0C 2026 
0163 6D0E 1602  14         jne   fh.file.read.sams.check_setpage
0164                                                   ; No, goto (1d)
0165 6D10 0460  28         b     @fh.file.read.sams.error
     6D12 6DE8 
0166                                                   ; Yes, so handle file error
0167                       ;------------------------------------------------------
0168                       ; 1d: Check if SAMS page needs to be set
0169                       ;------------------------------------------------------
0170               fh.file.read.sams.check_setpage:
0171 6D14 C120  34         mov   @edb.next_free.ptr,tmp0
     6D16 A308 
0172 6D18 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6D1A 24C4 
0173                                                   ; \ i  tmp0  = Memory address
0174                                                   ; | o  waux1 = SAMS page number
0175                                                   ; / o  waux2 = Address of SAMS register
0176               
0177 6D1C C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     6D1E 833C 
0178 6D20 8804  38         c     tmp0,@fh.sams.page   ; Compare page with current SAMS page
     6D22 A438 
0179 6D24 1310  14         jeq   fh.file.read.sams.nocompression
0180                                                   ; Same, skip to (2)
0181                       ;------------------------------------------------------
0182                       ; 1e: Increase SAMS page if necessary
0183                       ;------------------------------------------------------
0184 6D26 8804  38         c     tmp0,@fh.sams.hpage   ; Compare page with highest SAMS page
     6D28 A43A 
0185 6D2A 1502  14         jgt   fh.file.read.sams.switch
0186                                                   ; Switch page
0187 6D2C 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     6D2E 0005 
0188                       ;------------------------------------------------------
0189                       ; 1f: Switch to SAMS page
0190                       ;------------------------------------------------------
0191               fh.file.read.sams.switch:
0192 6D30 C160  34         mov   @edb.next_free.ptr,tmp1
     6D32 A308 
0193                                                   ; Beginning of line
0194               
0195 6D34 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D36 24FC 
0196                                                   ; \ i  tmp0 = SAMS page number
0197                                                   ; / i  tmp1 = Memory address
0198               
0199 6D38 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6D3A A438 
0200               
0201 6D3C 8804  38         c     tmp0,@fh.sams.hpage   ; Current SAMS page > highest SAMS page?
     6D3E A43A 
0202 6D40 1202  14         jle   fh.file.read.sams.nocompression
0203                                                   ; No, skip to (2)
0204 6D42 C804  38         mov   tmp0,@fh.sams.hpage   ; Update highest SAMS page
     6D44 A43A 
0205                       ;------------------------------------------------------
0206                       ; Step 2: Process line (without RLE compression)
0207                       ;------------------------------------------------------
0208               fh.file.read.sams.nocompression:
0209 6D46 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6D48 0960 
0210 6D4A C160  34         mov   @edb.next_free.ptr,tmp1
     6D4C A308 
0211                                                   ; RAM target in editor buffer
0212               
0213 6D4E C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6D50 8352 
0214               
0215 6D52 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6D54 A430 
0216 6D56 1324  14         jeq   fh.file.read.sams.prepindex.emptyline
0217                                                   ; Handle empty line
0218                       ;------------------------------------------------------
0219                       ; 2a: Copy line from VDP to CPU editor buffer
0220                       ;------------------------------------------------------
0221                                                   ; Save line prefix
0222 6D58 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0223 6D5A 06C6  14         swpb  tmp2                  ; |
0224 6D5C DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0225 6D5E 06C6  14         swpb  tmp2                  ; /
0226               
0227 6D60 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6D62 A308 
0228 6D64 A806  38         a     tmp2,@edb.next_free.ptr
     6D66 A308 
0229                                                   ; Add line length
0230                       ;------------------------------------------------------
0231                       ; 2b: Handle line split accross 2 consecutive SAMS pages
0232                       ;------------------------------------------------------
0233 6D68 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0234 6D6A C205  18         mov   tmp1,tmp4             ; Backup tmp1
0235               
0236 6D6C C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
0237 6D6E 09C4  56         srl   tmp0,12               ; Only keep high-nibble
0238               
0239 6D70 C160  34         mov   @edb.next_free.ptr,tmp1
     6D72 A308 
0240                                                   ; Get pointer to next line (aka end of line)
0241 6D74 09C5  56         srl   tmp1,12               ; Only keep high-nibble
0242               
0243 6D76 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
0244 6D78 1307  14         jeq   !                     ; Yes, skip setting SAMS page
0245               
0246 6D7A C120  34         mov   @fh.sams.page,tmp0    ; Get current SAMS page
     6D7C A438 
0247 6D7E 0584  14         inc   tmp0                  ; Increase SAMS page
0248 6D80 C160  34         mov   @edb.next_free.ptr,tmp1
     6D82 A308 
0249                                                   ; Get pointer to next line (aka end of line)
0250               
0251 6D84 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D86 24FC 
0252                                                   ; \ i  tmp0 = SAMS page number
0253                                                   ; / i  tmp1 = Memory address
0254               
0255 6D88 C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
0256 6D8A C107  18         mov   tmp3,tmp0             ; Restore tmp0
0257                       ;------------------------------------------------------
0258                       ; 2c: Do actual copy
0259                       ;------------------------------------------------------
0260 6D8C 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6D8E 2444 
0261                                                   ; \ i  tmp0 = VDP source address
0262                                                   ; | i  tmp1 = RAM target address
0263                                                   ; / i  tmp2 = Bytes to copy
0264               
0265 6D90 1000  14         jmp   fh.file.read.sams.prepindex
0266                                                   ; Prepare for updating index
0267                       ;------------------------------------------------------
0268                       ; Step 4: Update index
0269                       ;------------------------------------------------------
0270               fh.file.read.sams.prepindex:
0271 6D92 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6D94 A304 
     6D96 8350 
0272                                                   ; parm2 = Must allready be set!
0273 6D98 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6D9A A438 
     6D9C 8354 
0274               
0275 6D9E 1009  14         jmp   fh.file.read.sams.updindex
0276                                                   ; Update index
0277                       ;------------------------------------------------------
0278                       ; 4a: Special handling for empty line
0279                       ;------------------------------------------------------
0280               fh.file.read.sams.prepindex.emptyline:
0281 6DA0 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6DA2 A42E 
     6DA4 8350 
0282 6DA6 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6DA8 8350 
0283 6DAA 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6DAC 8352 
0284 6DAE 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6DB0 8354 
0285                       ;------------------------------------------------------
0286                       ; 4b: Do actual index update
0287                       ;------------------------------------------------------
0288               fh.file.read.sams.updindex:
0289 6DB2 06A0  32         bl    @idx.entry.update     ; Update index
     6DB4 68B6 
0290                                                   ; \ i  parm1    = Line num in editor buffer
0291                                                   ; | i  parm2    = Pointer to line in editor
0292                                                   ; |               buffer
0293                                                   ; | i  parm3    = SAMS page
0294                                                   ; | o  outparm1 = Pointer to updated index
0295                                                   ; /               entry
0296               
0297 6DB6 05A0  34         inc   @edb.lines            ; lines=lines+1
     6DB8 A304 
0298                       ;------------------------------------------------------
0299                       ; Step 5: Display results
0300                       ;------------------------------------------------------
0301               fh.file.read.sams.display:
0302 6DBA C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6DBC A43E 
0303 6DBE 0694  24         bl    *tmp0                 ; Run callback function
0304                       ;------------------------------------------------------
0305                       ; Step 6: Check if reaching memory high-limit >ffa0
0306                       ;------------------------------------------------------
0307               fh.file.read.sams.checkmem:
0308 6DC0 C120  34         mov   @edb.next_free.ptr,tmp0
     6DC2 A308 
0309 6DC4 0284  22         ci    tmp0,>ffa0
     6DC6 FFA0 
0310 6DC8 1205  14         jle   fh.file.read.sams.next
0311                       ;------------------------------------------------------
0312                       ; 6a: Address range b000-ffff full, switch SAMS pages
0313                       ;------------------------------------------------------
0314 6DCA 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     6DCC E002 
0315 6DCE C804  38         mov   tmp0,@edb.next_free.ptr
     6DD0 A308 
0316               
0317 6DD2 1000  14         jmp   fh.file.read.sams.next
0318                       ;------------------------------------------------------
0319                       ; 6b: Next record
0320                       ;------------------------------------------------------
0321               fh.file.read.sams.next:
0322 6DD4 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6DD6 2AA2 
0323 6DD8 A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0324               
0325               
0326                       ;-------------------------------------------------------
0327                       ; ** TEMPORARY FIX for 4KB INDEX LIMIT **
0328                       ;-------------------------------------------------------
0329 6DDA C120  34         mov   @edb.lines,tmp0
     6DDC A304 
0330 6DDE 0284  22         ci    tmp0,2047
     6DE0 07FF 
0331 6DE2 1311  14         jeq   fh.file.read.sams.eof
0332               
0333 6DE4 0460  28         b     @fh.file.read.sams.record
     6DE6 6CC8 
0334                                                   ; Next record
0335                       ;------------------------------------------------------
0336                       ; Error handler
0337                       ;------------------------------------------------------
0338               fh.file.read.sams.error:
0339 6DE8 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6DEA A42A 
0340 6DEC 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0341 6DEE 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6DF0 0005 
0342 6DF2 1309  14         jeq   fh.file.read.sams.eof
0343                                                   ; All good. File closed by DSRLNK
0344                       ;------------------------------------------------------
0345                       ; File error occured
0346                       ;------------------------------------------------------
0347 6DF4 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6DF6 2AC4 
0348 6DF8 A100                   data scrpad.backup2   ; / >2100->8300
0349               
0350 6DFA 06A0  32         bl    @mem.setup.sams.layout
     6DFC 66CA 
0351                                                   ; Restore SAMS default memory layout
0352               
0353 6DFE C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
     6E00 A442 
0354 6E02 0694  24         bl    *tmp0                 ; Run callback function
0355 6E04 100A  14         jmp   fh.file.read.sams.exit
0356                       ;------------------------------------------------------
0357                       ; End-Of-File reached
0358                       ;------------------------------------------------------
0359               fh.file.read.sams.eof:
0360 6E06 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E08 2AC4 
0361 6E0A A100                   data scrpad.backup2   ; / >2100->8300
0362               
0363 6E0C 06A0  32         bl    @mem.setup.sams.layout
     6E0E 66CA 
0364                                                   ; Restore SAMS default memory layout
0365                       ;------------------------------------------------------
0366                       ; Show "loading indicator 3" (final)
0367                       ;------------------------------------------------------
0368 6E10 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     6E12 A306 
0369               
0370 6E14 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
     6E16 A440 
0371 6E18 0694  24         bl    *tmp0                 ; Run callback function
0372               *--------------------------------------------------------------
0373               * Exit
0374               *--------------------------------------------------------------
0375               fh.file.read.sams.exit:
0376 6E1A 0460  28         b     @poprt                ; Return to caller
     6E1C 2212 
0377               
0378               
0379               
0380               
0381               
0382               
0383               ***************************************************************
0384               * PAB for accessing DV/80 file
0385               ********|*****|*********************|**************************
0386               fh.file.pab.header:
0387 6E1E 0014             byte  io.op.open            ;  0    - OPEN
0388                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0389 6E20 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0390 6E22 5000             byte  80                    ;  4    - Record length (80 chars max)
0391                       byte  00                    ;  5    - Character count
0392 6E24 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0393 6E26 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0394                       ;------------------------------------------------------
0395                       ; File descriptor part (variable length)
0396                       ;------------------------------------------------------
0397                       ; byte  12                  ;  9    - File descriptor length
0398                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0399                                                   ;         (Device + '.' + File name)
**** **** ****     > tivi_b1.asm.10901
0050                       copy  "fm.load.asm"         ; File manager loadfile
**** **** ****     > fm.load.asm
0001               * FILE......: fm_load.asm
0002               * Purpose...: High-level file manager module
0003               
0004               *---------------------------------------------------------------
0005               * Load file into editor
0006               *---------------------------------------------------------------
0007               * bl    @fm.loadfile
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * tmp0  = Pointer to length-prefixed string containing both
0011               *         device and filename
0012               ********|*****|*********************|**************************
0013               fm.loadfile:
0014 6E28 0649  14         dect  stack
0015 6E2A C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6E2C C804  38         mov   tmp0,@parm1           ; Setup file to load
     6E2E 8350 
0018 6E30 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E32 696A 
0019 6E34 06A0  32         bl    @idx.init             ; Initialize index
     6E36 6892 
0020 6E38 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E3A 6760 
0021 6E3C 06A0  32         bl    @cmdb.hide            ; Hide command buffer
     6E3E 6BB8 
0022 6E40 C820  54         mov   @parm1,@edb.filename.ptr
     6E42 8350 
     6E44 A30E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6E46 06A0  32         bl    @filv
     6E48 226E 
0028 6E4A 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6E4C 0000 
     6E4E 0004 
0029               
0030 6E50 C160  34         mov   @fb.scrrows,tmp1
     6E52 A298 
0031 6E54 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6E56 A28E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6E58 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6E5A 0050 
0035 6E5C 0205  20         li    tmp1,32               ; Character to fill
     6E5E 0020 
0036               
0037 6E60 06A0  32         bl    @xfilv                ; Fill VDP memory
     6E62 2274 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6E64 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     6E66 6E98 
0045 6E68 C804  38         mov   tmp0,@parm2           ; Register callback 1
     6E6A 8352 
0046               
0047 6E6C 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     6E6E 6ED0 
0048 6E70 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6E72 8354 
0049               
0050 6E74 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     6E76 6F02 
0051 6E78 C804  38         mov   tmp0,@parm4           ; Register callback 3
     6E7A 8356 
0052               
0053 6E7C 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     6E7E 6F34 
0054 6E80 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6E82 8358 
0055               
0056 6E84 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6E86 6C0E 
0057                                                   ; \ i  parm1 = Pointer to length prefixed
0058                                                   ; |            file descriptor
0059                                                   ; | i  parm2 = Pointer to callback
0060                                                   ; |            "loading indicator 1"
0061                                                   ; | i  parm3 = Pointer to callback
0062                                                   ; |            "loading indicator 2"
0063                                                   ; | i  parm4 = Pointer to callback
0064                                                   ; |            "loading indicator 3"
0065                                                   ; | i  parm5 = Pointer to callback
0066                                                   ; /            "File I/O error handler"
0067               
0068 6E88 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6E8A A306 
0069                                                   ; longer dirty.
0070               
0071 6E8C 0204  20         li    tmp0,txt.filetype.DV80
     6E8E 7310 
0072 6E90 C804  38         mov   tmp0,@edb.filetype.ptr
     6E92 A310 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6E94 0460  28         b     @poprt                ; Return to caller
     6E96 2212 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               *---------------------------------------------------------------
0085               * Is expected to be passed as parm2 to @tfh.file.read
0086               *---------------------------------------------------------------
0087               fm.loadfile.callback.indicator1:
0088 6E98 0649  14         dect  stack
0089 6E9A C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Show loading indicators and file descriptor
0092                       ;------------------------------------------------------
0093 6E9C 06A0  32         bl    @hchar
     6E9E 2742 
0094 6EA0 1D03                   byte 29,3,32,77
     6EA2 204D 
0095 6EA4 FFFF                   data EOL
0096               
0097 6EA6 06A0  32         bl    @putat
     6EA8 2410 
0098 6EAA 1D03                   byte 29,3
0099 6EAC 72AE                   data txt.loading      ; Display "Loading...."
0100               
0101 6EAE 8820  54         c     @fh.rleonload,@w$ffff
     6EB0 A444 
     6EB2 202C 
0102 6EB4 1604  14         jne   !
0103 6EB6 06A0  32         bl    @putat
     6EB8 2410 
0104 6EBA 1D44                   byte 29,68
0105 6EBC 72BE                   data txt.rle          ; Display "RLE"
0106               
0107 6EBE 06A0  32 !       bl    @at
     6EC0 264E 
0108 6EC2 1D0E                   byte 29,14            ; Cursor YX position
0109 6EC4 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     6EC6 8350 
0110 6EC8 06A0  32         bl    @xutst0               ; Display device/filename
     6ECA 2400 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.callback.indicator1.exit:
0115 6ECC 0460  28         b     @poprt                ; Return to caller
     6ECE 2212 
0116               
0117               
0118               
0119               
0120               *---------------------------------------------------------------
0121               * Callback function "Show loading indicator 2"
0122               *---------------------------------------------------------------
0123               * Is expected to be passed as parm3 to @tfh.file.read
0124               *---------------------------------------------------------------
0125               fm.loadfile.callback.indicator2:
0126 6ED0 0649  14         dect  stack
0127 6ED2 C64B  30         mov   r11,*stack            ; Save return address
0128               
0129 6ED4 06A0  32         bl    @putnum
     6ED6 2A1E 
0130 6ED8 1D4B                   byte 29,75            ; Show lines read
0131 6EDA A304                   data edb.lines,rambuf,>3020
     6EDC 8390 
     6EDE 3020 
0132               
0133 6EE0 8220  34         c     @fh.kilobytes,tmp4
     6EE2 A432 
0134 6EE4 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0135               
0136 6EE6 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     6EE8 A432 
0137               
0138 6EEA 06A0  32         bl    @putnum
     6EEC 2A1E 
0139 6EEE 1D38                   byte 29,56            ; Show kilobytes read
0140 6EF0 A432                   data fh.kilobytes,rambuf,>3020
     6EF2 8390 
     6EF4 3020 
0141               
0142 6EF6 06A0  32         bl    @putat
     6EF8 2410 
0143 6EFA 1D3D                   byte 29,61
0144 6EFC 72BA                   data txt.kb           ; Show "kb" string
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fm.loadfile.callback.indicator2.exit:
0149 6EFE 0460  28         b     @poprt                ; Return to caller
     6F00 2212 
0150               
0151               
0152               
0153               
0154               
0155               *---------------------------------------------------------------
0156               * Callback function "Show loading indicator 3"
0157               *---------------------------------------------------------------
0158               * Is expected to be passed as parm4 to @tfh.file.read
0159               *---------------------------------------------------------------
0160               fm.loadfile.callback.indicator3:
0161 6F02 0649  14         dect  stack
0162 6F04 C64B  30         mov   r11,*stack            ; Save return address
0163               
0164               
0165 6F06 06A0  32         bl    @hchar
     6F08 2742 
0166 6F0A 1D03                   byte 29,3,32,50       ; Erase loading indicator
     6F0C 2032 
0167 6F0E FFFF                   data EOL
0168               
0169 6F10 06A0  32         bl    @putnum
     6F12 2A1E 
0170 6F14 1D38                   byte 29,56            ; Show kilobytes read
0171 6F16 A432                   data fh.kilobytes,rambuf,>3020
     6F18 8390 
     6F1A 3020 
0172               
0173 6F1C 06A0  32         bl    @putat
     6F1E 2410 
0174 6F20 1D3D                   byte 29,61
0175 6F22 72BA                   data txt.kb           ; Show "kb" string
0176               
0177 6F24 06A0  32         bl    @putnum
     6F26 2A1E 
0178 6F28 1D4B                   byte 29,75            ; Show lines read
0179 6F2A A42E                   data fh.records,rambuf,>3020
     6F2C 8390 
     6F2E 3020 
0180                       ;------------------------------------------------------
0181                       ; Exit
0182                       ;------------------------------------------------------
0183               fm.loadfile.callback.indicator3.exit:
0184 6F30 0460  28         b     @poprt                ; Return to caller
     6F32 2212 
0185               
0186               
0187               
0188               *---------------------------------------------------------------
0189               * Callback function "File I/O error handler"
0190               *---------------------------------------------------------------
0191               * Is expected to be passed as parm5 to @tfh.file.read
0192               ********|*****|*********************|**************************
0193               fm.loadfile.callback.fioerr:
0194 6F34 0649  14         dect  stack
0195 6F36 C64B  30         mov   r11,*stack            ; Save return address
0196               
0197 6F38 06A0  32         bl    @hchar
     6F3A 2742 
0198 6F3C 1D00                   byte 29,0,32,50       ; Erase loading indicator
     6F3E 2032 
0199 6F40 FFFF                   data EOL
0200               
0201                       ;------------------------------------------------------
0202                       ; Display I/O error message
0203                       ;------------------------------------------------------
0204 6F42 06A0  32         bl    @cpym2m
     6F44 2460 
0205 6F46 72C9                   data txt.ioerr+1
0206 6F48 B000                   data cmdb.top
0207 6F4A 0029                   data 41               ; Error message
0208               
0209               
0210 6F4C C120  34         mov   @edb.filename.ptr,tmp0
     6F4E A30E 
0211 6F50 D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 6F52 0986  56         srl   tmp2,8                ; Right align
0213 6F54 0584  14         inc   tmp0                  ; Skip length byte
0214 6F56 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     6F58 B02A 
0215               
0216 6F5A 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     6F5C 2466 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220               
0221               
0222 6F5E 0204  20         li    tmp0,txt.newfile      ; New file
     6F60 72F6 
0223 6F62 C804  38         mov   tmp0,@edb.filename.ptr
     6F64 A30E 
0224               
0225 6F66 0204  20         li    tmp0,txt.filetype.none
     6F68 731C 
0226 6F6A C804  38         mov   tmp0,@edb.filetype.ptr
     6F6C A310 
0227                                                   ; Empty filetype string
0228               
0229 6F6E C820  54         mov   @cmdb.scrrows,@parm1
     6F70 A504 
     6F72 8350 
0230 6F74 06A0  32         bl    @cmdb.show
     6F76 6B86 
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               fm.loadfile.callback.fioerr.exit:
0235 6F78 0460  28         b     @poprt                ; Return to caller
     6F7A 2212 
**** **** ****     > tivi_b1.asm.10901
0051                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: TiVi Editor - Keyboard handling (spectra2 user hook)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Keyboard handling (spectra2 user hook)
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011               hook.keyscan:
0012 6F7C 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     6F7E 2014 
0013 6F80 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 6F82 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6F84 2014 
0019 6F86 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6F88 833C 
     6F8A 833E 
0020 6F8C 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 6F8E C820  54         mov   @waux1,@waux2         ; Save as previous key
     6F90 833C 
     6F92 833E 
0026 6F94 0460  28         b     @edkey.key.process    ; Process key
     6F96 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 6F98 04E0  34         clr   @waux1
     6F9A 833C 
0032 6F9C 04E0  34         clr   @waux2
     6F9E 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 6FA0 0204  20         li    tmp0,2000             ; Avoid key bouncing
     6FA2 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 6FA4 0604  14         dec   tmp0
0043 6FA6 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 6FA8 0460  28         b     @hookok               ; Return
     6FAA 2C7A 
**** **** ****     > tivi_b1.asm.10901
0052                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: TiVi Editor - VDP draw editor panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0010               ***************************************************************
0011               task.vdp.panes:
0012 6FAC C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     6FAE A296 
0013 6FB0 136E  14         jeq   task.vdp.panes.exit   ; No, skip update
0014                       ;------------------------------------------------------
0015                       ; Show banner line
0016                       ;------------------------------------------------------
0017 6FB2 06A0  32         bl    @pane.topline.draw
     6FB4 7100 
0018 6FB6 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     6FB8 832A 
     6FBA A294 
0019                       ;------------------------------------------------------
0020                       ; Determine how many rows to copy
0021                       ;------------------------------------------------------
0022 6FBC 8820  54         c     @edb.lines,@fb.scrrows
     6FBE A304 
     6FC0 A298 
0023 6FC2 1103  14         jlt   task.vdp.panes.setrows.small
0024 6FC4 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     6FC6 A298 
0025 6FC8 1003  14         jmp   task.vdp.panes.copy.framebuffer
0026                       ;------------------------------------------------------
0027                       ; Less lines in editor buffer as rows in frame buffer
0028                       ;------------------------------------------------------
0029               task.vdp.panes.setrows.small:
0030 6FCA C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     6FCC A304 
0031 6FCE 0585  14         inc   tmp1
0032                       ;------------------------------------------------------
0033                       ; Determine area to copy
0034                       ;------------------------------------------------------
0035               task.vdp.panes.copy.framebuffer:
0036 6FD0 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6FD2 A28E 
0037                                                   ; 16 bit part is in tmp2!
0038 6FD4 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6FD6 0050 
0039 6FD8 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6FDA A280 
0040                       ;------------------------------------------------------
0041                       ; Copy memory block
0042                       ;------------------------------------------------------
0043 6FDC 06A0  32         bl    @xpym2v               ; Copy to VDP
     6FDE 241E 
0044                                                   ; \ i  tmp0 = VDP target address
0045                                                   ; | i  tmp1 = RAM source address
0046                                                   ; / i  tmp2 = Bytes to copy
0047 6FE0 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6FE2 A296 
0048                       ;-------------------------------------------------------
0049                       ; Draw EOF marker at end-of-file
0050                       ;-------------------------------------------------------
0051 6FE4 C120  34         mov   @edb.lines,tmp0
     6FE6 A304 
0052 6FE8 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     6FEA A284 
0053 6FEC 05C4  14         inct  tmp0                  ; Y = Y + 2
0054 6FEE 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     6FF0 A298 
0055 6FF2 121C  14         jle   task.vdp.panes.draw_double.line
0056                       ;-------------------------------------------------------
0057                       ; Do actual drawing of EOF marker
0058                       ;-------------------------------------------------------
0059               task.vdp.panes.draw_marker:
0060 6FF4 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0061 6FF6 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     6FF8 832A 
0062               
0063 6FFA 06A0  32         bl    @putstr
     6FFC 23FE 
0064 6FFE 7298                   data txt.marker       ; Display *EOF*
0065                       ;-------------------------------------------------------
0066                       ; Draw empty line after (and below) EOF marker
0067                       ;-------------------------------------------------------
0068 7000 06A0  32         bl    @setx
     7002 2664 
0069 7004 0005                   data  5               ; Cursor after *EOF* string
0070               
0071 7006 C120  34         mov   @wyx,tmp0
     7008 832A 
0072 700A 0984  56         srl   tmp0,8                ; Right justify
0073 700C 0584  14         inc   tmp0                  ; One time adjust
0074 700E 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     7010 A298 
0075 7012 1303  14         jeq   !
0076 7014 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7016 009B 
0077 7018 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0078 701A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     701C 004B 
0079                       ;-------------------------------------------------------
0080                       ; Draw 1 or 2 empty lines
0081                       ;-------------------------------------------------------
0082               task.vdp.panes.draw_marker.empty.line:
0083 701E 0604  14         dec   tmp0                  ; One time adjust
0084 7020 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7022 23DA 
0085 7024 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7026 0020 
0086 7028 06A0  32         bl    @xfilv                ; Fill VDP memory
     702A 2274 
0087                                                   ; i  tmp0 = VDP destination
0088                                                   ; i  tmp1 = byte to write
0089                                                   ; i  tmp2 = Number of bytes to write
0090                       ;-------------------------------------------------------
0091                       ; Draw "double" bottom line (above command buffer)
0092                       ;-------------------------------------------------------
0093               task.vdp.panes.draw_double.line:
0094 702C C120  34         mov   @fb.scrrows,tmp0
     702E A298 
0095 7030 0584  14         inc   tmp0                  ; 1st Line after frame buffer boundary
0096 7032 06C4  14         swpb  tmp0                  ; LSB to MSB
0097 7034 C804  38         mov   tmp0,@wyx             ; Save YX
     7036 832A 
0098               
0099 7038 C120  34         mov   @cmdb.visible,tmp0    ; Command buffer hidden ?
     703A A502 
0100 703C 1306  14         jeq   !                     ; Yes, full double line
0101                       ;-------------------------------------------------------
0102                       ; Double line with corners
0103                       ;-------------------------------------------------------
0104 703E 06A0  32         bl    @setx                 ; Set cursor to screen column 17
     7040 2664 
0105 7042 0001                   data 1
0106 7044 0206  20         li    tmp2,78               ; Repeat 78x
     7046 004E 
0107 7048 1005  14         jmp   task.vdp.panes.draw_double.draw
0108                       ;-------------------------------------------------------
0109                       ; Continuous double line (80 characters)
0110                       ;-------------------------------------------------------
0111 704A 06A0  32 !       bl    @setx                 ; Set cursor to screen column 0
     704C 2664 
0112 704E 0000                   data 0
0113 7050 0206  20         li    tmp2,80               ; Repeat 80x
     7052 0050 
0114                       ;-------------------------------------------------------
0115                       ; Do actual drawing
0116                       ;-------------------------------------------------------
0117               task.vdp.panes.draw_double.draw:
0118 7054 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7056 23DA 
0119 7058 0205  20         li    tmp1,3                ; Character to write (double line)
     705A 0003 
0120 705C 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     705E 2274 
0121                                                   ; | i  tmp0 = VDP destination
0122                                                   ; | i  tmp1 = Byte to write
0123                                                   ; / i  tmp2 = Number of bstes to write
0124 7060 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7062 A294 
     7064 832A 
0125                       ;-------------------------------------------------------
0126                       ; Show command buffer
0127                       ;-------------------------------------------------------
0128 7066 C120  34         mov   @cmdb.visible,tmp0     ; Show command buffer?
     7068 A502 
0129 706A 1311  14         jeq   task.vdp.panes.exit    ; No, skip
0130               
0131 706C 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     706E 6BD2 
0132               
0133 7070 06A0  32         bl    @vchar
     7072 276A 
0134 7074 1400                   byte 20,0,4,1          ; Top left corner
     7076 0401 
0135 7078 1500                   byte 21,0,6,7          ; Left vertical double line
     707A 0607 
0136 707C 1C00                   byte 28,0,8,1          ; Bottom left corner
     707E 0801 
0137 7080 144F                   byte 20,79,5,1         ; Top right corner
     7082 0501 
0138 7084 154F                   byte 21,79,7,7         ; Right vertical double line
     7086 0707 
0139 7088 1C4F                   byte 28,79,9,1         ; Bottom right corner
     708A 0901 
0140 708C FFFF                   data EOL
0141                       ;------------------------------------------------------
0142                       ; Exit task
0143                       ;------------------------------------------------------
0144               task.vdp.panes.exit:
0145 708E 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     7090 7126 
0146 7092 0460  28         b     @slotok
     7094 2CF6 
**** **** ****     > tivi_b1.asm.10901
0053                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: TiVi Editor - VDP copy SAT
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
0010               ********|*****|*********************|**************************
0011               task.vdp.copy.sat:
0012 7096 C120  34         mov   @tv.pane.focus,tmp0
     7098 A216 
0013 709A 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 709C 0284  22         ci    tmp0,pane.focus.cmdb
     709E 0001 
0016 70A0 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 70A2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70A4 FFCE 
0022 70A6 06A0  32         bl    @cpu.crash            ; / Halt system.
     70A8 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 70AA C820  54         mov   @cmdb.yxtop,@wyx
     70AC A508 
     70AE 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 70B0 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     70B2 202A 
0032 70B4 06A0  32         bl    @yx2px                ; Calculate pixel position, result in tmp0
     70B6 2670 
0033 70B8 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     70BA 8380 
0034               
0035 70BC 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     70BE 2418 
0036 70C0 2000                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     70C2 8380 
     70C4 0004 
0037                                                   ; | i  tmp1 = ROM/RAM source
0038                                                   ; / i  tmp2 = Number of bytes to write
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               task.vdp.copy.sat.exit:
0043 70C6 0460  28         b     @slotok               ; Exit task
     70C8 2CF6 
**** **** ****     > tivi_b1.asm.10901
0054                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: TiVi Editor - VDP sprite cursor
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Update cursor shape (blink)
0010               ***************************************************************
0011               task.vdp.cursor:
0012 70CA 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     70CC A292 
0013 70CE 1303  14         jeq   task.vdp.cursor.visible
0014 70D0 04E0  34         clr   @ramsat+2              ; Hide cursor
     70D2 8382 
0015 70D4 100C  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 70D6 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     70D8 A30A 
0019 70DA 1302  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 70DC 04C4  14         clr   tmp0
0025 70DE 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0026                       ;------------------------------------------------------
0027                       ; Cursor in overwrite mode
0028                       ;------------------------------------------------------
0029               task.vdp.cursor.visible.overwrite_mode:
0030 70E0 0204  20         li    tmp0,>0200
     70E2 0200 
0031                       ;------------------------------------------------------
0032                       ; Set cursor shape
0033                       ;------------------------------------------------------
0034               task.vdp.cursor.visible.cursorshape:
0035 70E4 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     70E6 A214 
0036 70E8 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     70EA A214 
     70EC 8382 
0037                       ;------------------------------------------------------
0038                       ; Copy SAT
0039                       ;------------------------------------------------------
0040               task.vdp.cursor.copy.sat:
0041 70EE 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     70F0 2418 
0042 70F2 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     70F4 8380 
     70F6 0004 
0043                                                    ; | i  tmp1 = ROM/RAM source
0044                                                    ; / i  tmp2 = Number of bytes to write
0045                       ;-------------------------------------------------------
0046                       ; Show status bottom line
0047                       ;-------------------------------------------------------
0048 70F8 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     70FA 7126 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               task.vdp.cursor.exit:
0053 70FC 0460  28         b     @slotok                ; Exit task
     70FE 2CF6 
**** **** ****     > tivi_b1.asm.10901
0055                       copy  "pane.topline.asm"    ; Pane banner top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: TiVi Editor - Pane top line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Pane top line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.topline.draw
0010               * Draw TiVi status top line
0011               ***************************************************************
0012               * bl  @pane.topline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.topline.draw:
0021 7100 0649  14         dect  stack
0022 7102 C64B  30         mov   r11,*stack            ; Save return address
0023 7104 C820  54         mov   @wyx,@fb.yxsave
     7106 832A 
     7108 A294 
0024                       ;------------------------------------------------------
0025                       ; Show banner (line above frame buffer, not part of it)
0026                       ;------------------------------------------------------
0027 710A 06A0  32         bl    @hchar
     710C 2742 
0028 710E 0000                   byte 0,0,1,80         ; Double line at top
     7110 0150 
0029 7112 FFFF                   data EOL
0030               
0031 7114 06A0  32         bl    @putat
     7116 2410 
0032 7118 0022                   byte 0,34
0033 711A 7328                   data txt.tivi         ; TiVi banner
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               pane.topline.exit:
0038 711C C820  54         mov   @fb.yxsave,@wyx
     711E A294 
     7120 832A 
0039 7122 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 7124 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.10901
0056                       copy  "pane.botline.asm"    ; Pane status bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: TiVi Editor - Pane status bottom line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Pane status bottom line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.botline.draw
0010               * Draw TiVi status bottom line
0011               ***************************************************************
0012               * bl  @pane.botline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.botline.draw:
0021 7126 0649  14         dect  stack
0022 7128 C64B  30         mov   r11,*stack            ; Save return address
0023 712A 0649  14         dect  stack
0024 712C C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 712E C820  54         mov   @wyx,@fb.yxsave
     7130 832A 
     7132 A294 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 7134 06A0  32         bl    @putat
     7136 2410 
0032 7138 1D00                   byte  29,0
0033 713A 72F2                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 713C 06A0  32         bl    @at
     713E 264E 
0039 7140 1D03                   byte  29,3            ; Position cursor
0040 7142 C160  34         mov   @edb.filename.ptr,tmp1
     7144 A30E 
0041                                                   ; Get string to display
0042 7146 06A0  32         bl    @xutst0               ; Display string
     7148 2400 
0043               
0044 714A 06A0  32         bl    @at
     714C 264E 
0045 714E 1D23                   byte  29,35           ; Position cursor
0046               
0047 7150 C160  34         mov   @edb.filetype.ptr,tmp1
     7152 A310 
0048                                                   ; Get string to display
0049 7154 06A0  32         bl    @xutst0               ; Display Filetype string
     7156 2400 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 7158 C120  34         mov   @edb.insmode,tmp0
     715A A30A 
0055 715C 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 715E 06A0  32         bl    @putat
     7160 2410 
0061 7162 1D32                   byte  29,50
0062 7164 72A4                   data  txt.ovrwrite
0063 7166 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 7168 06A0  32         bl    @putat
     716A 2410 
0069 716C 1D32                   byte  29,50
0070 716E 72A8                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7170 C120  34         mov   @edb.dirty,tmp0
     7172 A306 
0076 7174 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7176 06A0  32         bl    @putat
     7178 2410 
0081 717A 1D36                   byte 29,54
0082 717C 72AC                   data txt.star
0083 717E 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7180 1000  14         nop
0089               pane.botline.show_linecol:
0090 7182 C820  54         mov   @fb.row,@parm1
     7184 A286 
     7186 8350 
0091 7188 06A0  32         bl    @fb.row2line
     718A 67A2 
0092 718C 05A0  34         inc   @outparm1
     718E 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7190 06A0  32         bl    @putnum
     7192 2A1E 
0097 7194 1D40                   byte  29,64           ; YX
0098 7196 8360                   data  outparm1,rambuf
     7198 8390 
0099 719A 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 719C 06A0  32         bl    @putat
     719E 2410 
0105 71A0 1D45                   byte  29,69
0106 71A2 7296                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 71A4 06A0  32         bl    @film
     71A6 2216 
0111 71A8 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     71AA 0020 
     71AC 000C 
0112               
0113 71AE C820  54         mov   @fb.column,@waux1
     71B0 A28C 
     71B2 833C 
0114 71B4 05A0  34         inc   @waux1                ; Offset 1
     71B6 833C 
0115               
0116 71B8 06A0  32         bl    @mknum                ; Convert unsigned number to string
     71BA 29A0 
0117 71BC 833C                   data  waux1,rambuf
     71BE 8390 
0118 71C0 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 71C2 06A0  32         bl    @trimnum              ; Trim number to the left
     71C4 29F8 
0122 71C6 8390                   data  rambuf,rambuf+6,32
     71C8 8396 
     71CA 0020 
0123               
0124 71CC 0204  20         li    tmp0,>0200
     71CE 0200 
0125 71D0 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     71D2 8396 
0126               
0127 71D4 06A0  32         bl    @putat
     71D6 2410 
0128 71D8 1D46                   byte 29,70
0129 71DA 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 71DC C820  54         mov   @fb.row,@parm1
     71DE A286 
     71E0 8350 
0134 71E2 06A0  32         bl    @fb.row2line
     71E4 67A2 
0135 71E6 8820  54         c     @edb.lines,@outparm1
     71E8 A304 
     71EA 8360 
0136 71EC 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 71EE 06A0  32         bl    @putat
     71F0 2410 
0139 71F2 1D4B                   byte 29,75
0140 71F4 729E                   data txt.bottom
0141               
0142 71F6 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 71F8 C820  54         mov   @edb.lines,@waux1
     71FA A304 
     71FC 833C 
0148 71FE 05A0  34         inc   @waux1                ; Offset 1
     7200 833C 
0149 7202 06A0  32         bl    @putnum
     7204 2A1E 
0150 7206 1D4B                   byte 29,75            ; YX
0151 7208 833C                   data waux1,rambuf
     720A 8390 
0152 720C 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 720E C820  54         mov   @fb.yxsave,@wyx
     7210 A294 
     7212 832A 
0159 7214 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 7216 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7218 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.10901
0057                       copy  "data.constants.asm"  ; Data segment - Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: TiVi Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               romsat:
0008 721A 0303             data  >0303,>000f           ; Cursor YX, initial shape and colour
     721C 000F 
0009               
0010               cursors:
0011 721E 0000             data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     7220 0000 
     7222 0000 
     7224 001C 
0012 7226 1010             data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     7228 1010 
     722A 1010 
     722C 1000 
0013 722E 1C1C             data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     7230 1C1C 
     7232 1C1C 
     7234 1C00 
0014               
0015               patterns:
0016 7236 0000             data >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
     7238 FF00 
     723A 00FF 
     723C 0080 
0017 723E 0080             data >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     7240 0000 
     7242 FF00 
     7244 FF00 
0018               patterns.box:
0019 7246 0000             data >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     7248 0000 
     724A FF00 
     724C FF00 
0020 724E 0000             data >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     7250 0000 
     7252 FF80 
     7254 BFA0 
0021 7256 0000             data >0000,>0000,>fc04,>f414 ; 05. Top right corner
     7258 0000 
     725A FC04 
     725C F414 
0022 725E A0A0             data >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7260 A0A0 
     7262 A0A0 
     7264 A0A0 
0023 7266 1414             data >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     7268 1414 
     726A 1414 
     726C 1414 
0024 726E A0A0             data >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7270 A0A0 
     7272 BF80 
     7274 FF00 
0025 7276 1414             data >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     7278 1414 
     727A F404 
     727C FC00 
0026 727E 0000             data >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7280 C0C0 
     7282 C0C0 
     7284 0080 
0027 7286 0000             data >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     7288 0F0F 
     728A 0F0F 
     728C 0000 
0028               
0029               
0030               tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
0031 728E F404             data  >f404                 ; White      | Dark blue  | Dark blue
0032 7290 F101             data  >f101                 ; White      | Black      | Black
0033 7292 1707             data  >1707                 ; Black      | Cyan       | Cyan
0034 7294 1F0F             data  >1f0f                 ; Black      | White      | White
**** **** ****     > tivi_b1.asm.10901
0058                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: TiVi Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 7296 012C             byte  1
0009 7297 ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 7298 052A             byte  5
0014 7299 ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 729E 0520             byte  5
0019 729F ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 72A4 034F             byte  3
0024 72A5 ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 72A8 0349             byte  3
0029 72A9 ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 72AC 012A             byte  1
0034 72AD ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 72AE 0A4C             byte  10
0039 72AF ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 72BA 026B             byte  2
0044 72BB ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 72BE 0352             byte  3
0049 72BF ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 72C2 054C             byte  5
0054 72C3 ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 72C8 293E             byte  41
0059 72C9 ....             text  '> I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 72F2 0223             byte  2
0064 72F3 ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 72F6 0A5B             byte  10
0069 72F7 ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.catalog
0074 7302 0C46             byte  12
0075 7303 ....             text  'File catalog'
0076                       even
0077               
0078               
0079               
0080               txt.filetype.dv80
0081 7310 0A44             byte  10
0082 7311 ....             text  'DIS/VAR80 '
0083                       even
0084               
0085               txt.filetype.none
0086 731C 0A20             byte  10
0087 731D ....             text  '          '
0088                       even
0089               
0090               
0091 7328 0C0A     txt.tivi     byte    12
0092                            byte    10
0093 732A ....                  text    'TiVi v1.00'
0094 7334 0B00                  byte    11
0095                            even
0096               
0097               fdname0
0098 7336 0F44             byte  15
0099 7337 ....             text  'DSK1.FWDOC/PSRV'
0100                       even
0101               
0102               fdname1
0103 7346 0F44             byte  15
0104 7347 ....             text  'DSK1.SPEECHDOCS'
0105                       even
0106               
0107               fdname2
0108 7356 0C44             byte  12
0109 7357 ....             text  'DSK1.XBEADOC'
0110                       even
0111               
0112               fdname3
0113 7364 0C44             byte  12
0114 7365 ....             text  'DSK3.XBEADOC'
0115                       even
0116               
0117               fdname4
0118 7372 0C44             byte  12
0119 7373 ....             text  'DSK3.C99MAN1'
0120                       even
0121               
0122               fdname5
0123 7380 0C44             byte  12
0124 7381 ....             text  'DSK3.C99MAN2'
0125                       even
0126               
0127               fdname6
0128 738E 0C44             byte  12
0129 738F ....             text  'DSK3.C99MAN3'
0130                       even
0131               
0132               fdname7
0133 739C 0D44             byte  13
0134 739D ....             text  'DSK3.C99SPECS'
0135                       even
0136               
0137               fdname8
0138 73AA 0D44             byte  13
0139 73AB ....             text  'DSK3.RANDOM#C'
0140                       even
0141               
0142               fdname9
0143 73B8 0D44             byte  13
0144 73B9 ....             text  'DSK1.INVADERS'
0145                       even
0146               
0147               
0148               
0149               *---------------------------------------------------------------
0150               * Keyboard labels - Function keys
0151               *---------------------------------------------------------------
0152               txt.fctn.0
0153 73C6 0866             byte  8
0154 73C7 ....             text  'fctn + 0'
0155                       even
0156               
0157               txt.fctn.1
0158 73D0 0866             byte  8
0159 73D1 ....             text  'fctn + 1'
0160                       even
0161               
0162               txt.fctn.2
0163 73DA 0866             byte  8
0164 73DB ....             text  'fctn + 2'
0165                       even
0166               
0167               txt.fctn.3
0168 73E4 0866             byte  8
0169 73E5 ....             text  'fctn + 3'
0170                       even
0171               
0172               txt.fctn.4
0173 73EE 0866             byte  8
0174 73EF ....             text  'fctn + 4'
0175                       even
0176               
0177               txt.fctn.5
0178 73F8 0866             byte  8
0179 73F9 ....             text  'fctn + 5'
0180                       even
0181               
0182               txt.fctn.6
0183 7402 0866             byte  8
0184 7403 ....             text  'fctn + 6'
0185                       even
0186               
0187               txt.fctn.7
0188 740C 0866             byte  8
0189 740D ....             text  'fctn + 7'
0190                       even
0191               
0192               txt.fctn.8
0193 7416 0866             byte  8
0194 7417 ....             text  'fctn + 8'
0195                       even
0196               
0197               txt.fctn.9
0198 7420 0866             byte  8
0199 7421 ....             text  'fctn + 9'
0200                       even
0201               
0202               txt.fctn.a
0203 742A 0866             byte  8
0204 742B ....             text  'fctn + a'
0205                       even
0206               
0207               txt.fctn.b
0208 7434 0866             byte  8
0209 7435 ....             text  'fctn + b'
0210                       even
0211               
0212               txt.fctn.c
0213 743E 0866             byte  8
0214 743F ....             text  'fctn + c'
0215                       even
0216               
0217               txt.fctn.d
0218 7448 0866             byte  8
0219 7449 ....             text  'fctn + d'
0220                       even
0221               
0222               txt.fctn.e
0223 7452 0866             byte  8
0224 7453 ....             text  'fctn + e'
0225                       even
0226               
0227               txt.fctn.f
0228 745C 0866             byte  8
0229 745D ....             text  'fctn + f'
0230                       even
0231               
0232               txt.fctn.g
0233 7466 0866             byte  8
0234 7467 ....             text  'fctn + g'
0235                       even
0236               
0237               txt.fctn.h
0238 7470 0866             byte  8
0239 7471 ....             text  'fctn + h'
0240                       even
0241               
0242               txt.fctn.i
0243 747A 0866             byte  8
0244 747B ....             text  'fctn + i'
0245                       even
0246               
0247               txt.fctn.j
0248 7484 0866             byte  8
0249 7485 ....             text  'fctn + j'
0250                       even
0251               
0252               txt.fctn.k
0253 748E 0866             byte  8
0254 748F ....             text  'fctn + k'
0255                       even
0256               
0257               txt.fctn.l
0258 7498 0866             byte  8
0259 7499 ....             text  'fctn + l'
0260                       even
0261               
0262               txt.fctn.m
0263 74A2 0866             byte  8
0264 74A3 ....             text  'fctn + m'
0265                       even
0266               
0267               txt.fctn.n
0268 74AC 0866             byte  8
0269 74AD ....             text  'fctn + n'
0270                       even
0271               
0272               txt.fctn.o
0273 74B6 0866             byte  8
0274 74B7 ....             text  'fctn + o'
0275                       even
0276               
0277               txt.fctn.p
0278 74C0 0866             byte  8
0279 74C1 ....             text  'fctn + p'
0280                       even
0281               
0282               txt.fctn.q
0283 74CA 0866             byte  8
0284 74CB ....             text  'fctn + q'
0285                       even
0286               
0287               txt.fctn.r
0288 74D4 0866             byte  8
0289 74D5 ....             text  'fctn + r'
0290                       even
0291               
0292               txt.fctn.s
0293 74DE 0866             byte  8
0294 74DF ....             text  'fctn + s'
0295                       even
0296               
0297               txt.fctn.t
0298 74E8 0866             byte  8
0299 74E9 ....             text  'fctn + t'
0300                       even
0301               
0302               txt.fctn.u
0303 74F2 0866             byte  8
0304 74F3 ....             text  'fctn + u'
0305                       even
0306               
0307               txt.fctn.v
0308 74FC 0866             byte  8
0309 74FD ....             text  'fctn + v'
0310                       even
0311               
0312               txt.fctn.w
0313 7506 0866             byte  8
0314 7507 ....             text  'fctn + w'
0315                       even
0316               
0317               txt.fctn.x
0318 7510 0866             byte  8
0319 7511 ....             text  'fctn + x'
0320                       even
0321               
0322               txt.fctn.y
0323 751A 0866             byte  8
0324 751B ....             text  'fctn + y'
0325                       even
0326               
0327               txt.fctn.z
0328 7524 0866             byte  8
0329 7525 ....             text  'fctn + z'
0330                       even
0331               
0332               *---------------------------------------------------------------
0333               * Keyboard labels - Function keys extra
0334               *---------------------------------------------------------------
0335               txt.fctn.dot
0336 752E 0866             byte  8
0337 752F ....             text  'fctn + .'
0338                       even
0339               
0340               txt.fctn.plus
0341 7538 0866             byte  8
0342 7539 ....             text  'fctn + +'
0343                       even
0344               
0345               *---------------------------------------------------------------
0346               * Keyboard labels - Control keys
0347               *---------------------------------------------------------------
0348               txt.ctrl.0
0349 7542 0863             byte  8
0350 7543 ....             text  'ctrl + 0'
0351                       even
0352               
0353               txt.ctrl.1
0354 754C 0863             byte  8
0355 754D ....             text  'ctrl + 1'
0356                       even
0357               
0358               txt.ctrl.2
0359 7556 0863             byte  8
0360 7557 ....             text  'ctrl + 2'
0361                       even
0362               
0363               txt.ctrl.3
0364 7560 0863             byte  8
0365 7561 ....             text  'ctrl + 3'
0366                       even
0367               
0368               txt.ctrl.4
0369 756A 0863             byte  8
0370 756B ....             text  'ctrl + 4'
0371                       even
0372               
0373               txt.ctrl.5
0374 7574 0863             byte  8
0375 7575 ....             text  'ctrl + 5'
0376                       even
0377               
0378               txt.ctrl.6
0379 757E 0863             byte  8
0380 757F ....             text  'ctrl + 6'
0381                       even
0382               
0383               txt.ctrl.7
0384 7588 0863             byte  8
0385 7589 ....             text  'ctrl + 7'
0386                       even
0387               
0388               txt.ctrl.8
0389 7592 0863             byte  8
0390 7593 ....             text  'ctrl + 8'
0391                       even
0392               
0393               txt.ctrl.9
0394 759C 0863             byte  8
0395 759D ....             text  'ctrl + 9'
0396                       even
0397               
0398               txt.ctrl.a
0399 75A6 0863             byte  8
0400 75A7 ....             text  'ctrl + a'
0401                       even
0402               
0403               txt.ctrl.b
0404 75B0 0863             byte  8
0405 75B1 ....             text  'ctrl + b'
0406                       even
0407               
0408               txt.ctrl.c
0409 75BA 0863             byte  8
0410 75BB ....             text  'ctrl + c'
0411                       even
0412               
0413               txt.ctrl.d
0414 75C4 0863             byte  8
0415 75C5 ....             text  'ctrl + d'
0416                       even
0417               
0418               txt.ctrl.e
0419 75CE 0863             byte  8
0420 75CF ....             text  'ctrl + e'
0421                       even
0422               
0423               txt.ctrl.f
0424 75D8 0863             byte  8
0425 75D9 ....             text  'ctrl + f'
0426                       even
0427               
0428               txt.ctrl.g
0429 75E2 0863             byte  8
0430 75E3 ....             text  'ctrl + g'
0431                       even
0432               
0433               txt.ctrl.h
0434 75EC 0863             byte  8
0435 75ED ....             text  'ctrl + h'
0436                       even
0437               
0438               txt.ctrl.i
0439 75F6 0863             byte  8
0440 75F7 ....             text  'ctrl + i'
0441                       even
0442               
0443               txt.ctrl.j
0444 7600 0863             byte  8
0445 7601 ....             text  'ctrl + j'
0446                       even
0447               
0448               txt.ctrl.k
0449 760A 0863             byte  8
0450 760B ....             text  'ctrl + k'
0451                       even
0452               
0453               txt.ctrl.l
0454 7614 0863             byte  8
0455 7615 ....             text  'ctrl + l'
0456                       even
0457               
0458               txt.ctrl.m
0459 761E 0863             byte  8
0460 761F ....             text  'ctrl + m'
0461                       even
0462               
0463               txt.ctrl.n
0464 7628 0863             byte  8
0465 7629 ....             text  'ctrl + n'
0466                       even
0467               
0468               txt.ctrl.o
0469 7632 0863             byte  8
0470 7633 ....             text  'ctrl + o'
0471                       even
0472               
0473               txt.ctrl.p
0474 763C 0863             byte  8
0475 763D ....             text  'ctrl + p'
0476                       even
0477               
0478               txt.ctrl.q
0479 7646 0863             byte  8
0480 7647 ....             text  'ctrl + q'
0481                       even
0482               
0483               txt.ctrl.r
0484 7650 0863             byte  8
0485 7651 ....             text  'ctrl + r'
0486                       even
0487               
0488               txt.ctrl.s
0489 765A 0863             byte  8
0490 765B ....             text  'ctrl + s'
0491                       even
0492               
0493               txt.ctrl.t
0494 7664 0863             byte  8
0495 7665 ....             text  'ctrl + t'
0496                       even
0497               
0498               txt.ctrl.u
0499 766E 0863             byte  8
0500 766F ....             text  'ctrl + u'
0501                       even
0502               
0503               txt.ctrl.v
0504 7678 0863             byte  8
0505 7679 ....             text  'ctrl + v'
0506                       even
0507               
0508               txt.ctrl.w
0509 7682 0863             byte  8
0510 7683 ....             text  'ctrl + w'
0511                       even
0512               
0513               txt.ctrl.x
0514 768C 0863             byte  8
0515 768D ....             text  'ctrl + x'
0516                       even
0517               
0518               txt.ctrl.y
0519 7696 0863             byte  8
0520 7697 ....             text  'ctrl + y'
0521                       even
0522               
0523               txt.ctrl.z
0524 76A0 0863             byte  8
0525 76A1 ....             text  'ctrl + z'
0526                       even
0527               
0528               *---------------------------------------------------------------
0529               * Keyboard labels - control keys extra
0530               *---------------------------------------------------------------
0531               txt.ctrl.plus
0532 76AA 0863             byte  8
0533 76AB ....             text  'ctrl + +'
0534                       even
0535               
0536               *---------------------------------------------------------------
0537               * Special keys
0538               *---------------------------------------------------------------
0539               txt.enter
0540 76B4 0565             byte  5
0541 76B5 ....             text  'enter'
0542                       even
0543               
**** **** ****     > tivi_b1.asm.10901
0059                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: TiVi Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      0000     key.fctn.0    equ >0000             ; fctn + 0
0008      0300     key.fctn.1    equ >0300             ; fctn + 1
0009      0400     key.fctn.2    equ >0400             ; fctn + 2
0010      0700     key.fctn.3    equ >0700             ; fctn + 3
0011      0000     key.fctn.4    equ >0000             ; fctn + 4
0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0013      0000     key.fctn.6    equ >0000             ; fctn + 6
0014      0000     key.fctn.7    equ >0000             ; fctn + 7
0015      0000     key.fctn.8    equ >0000             ; fctn + 8
0016      0F00     key.fctn.9    equ >0f00             ; fctn + 9
0017      0000     key.fctn.a    equ >0000             ; fctn + a
0018      0000     key.fctn.b    equ >0000             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      0000     key.fctn.h    equ >0000             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      0000     key.fctn.j    equ >0000             ; fctn + j
0027      0000     key.fctn.k    equ >0000             ; fctn + k
0028      0000     key.fctn.l    equ >0000             ; fctn + l
0029      0000     key.fctn.m    equ >0000             ; fctn + m
0030      0000     key.fctn.n    equ >0000             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      0000     key.fctn.q    equ >0000             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      0000     key.fctn.v    equ >0000             ; fctn + v
0039      0000     key.fctn.w    equ >0000             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      0000     key.fctn.y    equ >0000             ; fctn + y
0042      0000     key.fctn.z    equ >0000             ; fctn + z
0043               *---------------------------------------------------------------
0044               * Keyboard scancodes - Function keys extra
0045               *---------------------------------------------------------------
0046      B900     key.fctn.dot  equ >b900             ; fctn + .
0047      0500     key.fctn.plus equ >0500             ; fctn + +
0048               *---------------------------------------------------------------
0049               * Keyboard scancodes - control keys
0050               *-------------|---------------------|---------------------------
0051      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0052      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0053      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0054      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0055      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0056      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0057      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0058      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0059      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0060      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0061      8100     key.ctrl.a    equ >8100             ; ctrl + a
0062      8200     key.ctrl.b    equ >8200             ; ctrl + b
0063      0000     key.ctrl.c    equ >0000             ; ctrl + c
0064      8400     key.ctrl.d    equ >8400             ; ctrl + d
0065      8500     key.ctrl.e    equ >8500             ; ctrl + e
0066      8600     key.ctrl.f    equ >8600             ; ctrl + f
0067      0000     key.ctrl.g    equ >0000             ; ctrl + g
0068      0000     key.ctrl.h    equ >0000             ; ctrl + h
0069      0000     key.ctrl.i    equ >0000             ; ctrl + i
0070      0000     key.ctrl.j    equ >0000             ; ctrl + j
0071      0000     key.ctrl.k    equ >0000             ; ctrl + k
0072      0000     key.ctrl.l    equ >0000             ; ctrl + l
0073      0000     key.ctrl.m    equ >0000             ; ctrl + m
0074      0000     key.ctrl.n    equ >0000             ; ctrl + n
0075      0000     key.ctrl.o    equ >0000             ; ctrl + o
0076      0000     key.ctrl.p    equ >0000             ; ctrl + p
0077      0000     key.ctrl.q    equ >0000             ; ctrl + q
0078      0000     key.ctrl.r    equ >0000             ; ctrl + r
0079      9300     key.ctrl.s    equ >9300             ; ctrl + s
0080      9400     key.ctrl.t    equ >9400             ; ctrl + t
0081      0000     key.ctrl.u    equ >0000             ; ctrl + u
0082      0000     key.ctrl.v    equ >0000             ; ctrl + v
0083      0000     key.ctrl.w    equ >0000             ; ctrl + w
0084      9800     key.ctrl.x    equ >9800             ; ctrl + x
0085      0000     key.ctrl.y    equ >0000             ; ctrl + y
0086      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0087               *---------------------------------------------------------------
0088               * Keyboard scancodes - control keys extra
0089               *---------------------------------------------------------------
0090      9D00     key.ctrl.plus equ >9d00             ; ctrl + +
0091               *---------------------------------------------------------------
0092               * Special keys
0093               *---------------------------------------------------------------
0094      0D00     key.enter     equ >0d00             ; enter
0095               
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Action keys mapping table: Editor
0100               *---------------------------------------------------------------
0101               keymap_actions.editor:
0102                       ;-------------------------------------------------------
0103                       ; Movement keys
0104                       ;-------------------------------------------------------
0105 76BA 0D00             data  key.enter, txt.enter, edkey.action.enter
     76BC 76B4 
     76BE 6550 
0106 76C0 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     76C2 74DE 
     76C4 6146 
0107 76C6 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     76C8 7448 
     76CA 615C 
0108 76CC 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     76CE 7452 
     76D0 6174 
0109 76D2 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     76D4 7510 
     76D6 61C6 
0110 76D8 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     76DA 75A6 
     76DC 6232 
0111 76DE 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     76E0 75D8 
     76E2 624A 
0112 76E4 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     76E6 765A 
     76E8 625E 
0113 76EA 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     76EC 75C4 
     76EE 62B0 
0114 76F0 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     76F2 75CE 
     76F4 6310 
0115 76F6 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     76F8 768C 
     76FA 6356 
0116 76FC 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     76FE 7664 
     7700 6382 
0117 7702 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7704 75B0 
     7706 63B2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7708 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     770A 73D0 
     770C 63F2 
0122 770E 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7710 760A 
     7712 642A 
0123 7714 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7716 73E4 
     7718 645E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 771A 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     771C 73DA 
     771E 64B6 
0128 7720 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7722 752E 
     7724 65BE 
0129 7726 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7728 73F8 
     772A 650C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 772C 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     772E 7538 
     7730 660E 
0134 7732 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7734 7420 
     7736 661A 
0135 7738 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     773A 76A0 
     773C 6638 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 773E B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7740 7542 
     7742 667A 
0140 7744 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7746 754C 
     7748 6680 
0141 774A B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     774C 7556 
     774E 6686 
0142 7750 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7752 7560 
     7754 668C 
0143 7756 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7758 756A 
     775A 6692 
0144 775C B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     775E 7574 
     7760 6698 
0145 7762 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7764 757E 
     7766 669E 
0146 7768 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     776A 7588 
     776C 66A4 
0147 776E 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7770 7592 
     7772 66AA 
0148 7774 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7776 759C 
     7778 66B0 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 777A FFFF             data  EOL                           ; EOL
0153               
0154               
0155               
0156               
0157               *---------------------------------------------------------------
0158               * Action keys mapping table: Command Buffer (CMDB)
0159               *---------------------------------------------------------------
0160               keymap_actions.cmdb:
0161                       ;-------------------------------------------------------
0162                       ; Movement keys
0163                       ;-------------------------------------------------------
0164 777C 0D00             data  key.enter, txt.enter, edkey.action.enter
     777E 76B4 
     7780 6550 
0165 7782 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7784 74DE 
     7786 6146 
0166 7788 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     778A 7448 
     778C 615C 
0167 778E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     7790 7452 
     7792 6616 
0168 7794 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     7796 7510 
     7798 6616 
0169 779A 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
     779C 75A6 
     779E 6616 
0170 77A0 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
     77A2 75D8 
     77A4 6616 
0171 77A6 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     77A8 765A 
     77AA 6616 
0172 77AC 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     77AE 75C4 
     77B0 6616 
0173 77B2 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     77B4 75CE 
     77B6 6616 
0174 77B8 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     77BA 768C 
     77BC 6616 
0175 77BE 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     77C0 7664 
     77C2 6616 
0176 77C4 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     77C6 75B0 
     77C8 6616 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 77CA 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     77CC 73D0 
     77CE 63F2 
0181 77D0 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     77D2 760A 
     77D4 642A 
0182 77D6 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     77D8 73E4 
     77DA 6616 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 77DC 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     77DE 73DA 
     77E0 64B6 
0187 77E2 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     77E4 752E 
     77E6 65BE 
0188 77E8 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     77EA 73F8 
     77EC 6616 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 77EE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     77F0 7538 
     77F2 660E 
0193 77F4 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     77F6 7420 
     77F8 661A 
0194 77FA 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     77FC 76A0 
     77FE 6638 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 7800 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7802 7542 
     7804 667A 
0199 7806 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7808 754C 
     780A 6680 
0200 780C B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     780E 7556 
     7810 6686 
0201 7812 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7814 7560 
     7816 668C 
0202 7818 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     781A 756A 
     781C 6692 
0203 781E B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7820 7574 
     7822 6698 
0204 7824 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7826 757E 
     7828 669E 
0205 782A B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     782C 7588 
     782E 66A4 
0206 7830 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7832 7592 
     7834 66AA 
0207 7836 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7838 759C 
     783A 66B0 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 783C FFFF             data  EOL                           ; EOL
**** **** ****     > tivi_b1.asm.10901
0060               
0064 783E 783E                   data $                ; Bank 1 ROM size OK.
0066               
0067               *--------------------------------------------------------------
0068               * Video mode configuration
0069               *--------------------------------------------------------------
0070      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0071      0004     spfbck  equ   >04                   ; Screen background color.
0072      21F6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0073      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0074      0050     colrow  equ   80                    ; Columns per row
0075      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0076      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0077      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0078      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
