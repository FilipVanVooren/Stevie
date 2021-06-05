XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.1390892
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210605-1390892
0010               *
0011               * Bank 1 "James"
0012               *
0013               ***************************************************************
0014                       copy  "rom.build.asm"       ; Cartridge build options
**** **** ****     > rom.build.asm
0001               * FILE......: rom.build.asm
0002               * Purpose...: Equates with cartridge build options
0003               
0004               *--------------------------------------------------------------
0005               * Skip unused spectra2 code modules for reduced code size
0006               *--------------------------------------------------------------
0007      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0008      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0009      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0010      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0011      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0012      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0013      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0014      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0015      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0016      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0017      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0018      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0019      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0020      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0021      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0022      0001     skip_random_generator     equ  1       ; Skip random functions
0023      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0024      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0025               
0026               *--------------------------------------------------------------
0027               * Classic99 F18a 24x80, no FG99 advanced mode
0028               *--------------------------------------------------------------
0029      0001     device.f18a               equ  1       ; F18a GPU
0030      0000     device.9938               equ  0       ; 9938 GPU
0031      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0032               
0033               
0034               *--------------------------------------------------------------
0035               * JS99er F18a 30x80, FG99 advanced mode
0036               *--------------------------------------------------------------
0037               ; device.f18a             equ  0       ; F18a GPU
0038               ; device.9938             equ  1       ; 9938 GPU
0039               ; device.fg99.mode.adv    equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b1.asm.1390892
0015                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
**** **** ****     > rom.order.asm
0001               * FILE......: rom.order.asm
0002               * Purpose...: Equates with CPU write addresses for switching banks
0003               
0004               *--------------------------------------------------------------
0005               * ROM 8K/4K banks. Bank order (non-inverted)
0006               *--------------------------------------------------------------
0007      6000     bank0.rom                 equ  >6000   ; Jill
0008      6002     bank1.rom                 equ  >6002   ; James
0009      6004     bank2.rom                 equ  >6004   ; Jacky
0010      6006     bank3.rom                 equ  >6006   ; John
0011      6008     bank4.rom                 equ  >6008   ; Janine
0012               *--------------------------------------------------------------
0013               * RAM 4K banks (Only valid in advance mode FG99)
0014               *--------------------------------------------------------------
0015      6800     bank0.ram                 equ  >6800   ; Jill
0016      6802     bank1.ram                 equ  >6802   ; James
0017      6804     bank2.ram                 equ  >6804   ; Jacky
0018      6806     bank3.ram                 equ  >6806   ; John
0019      6808     bank4.ram                 equ  >6808   ; Janine
**** **** ****     > stevie_b1.asm.1390892
0016                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
0001               * FILE......: equates.asm
0002               * Purpose...: The main equates file for Stevie editor
0003               
0004               
0005               *===============================================================================
0006               * Memory map
0007               * ==========
0008               *
0009               * LOW MEMORY EXPANSION (2000-2fff)
0010               *
0011               *     Mem range   Bytes    SAMS   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     2000-2f1f    3872           SP2 library
0014               *     2f20-2f3f      32           Function input/output parameters
0015               *     2f40-2f43       4           Keyboard
0016               *     2f4a-2f59      16           Timer tasks table
0017               *     2f5a-2f69      16           Sprite attribute table in RAM
0018               *     2f6a-2f9f      54           RAM buffer
0019               *     2fa0-2fff      96           Value/Return stack (grows downwards from 2fff)
0020               *
0021               *
0022               * LOW MEMORY EXPANSION (3000-3fff)
0023               *
0024               *     Mem range   Bytes    SAMS   Purpose
0025               *     =========   =====    ====   ==================================
0026               *     3000-3fff    4096           Resident Stevie Modules
0027               *
0028               *
0029               * HIGH MEMORY EXPANSION (a000-ffff)
0030               *
0031               *     Mem range   Bytes    SAMS   Purpose
0032               *     =========   =====    ====   ==================================
0033               *     a000-a0ff     256           Stevie Editor shared structure
0034               *     a100-a1ff     256           Framebuffer structure
0035               *     a200-a2ff     256           Editor buffer structure
0036               *     a300-a3ff     256           Command buffer structure
0037               *     a400-a4ff     256           File handle structure
0038               *     a500-a5ff     256           Index structure
0039               *     a600-af5f    2400           Frame buffer
0040               *     af60-afff     ???           *FREE*
0041               *
0042               *     b000-bfff    4096           Index buffer page
0043               *     c000-cfff    4096           Editor buffer page
0044               *     d000-dfff    4096           CMDB history / Editor buffer page (temporary)
0045               *     e000-ebff    3072           Heap
0046               *     ec00-efff    1024           Farjump return stack (trampolines)
0047               *     f000-ffff    4096           *FREE*
0048               *
0049               *
0050               * CARTRIDGE SPACE (6000-7fff)
0051               *
0052               *     Mem range   Bytes    BANK   Purpose
0053               *     =========   =====    ====   ==================================
0054               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0055               *     7f9c-7fff      64       0   Vector table (32 vectors)
0056               *     ..............................................................
0057               *     6000-7f9b    8128       1   Stevie program code
0058               *     7f9c-7fff      64       1   Vector table (32 vectors)
0059               *     ..............................................................
0060               *     6000-7f9b    8128       2   Stevie program code
0061               *     7f9c-7fff      64       2   Vector table (32 vectors)
0062               *     ..............................................................
0063               *     6000-7f9b    8128       3   Stevie program code
0064               *     7f9c-7fff      64       3   Vector table (32 vectors)
0065               *
0066               *
0067               * VDP RAM F18a (0000-47ff)
0068               *
0069               *     Mem range   Bytes    Hex    Purpose
0070               *     =========   =====   =====   =================================
0071               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0072               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0073               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0074               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0075               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0076               *                                      (Position based colors F18a, 80 colums)
0077               *     2180                        SAT: Sprite Attribute Table
0078               *                                      (Cursor in F18a, 80 cols mode)
0079               *     2800                        SPT: Sprite Pattern Table
0080               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0081               *===============================================================================
0082               
0083               *--------------------------------------------------------------
0084               * Graphics mode selection
0085               *--------------------------------------------------------------
0087               
0088      001D     pane.botrow               equ  29      ; Bottom row on screen
0089               
0095               *--------------------------------------------------------------
0096               * Stevie Dialog / Pane specific equates
0097               *--------------------------------------------------------------
0098      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0099      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0100               *--------------------------------------------------------------
0101               * Stevie specific equates
0102               *--------------------------------------------------------------
0103      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0104      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0105      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0106      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0107      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0108      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0109                                                      ; VDP TAT address of 1st CMDB row
0110      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0111                                                      ; VDP SIT size 80 columns, 24/30 rows
0112      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0113      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0114               ;-----------------------------------------------------------------
0115               ;   Dialog ID's >= 100 indicate that command prompt should be
0116               ;   hidden and no characters added to CMDB keyboard buffer
0117               ;-----------------------------------------------------------------
0118      000A     id.dialog.load            equ  10      ; ID dialog "Load DV80 file"
0119      000B     id.dialog.save            equ  11      ; ID dialog "Save DV80 file"
0120      000C     id.dialog.saveblock       equ  12      ; ID dialog "Save codeblock to DV80 file"
0121      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0122      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0123      0067     id.dialog.about           equ  103     ; ID dialog "About"
0124      0068     id.dialog.file            equ  104     ; ID dialog "File"
0125               *--------------------------------------------------------------
0126               * SPECTRA2 / Stevie startup options
0127               *--------------------------------------------------------------
0128      0001     debug                     equ  1       ; Turn on spectra2 debugging
0129      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0130      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0131      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0132               *--------------------------------------------------------------
0133               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0134               *--------------------------------------------------------------
0135      2F20     parm1             equ  >2f20           ; Function parameter 1
0136      2F22     parm2             equ  >2f22           ; Function parameter 2
0137      2F24     parm3             equ  >2f24           ; Function parameter 3
0138      2F26     parm4             equ  >2f26           ; Function parameter 4
0139      2F28     parm5             equ  >2f28           ; Function parameter 5
0140      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0141      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0142      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0143      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0144      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0145      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0146      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0147      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0148      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0149      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0150      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0151      2F40     keycode1          equ  >2f40           ; Current key scanned
0152      2F42     keycode2          equ  >2f42           ; Previous key scanned
0153      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0154      2F4A     timers            equ  >2f4a           ; Timer table
0155      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0156      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0157               *--------------------------------------------------------------
0158               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0159               *--------------------------------------------------------------
0160      A000     tv.top            equ  >a000           ; Structure begin
0161      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0162      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0163      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0164      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0165      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0166      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0167      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0168      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0169      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0170      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0171      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0172      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0173      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0174      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0175      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0176      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0177      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0178      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0179      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0180      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0181      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0182      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0183      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0184               *--------------------------------------------------------------
0185               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0186               *--------------------------------------------------------------
0187      A100     fb.struct         equ  >a100           ; Structure begin
0188      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0189      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0190      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0191                                                      ; line X in editor buffer).
0192      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0193                                                      ; (offset 0 .. @fb.scrrows)
0194      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0195      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0196      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0197      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0198      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0199      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0200      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0201      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0202      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0203      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0204      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0205      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0206      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0207      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0208               *--------------------------------------------------------------
0209               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0210               *--------------------------------------------------------------
0211      A200     edb.struct        equ  >a200           ; Begin structure
0212      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0213      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0214      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0215      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0216      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0217      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0218      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0219      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0220      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0221      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0222                                                      ; with current filename.
0223      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0224                                                      ; with current file type.
0225      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0226      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0227      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0228                                                      ; for filename, but not always used.
0229      A269     edb.free          equ  edb.struct + 105; End of structure
0230               *--------------------------------------------------------------
0231               * Command buffer structure            @>a300-a3ff   (256 bytes)
0232               *--------------------------------------------------------------
0233      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0234      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0235      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0236      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0237      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0238      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0239      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0240      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0241      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0242      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0243      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0244      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0245      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0246      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0247      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0248      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0249      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0250      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0251      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0252      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0253      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0254      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0255      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0256               *--------------------------------------------------------------
0257               * File handle structure               @>a400-a4ff   (256 bytes)
0258               *--------------------------------------------------------------
0259      A400     fh.struct         equ  >a400           ; stevie file handling structures
0260               ;***********************************************************************
0261               ; ATTENTION
0262               ; The dsrlnk variables must form a continuous memory block and keep
0263               ; their order!
0264               ;***********************************************************************
0265      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0266      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0267      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0268      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0269      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0270      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0271      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0272      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0273      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0274      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0275      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0276      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0277      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0278      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0279      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0280      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0281      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0282      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0283      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0284      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0285      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0286      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0287      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0288      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0289      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0290      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0291      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0292      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0293      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0294      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0295      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0296      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0297               *--------------------------------------------------------------
0298               * Index structure                     @>a500-a5ff   (256 bytes)
0299               *--------------------------------------------------------------
0300      A500     idx.struct        equ  >a500           ; stevie index structure
0301      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0302      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0303      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0304               *--------------------------------------------------------------
0305               * Frame buffer                        @>a600-afff  (2560 bytes)
0306               *--------------------------------------------------------------
0307      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0308      0960     fb.size           equ  80*30           ; Frame buffer size
0309               *--------------------------------------------------------------
0310               * Index                               @>b000-bfff  (4096 bytes)
0311               *--------------------------------------------------------------
0312      B000     idx.top           equ  >b000           ; Top of index
0313      1000     idx.size          equ  4096            ; Index size
0314               *--------------------------------------------------------------
0315               * Editor buffer                       @>c000-cfff  (4096 bytes)
0316               *--------------------------------------------------------------
0317      C000     edb.top           equ  >c000           ; Editor buffer high memory
0318      1000     edb.size          equ  4096            ; Editor buffer size
0319               *--------------------------------------------------------------
0320               * Command history buffer              @>d000-dfff  (4096 bytes)
0321               *--------------------------------------------------------------
0322      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0323      1000     cmdb.size         equ  4096            ; Command buffer size
0324               *--------------------------------------------------------------
0325               * Heap                                @>e000-ebff  (3072 bytes)
0326               *--------------------------------------------------------------
0327      E000     heap.top          equ  >e000           ; Top of heap
0328               *--------------------------------------------------------------
0329               * Farjump return stack                @>ec00-efff  (1024 bytes)
0330               *--------------------------------------------------------------
0331      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.1390892
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 1
0025               ********|*****|*********************|**************************
0026      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank
0029                       copy  "rom.header.asm"      ; Include cartridge header
**** **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA01             byte  >aa                   ; 0  Standard header                   >6000
0008                       byte  >01                   ; 1  Version number
0009 6002 0100             byte  >01                   ; 2  Number of programs (optional)     >6002
0010                       byte  0                     ; 3  Reserved ('R' = adv. mode FG99)
0011               
0012 6004 0000             data  >0000                 ; 4  \ Pointer to power-up list        >6004
0013                                                   ; 5  /
0014               
0015 6006 600C             data  rom.program1          ; 6  \ Pointer to program list         >6006
0016                                                   ; 7  /
0017               
0018 6008 0000             data  >0000                 ; 8  \ Pointer to DSR list             >6008
0019                                                   ; 9  /
0020               
0021 600A 0000             data  >0000                 ; 10 \ Pointer to subprogram list      >600a
0022                                                   ; 11 /
0023               
0024                       ;-----------------------------------------------------------------------
0025                       ; Program list entry
0026                       ;-----------------------------------------------------------------------
0027               rom.program1:
0028 600C 0000             data  >0000                 ; 12 \ Next program list entry         >600c
0029                                                   ; 13 / (no more items following)
0030               
0031 600E 6030             data  kickstart.code1       ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0035               
0043               
0044 6010 1253             byte  18
0045 6011 ....             text  'STEVIE 1.1K (F18A)'
0046                       even
0047               
0049               
**** **** ****     > stevie_b1.asm.1390892
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6030
0035 6030 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6032 6000 
0036               ***************************************************************
0037               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0038               ********|*****|*********************|**************************
0039                       aorg  >2000
0040                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0030               * skip_textmode             equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a             equ  1  ; Skip f18a support
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
0061               * skip_cpu_strings          equ  1  ; Skip string support utilities
0062               
0063               * == Kernel/Multitasking
0064               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0065               * skip_mem_paging           equ  1  ; Skip support for memory paging
0066               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0067               *
0068               * == Startup behaviour
0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0071               *******************************************************************************
0072               
0073               *//////////////////////////////////////////////////////////////
0074               *                       RUNLIB SETUP
0075               *//////////////////////////////////////////////////////////////
0076               
0077                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
**** **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
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
0078                       copy  "registers.equ"            ; Equates runlib registers
**** **** ****     > registers.equ
0001               * FILE......: registers.equ
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4      Temporary register/variable tmp0
0011               * R5      Temporary register/variable tmp1
0012               * R6      Temporary register/variable tmp2
0013               * R7      Temporary register/variable tmp3
0014               * R8      Temporary register/variable tmp4
0015               * R9      Stack pointer
0016               * R10     Highest slot in use + Timer counter
0017               * R11     Subroutine return address
0018               * R12     CRU
0019               * R13     Copy of VDP status byte and counter for sound player
0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0021               * R15     VDP read/write address
0022               *--------------------------------------------------------------
0023               * Special purpose registers
0024               * R0      shift count
0025               * R12     CRU
0026               * R13     WS     - when using LWPI, BLWP, RTWP
0027               * R14     PC     - when using LWPI, BLWP, RTWP
0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0029               ***************************************************************
0030               * Define registers
0031               ********|*****|*********************|**************************
0032      0000     r0      equ   0
0033      0001     r1      equ   1
0034      0002     r2      equ   2
0035      0003     r3      equ   3
0036      0004     r4      equ   4
0037      0005     r5      equ   5
0038      0006     r6      equ   6
0039      0007     r7      equ   7
0040      0008     r8      equ   8
0041      0009     r9      equ   9
0042      000A     r10     equ   10
0043      000B     r11     equ   11
0044      000C     r12     equ   12
0045      000D     r13     equ   13
0046      000E     r14     equ   14
0047      000F     r15     equ   15
0048               ***************************************************************
0049               * Define register equates
0050               ********|*****|*********************|**************************
0051      0002     config  equ   r2                    ; Config register
0052      0003     xconfig equ   r3                    ; Extended config register
0053      0004     tmp0    equ   r4                    ; Temp register 0
0054      0005     tmp1    equ   r5                    ; Temp register 1
0055      0006     tmp2    equ   r6                    ; Temp register 2
0056      0007     tmp3    equ   r7                    ; Temp register 3
0057      0008     tmp4    equ   r8                    ; Temp register 4
0058      0009     stack   equ   r9                    ; Stack pointer
0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0061               ***************************************************************
0062               * Define MSB/LSB equates for registers
0063               ********|*****|*********************|**************************
0064      8300     r0hb    equ   ws1                   ; HI byte R0
0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0096               ********|*****|*********************|**************************
0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0107               ********|*****|*********************|**************************
0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0112               ***************************************************************
**** **** ****     > runlib.asm
0079                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
**** **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
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
0080                       copy  "param.equ"                ; Equates runlib parameters
**** **** ****     > param.equ
0001               * FILE......: param.equ
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
0081               
0085               
0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0012 2000 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 2002 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 2004 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2006 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2008 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 200A 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 200C 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 200E 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 2010 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 2012 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 2014 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2016 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2018 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 201A 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 201C 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 201E 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 2020 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 2022 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 2024 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      2000     hb$00   equ   w$0000                ; >0000
0035      2012     hb$01   equ   w$0100                ; >0100
0036      2014     hb$02   equ   w$0200                ; >0200
0037      2016     hb$04   equ   w$0400                ; >0400
0038      2018     hb$08   equ   w$0800                ; >0800
0039      201A     hb$10   equ   w$1000                ; >1000
0040      201C     hb$20   equ   w$2000                ; >2000
0041      201E     hb$40   equ   w$4000                ; >4000
0042      2020     hb$80   equ   w$8000                ; >8000
0043      2024     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      2000     lb$00   equ   w$0000                ; >0000
0048      2002     lb$01   equ   w$0001                ; >0001
0049      2004     lb$02   equ   w$0002                ; >0002
0050      2006     lb$04   equ   w$0004                ; >0004
0051      2008     lb$08   equ   w$0008                ; >0008
0052      200A     lb$10   equ   w$0010                ; >0010
0053      200C     lb$20   equ   w$0020                ; >0020
0054      200E     lb$40   equ   w$0040                ; >0040
0055      2010     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      2002     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      2004     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2006     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2008     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      200A     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      200C     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      200E     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      2010     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      2012     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      2014     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2016     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2018     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      201A     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      201C     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      201E     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      2020     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0087                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
0001               * FILE......: config.equ
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
0027      201C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2012     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      200E     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      200A     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
**** **** ****     > runlib.asm
0088                       copy  "cpu_crash.asm"            ; CPU crash handler
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
0038 2026 022B  22         ai    r11,-4                ; Remove opcode offset
     2028 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 202A C800  38         mov   r0,@>ffe0
     202C FFE0 
0043 202E C801  38         mov   r1,@>ffe2
     2030 FFE2 
0044 2032 C802  38         mov   r2,@>ffe4
     2034 FFE4 
0045 2036 C803  38         mov   r3,@>ffe6
     2038 FFE6 
0046 203A C804  38         mov   r4,@>ffe8
     203C FFE8 
0047 203E C805  38         mov   r5,@>ffea
     2040 FFEA 
0048 2042 C806  38         mov   r6,@>ffec
     2044 FFEC 
0049 2046 C807  38         mov   r7,@>ffee
     2048 FFEE 
0050 204A C808  38         mov   r8,@>fff0
     204C FFF0 
0051 204E C809  38         mov   r9,@>fff2
     2050 FFF2 
0052 2052 C80A  38         mov   r10,@>fff4
     2054 FFF4 
0053 2056 C80B  38         mov   r11,@>fff6
     2058 FFF6 
0054 205A C80C  38         mov   r12,@>fff8
     205C FFF8 
0055 205E C80D  38         mov   r13,@>fffa
     2060 FFFA 
0056 2062 C80E  38         mov   r14,@>fffc
     2064 FFFC 
0057 2066 C80F  38         mov   r15,@>ffff
     2068 FFFF 
0058 206A 02A0  12         stwp  r0
0059 206C C800  38         mov   r0,@>ffdc
     206E FFDC 
0060 2070 02C0  12         stst  r0
0061 2072 C800  38         mov   r0,@>ffde
     2074 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2076 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2078 8300 
0067 207A 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     207C 8302 
0068 207E 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     2080 4A4A 
0069 2082 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     2084 2E4C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FC 
0078 208A 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2364 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2292 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2446 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 29D0 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2446 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 29D0 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2446 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2446 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2446 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2446 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26D2 
0128 20EA 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20EC 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20EE FFDC 
0132 20F0 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20F2 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20F4 0649  14         dect  stack
0138 20F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 20F8 0649  14         dect  stack
0140 20FA C645  30         mov   tmp1,*stack           ; Push tmp1
0141 20FC 0649  14         dect  stack
0142 20FE C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 2100 C046  18         mov   tmp2,r1               ; Save register number
0148 2102 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     2104 0001 
0149 2106 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2108 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 210A 06A0  32         bl    @mknum
     210C 29DA 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26E8 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2422 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26E8 
0168 2124 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2126 0281  22         ci    r1,10
     2128 000A 
0172 212A 1102  14         jlt   !
0173 212C 0620  34         dec   @wyx                  ; x=x-1
     212E 832A 
0174               
0175 2130 06A0  32 !       bl    @putstr
     2132 2422 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 29DA 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 294C 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26E8 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2422 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26E8 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2422 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26D8 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D4A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2178 1553             byte  21
0225 2179 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 218E 1543             byte  21
0230 218F ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21A4 0152             byte  1
0235 21A5 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21A6 0320             byte  3
0240 21A7 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21AA 042A             byte  4
0245 21AB ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B0 042A             byte  4
0250 21B1 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21B6 1B53             byte  27
0255 21B7 ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1842             byte  24
0260 21D3 ....             text  'Build-ID  210605-1390892'
0261                       even
0262               
**** **** ****     > runlib.asm
0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21EC 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EE 000E 
     21F0 0106 
     21F2 0204 
     21F4 0020 
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
0032 21F6 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F8 000E 
     21FA 0106 
     21FC 00F4 
     21FE 0028 
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
0058 2200 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2202 003F 
     2204 0240 
     2206 03F4 
     2208 0050 
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
0084 220A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220C 003F 
     220E 0240 
     2210 03F4 
     2212 0050 
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
0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 2214 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2216 16FD             data  >16fd                 ; |         jne   mcloop
0015 2218 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 221A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               ***************************************************************
0027               * loadmc - Load machine code into scratchpad  >8322 - >8328
0028               ***************************************************************
0029               *  bl  @loadmc
0030               *--------------------------------------------------------------
0031               *  REMARKS
0032               *  Machine instruction in location @>8320 will be set by
0033               *  SP2 copy/fill routine that is called later on.
0034               ********|*****|*********************|**************************
0035               loadmc:
0036 221E 0201  20         li    r1,mccode             ; Machinecode to patch
     2220 2214 
0037 2222 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2224 8322 
0038 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 222A CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222C 045B  20         b     *r11                  ; Return to caller
0042               
0043               
0044               *//////////////////////////////////////////////////////////////
0045               *                    STACK SUPPORT FUNCTIONS
0046               *//////////////////////////////////////////////////////////////
0047               
0048               ***************************************************************
0049               * POPR. - Pop registers & return to caller
0050               ***************************************************************
0051               *  B  @POPRG.
0052               *--------------------------------------------------------------
0053               *  REMARKS
0054               *  R11 must be at stack bottom
0055               ********|*****|*********************|**************************
0056 222E C0F9  30 popr3   mov   *stack+,r3
0057 2230 C0B9  30 popr2   mov   *stack+,r2
0058 2232 C079  30 popr1   mov   *stack+,r1
0059 2234 C039  30 popr0   mov   *stack+,r0
0060 2236 C2F9  30 poprt   mov   *stack+,r11
0061 2238 045B  20         b     *r11
0062               
0063               
0064               
0065               *//////////////////////////////////////////////////////////////
0066               *                   MEMORY FILL FUNCTIONS
0067               *//////////////////////////////////////////////////////////////
0068               
0069               ***************************************************************
0070               * FILM - Fill CPU memory with byte
0071               ***************************************************************
0072               *  bl   @film
0073               *  data P0,P1,P2
0074               *--------------------------------------------------------------
0075               *  P0 = Memory start address
0076               *  P1 = Byte to fill
0077               *  P2 = Number of bytes to fill
0078               *--------------------------------------------------------------
0079               *  bl   @xfilm
0080               *
0081               *  TMP0 = Memory start address
0082               *  TMP1 = Byte to fill
0083               *  TMP2 = Number of bytes to fill
0084               ********|*****|*********************|**************************
0085 223A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2240 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2242 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2244 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2246 FFCE 
0095 2248 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     224A 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224E 830B 
     2250 830A 
0100               
0101 2252 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2254 0001 
0102 2256 1602  14         jne   filchk2
0103 2258 DD05  32         movb  tmp1,*tmp0+
0104 225A 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225E 0002 
0109 2260 1603  14         jne   filchk3
0110 2262 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2264 DD05  32         movb  tmp1,*tmp0+
0112 2266 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2268 C1C4  18 filchk3 mov   tmp0,tmp3
0117 226A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226C 0001 
0118 226E 1305  14         jeq   fil16b
0119 2270 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2272 0606  14         dec   tmp2
0121 2274 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2276 0002 
0122 2278 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 227A C1C6  18 fil16b  mov   tmp2,tmp3
0127 227C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227E 0001 
0128 2280 1301  14         jeq   dofill
0129 2282 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2284 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2286 0646  14         dect  tmp2
0132 2288 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 228A C1C7  18         mov   tmp3,tmp3
0137 228C 1301  14         jeq   fil.exit
0138 228E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2290 045B  20         b     *r11
0141               
0142               
0143               ***************************************************************
0144               * FILV - Fill VRAM with byte
0145               ***************************************************************
0146               *  BL   @FILV
0147               *  DATA P0,P1,P2
0148               *--------------------------------------------------------------
0149               *  P0 = VDP start address
0150               *  P1 = Byte to fill
0151               *  P2 = Number of bytes to fill
0152               *--------------------------------------------------------------
0153               *  BL   @XFILV
0154               *
0155               *  TMP0 = VDP start address
0156               *  TMP1 = Byte to fill
0157               *  TMP2 = Number of bytes to fill
0158               ********|*****|*********************|**************************
0159 2292 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2294 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2296 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2298 0264  22 xfilv   ori   tmp0,>4000
     229A 4000 
0166 229C 06C4  14         swpb  tmp0
0167 229E D804  38         movb  tmp0,@vdpa
     22A0 8C02 
0168 22A2 06C4  14         swpb  tmp0
0169 22A4 D804  38         movb  tmp0,@vdpa
     22A6 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A8 020F  20         li    r15,vdpw              ; Set VDP write address
     22AA 8C00 
0174 22AC 06C5  14         swpb  tmp1
0175 22AE C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B0 22B8 
     22B2 8320 
0176 22B4 0460  28         b     @mcloop               ; Write data to VDP
     22B6 8320 
0177               *--------------------------------------------------------------
0181 22B8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0183               
0184               
0185               
0186               *//////////////////////////////////////////////////////////////
0187               *                  VDP LOW LEVEL FUNCTIONS
0188               *//////////////////////////////////////////////////////////////
0189               
0190               ***************************************************************
0191               * VDWA / VDRA - Setup VDP write or read address
0192               ***************************************************************
0193               *  BL   @VDWA
0194               *
0195               *  TMP0 = VDP destination address for write
0196               *--------------------------------------------------------------
0197               *  BL   @VDRA
0198               *
0199               *  TMP0 = VDP source address for read
0200               ********|*****|*********************|**************************
0201 22BA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BC 4000 
0202 22BE 06C4  14 vdra    swpb  tmp0
0203 22C0 D804  38         movb  tmp0,@vdpa
     22C2 8C02 
0204 22C4 06C4  14         swpb  tmp0
0205 22C6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C8 8C02 
0206 22CA 045B  20         b     *r11                  ; Exit
0207               
0208               ***************************************************************
0209               * VPUTB - VDP put single byte
0210               ***************************************************************
0211               *  BL @VPUTB
0212               *  DATA P0,P1
0213               *--------------------------------------------------------------
0214               *  P0 = VDP target address
0215               *  P1 = Byte to write
0216               ********|*****|*********************|**************************
0217 22CC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D2 4000 
0223 22D4 06C4  14         swpb  tmp0                  ; \
0224 22D6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D8 8C02 
0225 22DA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DC D804  38         movb  tmp0,@vdpa            ; /
     22DE 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E0 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E2 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E4 045B  20         b     *r11                  ; Exit
0233               
0234               
0235               ***************************************************************
0236               * VGETB - VDP get single byte
0237               ***************************************************************
0238               *  bl   @vgetb
0239               *  data p0
0240               *--------------------------------------------------------------
0241               *  P0 = VDP source address
0242               *--------------------------------------------------------------
0243               *  bl   @xvgetb
0244               *
0245               *  tmp0 = VDP source address
0246               *--------------------------------------------------------------
0247               *  Output:
0248               *  tmp0 MSB = >00
0249               *  tmp0 LSB = VDP byte read
0250               ********|*****|*********************|**************************
0251 22E6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E8 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22EA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EC 8C02 
0257 22EE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F0 D804  38         movb  tmp0,@vdpa            ; /
     22F2 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F4 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F6 8800 
0263 22F8 0984  56         srl   tmp0,8                ; Right align
0264 22FA 045B  20         b     *r11                  ; Exit
0265               
0266               
0267               ***************************************************************
0268               * VIDTAB - Dump videomode table
0269               ***************************************************************
0270               *  BL   @VIDTAB
0271               *  DATA P0
0272               *--------------------------------------------------------------
0273               *  P0 = Address of video mode table
0274               *--------------------------------------------------------------
0275               *  BL   @XIDTAB
0276               *
0277               *  TMP0 = Address of video mode table
0278               *--------------------------------------------------------------
0279               *  Remarks
0280               *  TMP1 = MSB is the VDP target register
0281               *         LSB is the value to write
0282               ********|*****|*********************|**************************
0283 22FC C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FE C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2300 C144  18         mov   tmp0,tmp1
0289 2302 05C5  14         inct  tmp1
0290 2304 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2306 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2308 FF00 
0292 230A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230C C805  38         mov   tmp1,@wbase           ; Store calculated base
     230E 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2310 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2312 8000 
0298 2314 0206  20         li    tmp2,8
     2316 0008 
0299 2318 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     231A 830B 
0300 231C 06C5  14         swpb  tmp1
0301 231E D805  38         movb  tmp1,@vdpa
     2320 8C02 
0302 2322 06C5  14         swpb  tmp1
0303 2324 D805  38         movb  tmp1,@vdpa
     2326 8C02 
0304 2328 0225  22         ai    tmp1,>0100
     232A 0100 
0305 232C 0606  14         dec   tmp2
0306 232E 16F4  14         jne   vidta1                ; Next register
0307 2330 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2332 833A 
0308 2334 045B  20         b     *r11
0309               
0310               
0311               ***************************************************************
0312               * PUTVR  - Put single VDP register
0313               ***************************************************************
0314               *  BL   @PUTVR
0315               *  DATA P0
0316               *--------------------------------------------------------------
0317               *  P0 = MSB is the VDP target register
0318               *       LSB is the value to write
0319               *--------------------------------------------------------------
0320               *  BL   @PUTVRX
0321               *
0322               *  TMP0 = MSB is the VDP target register
0323               *         LSB is the value to write
0324               ********|*****|*********************|**************************
0325 2336 C13B  30 putvr   mov   *r11+,tmp0
0326 2338 0264  22 putvrx  ori   tmp0,>8000
     233A 8000 
0327 233C 06C4  14         swpb  tmp0
0328 233E D804  38         movb  tmp0,@vdpa
     2340 8C02 
0329 2342 06C4  14         swpb  tmp0
0330 2344 D804  38         movb  tmp0,@vdpa
     2346 8C02 
0331 2348 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 234A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234C C10E  18         mov   r14,tmp0
0341 234E 0984  56         srl   tmp0,8
0342 2350 06A0  32         bl    @putvrx               ; Write VR#0
     2352 2338 
0343 2354 0204  20         li    tmp0,>0100
     2356 0100 
0344 2358 D820  54         movb  @r14lb,@tmp0lb
     235A 831D 
     235C 8309 
0345 235E 06A0  32         bl    @putvrx               ; Write VR#1
     2360 2338 
0346 2362 0458  20         b     *tmp4                 ; Exit
0347               
0348               
0349               ***************************************************************
0350               * LDFNT - Load TI-99/4A font from GROM into VDP
0351               ***************************************************************
0352               *  BL   @LDFNT
0353               *  DATA P0,P1
0354               *--------------------------------------------------------------
0355               *  P0 = VDP Target address
0356               *  P1 = Font options
0357               *--------------------------------------------------------------
0358               * Uses registers tmp0-tmp4
0359               ********|*****|*********************|**************************
0360 2364 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2366 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2368 C11B  26         mov   *r11,tmp0             ; Get P0
0363 236A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236C 7FFF 
0364 236E 2120  38         coc   @wbit0,tmp0
     2370 2020 
0365 2372 1604  14         jne   ldfnt1
0366 2374 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2376 8000 
0367 2378 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     237A 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237E 23E6 
0372 2380 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2382 9C02 
0373 2384 06C4  14         swpb  tmp0
0374 2386 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2388 9C02 
0375 238A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238C 9800 
0376 238E 06C5  14         swpb  tmp1
0377 2390 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2392 9800 
0378 2394 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2396 D805  38         movb  tmp1,@grmwa
     2398 9C02 
0383 239A 06C5  14         swpb  tmp1
0384 239C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239E 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A4 22BA 
0390 23A6 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23AA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AC 7FFF 
0393 23AE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B0 23E8 
0394 23B2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B4 23EA 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23BA D120  34         movb  @grmrd,tmp0
     23BC 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C0 2020 
0405 23C2 1603  14         jne   ldfnt3                ; No, so skip
0406 23C4 D1C4  18         movb  tmp0,tmp3
0407 23C6 0917  56         srl   tmp3,1
0408 23C8 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23CA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CC 8C00 
0413 23CE 0606  14         dec   tmp2
0414 23D0 16F2  14         jne   ldfnt2
0415 23D2 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D4 020F  20         li    r15,vdpw              ; Set VDP write address
     23D6 8C00 
0417 23D8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23DA 7FFF 
0418 23DC 0458  20         b     *tmp4                 ; Exit
0419 23DE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E0 2000 
     23E2 8C00 
0420 23E4 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E8 0200 
     23EA 0000 
0425 23EC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EE 01C0 
     23F0 0101 
0426 23F2 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F4 02A0 
     23F6 0101 
0427 23F8 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23FA 00E0 
     23FC 0101 
0428               
0429               
0430               
0431               ***************************************************************
0432               * YX2PNT - Get VDP PNT address for current YX cursor position
0433               ***************************************************************
0434               *  BL   @YX2PNT
0435               *--------------------------------------------------------------
0436               *  INPUT
0437               *  @WYX = Cursor YX position
0438               *--------------------------------------------------------------
0439               *  OUTPUT
0440               *  TMP0 = VDP address for entry in Pattern Name Table
0441               *--------------------------------------------------------------
0442               *  Register usage
0443               *  TMP0, R14, R15
0444               ********|*****|*********************|**************************
0445 23FE C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2400 C3A0  34         mov   @wyx,r14              ; Get YX
     2402 832A 
0447 2404 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2406 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2408 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 240A C3A0  34         mov   @wyx,r14              ; Get YX
     240C 832A 
0454 240E 024E  22         andi  r14,>00ff             ; Remove Y
     2410 00FF 
0455 2412 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2414 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2416 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2418 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 241A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241C 020F  20         li    r15,vdpw              ; VDP write address
     241E 8C00 
0463 2420 045B  20         b     *r11
0464               
0465               
0466               
0467               ***************************************************************
0468               * Put length-byte prefixed string at current YX
0469               ***************************************************************
0470               *  BL   @PUTSTR
0471               *  DATA P0
0472               *
0473               *  P0 = Pointer to string
0474               *--------------------------------------------------------------
0475               *  REMARKS
0476               *  First byte of string must contain length
0477               *--------------------------------------------------------------
0478               *  Register usage
0479               *  tmp1, tmp2, tmp3
0480               ********|*****|*********************|**************************
0481 2422 C17B  30 putstr  mov   *r11+,tmp1
0482 2424 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2426 C1CB  18 xutstr  mov   r11,tmp3
0484 2428 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     242A 23FE 
0485 242C C2C7  18         mov   tmp3,r11
0486 242E 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2430 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2432 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2434 0286  22         ci    tmp2,255              ; Length > 255 ?
     2436 00FF 
0494 2438 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 243A 0460  28         b     @xpym2v               ; Display string
     243C 2490 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 243E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2440 FFCE 
0501 2442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2444 2026 
0502               
0503               
0504               
0505               ***************************************************************
0506               * Put length-byte prefixed string at YX
0507               ***************************************************************
0508               *  BL   @PUTAT
0509               *  DATA P0,P1
0510               *
0511               *  P0 = YX position
0512               *  P1 = Pointer to string
0513               *--------------------------------------------------------------
0514               *  REMARKS
0515               *  First byte of string must contain length
0516               ********|*****|*********************|**************************
0517 2446 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2448 832A 
0518 244A 0460  28         b     @putstr
     244C 2422 
0519               
0520               
0521               ***************************************************************
0522               * putlst
0523               * Loop over string list and display
0524               ***************************************************************
0525               * bl  @putlst
0526               *--------------------------------------------------------------
0527               * INPUT
0528               * @wyx = Cursor position
0529               * tmp1 = Pointer to first length-prefixed string in list
0530               * tmp2 = Number of strings to display
0531               *--------------------------------------------------------------
0532               * OUTPUT
0533               * none
0534               *--------------------------------------------------------------
0535               * Register usage
0536               * tmp0, tmp1, tmp2, tmp3
0537               ********|*****|*********************|**************************
0538               putlst:
0539 244E 0649  14         dect  stack
0540 2450 C64B  30         mov   r11,*stack            ; Save return address
0541 2452 0649  14         dect  stack
0542 2454 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2456 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2458 0987  56         srl   tmp3,8                ; Right align
0549               
0550 245A 0649  14         dect  stack
0551 245C C645  30         mov   tmp1,*stack           ; Push tmp1
0552 245E 0649  14         dect  stack
0553 2460 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2462 0649  14         dect  stack
0555 2464 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2466 06A0  32         bl    @xutst0               ; Display string
     2468 2424 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 246A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 246C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 246E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2470 06A0  32         bl    @down                 ; Move cursor down
     2472 26D8 
0566               
0567 2474 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2476 0585  14         inc   tmp1                  ; Consider length byte
0569 2478 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     247A 2002 
0570 247C 1301  14         jeq   !                     ; Yes, skip adjustment
0571 247E 0585  14         inc   tmp1                  ; Make address even
0572 2480 0606  14 !       dec   tmp2
0573 2482 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2484 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2486 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2488 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 248A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 248C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 248E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2490 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2492 1604  14         jne   !                     ; No, continue
0028               
0029 2494 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2496 FFCE 
0030 2498 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     249A 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 249C 0264  22 !       ori   tmp0,>4000
     249E 4000 
0035 24A0 06C4  14         swpb  tmp0
0036 24A2 D804  38         movb  tmp0,@vdpa
     24A4 8C02 
0037 24A6 06C4  14         swpb  tmp0
0038 24A8 D804  38         movb  tmp0,@vdpa
     24AA 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24AC 020F  20         li    r15,vdpw              ; Set VDP write address
     24AE 8C00 
0043 24B0 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24B2 24BA 
     24B4 8320 
0044 24B6 0460  28         b     @mcloop               ; Write data to VDP and return
     24B8 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24BA D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0095               
0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 24BC C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24BE C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24C0 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24C2 06C4  14 xpyv2m  swpb  tmp0
0027 24C4 D804  38         movb  tmp0,@vdpa
     24C6 8C02 
0028 24C8 06C4  14         swpb  tmp0
0029 24CA D804  38         movb  tmp0,@vdpa
     24CC 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24CE 020F  20         li    r15,vdpr              ; Set VDP read address
     24D0 8800 
0034 24D2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24D4 24DC 
     24D6 8320 
0035 24D8 0460  28         b     @mcloop               ; Read data from VDP
     24DA 8320 
0036 24DC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0099               
0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 24DE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24E0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24E2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24E4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24E6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24EA FFCE 
0034 24EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24EE 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24F0 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24F2 0001 
0039 24F4 1603  14         jne   cpym0                 ; No, continue checking
0040 24F6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24F8 04C6  14         clr   tmp2                  ; Reset counter
0042 24FA 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24FC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24FE 7FFF 
0047 2500 C1C4  18         mov   tmp0,tmp3
0048 2502 0247  22         andi  tmp3,1
     2504 0001 
0049 2506 1618  14         jne   cpyodd                ; Odd source address handling
0050 2508 C1C5  18 cpym1   mov   tmp1,tmp3
0051 250A 0247  22         andi  tmp3,1
     250C 0001 
0052 250E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2510 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2512 2020 
0057 2514 1605  14         jne   cpym3
0058 2516 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2518 253E 
     251A 8320 
0059 251C 0460  28         b     @mcloop               ; Copy memory and exit
     251E 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2520 C1C6  18 cpym3   mov   tmp2,tmp3
0064 2522 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2524 0001 
0065 2526 1301  14         jeq   cpym4
0066 2528 0606  14         dec   tmp2                  ; Make TMP2 even
0067 252A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 252C 0646  14         dect  tmp2
0069 252E 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2530 C1C7  18         mov   tmp3,tmp3
0074 2532 1301  14         jeq   cpymz
0075 2534 D554  38         movb  *tmp0,*tmp1
0076 2536 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2538 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     253A 8000 
0081 253C 10E9  14         jmp   cpym2
0082 253E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0103               
0107               
0111               
0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0062 2540 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2542 0649  14         dect  stack
0065 2544 C64B  30         mov   r11,*stack            ; Push return address
0066 2546 0649  14         dect  stack
0067 2548 C640  30         mov   r0,*stack             ; Push r0
0068 254A 0649  14         dect  stack
0069 254C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 254E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2550 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2552 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2554 4000 
0077 2556 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2558 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0082 255E 04C0  14         clr   r0
0083 2560 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2562 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2564 D100  18         movb  r0,tmp0
0086 2566 0984  56         srl   tmp0,8                ; Right align
0087 2568 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     256A 833C 
0088 256C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 256E C339  30         mov   *stack+,r12           ; Pop r12
0094 2570 C039  30         mov   *stack+,r0            ; Pop r0
0095 2572 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2574 045B  20         b     *r11                  ; Return to caller
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
0131 2576 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2578 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 257A 0649  14         dect  stack
0135 257C C64B  30         mov   r11,*stack            ; Push return address
0136 257E 0649  14         dect  stack
0137 2580 C640  30         mov   r0,*stack             ; Push r0
0138 2582 0649  14         dect  stack
0139 2584 C64C  30         mov   r12,*stack            ; Push r12
0140 2586 0649  14         dect  stack
0141 2588 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 258A 0649  14         dect  stack
0143 258C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 258E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2590 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2592 0284  22         ci    tmp0,255              ; Crash if page > 255
     2594 00FF 
0153 2596 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 2598 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     259A 001E 
0158 259C 150A  14         jgt   !
0159 259E 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25A0 0004 
0160 25A2 1107  14         jlt   !
0161 25A4 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25A6 0012 
0162 25A8 1508  14         jgt   sams.page.set.switch_page
0163 25AA 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25AC 0006 
0164 25AE 1501  14         jgt   !
0165 25B0 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25B2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25B4 FFCE 
0170 25B6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25B8 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25BA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25BC 1E00 
0176 25BE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25C0 06C0  14         swpb  r0                    ; LSB to MSB
0178 25C2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25C4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25C6 4000 
0180 25C8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25CE C339  30         mov   *stack+,r12           ; Pop r12
0188 25D0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25D2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25D4 045B  20         b     *r11                  ; Return to caller
0191               
0192               
0193               
0194               
0195               ***************************************************************
0196               * sams.mapping.on - Enable SAMS mapping mode
0197               ***************************************************************
0198               *  bl   @sams.mapping.on
0199               *--------------------------------------------------------------
0200               *  Register usage
0201               *  r12
0202               ********|*****|*********************|**************************
0203               sams.mapping.on:
0204 25D6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25D8 1E00 
0205 25DA 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25DC 045B  20         b     *r11                  ; Return to caller
0211               
0212               
0213               
0214               
0215               ***************************************************************
0216               * sams.mapping.off - Disable SAMS mapping mode
0217               ***************************************************************
0218               * bl  @sams.mapping.off
0219               *--------------------------------------------------------------
0220               * OUTPUT
0221               * none
0222               *--------------------------------------------------------------
0223               * Register usage
0224               * r12
0225               ********|*****|*********************|**************************
0226               sams.mapping.off:
0227 25DE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E0 1E00 
0228 25E2 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25E4 045B  20         b     *r11                  ; Return to caller
0234               
0235               
0236               
0237               
0238               
0239               ***************************************************************
0240               * sams.layout
0241               * Setup SAMS memory banks
0242               ***************************************************************
0243               * bl  @sams.layout
0244               *     data P0
0245               *--------------------------------------------------------------
0246               * INPUT
0247               * P0 = Pointer to SAMS page layout table (16 words).
0248               *--------------------------------------------------------------
0249               * bl  @xsams.layout
0250               *
0251               * tmp0 = Pointer to SAMS page layout table (16 words).
0252               *--------------------------------------------------------------
0253               * OUTPUT
0254               * none
0255               *--------------------------------------------------------------
0256               * Register usage
0257               * tmp0, tmp1, tmp2, tmp3
0258               ********|*****|*********************|**************************
0259               sams.layout:
0260 25E6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25E8 0649  14         dect  stack
0263 25EA C64B  30         mov   r11,*stack            ; Save return address
0264 25EC 0649  14         dect  stack
0265 25EE C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25F0 0649  14         dect  stack
0267 25F2 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25F4 0649  14         dect  stack
0269 25F6 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25F8 0649  14         dect  stack
0271 25FA C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25FC 0206  20         li    tmp2,8                ; Set loop counter
     25FE 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 2600 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 2602 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 2604 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2606 257A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2608 0606  14         dec   tmp2                  ; Next iteration
0288 260A 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 260C 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     260E 25D6 
0294                                                   ; / activating changes.
0295               
0296 2610 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 2612 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 2614 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2616 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2618 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 261A 045B  20         b     *r11                  ; Return to caller
0302               
0303               
0304               
0305               ***************************************************************
0306               * sams.layout.reset
0307               * Reset SAMS memory banks to standard layout
0308               ***************************************************************
0309               * bl  @sams.layout.reset
0310               *--------------------------------------------------------------
0311               * OUTPUT
0312               * none
0313               *--------------------------------------------------------------
0314               * Register usage
0315               * none
0316               ********|*****|*********************|**************************
0317               sams.layout.reset:
0318 261C 0649  14         dect  stack
0319 261E C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 2620 06A0  32         bl    @sams.layout
     2622 25E6 
0324 2624 262A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2626 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2628 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 262A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     262C 0002 
0336 262E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2630 0003 
0337 2632 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2634 000A 
0338 2636 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2638 000B 
0339 263A C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     263C 000C 
0340 263E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2640 000D 
0341 2642 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2644 000E 
0342 2646 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2648 000F 
0343               
0344               
0345               
0346               ***************************************************************
0347               * sams.layout.copy
0348               * Copy SAMS memory layout
0349               ***************************************************************
0350               * bl  @sams.layout.copy
0351               *     data P0
0352               *--------------------------------------------------------------
0353               * P0 = Pointer to 8 words RAM buffer for results
0354               *--------------------------------------------------------------
0355               * OUTPUT
0356               * RAM buffer will have the SAMS page number for each range
0357               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0358               *--------------------------------------------------------------
0359               * Register usage
0360               * tmp0, tmp1, tmp2, tmp3
0361               ***************************************************************
0362               sams.layout.copy:
0363 264A C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 264C 0649  14         dect  stack
0366 264E C64B  30         mov   r11,*stack            ; Push return address
0367 2650 0649  14         dect  stack
0368 2652 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2654 0649  14         dect  stack
0370 2656 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2658 0649  14         dect  stack
0372 265A C646  30         mov   tmp2,*stack           ; Push tmp2
0373 265C 0649  14         dect  stack
0374 265E C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2660 0205  20         li    tmp1,sams.layout.copy.data
     2662 2682 
0379 2664 0206  20         li    tmp2,8                ; Set loop counter
     2666 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2668 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 266A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     266C 2542 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 266E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2670 833C 
0390               
0391 2672 0606  14         dec   tmp2                  ; Next iteration
0392 2674 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2676 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2678 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 267A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 267C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 267E C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2680 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2682 2000             data  >2000                 ; >2000-2fff
0408 2684 3000             data  >3000                 ; >3000-3fff
0409 2686 A000             data  >a000                 ; >a000-afff
0410 2688 B000             data  >b000                 ; >b000-bfff
0411 268A C000             data  >c000                 ; >c000-cfff
0412 268C D000             data  >d000                 ; >d000-dfff
0413 268E E000             data  >e000                 ; >e000-efff
0414 2690 F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 2692 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2694 FFBF 
0010 2696 0460  28         b     @putv01
     2698 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 269A 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     269C 0040 
0018 269E 0460  28         b     @putv01
     26A0 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26A2 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26A4 FFDF 
0026 26A6 0460  28         b     @putv01
     26A8 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26AA 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26AC 0020 
0034 26AE 0460  28         b     @putv01
     26B0 234A 
**** **** ****     > runlib.asm
0119               
0121                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 26B2 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26B4 FFFE 
0011 26B6 0460  28         b     @putv01
     26B8 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26BA 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26BC 0001 
0019 26BE 0460  28         b     @putv01
     26C0 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26C2 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26C4 FFFD 
0027 26C6 0460  28         b     @putv01
     26C8 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26CA 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26CC 0002 
0035 26CE 0460  28         b     @putv01
     26D0 234A 
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 26D2 C83B  50 at      mov   *r11+,@wyx
     26D4 832A 
0019 26D6 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26D8 B820  54 down    ab    @hb$01,@wyx
     26DA 2012 
     26DC 832A 
0028 26DE 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26E0 7820  54 up      sb    @hb$01,@wyx
     26E2 2012 
     26E4 832A 
0037 26E6 045B  20         b     *r11
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
0049 26E8 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26EA D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26EC 832A 
0051 26EE C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26F0 832A 
0052 26F2 045B  20         b     *r11
**** **** ****     > runlib.asm
0127               
0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 26F4 C120  34 yx2px   mov   @wyx,tmp0
     26F6 832A 
0022 26F8 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26FA 06C4  14         swpb  tmp0                  ; Y<->X
0024 26FC 04C5  14         clr   tmp1                  ; Clear before copy
0025 26FE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2700 20A0  38         coc   @wbit1,config         ; f18a present ?
     2702 201E 
0030 2704 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2706 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2708 833A 
     270A 2734 
0032 270C 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 270E 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2710 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2712 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2714 0500 
0037 2716 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2718 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 271A 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 271C 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 271E D105  18         movb  tmp1,tmp0
0051 2720 06C4  14         swpb  tmp0                  ; X<->Y
0052 2722 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     2724 2020 
0053 2726 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2728 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     272A 2012 
0059 272C 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     272E 2024 
0060 2730 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2732 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2734 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0131               
0135               
0139               
0141                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
**** **** ****     > vdp_f18a.asm
0001               * FILE......: vdp_f18a.asm
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
0013 2736 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2738 06A0  32         bl    @putvr                ; Write once
     273A 2336 
0015 273C 391C             data  >391c                 ; VR1/57, value 00011100
0016 273E 06A0  32         bl    @putvr                ; Write twice
     2740 2336 
0017 2742 391C             data  >391c                 ; VR1/57, value 00011100
0018 2744 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2746 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2748 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     274A 2336 
0028 274C 391C             data  >391c
0029 274E 0458  20         b     *tmp4                 ; Exit
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
0040 2750 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2752 06A0  32         bl    @cpym2v
     2754 248A 
0042 2756 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2758 2794 
     275A 0008 
0043 275C 06A0  32         bl    @putvr
     275E 2336 
0044 2760 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2762 06A0  32         bl    @putvr
     2764 2336 
0046 2766 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2768 0204  20         li    tmp0,>3f00
     276A 3F00 
0052 276C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     276E 22BE 
0053 2770 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2772 8800 
0054 2774 0984  56         srl   tmp0,8
0055 2776 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2778 8800 
0056 277A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 277C 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 277E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2780 BFFF 
0060 2782 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2784 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2786 4000 
0063               f18chk_exit:
0064 2788 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     278A 2292 
0065 278C 3F00             data  >3f00,>00,6
     278E 0000 
     2790 0006 
0066 2792 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2794 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2796 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2798 0340             data  >0340                 ; 3f04   0340  idle
0074 279A 10FF             data  >10ff                 ; 3f06   10ff  jmp $
0075               
0076               
0077               ***************************************************************
0078               * f18rst - Reset f18a into standard settings
0079               ***************************************************************
0080               *  bl   @f18rst
0081               *--------------------------------------------------------------
0082               *  REMARKS
0083               *  This is used to leave the F18A mode and revert all settings
0084               *  that could lead to corruption when doing BLWP @0
0085               *
0086               *  There are some F18a settings that stay on when doing blwp @0
0087               *  and the TI title screen cannot recover from that.
0088               *
0089               *  It is your responsibility to set video mode tables should
0090               *  you want to continue instead of doing blwp @0 after your
0091               *  program cleanup
0092               ********|*****|*********************|**************************
0093 279C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0094                       ;------------------------------------------------------
0095                       ; Reset all F18a VDP registers to power-on defaults
0096                       ;------------------------------------------------------
0097 279E 06A0  32         bl    @putvr
     27A0 2336 
0098 27A2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0099               
0100 27A4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     27A6 2336 
0101 27A8 391C             data  >391c                 ; Lock the F18a
0102 27AA 0458  20         b     *tmp4                 ; Exit
0103               
0104               
0105               
0106               ***************************************************************
0107               * f18fwv - Get F18A Firmware Version
0108               ***************************************************************
0109               *  bl   @f18fwv
0110               *--------------------------------------------------------------
0111               *  REMARKS
0112               *  Successfully tested with F18A v1.8, note that this does not
0113               *  work with F18 v1.3 but you shouldn't be using such old F18A
0114               *  firmware to begin with.
0115               *--------------------------------------------------------------
0116               *  TMP0 High nibble = major version
0117               *  TMP0 Low nibble  = minor version
0118               *
0119               *  Example: >0018     F18a Firmware v1.8
0120               ********|*****|*********************|**************************
0121 27AC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0122 27AE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27B0 201E 
0123 27B2 1609  14         jne   f18fw1
0124               ***************************************************************
0125               * Read F18A major/minor version
0126               ***************************************************************
0127 27B4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27B6 8802 
0128 27B8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27BA 2336 
0129 27BC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0130 27BE 04C4  14         clr   tmp0
0131 27C0 D120  34         movb  @vdps,tmp0
     27C2 8802 
0132 27C4 0984  56         srl   tmp0,8
0133 27C6 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0143               
0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 27C8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27CA 832A 
0018 27CC D17B  28         movb  *r11+,tmp1
0019 27CE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27D0 D1BB  28         movb  *r11+,tmp2
0021 27D2 0986  56         srl   tmp2,8                ; Repeat count
0022 27D4 C1CB  18         mov   r11,tmp3
0023 27D6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27D8 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27DA 020B  20         li    r11,hchar1
     27DC 27E2 
0028 27DE 0460  28         b     @xfilv                ; Draw
     27E0 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27E2 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27E4 2022 
0033 27E6 1302  14         jeq   hchar2                ; Yes, exit
0034 27E8 C2C7  18         mov   tmp3,r11
0035 27EA 10EE  14         jmp   hchar                 ; Next one
0036 27EC 05C7  14 hchar2  inct  tmp3
0037 27EE 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0147               
0151               
0155               
0159               
0163               
0167               
0171               
0175               
0177                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 27F0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27F2 2020 
0017 27F4 020C  20         li    r12,>0024
     27F6 0024 
0018 27F8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27FA 288C 
0019 27FC 04C6  14         clr   tmp2
0020 27FE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 2800 04CC  14         clr   r12
0025 2802 1F08  20         tb    >0008                 ; Shift-key ?
0026 2804 1302  14         jeq   realk1                ; No
0027 2806 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2808 28BC 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 280A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 280C 1302  14         jeq   realk2                ; No
0033 280E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     2810 28EC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2812 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2814 1302  14         jeq   realk3                ; No
0039 2816 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2818 291C 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 281A 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     281C 200C 
0044 281E 1E15  20         sbz   >0015                 ; Set P5
0045 2820 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2822 1302  14         jeq   realk4                ; No
0047 2824 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2826 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2828 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 282A 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     282C 0006 
0053 282E 0606  14 realk5  dec   tmp2
0054 2830 020C  20         li    r12,>24               ; CRU address for P2-P4
     2832 0024 
0055 2834 06C6  14         swpb  tmp2
0056 2836 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2838 06C6  14         swpb  tmp2
0058 283A 020C  20         li    r12,6                 ; CRU read address
     283C 0006 
0059 283E 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2840 0547  14         inv   tmp3                  ;
0061 2842 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2844 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2846 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2848 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 284A 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 284C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 284E 0285  22         ci    tmp1,8
     2850 0008 
0070 2852 1AFA  14         jl    realk6
0071 2854 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2856 1BEB  14         jh    realk5                ; No, next column
0073 2858 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 285A C206  18 realk8  mov   tmp2,tmp4
0078 285C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 285E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2860 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2862 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2864 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2866 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2868 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     286A 200C 
0089 286C 1608  14         jne   realka                ; No, continue saving key
0090 286E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2870 28B6 
0091 2872 1A05  14         jl    realka
0092 2874 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2876 28B4 
0093 2878 1B02  14         jh    realka                ; No, continue
0094 287A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     287C E000 
0095 287E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2880 833C 
0096 2882 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2884 200A 
0097 2886 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2888 8C00 
0098                                                   ; / using R15 as temp storage
0099 288A 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 288C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     288E 0000 
     2890 FF0D 
     2892 203D 
0102 2894 ....             text  'xws29ol.'
0103 289C ....             text  'ced38ik,'
0104 28A4 ....             text  'vrf47ujm'
0105 28AC ....             text  'btg56yhn'
0106 28B4 ....             text  'zqa10p;/'
0107 28BC FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28BE 0000 
     28C0 FF0D 
     28C2 202B 
0108 28C4 ....             text  'XWS@(OL>'
0109 28CC ....             text  'CED#*IK<'
0110 28D4 ....             text  'VRF$&UJM'
0111 28DC ....             text  'BTG%^YHN'
0112 28E4 ....             text  'ZQA!)P:-'
0113 28EC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28EE 0000 
     28F0 FF0D 
     28F2 2005 
0114 28F4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28F6 0804 
     28F8 0F27 
     28FA C2B9 
0115 28FC 600B             data  >600b,>0907,>063f,>c1B8
     28FE 0907 
     2900 063F 
     2902 C1B8 
0116 2904 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2906 7B02 
     2908 015F 
     290A C0C3 
0117 290C BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     290E 7D0E 
     2910 0CC6 
     2912 BFC4 
0118 2914 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2916 7C03 
     2918 BC22 
     291A BDBA 
0119 291C FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     291E 0000 
     2920 FF0D 
     2922 209D 
0120 2924 9897             data  >9897,>93b2,>9f8f,>8c9B
     2926 93B2 
     2928 9F8F 
     292A 8C9B 
0121 292C 8385             data  >8385,>84b3,>9e89,>8b80
     292E 84B3 
     2930 9E89 
     2932 8B80 
0122 2934 9692             data  >9692,>86b4,>b795,>8a8D
     2936 86B4 
     2938 B795 
     293A 8A8D 
0123 293C 8294             data  >8294,>87b5,>b698,>888E
     293E 87B5 
     2940 B698 
     2942 888E 
0124 2944 9A91             data  >9a91,>81b1,>b090,>9cBB
     2946 81B1 
     2948 B090 
     294A 9CBB 
**** **** ****     > runlib.asm
0179               
0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 294C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 294E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2950 8340 
0025 2952 04E0  34         clr   @waux1
     2954 833C 
0026 2956 04E0  34         clr   @waux2
     2958 833E 
0027 295A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     295C 833C 
0028 295E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2960 0205  20         li    tmp1,4                ; 4 nibbles
     2962 0004 
0033 2964 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2966 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2968 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 296A 0286  22         ci    tmp2,>000a
     296C 000A 
0039 296E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2970 C21B  26         mov   *r11,tmp4
0045 2972 0988  56         srl   tmp4,8                ; Right justify
0046 2974 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2976 FFF6 
0047 2978 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 297A C21B  26         mov   *r11,tmp4
0054 297C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     297E 00FF 
0055               
0056 2980 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2982 06C6  14         swpb  tmp2
0058 2984 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2986 0944  56         srl   tmp0,4                ; Next nibble
0060 2988 0605  14         dec   tmp1
0061 298A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 298C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     298E BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2990 C160  34         mov   @waux3,tmp1           ; Get pointer
     2992 8340 
0067 2994 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2996 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2998 C120  34         mov   @waux2,tmp0
     299A 833E 
0070 299C 06C4  14         swpb  tmp0
0071 299E DD44  32         movb  tmp0,*tmp1+
0072 29A0 06C4  14         swpb  tmp0
0073 29A2 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29A4 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29A6 8340 
0078 29A8 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29AA 2016 
0079 29AC 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29AE C120  34         mov   @waux1,tmp0
     29B0 833C 
0084 29B2 06C4  14         swpb  tmp0
0085 29B4 DD44  32         movb  tmp0,*tmp1+
0086 29B6 06C4  14         swpb  tmp0
0087 29B8 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29BA 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29BC 2020 
0092 29BE 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29C0 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29C2 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29C4 7FFF 
0098 29C6 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29C8 8340 
0099 29CA 0460  28         b     @xutst0               ; Display string
     29CC 2424 
0100 29CE 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29D0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29D2 832A 
0122 29D4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29D6 8000 
0123 29D8 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0183               
0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 29DA 0207  20 mknum   li    tmp3,5                ; Digit counter
     29DC 0005 
0020 29DE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29E0 C155  26         mov   *tmp1,tmp1            ; /
0022 29E2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29E4 0228  22         ai    tmp4,4                ; Get end of buffer
     29E6 0004 
0024 29E8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29EA 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29EC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29EE 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29F0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29F2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29F4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29F6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29F8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29FA 0607  14         dec   tmp3                  ; Decrease counter
0036 29FC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29FE 0207  20         li    tmp3,4                ; Check first 4 digits
     2A00 0004 
0041 2A02 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A04 C11B  26         mov   *r11,tmp0
0043 2A06 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A08 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A0A 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A0C 05CB  14 mknum3  inct  r11
0047 2A0E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A10 2020 
0048 2A12 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A14 045B  20         b     *r11                  ; Exit
0050 2A16 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A18 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A1A 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A1C 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A1E 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A20 7FFF 
0058 2A22 C10B  18         mov   r11,tmp0
0059 2A24 0224  22         ai    tmp0,-4
     2A26 FFFC 
0060 2A28 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A2A 0206  20         li    tmp2,>0500            ; String length = 5
     2A2C 0500 
0062 2A2E 0460  28         b     @xutstr               ; Display string
     2A30 2426 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1,p2
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
0083               *               01234|56789A
0084               *  Before...:   XXXXX
0085               *  After....:   XXXXX|zY       where length byte z=1
0086               *               XXXXX|zYY      where length byte z=2
0087               *                 ..
0088               *               XXXXX|zYYYYY   where length byte z=5
0089               *--------------------------------------------------------------
0090               *  Destroys registers tmp0-tmp3
0091               ********|*****|*********************|**************************
0092               trimnum:
0093 2A32 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A34 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A36 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A38 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A3A 0207  20         li    tmp3,5                ; Set counter
     2A3C 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A3E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A40 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A42 0584  14         inc   tmp0                  ; Next character
0105 2A44 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A46 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A48 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A4A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A4C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A4E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A50 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A52 0607  14         dec   tmp3                  ; Last character ?
0121 2A54 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A56 045B  20         b     *r11                  ; Return
0123               
0124               
0125               
0126               
0127               ***************************************************************
0128               * PUTNUM - Put unsigned number on screen
0129               ***************************************************************
0130               *  BL   @PUTNUM
0131               *  DATA P0,P1,P2,P3
0132               *--------------------------------------------------------------
0133               *  P0   = YX position
0134               *  P1   = Pointer to 16 bit unsigned number
0135               *  P2   = Pointer to 5 byte string buffer
0136               *  P3HB = Offset for ASCII digit
0137               *  P3LB = Character for replacing leading 0's
0138               ********|*****|*********************|**************************
0139 2A58 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A5A 832A 
0140 2A5C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A5E 8000 
0141 2A60 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0187               
0191               
0195               
0199               
0203               
0205                       copy  "cpu_strings.asm"          ; String utilities support
**** **** ****     > cpu_strings.asm
0001               * FILE......: cpu_strings.asm
0002               * Purpose...: CPU string manipulation library
0003               
0004               
0005               ***************************************************************
0006               * string.ltrim - Left justify string
0007               ***************************************************************
0008               *  bl   @string.ltrim
0009               *       data p0,p1,p2
0010               *--------------------------------------------------------------
0011               *  P0 = Pointer to length-prefix string
0012               *  P1 = Pointer to RAM work buffer
0013               *  P2 = Fill character
0014               *--------------------------------------------------------------
0015               *  BL   @xstring.ltrim
0016               *
0017               *  TMP0 = Pointer to length-prefix string
0018               *  TMP1 = Pointer to RAM work buffer
0019               *  TMP2 = Fill character
0020               ********|*****|*********************|**************************
0021               string.ltrim:
0022 2A62 0649  14         dect  stack
0023 2A64 C64B  30         mov   r11,*stack            ; Save return address
0024 2A66 0649  14         dect  stack
0025 2A68 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A6A 0649  14         dect  stack
0027 2A6C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A6E 0649  14         dect  stack
0029 2A70 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A72 0649  14         dect  stack
0031 2A74 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A76 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A78 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A7A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A7C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A7E 0649  14         dect  stack
0044 2A80 C64B  30         mov   r11,*stack            ; Save return address
0045 2A82 0649  14         dect  stack
0046 2A84 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A86 0649  14         dect  stack
0048 2A88 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A8A 0649  14         dect  stack
0050 2A8C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A8E 0649  14         dect  stack
0052 2A90 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A92 C1D4  26 !       mov   *tmp0,tmp3
0057 2A94 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A96 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A98 00FF 
0059 2A9A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A9C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A9E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2AA0 0584  14         inc   tmp0                  ; Next byte
0067 2AA2 0607  14         dec   tmp3                  ; Shorten string length
0068 2AA4 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AA6 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AA8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AAA C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AAC 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2AAE C187  18         mov   tmp3,tmp2
0078 2AB0 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AB2 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AB4 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AB6 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AB8 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2ABA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ABC FFCE 
0090 2ABE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AC0 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AC2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2ACA C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2ACC 045B  20         b     *r11                  ; Return to caller
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * string.getlenc - Get length of C-style string
0107               ***************************************************************
0108               *  bl   @string.getlenc
0109               *       data p0,p1
0110               *--------------------------------------------------------------
0111               *  P0 = Pointer to C-style string
0112               *  P1 = String termination character
0113               *--------------------------------------------------------------
0114               *  bl   @xstring.getlenc
0115               *
0116               *  TMP0 = Pointer to C-style string
0117               *  TMP1 = Termination character
0118               *--------------------------------------------------------------
0119               *  OUTPUT:
0120               *  @waux1 = Length of string
0121               ********|*****|*********************|**************************
0122               string.getlenc:
0123 2ACE 0649  14         dect  stack
0124 2AD0 C64B  30         mov   r11,*stack            ; Save return address
0125 2AD2 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AD4 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AD6 0649  14         dect  stack
0128 2AD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2ADA 0649  14         dect  stack
0130 2ADC C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ADE 0649  14         dect  stack
0132 2AE0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AE2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AE4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AE6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AE8 0649  14         dect  stack
0144 2AEA C64B  30         mov   r11,*stack            ; Save return address
0145 2AEC 0649  14         dect  stack
0146 2AEE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AF0 0649  14         dect  stack
0148 2AF2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AF4 0649  14         dect  stack
0150 2AF6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AF8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AFA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AFC 0586  14         inc   tmp2
0161 2AFE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2B00 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B02 0286  22         ci    tmp2,255
     2B04 00FF 
0167 2B06 1505  14         jgt   string.getlenc.panic
0168 2B08 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B0A 0606  14         dec   tmp2                  ; One time adjustment
0174 2B0C C806  38         mov   tmp2,@waux1           ; Store length
     2B0E 833C 
0175 2B10 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B12 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B14 FFCE 
0181 2B16 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B18 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B1A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B1C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B20 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B22 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0216               
0218                       copy  "fio.equ"                  ; File I/O equates
**** **** ****     > fio.equ
0001               * FILE......: fio.equ
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations - Byte 0 in PAB
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
0018               * File & data type - Byte 1 in PAB (Bit 0-4)
0019               ***************************************************************
0020               * Bit position: 4  3  21  0
0021               *               |  |  ||   \
0022               *               |  |  ||    File type
0023               *               |  |  ||    0 = INTERNAL
0024               *               |  |  ||    1 = FIXED
0025               *               |  |  \\
0026               *               |  |   File operation
0027               *               |  |   00 - UPDATE
0028               *               |  |   01 - OUTPUT
0029               *               |  |   10 - INPUT
0030               *               |  |   11 - APPEND
0031               *               |  |
0032               *               |  \
0033               *               |   Data type
0034               *               |   0 = DISPLAY
0035               *               |   1 = INTERNAL
0036               *               |
0037               *               \
0038               *                Record type
0039               *                0 = FIXED
0040               *                1 = VARIABLE
0041               ***************************************************************
0042               ; Bit position           43210
0043               ************************************|**************************
0044      0000     io.seq.upd.dis.fix  equ :00000      ; 00
0045      0001     io.rel.upd.dis.fix  equ :00001      ; 01
0046      0003     io.rel.out.dis.fix  equ :00011      ; 02
0047      0002     io.seq.out.dis.fix  equ :00010      ; 03
0048      0004     io.seq.inp.dis.fix  equ :00100      ; 04
0049      0005     io.rel.inp.dis.fix  equ :00101      ; 05
0050      0006     io.seq.app.dis.fix  equ :00110      ; 06
0051      0007     io.rel.app.dis.fix  equ :00111      ; 07
0052      0008     io.seq.upd.int.fix  equ :01000      ; 08
0053      0009     io.rel.upd.int.fix  equ :01001      ; 09
0054      000A     io.seq.out.int.fix  equ :01010      ; 0A
0055      000B     io.rel.out.int.fix  equ :01011      ; 0B
0056      000C     io.seq.inp.int.fix  equ :01100      ; 0C
0057      000D     io.rel.inp.int.fix  equ :01101      ; 0D
0058      000E     io.seq.app.int.fix  equ :01110      ; 0E
0059      000F     io.rel.app.int.fix  equ :01111      ; 0F
0060      0010     io.seq.upd.dis.var  equ :10000      ; 10
0061      0011     io.rel.upd.dis.var  equ :10001      ; 11
0062      0012     io.seq.out.dis.var  equ :10010      ; 12
0063      0013     io.rel.out.dis.var  equ :10011      ; 13
0064      0014     io.seq.inp.dis.var  equ :10100      ; 14
0065      0015     io.rel.inp.dis.var  equ :10101      ; 15
0066      0016     io.seq.app.dis.var  equ :10110      ; 16
0067      0017     io.rel.app.dis.var  equ :10111      ; 17
0068      0018     io.seq.upd.int.var  equ :11000      ; 18
0069      0019     io.rel.upd.int.var  equ :11001      ; 19
0070      001A     io.seq.out.int.var  equ :11010      ; 1A
0071      001B     io.rel.out.int.var  equ :11011      ; 1B
0072      001C     io.seq.inp.int.var  equ :11100      ; 1C
0073      001D     io.rel.inp.int.var  equ :11101      ; 1D
0074      001E     io.seq.app.int.var  equ :11110      ; 1E
0075      001F     io.rel.app.int.var  equ :11111      ; 1F
0076               ***************************************************************
0077               * File error codes - Byte 1 in PAB (Bits 5-7)
0078               ************************************|**************************
0079      0000     io.err.no_error_occured             equ 0
0080                       ; Error code 0 with condition bit reset, indicates that
0081                       ; no error has occured
0082               
0083      0000     io.err.bad_device_name              equ 0
0084                       ; Device indicated not in system
0085                       ; Error code 0 with condition bit set, indicates a
0086                       ; device not present in system
0087               
0088      0001     io.err.device_write_prottected      equ 1
0089                       ; Device is write protected
0090               
0091      0002     io.err.bad_open_attribute           equ 2
0092                       ; One or more of the OPEN attributes are illegal or do
0093                       ; not match the file's actual characteristics.
0094                       ; This could be:
0095                       ;   * File type
0096                       ;   * Record length
0097                       ;   * I/O mode
0098                       ;   * File organization
0099               
0100      0003     io.err.illegal_operation            equ 3
0101                       ; Either an issued I/O command was not supported, or a
0102                       ; conflict with the OPEN mode has occured
0103               
0104      0004     io.err.out_of_table_buffer_space    equ 4
0105                       ; The amount of space left on the device is insufficient
0106                       ; for the requested operation
0107               
0108      0005     io.err.eof                          equ 5
0109                       ; Attempt to read past end of file.
0110                       ; This error may also be given for non-existing records
0111                       ; in a relative record file
0112               
0113      0006     io.err.device_error                 equ 6
0114                       ; Covers all hard device errors, such as parity and
0115                       ; bad medium errors
0116               
0117      0007     io.err.file_error                   equ 7
0118                       ; Covers all file-related error like: program/data
0119                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0010               * dsrlnk - DSRLNK for file I/O in DSR space >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  Input:
0016               *  P0     = 8 or 10 (a)
0017               *  @>8356 = Pointer to VDP PAB file descriptor length (PAB+9)
0018               *--------------------------------------------------------------
0019               *  Output:
0020               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0021               *--------------------------------------------------------------
0022               *  Remarks:
0023               *
0024               *  You need to specify following equates in main program
0025               *
0026               *  dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0027               *  dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0028               *
0029               *  Scratchpad memory usage
0030               *  >8322            Parameter (>08) or (>0A) passed to dsrlnk
0031               *  >8356            Pointer to PAB
0032               *  >83D0            CRU address of current device
0033               *  >83D2            DSR entry address
0034               *  >83e0 - >83ff    GPL / DSRLNK workspace
0035               *
0036               *  Credits
0037               *  Originally appeared in Miller Graphics The Smart Programmer.
0038               *  This version based on version of Paolo Bagnaresi.
0039               *
0040               *  The following memory address can be used to directly jump
0041               *  into the DSR in consequtive calls without having to
0042               *  scan the PEB cards again:
0043               *
0044               *  dsrlnk.namsto  -  8-byte RAM buf for holding device name
0045               *  dsrlnk.savcru  -  CRU address of device in prev. DSR call
0046               *  dsrlnk.savent  -  DSR entry addr of prev. DSR call
0047               *  dsrlnk.savpab  -  Pointer to Device or Subprogram in PAB
0048               *  dsrlnk.savver  -  Version used in prev. DSR call
0049               *  dsrlnk.savlen  -  Length of DSR name of prev. DSR call (in MSB)
0050               *  dsrlnk.flgptr  -  Pointer to VDP PAB byte 1 (flag byte)
0051               
0052               *--------------------------------------------------------------
0053      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0054                                                   ; dstype is address of R5 of DSRLNK ws.
0055               ********|*****|*********************|**************************
0056 2B24 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B26 2B28             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B28 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B2A C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B2C A428 
0064 2B2E 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B30 201C 
0065 2B32 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B34 8356 
0066 2B36 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B38 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B3A FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B3C C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B3E A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B40 06C0  14         swpb  r0                    ;
0075 2B42 D800  38         movb  r0,@vdpa              ; Send low byte
     2B44 8C02 
0076 2B46 06C0  14         swpb  r0                    ;
0077 2B48 D800  38         movb  r0,@vdpa              ; Send high byte
     2B4A 8C02 
0078 2B4C D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B4E 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B50 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B52 0704  14         seto  r4                    ; Init counter
0086 2B54 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B56 A420 
0087 2B58 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B5A 0584  14         inc   r4                    ; Increment char counter
0089 2B5C 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B5E 0007 
0090 2B60 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B62 80C4  18         c     r4,r3                 ; End of name?
0093 2B64 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B66 06C0  14         swpb  r0                    ;
0098 2B68 D800  38         movb  r0,@vdpa              ; Send low byte
     2B6A 8C02 
0099 2B6C 06C0  14         swpb  r0                    ;
0100 2B6E D800  38         movb  r0,@vdpa              ; Send high byte
     2B70 8C02 
0101 2B72 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B74 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B76 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B78 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B7A 2C90 
0109 2B7C 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B7E C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B80 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B82 04E0  34         clr   @>83d0
     2B84 83D0 
0118 2B86 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B88 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B8A C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B8C A432 
0121               
0122 2B8E 0584  14         inc   r4                    ; Adjust for dot
0123 2B90 A804  38         a     r4,@>8356             ; Point to position after name
     2B92 8356 
0124 2B94 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B96 8356 
     2B98 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B9A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B9C 83E0 
0130 2B9E 04C1  14         clr   r1                    ; Version found of dsr
0131 2BA0 020C  20         li    r12,>0f00             ; Init cru address
     2BA2 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BA4 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BA6 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BA8 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BAA 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BAC 0100 
0145 2BAE 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BB0 83D0 
0146 2BB2 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BB4 2000 
0147 2BB6 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BB8 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BBA 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BBC 1D00  20         sbo   0                     ; Turn on ROM
0154 2BBE 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BC0 4000 
0155 2BC2 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BC4 2C8C 
0156 2BC6 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BC8 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BCA A40A 
0166 2BCC 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BCE C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BD0 83D2 
0172                                                   ; subprogram
0173               
0174 2BD2 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BD4 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BD6 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BD8 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BDA 83D2 
0183                                                   ; subprogram
0184               
0185 2BDC 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BDE C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BE0 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BE2 D160  34         movb  @>8355,r5             ; Get length as counter
     2BE4 8355 
0195 2BE6 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BE8 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BEA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BEC 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BEE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BF0 A420 
0206 2BF2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BF4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BF6 0605  14         dec   r5                    ; Update loop counter
0211 2BF8 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BFA 0581  14         inc   r1                    ; Next version found
0217 2BFC C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BFE A42A 
0218 2C00 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C02 A42C 
0219 2C04 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C06 A430 
0220               
0221 2C08 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C0A 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C0C 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C0E 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C10 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C12 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C14 A400 
0233 2C16 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C18 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C1A A428 
0239                                                   ; (8 or >a)
0240 2C1C 0281  22         ci    r1,8                  ; was it 8?
     2C1E 0008 
0241 2C20 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C22 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C24 8350 
0243                                                   ; Get error byte from @>8350
0244 2C26 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C28 06C0  14         swpb  r0                    ;
0252 2C2A D800  38         movb  r0,@vdpa              ; send low byte
     2C2C 8C02 
0253 2C2E 06C0  14         swpb  r0                    ;
0254 2C30 D800  38         movb  r0,@vdpa              ; send high byte
     2C32 8C02 
0255 2C34 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C36 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C38 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C3A 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C3C 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C3E 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C40 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C42 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C44 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C46 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C48 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C4A F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C4C 201C 
0281                                                   ; / to indicate error
0282 2C4E 0380  18         rtwp                        ; Return from DSR workspace to caller
0283                                                   ; workspace
0284               
0285               
0286               ***************************************************************
0287               * dsrln.reuse - Reuse previous DSRLNK call for improved speed
0288               ***************************************************************
0289               *  blwp @dsrlnk.reuse
0290               *--------------------------------------------------------------
0291               *  Input:
0292               *  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
0293               *  @dsrlnk.savcru = CRU address of device in previous DSR call
0294               *  @dsrlnk.savent = DSR entry address of previous DSR call
0295               *  @dsrlnk.savver = Version used in previous DSR call
0296               *  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
0297               *--------------------------------------------------------------
0298               *  Output:
0299               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0300               *--------------------------------------------------------------
0301               *  Remarks:
0302               *   Call the same DSR entry again without having to scan through
0303               *   all devices again.
0304               *
0305               *   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
0306               *   set by previous DSRLNK call.
0307               ********|*****|*********************|**************************
0308               dsrlnk.reuse:
0309 2C50 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C52 2C54             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C54 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C56 83E0 
0316               
0317 2C58 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C5A 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C5C 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C5E A42A 
0322 2C60 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C62 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C64 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C66 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C68 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C6A C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C6C 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C6E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C70 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C72 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C74 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C76 4000 
     2C78 2C8C 
0337 2C7A 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C7C 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C7E 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C80 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C82 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C84 A400 
0355 2C86 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C88 A434 
0356               
0357 2C8A 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C8C AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C8E 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C90 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0220                       copy  "fio_level3.asm"           ; File I/O level 3 support
**** **** ****     > fio_level3.asm
0001               * FILE......: fio_level3.asm
0002               * Purpose...: File I/O level 3 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
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
0029               *       data P0,P1
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *  P1 = LSB contains File type/mode
0033               *--------------------------------------------------------------
0034               *  bl   @xfile.open
0035               *
0036               *  R0 = Address of PAB in VDP RAM
0037               *  R1 = LSB contains File type/mode
0038               *--------------------------------------------------------------
0039               *  Output:
0040               *  tmp0     = Copy of VDP PAB byte 1 after operation
0041               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0042               *  tmp2 LSB = Copy of status register after operation
0043               ********|*****|*********************|**************************
0044               file.open:
0045 2C92 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C94 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C96 0649  14         dect  stack
0052 2C98 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C9A 0204  20         li    tmp0,dsrlnk.savcru
     2C9C A42A 
0057 2C9E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2CA0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CA2 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CA4 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CA6 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CA8 37D7 
0065 2CAA C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CAC 8370 
0066                                                   ; / location
0067 2CAE C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CB0 A44C 
0068 2CB2 04C5  14         clr   tmp1                  ; io.op.open
0069 2CB4 101F  14         jmp   _file.record.fop      ; Do file operation
0070               
0071               
0072               
0073               ***************************************************************
0074               * file.close - Close currently open file
0075               ***************************************************************
0076               *  bl   @file.close
0077               *       data P0
0078               *--------------------------------------------------------------
0079               *  P0 = Address of PAB in VDP RAM
0080               *--------------------------------------------------------------
0081               *  bl   @xfile.close
0082               *
0083               *  R0 = Address of PAB in VDP RAM
0084               *--------------------------------------------------------------
0085               *  Output:
0086               *  tmp0 LSB = Copy of VDP PAB byte 1 after operation
0087               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0088               *  tmp2 LSB = Copy of status register after operation
0089               ********|*****|*********************|**************************
0090               file.close:
0091 2CB6 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CB8 0649  14         dect  stack
0097 2CBA C64B  30         mov   r11,*stack            ; Save return address
0098 2CBC 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CBE 0001 
0099 2CC0 1019  14         jmp   _file.record.fop      ; Do file operation
0100               
0101               
0102               ***************************************************************
0103               * file.record.read - Read record from file
0104               ***************************************************************
0105               *  bl   @file.record.read
0106               *       data P0
0107               *--------------------------------------------------------------
0108               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0109               *--------------------------------------------------------------
0110               *  bl   @xfile.record.read
0111               *
0112               *  R0 = Address of PAB in VDP RAM
0113               *--------------------------------------------------------------
0114               *  Output:
0115               *  tmp0     = Copy of VDP PAB byte 1 after operation
0116               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0117               *  tmp2 LSB = Copy of status register after operation
0118               ********|*****|*********************|**************************
0119               file.record.read:
0120 2CC2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CC4 0649  14         dect  stack
0125 2CC6 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CC8 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CCA 0002 
0128 2CCC 1013  14         jmp   _file.record.fop      ; Do file operation
0129               
0130               
0131               
0132               ***************************************************************
0133               * file.record.write - Write record to file
0134               ***************************************************************
0135               *  bl   @file.record.write
0136               *       data P0
0137               *--------------------------------------------------------------
0138               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0139               *--------------------------------------------------------------
0140               *  bl   @xfile.record.write
0141               *
0142               *  R0 = Address of PAB in VDP RAM
0143               *--------------------------------------------------------------
0144               *  Output:
0145               *  tmp0     = Copy of VDP PAB byte 1 after operation
0146               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0147               *  tmp2 LSB = Copy of status register after operation
0148               ********|*****|*********************|**************************
0149               file.record.write:
0150 2CCE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CD0 0649  14         dect  stack
0155 2CD2 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CD4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CD6 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CD8 0005 
0159               
0160 2CDA C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CDC A43E 
0161               
0162 2CDE 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CE0 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CE2 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CE4 0003 
0167 2CE6 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CE8 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CEA 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CEC 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CEE 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CF0 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CF2 1000  14         nop
0193               
0194               
0195               
0196               ***************************************************************
0197               * file.record.fop - File operation
0198               ***************************************************************
0199               * Called internally via JMP/B by file operations
0200               *--------------------------------------------------------------
0201               *  Input:
0202               *  r0   = Address of PAB in VDP RAM
0203               *  r1   = File type/mode
0204               *  tmp1 = File operation opcode
0205               *
0206               *  @fh.offsetopcode = >00  Data buffer in VDP RAM
0207               *  @fh.offsetopcode = >40  Data buffer in CPU RAM
0208               *--------------------------------------------------------------
0209               *  Output:
0210               *  tmp0     = Copy of VDP PAB byte 1 after operation
0211               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0212               *  tmp2 LSB = Copy of status register after operation
0213               *--------------------------------------------------------------
0214               *  Register usage:
0215               *  r0, r1, tmp0, tmp1, tmp2
0216               *--------------------------------------------------------------
0217               *  Remarks
0218               *  Private, only to be called from inside fio_level2 module
0219               *  via jump or branch instruction.
0220               *
0221               *  Uses @waux1 for backup/restore of memory word @>8322
0222               ********|*****|*********************|**************************
0223               _file.record.fop:
0224                       ;------------------------------------------------------
0225                       ; Write to PAB required?
0226                       ;------------------------------------------------------
0227 2CF4 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CF6 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CFA A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CFC A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CFE 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D00 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D02 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D04 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D06 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D08 A44C 
0246               
0247 2D0A 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D0C 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D0E 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D10 0009 
0254 2D12 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D14 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D16 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D18 8322 
     2D1A 833C 
0259               
0260 2D1C C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D1E A42A 
0261 2D20 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D22 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D24 2B24 
0268 2D26 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D28 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D2A 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D2C 2C50 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D2E 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D30 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D32 833C 
     2D34 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D36 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D38 A436 
0292 2D3A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D3C 0005 
0293 2D3E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D40 22E8 
0294 2D42 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D44 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0299                                                   ; as returned by DSRLNK
0300               *--------------------------------------------------------------
0301               * Exit
0302               *--------------------------------------------------------------
0303               ; If an error occured during the IO operation, then the
0304               ; equal bit in the saved status register (=tmp2) is set to 1.
0305               ;
0306               ; Upon return from this IO call you should basically test with:
0307               ;       coc   @wbit2,tmp2           ; Equal bit set?
0308               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0309               ;
0310               ; Then look for further details in the copy of VDP PAB byte 1
0311               ; in register tmp0, bits 13-15
0312               ;
0313               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0314               ;                                   ; calls, skip for type >A subprograms!)
0315               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0316               ;       jeq   my_error_handler
0317               *--------------------------------------------------------------
0318               _file.record.fop.exit:
0319 2D46 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D48 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0222               
0223               *//////////////////////////////////////////////////////////////
0224               *                            TIMERS
0225               *//////////////////////////////////////////////////////////////
0226               
0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0011               *  This is basically the kernel keeping everything together.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2D4A 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D4C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D4E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D50 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D52 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D54 201C 
0029 2D56 1602  14         jne   tmgr1a                ; No, so move on
0030 2D58 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D5A 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D5C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D5E 2020 
0035 2D60 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D62 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D64 2010 
0048 2D66 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D68 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D6A 200E 
0050 2D6C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D6E 0460  28         b     @kthread              ; Run kernel thread
     2D70 2DE8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D72 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D74 2014 
0056 2D76 13EB  14         jeq   tmgr1
0057 2D78 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D7A 2012 
0058 2D7C 16E8  14         jne   tmgr1
0059 2D7E C120  34         mov   @wtiusr,tmp0
     2D80 832E 
0060 2D82 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D84 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D86 2DE6 
0065 2D88 C10A  18         mov   r10,tmp0
0066 2D8A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D8C 00FF 
0067 2D8E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D90 201C 
0068 2D92 1303  14         jeq   tmgr5
0069 2D94 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D96 003C 
0070 2D98 1002  14         jmp   tmgr6
0071 2D9A 0284  22 tmgr5   ci    tmp0,50
     2D9C 0032 
0072 2D9E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2DA0 1001  14         jmp   tmgr8
0074 2DA2 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DA4 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DA6 832C 
0079 2DA8 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DAA FF00 
0080 2DAC C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DAE 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DB0 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DB2 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DB4 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DB6 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DB8 830C 
     2DBA 830D 
0089 2DBC 1608  14         jne   tmgr10                ; No, get next slot
0090 2DBE 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DC0 FF00 
0091 2DC2 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DC4 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DC6 8330 
0096 2DC8 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DCA C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DCC 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DCE 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DD0 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DD2 8315 
     2DD4 8314 
0103 2DD6 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DD8 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DDA 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DDC 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DDE 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DE0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DE2 FF00 
0109 2DE4 10B4  14         jmp   tmgr1
0110 2DE6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2DE8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DEA 2010 
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
0041 2DEC 06A0  32         bl    @realkb               ; Scan full keyboard
     2DEE 27F0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DF0 0460  28         b     @tmgr3                ; Exit
     2DF2 2D72 
**** **** ****     > runlib.asm
0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2DF4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DF6 832E 
0018 2DF8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DFA 2012 
0019 2DFC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D4E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DFE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E00 832E 
0029 2E02 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E04 FEFF 
0030 2E06 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0230               
0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2E08 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E0A C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E0C C184  18         mov   tmp0,tmp2
0023 2E0E 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E10 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E12 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E14 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E16 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E18 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E1A 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E1C 2022 
0035 2E1E 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E20 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E22 05CB  14 mkslo1  inct  r11
0041 2E24 045B  20         b     *r11                  ; Exit
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
0052 2E26 C13B  30 clslot  mov   *r11+,tmp0
0053 2E28 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E2A A120  34         a     @wtitab,tmp0          ; Add table base
     2E2C 832C 
0055 2E2E 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E30 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E32 045B  20         b     *r11                  ; Exit
0058               
0059               
0060               ***************************************************************
0061               * RSSLOT - Reset single timer slot loop counter
0062               ***************************************************************
0063               *  BL    @RSSLOT
0064               *  DATA  P0
0065               *--------------------------------------------------------------
0066               *  P0 = Slot number
0067               ********|*****|*********************|**************************
0068 2E34 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E36 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E38 A120  34         a     @wtitab,tmp0          ; Add table base
     2E3A 832C 
0071 2E3C 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E3E C154  26         mov   *tmp0,tmp1
0073 2E40 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E42 FF00 
0074 2E44 C505  30         mov   tmp1,*tmp0
0075 2E46 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0234               
0235               
0236               
0237               *//////////////////////////////////////////////////////////////
0238               *                    RUNLIB INITIALISATION
0239               *//////////////////////////////////////////////////////////////
0240               
0241               ***************************************************************
0242               *  RUNLIB - Runtime library initalisation
0243               ***************************************************************
0244               *  B  @RUNLIB
0245               *--------------------------------------------------------------
0246               *  REMARKS
0247               *  if R0 in WS1 equals >4a4a we were called from the system
0248               *  crash handler so we return there after initialisation.
0249               
0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0251               *  after clearing scratchpad memory. This has higher priority
0252               *  as crash handler flag R0.
0253               ********|*****|*********************|**************************
0260 2E48 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E4A 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E4C 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E4E 0000 
0266 2E50 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E52 8300 
0267 2E54 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E56 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E58 0202  20 runli2  li    r2,>8308
     2E5A 8308 
0272 2E5C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E5E 0282  22         ci    r2,>8400
     2E60 8400 
0274 2E62 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E64 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E66 FFFF 
0279 2E68 1602  14         jne   runli4                ; No, continue
0280 2E6A 0420  54         blwp  @0                    ; Yes, bye bye
     2E6C 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E6E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E70 833C 
0285 2E72 04C1  14         clr   r1                    ; Reset counter
0286 2E74 0202  20         li    r2,10                 ; We test 10 times
     2E76 000A 
0287 2E78 C0E0  34 runli5  mov   @vdps,r3
     2E7A 8802 
0288 2E7C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E7E 2020 
0289 2E80 1302  14         jeq   runli6
0290 2E82 0581  14         inc   r1                    ; Increase counter
0291 2E84 10F9  14         jmp   runli5
0292 2E86 0602  14 runli6  dec   r2                    ; Next test
0293 2E88 16F7  14         jne   runli5
0294 2E8A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E8C 1250 
0295 2E8E 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E90 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E92 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E94 06A0  32 runli7  bl    @loadmc
     2E96 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E98 04C1  14 runli9  clr   r1
0305 2E9A 04C2  14         clr   r2
0306 2E9C 04C3  14         clr   r3
0307 2E9E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2EA0 3000 
0308 2EA2 020F  20         li    r15,vdpw              ; Set VDP write address
     2EA4 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2EA6 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EA8 4A4A 
0317 2EAA 1605  14         jne   runlia
0318 2EAC 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EAE 2292 
0319 2EB0 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EB2 0000 
     2EB4 3000 
0324 2EB6 06A0  32 runlia  bl    @filv
     2EB8 2292 
0325 2EBA 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EBC 00F4 
     2EBE 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2EC0 06A0  32         bl    @f18unl               ; Unlock the F18A
     2EC2 2736 
0333 2EC4 06A0  32         bl    @f18chk               ; Check if F18A is there
     2EC6 2750 
0334 2EC8 06A0  32         bl    @f18lck               ; Lock the F18A again
     2ECA 2746 
0335               
0336 2ECC 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2ECE 2336 
0337 2ED0 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2ED2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2ED4 22FC 
0351 2ED6 339A             data  spvmod                ; Equate selected video mode table
0352 2ED8 0204  20         li    tmp0,spfont           ; Get font option
     2EDA 000C 
0353 2EDC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EDE 1304  14         jeq   runlid                ; Yes, skip it
0355 2EE0 06A0  32         bl    @ldfnt
     2EE2 2364 
0356 2EE4 1100             data  fntadr,spfont         ; Load specified font
     2EE6 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EE8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EEA 4A4A 
0361 2EEC 1602  14         jne   runlie                ; No, continue
0362 2EEE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EF0 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EF2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EF4 0040 
0367 2EF6 0460  28         b     @main                 ; Give control to main program
     2EF8 6036 
**** **** ****     > stevie_b1.asm.1390892
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 2EFA DEAD             data >dead,>beef,>dead,>beef
     2EFC BEEF 
     2EFE DEAD 
     2F00 BEEF 
0048               ***************************************************************
0049               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0050               ********|*****|*********************|**************************
0051                       aorg  >3000
0052                       ;------------------------------------------------------
0053                       ; Activate bank 1 and branch to  >6036
0054                       ;------------------------------------------------------
0055 3000 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3002 6002 
0056               
0060               
0061 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0062                       ;------------------------------------------------------
0063                       ; Resident Stevie modules: >3000 - >3fff
0064                       ;------------------------------------------------------
0065                       copy  "ram.resident.3000.asm"
**** **** ****     > ram.resident.3000.asm
0001               * FILE......: ram.resident.3000.asm
0002               * Purpose...: Resident modules at RAM >3000 callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules >3000 - >3fff
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
**** **** ****     > rom.farjump.asm
0001               * FILE......: rom.farjump.asm
0002               * Purpose...: Trampoline to routine in other ROM bank
0003               
0004               ***************************************************************
0005               * rom.farjump - Jump to routine in specified bank
0006               ***************************************************************
0007               *  bl   @rom.farjump
0008               *       data p0,p1
0009               *--------------------------------------------------------------
0010               *  p0 = Write address of target ROM bank
0011               *  p1 = Vector address with target address to jump to
0012               *  p2 = Write address of source ROM bank
0013               *--------------------------------------------------------------
0014               *  bl @xrom.farjump
0015               *
0016               *  tmp0 = Write address of target ROM bank
0017               *  tmp1 = Vector address with target address to jump to
0018               *  tmp2 = Write address of source ROM bank
0019               ********|*****|*********************|**************************
0020               rom.farjump:
0021 3008 C13B  30         mov   *r11+,tmp0            ; P0
0022 300A C17B  30         mov   *r11+,tmp1            ; P1
0023 300C C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 300E 0649  14         dect  stack
0029 3010 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 3012 0649  14         dect  stack
0031 3014 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 3016 0649  14         dect  stack
0033 3018 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 301A 0649  14         dect  stack
0035 301C C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 301E 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     3020 6000 
0040 3022 1111  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 3024 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     3026 A026 
0044 3028 0647  14         dect  tmp3
0045 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 302C 0647  14         dect  tmp3
0047 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A026 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 3034 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 3036 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 3038 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 303A 0224  22         ai    tmp0,>0800
     303C 0800 
0066 303E 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071 3040 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0072 3042 1301  14         jeq   rom.farjump.bankswitch.failed1
0073                                                   ; Crash if null-pointer in vector
0074 3044 1004  14         jmp   rom.farjump.bankswitch.call
0075                                                   ; Call function in target bank
0076                       ;------------------------------------------------------
0077                       ; Assert 1 failed before bank-switch
0078                       ;------------------------------------------------------
0079               rom.farjump.bankswitch.failed1:
0080 3046 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3048 FFCE 
0081 304A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     304C 2026 
0082                       ;------------------------------------------------------
0083                       ; Call function in target bank
0084                       ;------------------------------------------------------
0085               rom.farjump.bankswitch.call:
0086 304E 0694  24         bl    *tmp0                 ; Call function
0087                       ;------------------------------------------------------
0088                       ; Bankswitch back to source bank
0089                       ;------------------------------------------------------
0090               rom.farjump.return:
0091 3050 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3052 A026 
0092 3054 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0093 3056 1312  14         jeq   rom.farjump.bankswitch.failed2
0094                                                   ; Crash if null-pointer in address
0095               
0096 3058 04F4  30         clr   *tmp0+                ; Remove bank write address from
0097                                                   ; farjump stack
0098               
0099 305A C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0100               
0101 305C 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0102                                                   ; farjump stack
0103               
0104 305E 028B  22         ci    r11,>6000
     3060 6000 
0105 3062 110C  14         jlt   rom.farjump.bankswitch.failed2
0106 3064 028B  22         ci    r11,>7fff
     3066 7FFF 
0107 3068 1509  14         jgt   rom.farjump.bankswitch.failed2
0108               
0109 306A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     306C A026 
0110               
0114               
0115                       ;------------------------------------------------------
0116                       ; Bankswitch to source 8K ROM bank
0117                       ;------------------------------------------------------
0118               rom.farjump.bankswitch.src.rom8k:
0119 306E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0120 3070 1009  14         jmp   rom.farjump.exit
0121                       ;------------------------------------------------------
0122                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0123                       ;------------------------------------------------------
0124               rom.farjump.bankswitch.src.advfg99:
0125 3072 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0126 3074 0225  22         ai    tmp1,>0800
     3076 0800 
0127 3078 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0128 307A 1004  14         jmp   rom.farjump.exit
0129                       ;------------------------------------------------------
0130                       ; Assert 2 failed after bank-switch
0131                       ;------------------------------------------------------
0132               rom.farjump.bankswitch.failed2:
0133 307C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     307E FFCE 
0134 3080 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3082 2026 
0135                       ;-------------------------------------------------------
0136                       ; Exit
0137                       ;-------------------------------------------------------
0138               rom.farjump.exit:
0139 3084 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0140 3086 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 3088 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 308A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 308C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0008                       copy  "fb.asm"                 ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               ***************************************************************
0005               * fb.init
0006               * Initialize framebuffer
0007               ***************************************************************
0008               *  bl   @fb.init
0009               *--------------------------------------------------------------
0010               *  INPUT
0011               *  none
0012               *--------------------------------------------------------------
0013               *  OUTPUT
0014               *  none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               fb.init:
0020 308E 0649  14         dect  stack
0021 3090 C64B  30         mov   r11,*stack            ; Save return address
0022 3092 0649  14         dect  stack
0023 3094 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3096 0649  14         dect  stack
0025 3098 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 309A 0204  20         li    tmp0,fb.top
     309C A600 
0030 309E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     30A0 A100 
0031 30A2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     30A4 A104 
0032 30A6 04E0  34         clr   @fb.row               ; Current row=0
     30A8 A106 
0033 30AA 04E0  34         clr   @fb.column            ; Current column=0
     30AC A10C 
0034               
0035 30AE 0204  20         li    tmp0,colrow
     30B0 0050 
0036 30B2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30B4 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30B6 C160  34         mov   @tv.ruler.visible,tmp1
     30B8 A010 
0041 30BA 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30BC 0204  20         li    tmp0,pane.botrow-2
     30BE 001B 
0043 30C0 1002  14         jmp   fb.init.cont
0044 30C2 0204  20 !       li    tmp0,pane.botrow-1
     30C4 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30C6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30C8 A11A 
0050 30CA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30CC A11C 
0051               
0052 30CE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30D0 A022 
0053 30D2 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30D4 A110 
0054 30D6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30D8 A116 
0055 30DA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30DC A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30DE 06A0  32         bl    @film
     30E0 223A 
0060 30E2 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30E4 0000 
     30E6 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30EC C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30EE 045B  20         b     *r11                  ; Return to caller
0069               
**** **** ****     > ram.resident.3000.asm
0009                       copy  "idx.asm"                ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Index management
0003               
0004               ***************************************************************
0005               *  Size of index page is 4K and allows indexing of 2048 lines
0006               *  per page.
0007               *
0008               *  Each index slot (word) has the format:
0009               *    +-----+-----+
0010               *    | MSB | LSB |
0011               *    +-----|-----+   LSB = Pointer offset 00-ff.
0012               *
0013               *  MSB = SAMS Page 00-ff
0014               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0015               *
0016               *  LSB = Pointer offset in range 00-ff
0017               *
0018               *        To calculate pointer to line in Editor buffer:
0019               *        Pointer address = edb.top + (LSB * 16)
0020               *
0021               *        Note that the editor buffer itself resides in own 4K memory range
0022               *        starting at edb.top
0023               *
0024               *        All support routines must assure that length-prefixed string in
0025               *        Editor buffer always start on a 16 byte boundary for being
0026               *        accessible via index.
0027               ***************************************************************
0028               
0029               
0030               ***************************************************************
0031               * idx.init
0032               * Initialize index
0033               ***************************************************************
0034               * bl @idx.init
0035               *--------------------------------------------------------------
0036               * INPUT
0037               * none
0038               *--------------------------------------------------------------
0039               * OUTPUT
0040               * none
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0
0044               ********|*****|*********************|**************************
0045               idx.init:
0046 30F0 0649  14         dect  stack
0047 30F2 C64B  30         mov   r11,*stack            ; Save return address
0048 30F4 0649  14         dect  stack
0049 30F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30F8 0204  20         li    tmp0,idx.top
     30FA B000 
0054 30FC C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30FE A202 
0055               
0056 3100 C120  34         mov   @tv.sams.b000,tmp0
     3102 A006 
0057 3104 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     3106 A500 
0058 3108 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     310A A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 310C 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     310E 0004 
0063 3110 C804  38         mov   tmp0,@idx.sams.hipage ; /
     3112 A504 
0064               
0065 3114 06A0  32         bl    @_idx.sams.mapcolumn.on
     3116 3132 
0066                                                   ; Index in continuous memory region
0067               
0068 3118 06A0  32         bl    @film
     311A 223A 
0069 311C B000                   data idx.top,>00,idx.size * 5
     311E 0000 
     3120 5000 
0070                                                   ; Clear index
0071               
0072 3122 06A0  32         bl    @_idx.sams.mapcolumn.off
     3124 3166 
0073                                                   ; Restore memory window layout
0074               
0075 3126 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     3128 A502 
     312A A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 312C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 312E C2F9  30         mov   *stack+,r11           ; Pop r11
0083 3130 045B  20         b     *r11                  ; Return to caller
0084               
0085               
0086               ***************************************************************
0087               * bl @_idx.sams.mapcolumn.on
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0, tmp1, tmp2
0091               *--------------------------------------------------------------
0092               *  Remarks
0093               *  Private, only to be called from inside idx module
0094               ********|*****|*********************|**************************
0095               _idx.sams.mapcolumn.on:
0096 3132 0649  14         dect  stack
0097 3134 C64B  30         mov   r11,*stack            ; Push return address
0098 3136 0649  14         dect  stack
0099 3138 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 313A 0649  14         dect  stack
0101 313C C645  30         mov   tmp1,*stack           ; Push tmp1
0102 313E 0649  14         dect  stack
0103 3140 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 3142 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3144 A502 
0108 3146 0205  20         li    tmp1,idx.top
     3148 B000 
0109 314A 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     314C 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 314E 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3150 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 3152 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3154 0225  22         ai    tmp1,>1000            ; Next memory region
     3156 1000 
0119 3158 0606  14         dec   tmp2                  ; Update loop counter
0120 315A 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 315C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 315E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3162 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3164 045B  20         b     *r11                  ; Return to caller
0130               
0131               
0132               ***************************************************************
0133               * _idx.sams.mapcolumn.off
0134               * Restore normal SAMS layout again (single index page)
0135               ***************************************************************
0136               * bl @_idx.sams.mapcolumn.off
0137               *--------------------------------------------------------------
0138               * Register usage
0139               * tmp0, tmp1, tmp2, tmp3
0140               *--------------------------------------------------------------
0141               *  Remarks
0142               *  Private, only to be called from inside idx module
0143               ********|*****|*********************|**************************
0144               _idx.sams.mapcolumn.off:
0145 3166 0649  14         dect  stack
0146 3168 C64B  30         mov   r11,*stack            ; Push return address
0147 316A 0649  14         dect  stack
0148 316C C644  30         mov   tmp0,*stack           ; Push tmp0
0149 316E 0649  14         dect  stack
0150 3170 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3172 0649  14         dect  stack
0152 3174 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3176 0649  14         dect  stack
0154 3178 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 317A 0205  20         li    tmp1,idx.top
     317C B000 
0159 317E 0206  20         li    tmp2,5                ; Always 5 pages
     3180 0005 
0160 3182 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3184 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3186 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3188 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     318A 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 318C 0225  22         ai    tmp1,>1000            ; Next memory region
     318E 1000 
0171 3190 0606  14         dec   tmp2                  ; Update loop counter
0172 3192 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3194 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 3196 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 3198 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 319A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 319C C2F9  30         mov   *stack+,r11           ; Pop return address
0182 319E 045B  20         b     *r11                  ; Return to caller
0183               
0184               
0185               
0186               ***************************************************************
0187               * _idx.samspage.get
0188               * Get SAMS page for index
0189               ***************************************************************
0190               * bl @_idx.samspage.get
0191               *--------------------------------------------------------------
0192               * INPUT
0193               * tmp0 = Line number
0194               *--------------------------------------------------------------
0195               * OUTPUT
0196               * @outparm1 = Offset for index entry in index SAMS page
0197               *--------------------------------------------------------------
0198               * Register usage
0199               * tmp0, tmp1, tmp2
0200               *--------------------------------------------------------------
0201               *  Remarks
0202               *  Private, only to be called from inside idx module.
0203               *  Activates SAMS page containing required index slot entry.
0204               ********|*****|*********************|**************************
0205               _idx.samspage.get:
0206 31A0 0649  14         dect  stack
0207 31A2 C64B  30         mov   r11,*stack            ; Save return address
0208 31A4 0649  14         dect  stack
0209 31A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 31A8 0649  14         dect  stack
0211 31AA C645  30         mov   tmp1,*stack           ; Push tmp1
0212 31AC 0649  14         dect  stack
0213 31AE C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 31B0 C184  18         mov   tmp0,tmp2             ; Line number
0218 31B2 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31B4 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31B6 0800 
0220               
0221 31B8 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31BA 0A16  56         sla   tmp2,1                ; line number * 2
0226 31BC C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31BE 2F30 
0227               
0228 31C0 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31C2 A502 
0229 31C4 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31C6 A500 
0230               
0231 31C8 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31CA C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31CC A500 
0237 31CE C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31D0 A006 
0238               
0239 31D2 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31D4 0205  20         li    tmp1,>b000            ; Memory window for index page
     31D6 B000 
0241               
0242 31D8 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31DA 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31DC 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31DE A504 
0249 31E0 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31E2 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31E4 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31E6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31EC C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31EE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0010                       copy  "edb.asm"                ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               ***************************************************************
0005               * edb.init
0006               * Initialize Editor buffer
0007               ***************************************************************
0008               * bl @edb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               edb.init:
0022 31F0 0649  14         dect  stack
0023 31F2 C64B  30         mov   r11,*stack            ; Save return address
0024 31F4 0649  14         dect  stack
0025 31F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31F8 0204  20         li    tmp0,edb.top          ; \
     31FA C000 
0030 31FC C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31FE A200 
0031 3200 C804  38         mov   tmp0,@edb.next_free.ptr
     3202 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 3204 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3206 A20A 
0035               
0036 3208 0204  20         li    tmp0,1
     320A 0001 
0037 320C C804  38         mov   tmp0,@edb.lines       ; Lines=1
     320E A204 
0038               
0039 3210 0720  34         seto  @edb.block.m1         ; Reset block start line
     3212 A20C 
0040 3214 0720  34         seto  @edb.block.m2         ; Reset block end line
     3216 A20E 
0041               
0042 3218 0204  20         li    tmp0,txt.newfile      ; "New file"
     321A 3524 
0043 321C C804  38         mov   tmp0,@edb.filename.ptr
     321E A212 
0044               
0045 3220 0204  20         li    tmp0,txt.filetype.none
     3222 35EE 
0046 3224 C804  38         mov   tmp0,@edb.filetype.ptr
     3226 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 3228 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 322A C2F9  30         mov   *stack+,r11           ; Pop r11
0054 322C 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.3000.asm
0011                       copy  "cmdb.asm"               ; Command buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               ***************************************************************
0005               * cmdb.init
0006               * Initialize Command Buffer
0007               ***************************************************************
0008               * bl @cmdb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.init:
0022 322E 0649  14         dect  stack
0023 3230 C64B  30         mov   r11,*stack            ; Save return address
0024 3232 0649  14         dect  stack
0025 3234 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3236 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3238 D000 
0030 323A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     323C A300 
0031               
0032 323E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3240 A302 
0033 3242 0204  20         li    tmp0,4
     3244 0004 
0034 3246 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3248 A306 
0035 324A C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     324C A308 
0036               
0037 324E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3250 A316 
0038 3252 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3254 A318 
0039 3256 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3258 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 325A 06A0  32         bl    @film
     325C 223A 
0044 325E D000             data  cmdb.top,>00,cmdb.size
     3260 0000 
     3262 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3264 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3266 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3268 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0012                       copy  "errline.asm"            ; Error line
**** **** ****     > errline.asm
0001               * FILE......: errline.asm
0002               * Purpose...: Stevie Editor - Error line utilities
0003               
0004               ***************************************************************
0005               * errline.init
0006               * Initialize error line
0007               ***************************************************************
0008               * bl @errline.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               errline.init:
0022 326A 0649  14         dect  stack
0023 326C C64B  30         mov   r11,*stack            ; Save return address
0024 326E 0649  14         dect  stack
0025 3270 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3272 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3274 A028 
0030               
0031 3276 06A0  32         bl    @film
     3278 223A 
0032 327A A02A                   data tv.error.msg,0,160
     327C 0000 
     327E 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3280 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3282 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3284 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.3000.asm
0013                       copy  "tv.asm"                 ; Main editor configuration
**** **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               ***************************************************************
0005               * tv.init
0006               * Initialize editor settings
0007               ***************************************************************
0008               * bl @tv.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               tv.init:
0022 3286 0649  14         dect  stack
0023 3288 C64B  30         mov   r11,*stack            ; Save return address
0024 328A 0649  14         dect  stack
0025 328C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 328E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3290 0001 
0030 3292 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3294 A012 
0031               
0032 3296 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3298 A024 
0033 329A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     329C 200C 
0034               
0035 329E 0204  20         li    tmp0,fj.bottom
     32A0 F000 
0036 32A2 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32A4 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 32A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 32A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 32AA 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               
0047               ***************************************************************
0048               * tv.reset
0049               * Reset editor (clear buffer)
0050               ***************************************************************
0051               * bl @tv.reset
0052               *--------------------------------------------------------------
0053               * INPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * OUTPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * r11
0061               *--------------------------------------------------------------
0062               * Notes
0063               ***************************************************************
0064               tv.reset:
0065 32AC 0649  14         dect  stack
0066 32AE C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 32B0 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32B2 322E 
0071 32B4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32B6 31F0 
0072 32B8 06A0  32         bl    @idx.init             ; Initialize index
     32BA 30F0 
0073 32BC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32BE 308E 
0074 32C0 06A0  32         bl    @errline.init         ; Initialize error line
     32C2 326A 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 32C4 06A0  32         bl    @hchar
     32C6 27C8 
0079 32C8 0034                   byte 0,52,32,18           ; Remove markers
     32CA 2012 
0080 32CC 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     32CE 2033 
0081 32D0 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32D2 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0014                       copy  "tv.utils.asm"           ; General purpose utility functions
**** **** ****     > tv.utils.asm
0001               * FILE......: tv.utils.asm
0002               * Purpose...: General purpose utility functions
0003               
0004               ***************************************************************
0005               * tv.unpack.uint16
0006               * Unpack 16bit unsigned integer to string
0007               ***************************************************************
0008               * bl @tv.unpack.uint16
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = 16bit unsigned integer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @unpacked.string = Length-prefixed string with unpacked uint16
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.unpack.uint16:
0020 32D6 0649  14         dect  stack
0021 32D8 C64B  30         mov   r11,*stack            ; Save return address
0022 32DA 0649  14         dect  stack
0023 32DC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32DE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32E0 29DA 
0028 32E2 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32E4 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32E6 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32E8 0204  20         li    tmp0,unpacked.string
     32EA 2F44 
0034 32EC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32EE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32F0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32F2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32F4 2A32 
0039 32F6 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32F8 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32FA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32FE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3300 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0051               
0052               
0053               
0054               ***************************************************************
0055               * tv.pad.string
0056               * pad string to specified length
0057               ***************************************************************
0058               * bl @tv.pad.string
0059               *--------------------------------------------------------------
0060               * INPUT
0061               * @parm1 = Pointer to length-prefixed string
0062               * @parm2 = Requested length
0063               * @parm3 = Fill character
0064               * @parm4 = Pointer to string buffer
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               * @outparm1 = Pointer to padded string
0068               *--------------------------------------------------------------
0069               * Register usage
0070               * none
0071               ***************************************************************
0072               tv.pad.string:
0073 3302 0649  14         dect  stack
0074 3304 C64B  30         mov   r11,*stack            ; Push return address
0075 3306 0649  14         dect  stack
0076 3308 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 330A 0649  14         dect  stack
0078 330C C645  30         mov   tmp1,*stack           ; Push tmp1
0079 330E 0649  14         dect  stack
0080 3310 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 3312 0649  14         dect  stack
0082 3314 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 3316 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     3318 2F20 
0087 331A D194  26         movb  *tmp0,tmp2            ; /
0088 331C 0986  56         srl   tmp2,8                ; Right align
0089 331E C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3320 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3322 2F22 
0092 3324 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 3326 C120  34         mov   @parm1,tmp0           ; Get source address
     3328 2F20 
0097 332A C160  34         mov   @parm4,tmp1           ; Get destination address
     332C 2F26 
0098 332E 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3330 0649  14         dect  stack
0101 3332 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3334 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3336 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 3338 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 333A C120  34         mov   @parm2,tmp0           ; Get requested length
     333C 2F22 
0113 333E 0A84  56         sla   tmp0,8                ; Left align
0114 3340 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3342 2F26 
0115 3344 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 3346 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 3348 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 334A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     334C 2F22 
0122 334E 6187  18         s     tmp3,tmp2             ; |
0123 3350 0586  14         inc   tmp2                  ; /
0124               
0125 3352 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3354 2F24 
0126 3356 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 3358 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 335A 0606  14         dec   tmp2                  ; Update loop counter
0133 335C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 335E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3360 2F26 
     3362 2F30 
0136 3364 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3366 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3368 FFCE 
0142 336A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     336C 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 336E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3370 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3372 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3374 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3376 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3378 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0015                       copy  "mem.asm"                ; Memory Management (SAMS)
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: Stevie Editor - Memory management (SAMS)
0003               
0004               ***************************************************************
0005               * mem.sams.layout
0006               * Setup SAMS memory pages for Stevie
0007               ***************************************************************
0008               * bl  @mem.sams.layout
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ***************************************************************
0016               mem.sams.layout:
0017 337A 0649  14         dect  stack
0018 337C C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 337E 06A0  32         bl    @sams.layout
     3380 25E6 
0023 3382 33B2                   data mem.sams.layout.data
0024               
0025 3384 06A0  32         bl    @sams.layout.copy
     3386 264A 
0026 3388 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 338A C820  54         mov   @tv.sams.c000,@edb.sams.page
     338C A008 
     338E A216 
0029 3390 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3392 A216 
     3394 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 3396 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 3398 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0016                       copy  "data.constants.asm"     ; Data Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: Stevie Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               
0008               
0009               ***************************************************************
0010               * Textmode (80 columns, 30 rows) - F18A
0011               *--------------------------------------------------------------
0012               *
0013               * ; VDP#0 Control bits
0014               * ;      bit 6=0: M3 | Graphics 1 mode
0015               * ;      bit 7=0: Disable external VDP input
0016               * ; VDP#1 Control bits
0017               * ;      bit 0=1: 16K selection
0018               * ;      bit 1=1: Enable display
0019               * ;      bit 2=1: Enable VDP interrupt
0020               * ;      bit 3=1: M1 \ TEXT MODE
0021               * ;      bit 4=0: M2 /
0022               * ;      bit 5=0: reserved
0023               * ;      bit 6=0: 8x8 sprites
0024               * ;      bit 7=0: Sprite magnification (1x)
0025               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0026               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0027               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0028               * ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
0029               * ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
0030               * ; VDP#7 Set foreground/background color
0031               ***************************************************************
0032               stevie.tx8030:
0033 339A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     339C 003F 
     339E 0243 
     33A0 05F4 
     33A2 0050 
0034               
0035               romsat:
0036 33A4 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     33A6 0201 
0037 33A8 0000             data  >0000,>0301             ; Current line indicator
     33AA 0301 
0038 33AC 0820             data  >0820,>0401             ; Current line indicator
     33AE 0401 
0039               nosprite:
0040 33B0 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 33B2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33B4 0002 
0048 33B6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33B8 0003 
0049 33BA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     33BC 000A 
0050               
0051 33BE B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     33C0 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 33C2 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     33C4 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 33C6 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     33C8 000D 
0060 33CA E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     33CC 000E 
0061 33CE F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     33D0 000F 
0062               
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * Stevie color schemes table
0069               *--------------------------------------------------------------
0070               * Word 1
0071               * A  MSB  high-nibble    Foreground color text line in frame buffer
0072               * B  MSB  low-nibble     Background color text line in frame buffer
0073               * C  LSB  high-nibble    Foreground color top/bottom line
0074               * D  LSB  low-nibble     Background color top/bottom line
0075               *
0076               * Word 2
0077               * E  MSB  high-nibble    Foreground color cmdb pane
0078               * F  MSB  low-nibble     Background color cmdb pane
0079               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0080               * H  LSB  low-nibble     Cursor foreground color frame buffer
0081               *
0082               * Word 3
0083               * I  MSB  high-nibble    Foreground color busy top/bottom line
0084               * J  MSB  low-nibble     Background color busy top/bottom line
0085               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0086               * L  LSB  low-nibble     Background color marked line in frame buffer
0087               *
0088               * Word 4
0089               * M  MSB  high-nibble    Foreground color command buffer header line
0090               * N  MSB  low-nibble     Background color command buffer header line
0091               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0092               * P  LSB  low-nibble     Foreground color ruler frame buffer
0093               *
0094               * Colors
0095               * 0  Transparant
0096               * 1  black
0097               * 2  Green
0098               * 3  Light Green
0099               * 4  Blue
0100               * 5  Light Blue
0101               * 6  Dark Red
0102               * 7  Cyan
0103               * 8  Red
0104               * 9  Light Red
0105               * A  Yellow
0106               * B  Light Yellow
0107               * C  Dark Green
0108               * D  Magenta
0109               * E  Grey
0110               * F  White
0111               *--------------------------------------------------------------
0112      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0113               
0114               tv.colorscheme.table:
0115                       ;                             ; #
0116                       ;      ABCD  EFGH  IJKL  MNOP ; -
0117 33D2 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     33D4 F171 
     33D6 1B1F 
     33D8 71B1 
0118 33DA A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     33DC F0FF 
     33DE 1F1A 
     33E0 F1FF 
0119 33E2 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     33E4 F0FF 
     33E6 1F12 
     33E8 F1F6 
0120 33EA F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     33EC 1E11 
     33EE 1A17 
     33F0 1E11 
0121 33F2 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     33F4 E1FF 
     33F6 1F1E 
     33F8 E1FF 
0122 33FA 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     33FC 1016 
     33FE 1B71 
     3400 1711 
0123 3402 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3404 1011 
     3406 F1F1 
     3408 1F11 
0124 340A 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     340C A1FF 
     340E 1F1F 
     3410 F11F 
0125 3412 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3414 12FF 
     3416 1B12 
     3418 12FF 
0126 341A F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     341C E1FF 
     341E 1B1F 
     3420 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 3422 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3424 0C19 
0131 3426 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3428 3B4F 
0132 342A FF00             byte  >ff,0,0,0               ; |
     342C 0000 
0133 342E 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3430 0000 
0134 3432 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3434 0000 
0135                       even
**** **** ****     > ram.resident.3000.asm
0017                       copy  "data.strings.asm"       ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for about pane
0010               ;--------------------------------------------------------------
0011               txt.stevie
0012 3436 0B53             byte  11
0013 3437 ....             text  'STEVIE 1.1K'
0014                       even
0015               
0016               txt.about.build
0017 3442 4C42             byte  76
0018 3443 ....             text  'Build: 210605-1390892 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 3490 012C             byte  1
0024 3491 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 3492 0520             byte  5
0029 3493 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 3498 034F             byte  3
0034 3499 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 349C 0349             byte  3
0039 349D ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34A0 012A             byte  1
0044 34A1 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34A2 0A4C             byte  10
0049 34A3 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34AE 0A53             byte  10
0054 34AF ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34BA 1244             byte  18
0059 34BB ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34CE 1143             byte  17
0064 34CF ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34E0 104D             byte  16
0069 34E1 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 34F2 1D53             byte  29
0074 34F3 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 3510 0846             byte  8
0079 3511 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 351A 026B             byte  2
0084 351B ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 351E 054C             byte  5
0089 351F ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 3524 0A5B             byte  10
0094 3525 ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 3530 0444             byte  4
0099 3531 ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 3536 034D             byte  3
0104 3537 ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 353A 034D             byte  3
0109 353B ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 353E 1B45             byte  27
0114 353F ....             text  'Editor: ^Help, ^File, ^Quit'
0115                       even
0116               
0117               txt.keys.block
0118 355A 3342             byte  51
0119 355B ....             text  'Block: F9=Back, ^Del, ^Copy, ^Move, ^Goto M1, ^Save'
0120                       even
0121               
0122 358E ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 3598 ....                        text    '.........'
0125                                  byte    19
0126 35A2 ....                        text    '.........'
0127                                  byte    20
0128 35AC ....                        text    '.........'
0129                                  byte    21
0130 35B6 ....                        text    '.........'
0131                                  byte    22
0132 35C0 ....                        text    '.........'
0133                                  byte    23
0134 35CA ....                        text    '.........'
0135                                  byte    24
0136 35D4 ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139               
0140 35DE 020E     txt.alpha.down     data >020e,>0f00
     35E0 0F00 
0141 35E2 0110     txt.vertline       data >0110
0142               
0143               txt.ws1
0144 35E4 0120             byte  1
0145 35E5 ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 35E6 0220             byte  2
0150 35E7 ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 35EA 0320             byte  3
0155 35EB ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 35EE 0420             byte  4
0160 35EF ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 35F4 0520             byte  5
0165 35F5 ....             text  '     '
0166                       even
0167               
0168      35EE     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 35FA 1301     txt.head.load      byte 19,1,3,32
     35FC 0320 
0175 35FE ....                        text 'Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 360E 3D53             byte  61
0179 360F ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 364C 3C46     txt.keys.load      byte 60
0184 364D ....                        text 'File'
0185                                  byte 27
0186 3652 ....                        text 'Open: F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '
0187               
0188 368A 3D46     txt.keys.load2     byte 61
0189 368B ....                        text 'File'
0190                                  byte 27
0191 3690 ....                        text 'Open: F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End '
0192               
0193               ;--------------------------------------------------------------
0194               ; Dialog Save DV 80 file
0195               ;--------------------------------------------------------------
0196 36CA 0103     txt.head.save      byte 19,1,3,32
     36CC 2053 
0197 36CD ....                        text 'Save DV80 file '
0198 36DC 0223                        byte 2
0199 36DE 0103     txt.head.save2     byte 35,1,3,32
     36E0 2053 
0200 36E1 ....                        text 'Save marked block to DV80 file '
0201 3700 0201                        byte 2
0202               txt.hint.save
0203                       byte  1
0204 3702 ....             text  ' '
0205                       even
0206               
0207               
0208 3704 2F46     txt.keys.save      byte 47
0209 3705 ....                        text 'File'
0210                                  byte 27
0211 370A ....                        text 'Save: F9=Back, F3=Clear, F-H=Home, F-L=End'
0212               
0213               ;--------------------------------------------------------------
0214               ; Dialog "Unsaved changes"
0215               ;--------------------------------------------------------------
0216 3734 1401     txt.head.unsaved   byte 20,1,3,32
     3736 0320 
0217 3738 ....                        text 'Unsaved changes '
0218 3748 0221                        byte 2
0219               txt.info.unsaved
0220                       byte  33
0221 374A ....             text  'Warning! Unsaved changes in file.'
0222                       even
0223               
0224               txt.hint.unsaved
0225 376C 2A50             byte  42
0226 376D ....             text  'Press F6 to proceed or ENTER to save file.'
0227                       even
0228               
0229               txt.keys.unsaved
0230 3798 2D43             byte  45
0231 3799 ....             text  'Confirm: F9=Back, F6=Proceed, ENTER=Save file'
0232                       even
0233               
0234               
0235               ;--------------------------------------------------------------
0236               ; Dialog "About"
0237               ;--------------------------------------------------------------
0238 37C6 0A01     txt.head.about     byte 10,1,3,32
     37C8 0320 
0239 37CA ....                        text 'About '
0240 37D0 0200                        byte 2
0241               
0242               txt.info.about
0243                       byte  0
0244 37D2 ....             text
0245                       even
0246               
0247               txt.hint.about
0248 37D2 2650             byte  38
0249 37D3 ....             text  'Press F9 or ENTER to return to editor.'
0250                       even
0251               
0252 37FA 2D48     txt.keys.about     byte 45
0253 37FB ....                        text 'Help: F9=Back, ENTER=Back, '
0254 3816 0E0F                        byte 14,15
0255 3818 ....                        text '=Alpha Lock down'
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "File"
0260               ;--------------------------------------------------------------
0261 3828 0901     txt.head.file      byte 9,1,3,32
     382A 0320 
0262 382C ....                        text 'File '
0263                                  byte 2
0264               
0265               txt.info.file
0266 3832 245B             byte  36
0267 3833 ....             text  '[N]ew file, [O]pen file, [S]ave file'
0268                       even
0269               
0270               txt.hint.file
0271 3858 2950             byte  41
0272 3859 ....             text  'Press N,O,S or ENTER to return to editor.'
0273                       even
0274               
0275               txt.keys.file
0276 3882 1946             byte  25
0277 3883 ....             text  'File: F9=Back, ENTER=Back'
0278                       even
0279               
0280               
0281               
0282               ;--------------------------------------------------------------
0283               ; Strings for error line pane
0284               ;--------------------------------------------------------------
0285               txt.ioerr.load
0286 389C 2049             byte  32
0287 389D ....             text  'I/O error. Failed loading file: '
0288                       even
0289               
0290               txt.ioerr.save
0291 38BE 2049             byte  32
0292 38BF ....             text  'I/O error. Failed saving file:  '
0293                       even
0294               
0295               txt.memfull.load
0296 38E0 4049             byte  64
0297 38E1 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0298                       even
0299               
0300               txt.io.nofile
0301 3922 2149             byte  33
0302 3923 ....             text  'I/O error. No filename specified.'
0303                       even
0304               
0305               txt.block.inside
0306 3944 3445             byte  52
0307 3945 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0308                       even
0309               
0310               
0311               ;--------------------------------------------------------------
0312               ; Strings for command buffer
0313               ;--------------------------------------------------------------
0314               txt.cmdb.prompt
0315 397A 013E             byte  1
0316 397B ....             text  '>'
0317                       even
0318               
0319               txt.colorscheme
0320 397C 0D43             byte  13
0321 397D ....             text  'Color scheme:'
0322                       even
0323               
**** **** ****     > ram.resident.3000.asm
0018                       copy  "data.keymap.keys.asm"   ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Keyboard scancodes - Letter keys
0007               *-------------|---------------------|---------------------------
0008      4E00     key.uc.n      equ >4e00             ; N
0009      5300     key.uc.s      equ >5300             ; S
0010      4F00     key.uc.o      equ >4f00             ; O
0011      6E00     key.lc.n      equ >6e00             ; n
0012      7300     key.lc.s      equ >7300             ; s
0013      6F00     key.lc.o      equ >6f00             ; o
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Keyboard scancodes - Function keys
0018               *-------------|---------------------|---------------------------
0019      BC00     key.fctn.0    equ >bc00             ; fctn + 0
0020      0300     key.fctn.1    equ >0300             ; fctn + 1
0021      0400     key.fctn.2    equ >0400             ; fctn + 2
0022      0700     key.fctn.3    equ >0700             ; fctn + 3
0023      0200     key.fctn.4    equ >0200             ; fctn + 4
0024      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0025      0C00     key.fctn.6    equ >0c00             ; fctn + 6
0026      0100     key.fctn.7    equ >0100             ; fctn + 7
0027      0600     key.fctn.8    equ >0600             ; fctn + 8
0028      0F00     key.fctn.9    equ >0f00             ; fctn + 9
0029      0000     key.fctn.a    equ >0000             ; fctn + a
0030      BE00     key.fctn.b    equ >be00             ; fctn + b
0031      0000     key.fctn.c    equ >0000             ; fctn + c
0032      0900     key.fctn.d    equ >0900             ; fctn + d
0033      0B00     key.fctn.e    equ >0b00             ; fctn + e
0034      0000     key.fctn.f    equ >0000             ; fctn + f
0035      0000     key.fctn.g    equ >0000             ; fctn + g
0036      BF00     key.fctn.h    equ >bf00             ; fctn + h
0037      0000     key.fctn.i    equ >0000             ; fctn + i
0038      C000     key.fctn.j    equ >c000             ; fctn + j
0039      C100     key.fctn.k    equ >c100             ; fctn + k
0040      C200     key.fctn.l    equ >c200             ; fctn + l
0041      C300     key.fctn.m    equ >c300             ; fctn + m
0042      C400     key.fctn.n    equ >c400             ; fctn + n
0043      0000     key.fctn.o    equ >0000             ; fctn + o
0044      0000     key.fctn.p    equ >0000             ; fctn + p
0045      C500     key.fctn.q    equ >c500             ; fctn + q
0046      0000     key.fctn.r    equ >0000             ; fctn + r
0047      0800     key.fctn.s    equ >0800             ; fctn + s
0048      0000     key.fctn.t    equ >0000             ; fctn + t
0049      0000     key.fctn.u    equ >0000             ; fctn + u
0050      7F00     key.fctn.v    equ >7f00             ; fctn + v
0051      7E00     key.fctn.w    equ >7e00             ; fctn + w
0052      0A00     key.fctn.x    equ >0a00             ; fctn + x
0053      C600     key.fctn.y    equ >c600             ; fctn + y
0054      0000     key.fctn.z    equ >0000             ; fctn + z
0055               *---------------------------------------------------------------
0056               * Keyboard scancodes - Function keys extra
0057               *---------------------------------------------------------------
0058      B900     key.fctn.dot    equ >b900           ; fctn + .
0059      B800     key.fctn.comma  equ >b800           ; fctn + ,
0060      0500     key.fctn.plus   equ >0500           ; fctn + +
0061               *---------------------------------------------------------------
0062               * Keyboard scancodes - control keys
0063               *-------------|---------------------|---------------------------
0064      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0065      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0066      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0067      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0068      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0069      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0070      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0071      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0072      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0073      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0074      8100     key.ctrl.a    equ >8100             ; ctrl + a
0075      8200     key.ctrl.b    equ >8200             ; ctrl + b
0076      8300     key.ctrl.c    equ >8300             ; ctrl + c
0077      8400     key.ctrl.d    equ >8400             ; ctrl + d
0078      8500     key.ctrl.e    equ >8500             ; ctrl + e
0079      8600     key.ctrl.f    equ >8600             ; ctrl + f
0080      8700     key.ctrl.g    equ >8700             ; ctrl + g
0081      8800     key.ctrl.h    equ >8800             ; ctrl + h
0082      8900     key.ctrl.i    equ >8900             ; ctrl + i
0083      8A00     key.ctrl.j    equ >8a00             ; ctrl + j
0084      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0085      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0086      8D00     key.ctrl.m    equ >8d00             ; ctrl + m
0087      8E00     key.ctrl.n    equ >8e00             ; ctrl + n
0088      8F00     key.ctrl.o    equ >8f00             ; ctrl + o
0089      9000     key.ctrl.p    equ >9000             ; ctrl + p
0090      9100     key.ctrl.q    equ >9100             ; ctrl + q
0091      9200     key.ctrl.r    equ >9200             ; ctrl + r
0092      9300     key.ctrl.s    equ >9300             ; ctrl + s
0093      9400     key.ctrl.t    equ >9400             ; ctrl + t
0094      9500     key.ctrl.u    equ >9500             ; ctrl + u
0095      9600     key.ctrl.v    equ >9600             ; ctrl + v
0096      9700     key.ctrl.w    equ >9700             ; ctrl + w
0097      9800     key.ctrl.x    equ >9800             ; ctrl + x
0098      9900     key.ctrl.y    equ >9900             ; ctrl + y
0099      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0100               *---------------------------------------------------------------
0101               * Keyboard scancodes - control keys extra
0102               *---------------------------------------------------------------
0103      9B00     key.ctrl.dot    equ >9b00           ; ctrl + .
0104      8000     key.ctrl.comma  equ >8000           ; ctrl + ,
0105      9D00     key.ctrl.plus   equ >9d00           ; ctrl + +
0106               *---------------------------------------------------------------
0107               * Special keys
0108               *---------------------------------------------------------------
0109      0D00     key.enter     equ >0d00             ; enter
**** **** ****     > ram.resident.3000.asm
0019                       ;------------------------------------------------------
0020                       ; End of File marker
0021                       ;------------------------------------------------------
0022 398A DEAD             data  >dead,>beef,>dead,>beef
     398C BEEF 
     398E DEAD 
     3990 BEEF 
**** **** ****     > stevie_b1.asm.1390892
0066               ***************************************************************
0067               * Step 4: Include main editor modules
0068               ********|*****|*********************|**************************
0069               main:
0070                       aorg  kickstart.code2       ; >6036
0071 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0072                       ;-----------------------------------------------------------------------
0073                       ; Include files
0074                       ;-----------------------------------------------------------------------
0075                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: Stevie Editor - Main editor module
0003               
0004               ***************************************************************
0005               * main
0006               * Initialize editor
0007               ***************************************************************
0008               * b   @main.stevie
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * -
0018               *--------------------------------------------------------------
0019               * Notes
0020               * Main entry point for stevie editor
0021               ***************************************************************
0022               
0023               
0024               ***************************************************************
0025               * Main
0026               ********|*****|*********************|**************************
0027               main.stevie:
0028 603A 20A0  38         coc   @wbit1,config         ; F18a detected?
     603C 201E 
0029 603E 1302  14         jeq   main.continue
0030 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 2692 
0037               
0038 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2736 
0039               
0041               
0042 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 2336 
0043 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0044               
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 2336 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 2336 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 2292 
0056 6062 0000                   data >0000,32,vdp.sit.size
     6064 0020 
     6066 0960 
0057                                                   ; Clear screen
0058                       ;------------------------------------------------------
0059                       ; Initialize high memory expansion
0060                       ;------------------------------------------------------
0061 6068 06A0  32         bl    @film
     606A 223A 
0062 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0063                       ;------------------------------------------------------
0064                       ; Setup SAMS windows
0065                       ;------------------------------------------------------
0066 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 337A 
0067                       ;------------------------------------------------------
0068                       ; Setup cursor, screen, etc.
0069                       ;------------------------------------------------------
0070 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 26B2 
0071 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 26C2 
0072               
0073 607E 06A0  32         bl    @cpym2m
     6080 24DE 
0074 6082 33A4                   data romsat,ramsat,14 ; Load sprite SAT
     6084 2F5A 
     6086 000E 
0075               
0076 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 33A6 
     608C A014 
0077                                                   ; Save cursor shape & color
0078               
0079 608E 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     6090 7D06 
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 6092 06A0  32         bl    @tv.init              ; Initialize editor configuration
     6094 3286 
0084 6096 06A0  32         bl    @tv.reset             ; Reset editor
     6098 32AC 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 609A 06A0  32         bl    @pane.action.colorscheme.Load
     609C 76EA 
0089                                                   ; Load color scheme and turn on screen
0090                       ;-------------------------------------------------------
0091                       ; Setup editor tasks & hook
0092                       ;-------------------------------------------------------
0093 609E 0204  20         li    tmp0,>0300
     60A0 0300 
0094 60A2 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60A4 8314 
0095               
0096 60A6 06A0  32         bl    @at
     60A8 26D2 
0097 60AA 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60AC 0204  20         li    tmp0,timers
     60AE 2F4A 
0100 60B0 C804  38         mov   tmp0,@wtitab
     60B2 832C 
0101               
0103               
0104 60B4 06A0  32         bl    @mkslot
     60B6 2E08 
0105 60B8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60BA 74A0 
0106 60BC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60BE 752C 
0107 60C0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60C2 75C8 
0108 60C4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60C6 75F6 
0109 60C8 FFFF                   data eol
0110               
0120               
0121               
0122 60CA 06A0  32         bl    @mkhook
     60CC 2DF4 
0123 60CE 7462                   data hook.keyscan     ; Setup user hook
0124               
0125 60D0 0460  28         b     @tmgr                 ; Start timers and kthread
     60D2 2D4A 
**** **** ****     > stevie_b1.asm.1390892
0076                       ;-----------------------------------------------------------------------
0077                       ; Keyboard actions
0078                       ;-----------------------------------------------------------------------
0079                       copy  "edkey.key.process.asm"    ; Process keyboard actions
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60D4 C160  34         mov   @waux1,tmp1           ; Get key value
     60D6 833C 
0009 60D8 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     60DA FF00 
0010 60DC 0707  14         seto  tmp3                  ; EOL marker
0011                       ;-------------------------------------------------------
0012                       ; Process key depending on pane with focus
0013                       ;-------------------------------------------------------
0014 60DE C1A0  34         mov   @tv.pane.focus,tmp2
     60E0 A022 
0015 60E2 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60E4 0000 
0016 60E6 1307  14         jeq   edkey.key.process.loadmap.editor
0017                                                   ; Yes, so load editor keymap
0018               
0019 60E8 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60EA 0001 
0020 60EC 1307  14         jeq   edkey.key.process.loadmap.cmdb
0021                                                   ; Yes, so load CMDB keymap
0022                       ;-------------------------------------------------------
0023                       ; Pane without focus, crash
0024                       ;-------------------------------------------------------
0025 60EE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     60F0 FFCE 
0026 60F2 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     60F4 2026 
0027                       ;-------------------------------------------------------
0028                       ; Load Editor keyboard map
0029                       ;-------------------------------------------------------
0030               edkey.key.process.loadmap.editor:
0031 60F6 0206  20         li    tmp2,keymap_actions.editor
     60F8 7E16 
0032 60FA 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 60FC 0206  20         li    tmp2,keymap_actions.cmdb
     60FE 7EF0 
0038 6100 1600  14         jne   edkey.key.check.next
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6102 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0044 6104 1319  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 6106 8585  30         c     tmp1,*tmp2            ; Action key matched?
0051 6108 1303  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053 610A 0226  22         ai    tmp2,6                ; Skip current entry
     610C 0006 
0054 610E 10F9  14         jmp   edkey.key.check.next  ; Check next entry
0055                       ;-------------------------------------------------------
0056                       ; Check scope of key
0057                       ;-------------------------------------------------------
0058               edkey.key.check.scope:
0059 6110 05C6  14         inct  tmp2                  ; Move to scope
0060 6112 8816  46         c     *tmp2,@tv.pane.focus  ; (1) Process key if scope matches pane
     6114 A022 
0061 6116 1306  14         jeq   edkey.key.process.action
0062               
0063 6118 8816  46         c     *tmp2,@cmdb.dialog    ; (2) Process key if scope matches dialog
     611A A31A 
0064 611C 1303  14         jeq   edkey.key.process.action
0065                       ;-------------------------------------------------------
0066                       ; Key pressed outside valid scope, ignore action entry
0067                       ;-------------------------------------------------------
0068 611E 0226  22         ai    tmp2,4                ; Skip current entry
     6120 0004 
0069 6122 10EF  14         jmp   edkey.key.check.next  ; Process next action entry
0070                       ;-------------------------------------------------------
0071                       ; Trigger keyboard action
0072                       ;-------------------------------------------------------
0073               edkey.key.process.action:
0074 6124 05C6  14         inct  tmp2                  ; Move to action address
0075 6126 C196  26         mov   *tmp2,tmp2            ; Get action address
0076               
0077 6128 0204  20         li    tmp0,id.dialog.unsaved
     612A 0065 
0078 612C 8120  34         c     @cmdb.dialog,tmp0
     612E A31A 
0079 6130 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0080               
0081 6132 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6134 A324 
0082 6136 0456  20 !       b     *tmp2                 ; Process key action
0083                       ;-------------------------------------------------------
0084                       ; Add character to editor or cmdb buffer
0085                       ;-------------------------------------------------------
0086               edkey.key.process.addbuffer:
0087 6138 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     613A A022 
0088 613C 1602  14         jne   !                     ; No, skip frame buffer
0089 613E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6140 66EA 
0090                       ;-------------------------------------------------------
0091                       ; CMDB buffer
0092                       ;-------------------------------------------------------
0093 6142 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6144 0001 
0094 6146 1607  14         jne   edkey.key.process.crash
0095                                                   ; No, crash
0096                       ;-------------------------------------------------------
0097                       ; Don't add character if dialog has ID > 100
0098                       ;-------------------------------------------------------
0099 6148 C120  34         mov   @cmdb.dialog,tmp0
     614A A31A 
0100 614C 0284  22         ci    tmp0,100
     614E 0064 
0101 6150 1506  14         jgt   edkey.key.process.exit
0102                       ;-------------------------------------------------------
0103                       ; Add character to CMDB
0104                       ;-------------------------------------------------------
0105 6152 0460  28         b     @edkey.action.cmdb.char
     6154 6906 
0106                                                   ; Add character to CMDB buffer
0107                       ;-------------------------------------------------------
0108                       ; Crash
0109                       ;-------------------------------------------------------
0110               edkey.key.process.crash:
0111 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6158 FFCE 
0112 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     615C 2026 
0113                       ;-------------------------------------------------------
0114                       ; Exit
0115                       ;-------------------------------------------------------
0116               edkey.key.process.exit:
0117 615E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6160 7494 
**** **** ****     > stevie_b1.asm.1390892
0080                       ;-----------------------------------------------------------------------
0081                       ; Keyboard actions - Framebuffer (1)
0082                       ;-----------------------------------------------------------------------
0083                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6162 C120  34         mov   @fb.column,tmp0
     6164 A10C 
0009 6166 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6168 0620  34         dec   @fb.column            ; Column-- in screen buffer
     616A A10C 
0014 616C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     616E 832A 
0015 6170 0620  34         dec   @fb.current
     6172 A102 
0016 6174 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6176 A118 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6178 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     617A 7494 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 617C 8820  54         c     @fb.column,@fb.row.length
     617E A10C 
     6180 A108 
0028 6182 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6184 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6186 A10C 
0033 6188 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     618A 832A 
0034 618C 05A0  34         inc   @fb.current
     618E A102 
0035 6190 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6192 A118 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 6194 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6196 7494 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 6198 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     619A A118 
0047 619C C120  34         mov   @wyx,tmp0
     619E 832A 
0048 61A0 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     61A2 FF00 
0049 61A4 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     61A6 832A 
0050 61A8 04E0  34         clr   @fb.column
     61AA A10C 
0051 61AC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61AE 6A76 
0052 61B0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61B2 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61B6 7494 
0057               
0058               
0059               *---------------------------------------------------------------
0060               * Cursor end of line
0061               *---------------------------------------------------------------
0062               edkey.action.end:
0063 61B8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61BA A118 
0064 61BC C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61BE A108 
0065 61C0 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61C2 0050 
0066 61C4 1102  14         jlt   !                     ; | is right of last character on line,
0067 61C6 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61C8 004F 
0068                       ;-------------------------------------------------------
0069                       ; Set cursor X position
0070                       ;-------------------------------------------------------
0071 61CA C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61CC A10C 
0072 61CE 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61D0 26EA 
0073 61D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D4 6A76 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 61D6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61D8 7494 
**** **** ****     > stevie_b1.asm.1390892
0084                                                        ; Move left / right / home / end
0085                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61DA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61DC A118 
0009 61DE C120  34         mov   @fb.column,tmp0
     61E0 A10C 
0010 61E2 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61E4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61E6 A102 
0015 61E8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 61EA 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 61EC 0605  14         dec   tmp1
0022 61EE 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 61F0 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 61F2 D195  26         movb  *tmp1,tmp2            ; Get character
0030 61F4 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 61F6 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 61F8 0986  56         srl   tmp2,8                ; Right justify
0033 61FA 0286  22         ci    tmp2,32               ; Space character found?
     61FC 0020 
0034 61FE 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 6200 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6202 2020 
0040 6204 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 6206 0287  22         ci    tmp3,>20ff            ; First character is space
     6208 20FF 
0043 620A 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 620C C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     620E A10C 
0048 6210 61C4  18         s     tmp0,tmp3
0049 6212 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6214 0002 
0050 6216 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6218 0585  14         inc   tmp1
0056 621A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 621C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     621E A10C 
0062 6220 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6222 26EA 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 6224 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6226 6A76 
0068 6228 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     622A 7494 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 622C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     622E A118 
0077 6230 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6232 C120  34         mov   @fb.column,tmp0
     6234 A10C 
0079 6236 8804  38         c     tmp0,@fb.row.length
     6238 A108 
0080 623A 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 623C C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     623E A102 
0085 6240 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6242 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 6244 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6246 0585  14         inc   tmp1
0097 6248 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 624A 8804  38         c     tmp0,@fb.row.length
     624C A108 
0099 624E 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6250 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6252 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 6254 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6256 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6258 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     625A FFFF 
0111 625C 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 625E 0286  22         ci    tmp2,32
     6260 0020 
0117 6262 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 6264 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 6266 0286  22         ci    tmp2,32               ; Space character found?
     6268 0020 
0125 626A 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 626C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     626E 2020 
0131 6270 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6272 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6274 20FF 
0134 6276 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6278 0585  14         inc   tmp1
0139 627A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 627C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     627E A10C 
0145 6280 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6282 26EA 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 6284 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6286 6A76 
0151 6288 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     628A 7494 
0152               
0153               
**** **** ****     > stevie_b1.asm.1390892
0086                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 628C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     628E A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6290 8820  54         c     @fb.row.dirty,@w$ffff
     6292 A10A 
     6294 2022 
0013 6296 1604  14         jne   edkey.action.up.cursor
0014 6298 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     629A 6DC2 
0015 629C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     629E A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 62A0 C120  34         mov   @fb.row,tmp0
     62A2 A106 
0021 62A4 150B  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 62A6 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62A8 A104 
0024 62AA 130C  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62AC 0604  14         dec   tmp0                  ; fb.topline--
0030 62AE C804  38         mov   tmp0,@parm1           ; Scroll one line up
     62B0 2F20 
0031               
0032 62B2 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62B4 6AE6 
0033                                                   ; | i  @parm1 = Line to start with
0034                                                   ; /             (becomes @fb.topline)
0035               
0036 62B6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62B8 A110 
0037 62BA 1004  14         jmp   edkey.action.up.set_cursorx
0038                       ;-------------------------------------------------------
0039                       ; Move cursor up
0040                       ;-------------------------------------------------------
0041               edkey.action.up.cursor_up:
0042 62BC 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62BE A106 
0043 62C0 06A0  32         bl    @up                   ; Row-- VDP cursor
     62C2 26E0 
0044                       ;-------------------------------------------------------
0045                       ; Check line length and position cursor
0046                       ;-------------------------------------------------------
0047               edkey.action.up.set_cursorx:
0048 62C4 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62C6 6FB8 
0049                                                   ; | i  @fb.row        = Row in frame buffer
0050                                                   ; / o  @fb.row.length = Length of row
0051               
0052 62C8 8820  54         c     @fb.column,@fb.row.length
     62CA A10C 
     62CC A108 
0053 62CE 1207  14         jle   edkey.action.up.exit
0054                       ;-------------------------------------------------------
0055                       ; Adjust cursor column position
0056                       ;-------------------------------------------------------
0057 62D0 C820  54         mov   @fb.row.length,@fb.column
     62D2 A108 
     62D4 A10C 
0058 62D6 C120  34         mov   @fb.column,tmp0
     62D8 A10C 
0059 62DA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62DC 26EA 
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.up.exit:
0064 62DE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62E0 6A76 
0065 62E2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62E4 7494 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Cursor down
0071               *---------------------------------------------------------------
0072               edkey.action.down:
0073 62E6 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     62E8 A106 
     62EA A204 
0074 62EC 1332  14         jeq   edkey.action.down.exit
0075                                                   ; Yes, skip further processing
0076 62EE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62F0 A118 
0077                       ;-------------------------------------------------------
0078                       ; Crunch current row if dirty
0079                       ;-------------------------------------------------------
0080 62F2 8820  54         c     @fb.row.dirty,@w$ffff
     62F4 A10A 
     62F6 2022 
0081 62F8 1604  14         jne   edkey.action.down.move
0082 62FA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62FC 6DC2 
0083 62FE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6300 A10A 
0084                       ;-------------------------------------------------------
0085                       ; Move cursor
0086                       ;-------------------------------------------------------
0087               edkey.action.down.move:
0088                       ;-------------------------------------------------------
0089                       ; EOF reached?
0090                       ;-------------------------------------------------------
0091 6302 C120  34         mov   @fb.topline,tmp0
     6304 A104 
0092 6306 A120  34         a     @fb.row,tmp0
     6308 A106 
0093 630A 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     630C A204 
0094 630E 1314  14         jeq   edkey.action.down.set_cursorx
0095                                                   ; Yes, only position cursor X
0096                       ;-------------------------------------------------------
0097                       ; Check if scrolling required
0098                       ;-------------------------------------------------------
0099 6310 C120  34         mov   @fb.scrrows,tmp0
     6312 A11A 
0100 6314 0604  14         dec   tmp0
0101 6316 8120  34         c     @fb.row,tmp0
     6318 A106 
0102 631A 110A  14         jlt   edkey.action.down.cursor
0103                       ;-------------------------------------------------------
0104                       ; Scroll 1 line
0105                       ;-------------------------------------------------------
0106 631C C820  54         mov   @fb.topline,@parm1
     631E A104 
     6320 2F20 
0107 6322 05A0  34         inc   @parm1
     6324 2F20 
0108               
0109 6326 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6328 6AE6 
0110                                                   ; | i  @parm1 = Line to start with
0111                                                   ; /             (becomes @fb.topline)
0112               
0113 632A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     632C A110 
0114 632E 1004  14         jmp   edkey.action.down.set_cursorx
0115                       ;-------------------------------------------------------
0116                       ; Move cursor down a row, there are still rows left
0117                       ;-------------------------------------------------------
0118               edkey.action.down.cursor:
0119 6330 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6332 A106 
0120 6334 06A0  32         bl    @down                 ; Row++ VDP cursor
     6336 26D8 
0121                       ;-------------------------------------------------------
0122                       ; Check line length and position cursor
0123                       ;-------------------------------------------------------
0124               edkey.action.down.set_cursorx:
0125 6338 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     633A 6FB8 
0126                                                   ; | i  @fb.row        = Row in frame buffer
0127                                                   ; / o  @fb.row.length = Length of row
0128               
0129 633C 8820  54         c     @fb.column,@fb.row.length
     633E A10C 
     6340 A108 
0130 6342 1207  14         jle   edkey.action.down.exit
0131                                                   ; Exit
0132                       ;-------------------------------------------------------
0133                       ; Adjust cursor column position
0134                       ;-------------------------------------------------------
0135 6344 C820  54         mov   @fb.row.length,@fb.column
     6346 A108 
     6348 A10C 
0136 634A C120  34         mov   @fb.column,tmp0
     634C A10C 
0137 634E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6350 26EA 
0138                       ;-------------------------------------------------------
0139                       ; Exit
0140                       ;-------------------------------------------------------
0141               edkey.action.down.exit:
0142 6352 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6354 6A76 
0143 6356 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6358 7494 
**** **** ****     > stevie_b1.asm.1390892
0087                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 635A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     635C A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 635E 8820  54         c     @fb.row.dirty,@w$ffff
     6360 A10A 
     6362 2022 
0013 6364 1604  14         jne   edkey.action.ppage.sanity
0014 6366 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6368 6DC2 
0015 636A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636C A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 636E C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6370 A104 
0021 6372 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 6374 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6376 A11A 
0026 6378 1503  14         jgt   edkey.action.ppage.topline
0027 637A 04E0  34         clr   @fb.topline           ; topline = 0
     637C A104 
0028 637E 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6380 6820  54         s     @fb.scrrows,@fb.topline
     6382 A11A 
     6384 A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 6386 C820  54         mov   @fb.topline,@parm1
     6388 A104 
     638A 2F20 
0039 638C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     638E A110 
0040               
0041 6390 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 6392 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6394 7494 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 6396 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6398 A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 639A 8820  54         c     @fb.row.dirty,@w$ffff
     639C A10A 
     639E 2022 
0061 63A0 1604  14         jne   edkey.action.npage.sanity
0062 63A2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63A4 6DC2 
0063 63A6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63A8 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 63AA C120  34         mov   @fb.topline,tmp0
     63AC A104 
0069 63AE A120  34         a     @fb.scrrows,tmp0
     63B0 A11A 
0070 63B2 0584  14         inc   tmp0                  ; Base 1 offset !
0071 63B4 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     63B6 A204 
0072 63B8 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 63BA A820  54         a     @fb.scrrows,@fb.topline
     63BC A11A 
     63BE A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 63C0 C820  54         mov   @fb.topline,@parm1
     63C2 A104 
     63C4 2F20 
0083 63C6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63C8 A110 
0084               
0085 63CA 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 63CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63CE 7494 
**** **** ****     > stevie_b1.asm.1390892
0088                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
**** **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Goto top of file
0006               *---------------------------------------------------------------
0007               edkey.action.top:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current row if dirty
0010                       ;-------------------------------------------------------
0011 63D0 8820  54         c     @fb.row.dirty,@w$ffff
     63D2 A10A 
     63D4 2022 
0012 63D6 1604  14         jne   edkey.action.top.refresh
0013 63D8 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63DA 6DC2 
0014 63DC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63DE A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 63E0 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63E2 2F20 
0020 63E4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63E6 A110 
0021               
0022 63E8 0460  28         b     @ _edkey.goto.fb.toprow
     63EA 641C 
0023                                                   ; \ Position cursor and exit
0024                                                   ; / i  @parm1 = Line in editor buffer
0025               
0026               
0027               
0028               *---------------------------------------------------------------
0029               * Goto bottom of file
0030               *---------------------------------------------------------------
0031               edkey.action.bot:
0032                       ;-------------------------------------------------------
0033                       ; Crunch current row if dirty
0034                       ;-------------------------------------------------------
0035 63EC 8820  54         c     @fb.row.dirty,@w$ffff
     63EE A10A 
     63F0 2022 
0036 63F2 1604  14         jne   edkey.action.bot.refresh
0037 63F4 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63F6 6DC2 
0038 63F8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63FA A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 63FC 8820  54         c     @edb.lines,@fb.scrrows
     63FE A204 
     6400 A11A 
0044 6402 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 6404 C120  34         mov   @edb.lines,tmp0
     6406 A204 
0047 6408 6120  34         s     @fb.scrrows,tmp0
     640A A11A 
0048 640C C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     640E 2F20 
0049 6410 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6412 A110 
0050               
0051 6414 0460  28         b     @ _edkey.goto.fb.toprow
     6416 641C 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6418 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     641A 7494 
**** **** ****     > stevie_b1.asm.1390892
0089                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
**** **** ****     > edkey.fb.mov.goto.asm
0001               * FILE......: edkey.fb.mov.goto.asm
0002               * Purpose...: Goto specified line in editor buffer
0003               
0004               ***************************************************************
0005               * _edkey.goto.fb.toprow
0006               *
0007               * Position cursor on first row in frame buffer and
0008               * align variables in editor buffer to match with that position.
0009               *
0010               * Internal method that needs to be called via jmp or branch
0011               * instruction.
0012               ***************************************************************
0013               * b    _edkey.goto.fb.toprow
0014               * jmp  _edkey.goto.fb.toprow
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @parm1  = Line in editor buffer to display as top row (goto)
0018               *
0019               * Register usage
0020               * none
0021               *--------------------------------------------------------------
0022               *  Remarks
0023               *  Private, only to be called from inside edkey submodules
0024               ********|*****|*********************|**************************
0025               _edkey.goto.fb.toprow:
0026 641C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     641E A118 
0027               
0028 6420 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6422 6AE6 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 6424 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6426 A106 
0033 6428 04E0  34         clr   @fb.column            ; Frame buffer column 0
     642A A10C 
0034 642C 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     642E 832A 
0035               
0036 6430 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6432 6A76 
0037               
0038 6434 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6436 6FB8 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6438 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     643A 7494 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 643C 8820  54         c     @fb.row.dirty,@w$ffff
     643E A10A 
     6440 2022 
0053 6442 1609  14         jne   edkey.action.goto.refresh
0054               
0055 6444 0649  14         dect  stack
0056 6446 C660  46         mov   @parm1,*stack         ; Push parm1
     6448 2F20 
0057 644A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     644C 6DC2 
0058 644E C839  50         mov   *stack+,@parm1        ; Pop parm1
     6450 2F20 
0059               
0060 6452 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6454 A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 6456 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6458 A110 
0066               
0067 645A 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     645C 641C 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.1390892
0090                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 645E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6460 A206 
0009 6462 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6464 6A76 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6466 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6468 A108 
0015 646A 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 646C C120  34         mov   @fb.current,tmp0      ; Get pointer
     646E A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6470 C1C6  18         mov   tmp2,tmp3             ; \
0024 6472 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 6474 81E0  34         c     @fb.column,tmp3
     6476 A10C 
0026 6478 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 647A 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 647C D505  30         movb  tmp1,*tmp0            ; /
0033 647E C820  54         mov   @fb.column,@fb.row.length
     6480 A10C 
     6482 A108 
0034                                                   ; Row length - 1
0035 6484 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6486 A10A 
0036 6488 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     648A A116 
0037 648C 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 648E 0286  22         ci    tmp2,colrow
     6490 0050 
0043 6492 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 6494 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6496 FFCE 
0049 6498 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     649A 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 649C C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 649E 61E0  34         s     @fb.column,tmp3
     64A0 A10C 
0056 64A2 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 64A4 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 64A6 C144  18         mov   tmp0,tmp1
0059 64A8 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 64AA 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64AC A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 64AE C120  34         mov   @fb.current,tmp0      ; Get pointer
     64B0 A102 
0065 64B2 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 64B4 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 64B6 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 64B8 0606  14         dec   tmp2
0073 64BA 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 64BC 0206  20         li    tmp2,colrow
     64BE 0050 
0078 64C0 81A0  34         c     @fb.row.length,tmp2
     64C2 A108 
0079 64C4 1603  14         jne   edkey.action.del_char.save
0080 64C6 0604  14         dec   tmp0                  ; One time adjustment
0081 64C8 04C5  14         clr   tmp1
0082 64CA D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 64CC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64CE A10A 
0088 64D0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64D2 A116 
0089 64D4 0620  34         dec   @fb.row.length        ; @fb.row.length--
     64D6 A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 64D8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64DA 7494 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64DC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64DE A206 
0102 64E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64E2 6A76 
0103 64E4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64E6 A108 
0104 64E8 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 64EA C120  34         mov   @fb.current,tmp0      ; Get pointer
     64EC A102 
0110 64EE C1A0  34         mov   @fb.colsline,tmp2
     64F0 A10E 
0111 64F2 61A0  34         s     @fb.column,tmp2
     64F4 A10C 
0112 64F6 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64F8 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64FA 0606  14         dec   tmp2
0119 64FC 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64FE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6500 A10A 
0124 6502 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6504 A116 
0125               
0126 6506 C820  54         mov   @fb.column,@fb.row.length
     6508 A10C 
     650A A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 650C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     650E 7494 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 6510 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6512 6A76 
0143 6514 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6516 A10A 
0144               
0145 6518 C820  54         mov   @fb.topline,@parm1    ; \
     651A A104 
     651C 2F20 
0146 651E A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     6520 A106 
     6522 2F20 
0147 6524 05A0  34         inc   @parm1                ; /
     6526 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6528 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     652A 2F20 
     652C A204 
0153 652E 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 6530 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6532 A104 
     6534 2F20 
0157 6536 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6538 6AE6 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 653A 0460  28         b     @edkey.action.up      ; Move cursor one line up
     653C 628C 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 653E 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6540 70BE 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 6542 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     6544 2F20 
     6546 A204 
0170 6548 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 654A 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     654C 6FB8 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 654E C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6550 A104 
     6552 2F20 
0183               
0184 6554 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6556 6AE6 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 6558 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     655A A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 655C C120  34         mov   @fb.topline,tmp0
     655E A104 
0193 6560 A120  34         a     @fb.row,tmp0
     6562 A106 
0194               
0195 6564 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6566 A204 
0196 6568 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 656A 0460  28         b     @edkey.action.up      ; Move cursor one line up
     656C 628C 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 656E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6570 6198 
**** **** ****     > stevie_b1.asm.1390892
0091                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
**** **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert character
0006               *
0007               * @parm1 = high byte has character to insert
0008               *---------------------------------------------------------------
0009               edkey.action.ins_char.ws:
0010 6572 0204  20         li    tmp0,>2000            ; White space
     6574 2000 
0011 6576 C804  38         mov   tmp0,@parm1
     6578 2F20 
0012               edkey.action.ins_char:
0013 657A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     657C A206 
0014 657E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6580 6A76 
0015                       ;-------------------------------------------------------
0016                       ; Assert 1 - Empty line
0017                       ;-------------------------------------------------------
0018 6582 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6584 A102 
0019 6586 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6588 A108 
0020 658A 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Assert 2 - EOL
0024                       ;-------------------------------------------------------
0025 658C 8820  54         c     @fb.column,@fb.row.length
     658E A10C 
     6590 A108 
0026 6592 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Assert 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 6594 C160  34         mov   @fb.column,tmp1
     6596 A10C 
0032 6598 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     659A 004F 
0033 659C 1102  14         jlt   !
0034 659E 0460  28         b     @edkey.action.char.overwrite
     65A0 6710 
0035                       ;-------------------------------------------------------
0036                       ; Assert 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 65A2 C160  34 !       mov   @fb.row.length,tmp1
     65A4 A108 
0039 65A6 0285  22         ci    tmp1,colrow
     65A8 0050 
0040 65AA 1101  14         jlt   edkey.action.ins_char.prep
0041 65AC 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 65AE C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 65B0 61E0  34         s     @fb.column,tmp3
     65B2 A10C 
0048 65B4 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 65B6 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 65B8 C144  18         mov   tmp0,tmp1
0051 65BA 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 65BC 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65BE A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 65C0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 65C2 0604  14         dec   tmp0
0059 65C4 0605  14         dec   tmp1
0060 65C6 0606  14         dec   tmp2
0061 65C8 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 65CA D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65CC 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 65CE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65D0 A10A 
0070 65D2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65D4 A116 
0071 65D6 05A0  34         inc   @fb.column
     65D8 A10C 
0072 65DA 05A0  34         inc   @wyx
     65DC 832A 
0073 65DE 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65E0 A108 
0074 65E2 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65E4 0460  28         b     @edkey.action.char.overwrite
     65E6 6710 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 65E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65EA 7494 
0085               
0086               
0087               
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Insert new line
0093               *---------------------------------------------------------------
0094               edkey.action.ins_line:
0095 65EC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65EE A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 65F0 8820  54         c     @fb.row.dirty,@w$ffff
     65F2 A10A 
     65F4 2022 
0100 65F6 1604  14         jne   edkey.action.ins_line.insert
0101 65F8 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     65FA 6DC2 
0102 65FC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65FE A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 6600 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6602 6A76 
0108 6604 C820  54         mov   @fb.topline,@parm1
     6606 A104 
     6608 2F20 
0109 660A A820  54         a     @fb.row,@parm1        ; Line number to insert
     660C A106 
     660E 2F20 
0110 6610 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6612 A204 
     6614 2F22 
0111               
0112 6616 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6618 6CDA 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 661A 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     661C A204 
0117                       ;-------------------------------------------------------
0118                       ; Check/Adjust marker M1
0119                       ;-------------------------------------------------------
0120               edkey.action.ins_line.m1:
0121 661E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6620 A20C 
     6622 2022 
0122 6624 1308  14         jeq   edkey.action.ins_line.m2
0123                                                   ; Yes, skip to M2 check
0124               
0125 6626 8820  54         c     @parm1,@edb.block.m1
     6628 2F20 
     662A A20C 
0126 662C 1504  14         jgt   edkey.action.ins_line.m2
0127 662E 05A0  34         inc   @edb.block.m1         ; M1++
     6630 A20C 
0128 6632 0720  34         seto  @fb.colorize          ; Set colorize flag
     6634 A110 
0129                       ;-------------------------------------------------------
0130                       ; Check/Adjust marker M2
0131                       ;-------------------------------------------------------
0132               edkey.action.ins_line.m2:
0133 6636 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6638 A20E 
     663A 2022 
0134 663C 1308  14         jeq   edkey.action.ins_line.refresh
0135                                                   ; Yes, skip to refresh frame buffer
0136               
0137 663E 8820  54         c     @parm1,@edb.block.m2
     6640 2F20 
     6642 A20E 
0138 6644 1504  14         jgt   edkey.action.ins_line.refresh
0139 6646 05A0  34         inc   @edb.block.m2         ; M2++
     6648 A20E 
0140 664A 0720  34         seto  @fb.colorize          ; Set colorize flag
     664C A110 
0141                       ;-------------------------------------------------------
0142                       ; Refresh frame buffer and physical screen
0143                       ;-------------------------------------------------------
0144               edkey.action.ins_line.refresh:
0145 664E C820  54         mov   @fb.topline,@parm1
     6650 A104 
     6652 2F20 
0146               
0147 6654 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6656 6AE6 
0148                                                   ; | i  @parm1 = Line to start with
0149                                                   ; /             (becomes @fb.topline)
0150               
0151 6658 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     665A A116 
0152                       ;-------------------------------------------------------
0153                       ; Exit
0154                       ;-------------------------------------------------------
0155               edkey.action.ins_line.exit:
0156 665C 0460  28         b     @edkey.action.home    ; Position cursor at home
     665E 6198 
0157               
**** **** ****     > stevie_b1.asm.1390892
0092                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6660 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6662 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6664 8820  54         c     @fb.row.dirty,@w$ffff
     6666 A10A 
     6668 2022 
0013 666A 1606  14         jne   edkey.action.enter.upd_counter
0014 666C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     666E A206 
0015 6670 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6672 6DC2 
0016 6674 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6676 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6678 C120  34         mov   @fb.topline,tmp0
     667A A104 
0022 667C A120  34         a     @fb.row,tmp0
     667E A106 
0023 6680 0584  14         inc   tmp0
0024 6682 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6684 A204 
0025 6686 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6688 05A0  34         inc   @edb.lines            ; Total lines++
     668A A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 668C C120  34         mov   @fb.scrrows,tmp0
     668E A11A 
0035 6690 0604  14         dec   tmp0
0036 6692 8120  34         c     @fb.row,tmp0
     6694 A106 
0037 6696 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 6698 C120  34         mov   @fb.scrrows,tmp0
     669A A11A 
0042 669C C820  54         mov   @fb.topline,@parm1
     669E A104 
     66A0 2F20 
0043 66A2 05A0  34         inc   @parm1
     66A4 2F20 
0044 66A6 06A0  32         bl    @fb.refresh
     66A8 6AE6 
0045 66AA 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     66AC A110 
0046 66AE 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 66B0 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     66B2 A106 
0052 66B4 06A0  32         bl    @down                 ; Row++ VDP cursor
     66B6 26D8 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 66B8 06A0  32         bl    @fb.get.firstnonblank
     66BA 6A9E 
0058 66BC C120  34         mov   @outparm1,tmp0
     66BE 2F30 
0059 66C0 C804  38         mov   tmp0,@fb.column
     66C2 A10C 
0060 66C4 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     66C6 26EA 
0061 66C8 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     66CA 6FB8 
0062 66CC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66CE 6A76 
0063 66D0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66D2 A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 66D4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D6 7494 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 66D8 0649  14         dect  stack
0078 66DA C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 66DC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66DE A118 
0081 66E0 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66E2 A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 66E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 66E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66E8 7494 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 66EA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66EC A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 66EE D105  18         movb  tmp1,tmp0             ; Get keycode
0100 66F0 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 66F2 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66F4 0020 
0103 66F6 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 66F8 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     66FA 007E 
0107 66FC 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 66FE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6700 A206 
0113 6702 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6704 2F20 
0114 6706 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6708 A20A 
0115 670A 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 670C 0460  28         b     @edkey.action.ins_char
     670E 657A 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6710 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6712 6A76 
0126 6714 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6716 A102 
0127               
0128 6718 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     671A 2F20 
0129 671C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     671E A10A 
0130 6720 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6722 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 6724 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6726 A10C 
0135 6728 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     672A 004F 
0136 672C 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 672E 0205  20         li    tmp1,colrow           ; \
     6730 0050 
0140 6732 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6734 A108 
0141 6736 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6738 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     673A A10C 
0147 673C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     673E 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 6740 8820  54         c     @fb.column,@fb.row.length
     6742 A10C 
     6744 A108 
0152                                                   ; column < line length ?
0153 6746 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 6748 C820  54         mov   @fb.column,@fb.row.length
     674A A10C 
     674C A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 674E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6750 7494 
**** **** ****     > stevie_b1.asm.1390892
0093                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Quit stevie
0006               *---------------------------------------------------------------
0007               edkey.action.quit:
0008                       ;-------------------------------------------------------
0009                       ; Show dialog "unsaved changes" if editor buffer dirty
0010                       ;-------------------------------------------------------
0011 6752 C120  34         mov   @edb.dirty,tmp0
     6754 A206 
0012 6756 1302  14         jeq   !
0013 6758 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     675A 7DAA 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 675C 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     675E 279C 
0018 6760 0420  54         blwp  @0                    ; Exit
     6762 0000 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 6764 0649  14         dect  stack
0026 6766 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6768 0649  14         dect  stack
0028 676A C660  46         mov   @wyx,*stack           ; Push cursor YX
     676C 832A 
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 676E 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6770 A116 
0033 6772 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     6774 A010 
0034 6776 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 6778 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     677A 7DE0 
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 677C 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     677E 794E 
0041 6780 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6782 832A 
0042 6784 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 6786 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6788 7494 
**** **** ****     > stevie_b1.asm.1390892
0094                       copy  "edkey.fb.file.asm"        ; File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load next or previous file based on last char in suffix
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.fname.inc.load
0008               * b   @edkey.action.fb.fname.dec.load
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 678A C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     678C A444 
     678E 2F20 
0018 6790 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6792 2F22 
0019 6794 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 6796 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6798 A444 
     679A 2F20 
0023 679C 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     679E 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 67A0 C120  34         mov   @parm1,tmp0
     67A2 2F20 
0030 67A4 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 67A6 C120  34         mov   @edb.dirty,tmp0
     67A8 A206 
0036 67AA 1302  14         jeq   !
0037 67AC 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     67AE 7DAA 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 67B0 06A0  32 !       bl    @fm.browse.fname.suffix
     67B2 7D50 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 67B4 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67B6 E000 
0047 67B8 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67BA 7D18 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 67BC 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     67BE 63D0 
**** **** ****     > stevie_b1.asm.1390892
0095                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 67C0 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     67C2 714E 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 67C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67C6 7494 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 67C8 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     67CA 7176 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67CE 7494 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 67D0 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     67D2 719E 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 67D4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67D6 7494 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 67D8 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67DA 7B9E 
0043 67DC 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67DE 71DA 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67E0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67E2 7494 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 67E4 0649  14         dect  stack
0055 67E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 67E8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67EA A20E 
     67EC 2022 
0060 67EE 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 67F0 C120  34         mov   @wyx,tmp0             ; Get cursor position
     67F2 832A 
0066 67F4 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67F6 FF00 
0067 67F8 C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67FA A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 67FC 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67FE 7B9E 
0072               
0073 6800 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     6802 2F20 
0074 6804 06A0  32         bl    @edb.block.copy       ; Copy code block
     6806 7220 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 6808 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     680A 2F30 
     680C 2000 
0079 680E 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6810 C820  54         mov   @fb.yxsave,@parm1
     6812 A114 
     6814 2F20 
0083 6816 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     6818 6B56 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 681A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 681C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     681E 7494 
0092               
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Delete code block
0098               ********|*****|*********************|**************************
0099               edkey.action.block.delete:
0100                       ;-------------------------------------------------------
0101                       ; Exit early if nothing to do
0102                       ;-------------------------------------------------------
0103 6820 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6822 A20E 
     6824 2022 
0104 6826 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 6828 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     682A 7B9E 
0110               
0111 682C 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     682E 2F20 
0112 6830 06A0  32         bl    @edb.block.delete     ; Delete code block
     6832 7316 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 6834 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6836 2F30 
     6838 2000 
0119 683A 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 683C C820  54         mov   @fb.topline,@parm1
     683E A104 
     6840 2F20 
0123 6842 0460  28         b     @_edkey.goto.fb.toprow
     6844 641C 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 6846 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6848 7494 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 684A 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     684C A20E 
     684E 2022 
0142 6850 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6852 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6854 7B9E 
0148               
0149 6856 0720  34         seto  @parm1                ; Set message to "Moving block..."
     6858 2F20 
0150 685A 06A0  32         bl    @edb.block.copy       ; Copy code block
     685C 7220 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 685E 0720  34         seto  @parm1                ; Don't display delete message
     6860 2F20 
0155 6862 06A0  32         bl    @edb.block.delete     ; Delete code block
     6864 7316 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 6866 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6868 2F30 
     686A 2000 
0162 686C 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 686E C820  54         mov   @fb.topline,@parm1
     6870 A104 
     6872 2F20 
0166 6874 0460  28         b     @_edkey.goto.fb.toprow
     6876 641C 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 6878 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     687A 7494 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 687C 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     687E A20C 
     6880 2022 
0182 6882 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 6884 C820  54         mov   @edb.block.m1,@parm1
     6886 A20C 
     6888 2F20 
0188 688A 0620  34         dec   @parm1                ; Base 0 offset
     688C 2F20 
0189               
0190 688E 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6890 643C 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6892 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6894 7494 
**** **** ****     > stevie_b1.asm.1390892
0096                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 6896 0649  14         dect  stack
0009 6898 C64B  30         mov   r11,*stack            ; Save return address
0010 689A 06A0  32         bl  @fb.tab.next            ; Jump to next tab position on line
     689C 7DCE 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 689E C2F9  30         mov   *stack+,r11           ; Pop r11
0016 68A0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68A2 7494 
**** **** ****     > stevie_b1.asm.1390892
0097                       ;-----------------------------------------------------------------------
0098                       ; Keyboard actions - Command Buffer
0099                       ;-----------------------------------------------------------------------
0100                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 68A4 C120  34         mov   @cmdb.column,tmp0
     68A6 A312 
0009 68A8 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 68AA 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     68AC A312 
0014 68AE 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     68B0 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 68B2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68B4 7494 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 68B6 06A0  32         bl    @cmdb.cmd.getlength
     68B8 7434 
0026 68BA 8820  54         c     @cmdb.column,@outparm1
     68BC A312 
     68BE 2F30 
0027 68C0 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 68C2 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     68C4 A312 
0032 68C6 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     68C8 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 68CA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68CC 7494 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 68CE 04C4  14         clr   tmp0
0045 68D0 C804  38         mov   tmp0,@cmdb.column      ; First column
     68D2 A312 
0046 68D4 0584  14         inc   tmp0
0047 68D6 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     68D8 A30A 
0048 68DA C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     68DC A30A 
0049               
0050 68DE 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68E0 7494 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68E2 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68E4 A326 
0057 68E6 0984  56         srl   tmp0,8                 ; Right justify
0058 68E8 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68EA A312 
0059 68EC 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68EE 0224  22         ai    tmp0,>1a00             ; Y=26
     68F0 1A00 
0061 68F2 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68F4 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68F6 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68F8 7494 
**** **** ****     > stevie_b1.asm.1390892
0101                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.clear
0006               * Clear current command
0007               ***************************************************************
0008               * b  @edkey.action.cmdb.clear
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               edkey.action.cmdb.clear:
0022                       ;-------------------------------------------------------
0023                       ; Clear current command
0024                       ;-------------------------------------------------------
0025 68FA 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68FC 7402 
0026 68FE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6900 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 6902 0460  28         b     @edkey.action.cmdb.home
     6904 68CE 
0032                                                   ; Reposition cursor
0033               
0034               
0035               
0036               
0037               
0038               
0039               ***************************************************************
0040               * edkey.action.cmdb.char
0041               * Add character to command line
0042               ***************************************************************
0043               * b  @edkey.action.cmdb.char
0044               *--------------------------------------------------------------
0045               * INPUT
0046               * tmp1
0047               *--------------------------------------------------------------
0048               * OUTPUT
0049               * none
0050               *--------------------------------------------------------------
0051               * Register usage
0052               * tmp0
0053               *--------------------------------------------------------------
0054               * Notes
0055               ********|*****|*********************|**************************
0056               edkey.action.cmdb.char:
0057                       ;-------------------------------------------------------
0058                       ; Asserts
0059                       ;-------------------------------------------------------
0060 6906 D105  18         movb  tmp1,tmp0             ; Get keycode
0061 6908 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 690A 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     690C 0020 
0064 690E 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6910 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6912 007E 
0068 6914 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 6916 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6918 A318 
0074               
0075 691A 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     691C A327 
0076 691E A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6920 A312 
0077 6922 D505  30         movb  tmp1,*tmp0            ; Add character
0078 6924 05A0  34         inc   @cmdb.column          ; Next column
     6926 A312 
0079 6928 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     692A A30A 
0080               
0081 692C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     692E 7434 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6930 C120  34         mov   @outparm1,tmp0
     6932 2F30 
0088 6934 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 6936 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6938 A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 693A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     693C 7494 
**** **** ****     > stevie_b1.asm.1390892
0102                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 693E C120  34         mov   @cmdb.visible,tmp0
     6940 A302 
0009 6942 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 6944 04E0  34         clr   @cmdb.column          ; Column = 0
     6946 A312 
0015 6948 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     694A 78FE 
0016 694C 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 694E 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6950 794E 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6952 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6954 7494 
**** **** ****     > stevie_b1.asm.1390892
0103                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
**** **** ****     > edkey.cmdb.file.new.asm
0001               * FILE......: edkey.cmdb.fíle.new.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * New DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.file.new:
0008                       ;-------------------------------------------------------
0009                       ; New file
0010                       ;-------------------------------------------------------
0011 6956 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6958 794E 
0012 695A 06A0  32         bl    @tv.reset             ; Reset editor
     695C 32AC 
0013                       ;-------------------------------------------------------
0014                       ; Exit
0015                       ;-------------------------------------------------------
0016               edkey.action.cmdb.file.new.exit:
0017 695E 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6960 63D0 
**** **** ****     > stevie_b1.asm.1390892
0104                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
**** **** ****     > edkey.cmdb.file.load.asm
0001               * FILE......: edkey.cmdb.fíle.load.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.load:
0008                       ;-------------------------------------------------------
0009                       ; Load file
0010                       ;-------------------------------------------------------
0011 6962 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6964 794E 
0012               
0013 6966 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6968 7434 
0014 696A C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     696C 2F30 
0015 696E 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6970 06A0  32         bl    @pane.errline.show    ; Show error line
     6972 7B36 
0020               
0021 6974 06A0  32         bl    @pane.show_hint
     6976 7678 
0022 6978 1C00                   byte pane.botrow-1,0
0023 697A 3922                   data txt.io.nofile
0024               
0025 697C 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 697E 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 6980 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6982 A326 
0031               
0032 6984 06A0  32         bl    @cpym2m
     6986 24DE 
0033 6988 A326                   data cmdb.cmdlen,heap.top,80
     698A E000 
     698C 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 698E 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6990 E000 
0039 6992 C804  38         mov   tmp0,@parm1
     6994 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6996 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6998 E000 
0045 699A C804  38         mov   tmp0,@parm1
     699C 2F20 
0046               
0047 699E 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     69A0 7D18 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 69A2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     69A4 63D0 
**** **** ****     > stevie_b1.asm.1390892
0105                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
**** **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008                       ;-------------------------------------------------------
0009                       ; Save file
0010                       ;-------------------------------------------------------
0011 69A6 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     69A8 794E 
0012               
0013 69AA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     69AC 7434 
0014 69AE C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     69B0 2F30 
0015 69B2 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 69B4 06A0  32         bl    @pane.errline.show    ; Show error line
     69B6 7B36 
0020               
0021 69B8 06A0  32         bl    @pane.show_hint
     69BA 7678 
0022 69BC 1C00                   byte pane.botrow-1,0
0023 69BE 3922                   data txt.io.nofile
0024               
0025 69C0 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 69C2 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 69C4 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69C6 A326 
0031               
0032 69C8 06A0  32         bl    @cpym2m
     69CA 24DE 
0033 69CC A326                   data cmdb.cmdlen,heap.top,80
     69CE E000 
     69D0 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 69D2 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69D4 E000 
0039 69D6 C804  38         mov   tmp0,@parm1
     69D8 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 69DA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     69DC A20E 
     69DE 2022 
0044 69E0 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 69E2 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     69E4 A20C 
     69E6 2F22 
0050 69E8 0620  34         dec   @parm2                ; /
     69EA 2F22 
0051               
0052 69EC C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     69EE A20E 
     69F0 2F24 
0053               
0054 69F2 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 69F4 04E0  34         clr   @parm2                ; First line to save
     69F6 2F22 
0060 69F8 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     69FA A204 
     69FC 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 69FE 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6A00 7D3E 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 6A02 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6A04 63D0 
**** **** ****     > stevie_b1.asm.1390892
0106                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
**** **** ****     > edkey.cmdb.dialog.asm
0001               * FILE......: edkey.cmdb.dialog.asm
0002               * Purpose...: Dialog specific actions in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.proceed
0006               * Proceed with action
0007               ***************************************************************
0008               * b   @edkey.action.cmdb.proceed
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @cmdb.action.ptr = Pointer to keyboard action
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.cmdb.proceed:
0017                       ;-------------------------------------------------------
0018                       ; Intialisation
0019                       ;-------------------------------------------------------
0020 6A06 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6A08 A206 
0021 6A0A 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6A0C 7894 
0022 6A0E 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6A10 7402 
0023 6A12 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6A14 A324 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6A16 0284  22         ci    tmp0,>2000
     6A18 2000 
0028 6A1A 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6A1C 0284  22         ci    tmp0,>7fff
     6A1E 7FFF 
0031 6A20 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6A22 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6A24 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6A26 FFCE 
0040 6A28 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A2A 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6A2C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A2E 7494 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * edkey.action.cmdb.fastmode.toggle
0052               * Toggle fastmode on/off
0053               ***************************************************************
0054               * b   @edkey.action.cmdb.fastmode.toggle
0055               *--------------------------------------------------------------
0056               * INPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * none
0061               ********|*****|*********************|**************************
0062               edkey.action.cmdb.fastmode.toggle:
0063 6A30 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A32 7D62 
0064 6A34 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A36 A318 
0065 6A38 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A3A 7494 
0066               
0067               
0068               
0069               
0070               ***************************************************************
0071               * dialog.close
0072               * Close dialog "About"
0073               ***************************************************************
0074               * b   @edkey.action.cmdb.close.about
0075               *--------------------------------------------------------------
0076               * OUTPUT
0077               * none
0078               *--------------------------------------------------------------
0079               * Register usage
0080               * none
0081               ********|*****|*********************|**************************
0082               edkey.action.cmdb.close.about:
0083                       ;------------------------------------------------------
0084                       ; Erase header line
0085                       ;------------------------------------------------------
0086 6A3C 06A0  32         bl    @hchar
     6A3E 27C8 
0087 6A40 0000                   byte 0,0,32,80*2
     6A42 20A0 
0088 6A44 FFFF                   data EOL
0089 6A46 1000  14         jmp   edkey.action.cmdb.close.dialog
0090               
0091               
0092               ***************************************************************
0093               * dialog.close
0094               * Close dialog
0095               ***************************************************************
0096               * b   @edkey.action.cmdb.close.dialog
0097               *--------------------------------------------------------------
0098               * OUTPUT
0099               * none
0100               *--------------------------------------------------------------
0101               * Register usage
0102               * none
0103               ********|*****|*********************|**************************
0104               edkey.action.cmdb.close.dialog:
0105                       ;------------------------------------------------------
0106                       ; Close dialog
0107                       ;------------------------------------------------------
0108 6A48 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A4A A31A 
0109 6A4C 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A4E 7894 
0110 6A50 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A52 794E 
0111 6A54 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A56 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6A58 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A5A 7494 
**** **** ****     > stevie_b1.asm.1390892
0107                       ;-----------------------------------------------------------------------
0108                       ; Logic for Framebuffer (1)
0109                       ;-----------------------------------------------------------------------
0110                       copy  "fb.utils.asm"        ; Framebuffer utilities
**** **** ****     > fb.utils.asm
0001               * FILE......: fb.utils.asm
0002               * Purpose...: Stevie Editor - Framebuffer utilities
0003               
0004               ***************************************************************
0005               * fb.row2line
0006               * Calculate line in editor buffer
0007               ***************************************************************
0008               * bl @fb.row2line
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.topline = Top line in frame buffer
0012               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * @outparm1 = Matching line in editor buffer
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               *--------------------------------------------------------------
0020               * Formula
0021               * outparm1 = @fb.topline + @parm1
0022               ********|*****|*********************|**************************
0023               fb.row2line:
0024 6A5C 0649  14         dect  stack
0025 6A5E C64B  30         mov   r11,*stack            ; Save return address
0026 6A60 0649  14         dect  stack
0027 6A62 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A64 C120  34         mov   @parm1,tmp0
     6A66 2F20 
0032 6A68 A120  34         a     @fb.topline,tmp0
     6A6A A104 
0033 6A6C C804  38         mov   tmp0,@outparm1
     6A6E 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A70 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A72 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A74 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               
0045               ***************************************************************
0046               * fb.calc_pointer
0047               * Calculate pointer address in frame buffer
0048               ***************************************************************
0049               * bl @fb.calc_pointer
0050               *--------------------------------------------------------------
0051               * INPUT
0052               * @fb.top       = Address of top row in frame buffer
0053               * @fb.topline   = Top line in frame buffer
0054               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0055               * @fb.column    = Current column in frame buffer
0056               * @fb.colsline  = Columns per line in frame buffer
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * @fb.current   = Updated pointer
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * tmp0,tmp1
0063               *--------------------------------------------------------------
0064               * Formula
0065               * pointer = row * colsline + column + deref(@fb.top.ptr)
0066               ********|*****|*********************|**************************
0067               fb.calc_pointer:
0068 6A76 0649  14         dect  stack
0069 6A78 C64B  30         mov   r11,*stack            ; Save return address
0070 6A7A 0649  14         dect  stack
0071 6A7C C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A7E 0649  14         dect  stack
0073 6A80 C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A82 C120  34         mov   @fb.row,tmp0
     6A84 A106 
0078 6A86 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A88 A10E 
0079 6A8A A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A8C A10C 
0080 6A8E A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A90 A100 
0081 6A92 C805  38         mov   tmp1,@fb.current
     6A94 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A96 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A98 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A9A C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A9C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0111                       copy  "fb.get.firstnonblank.asm"
**** **** ****     > fb.get.firstnonblank.asm
0001               * FILE......: fb.get.firstnonblank.asm
0002               * Purpose...: Get column of first non-blank character
0003               
0004               ***************************************************************
0005               * fb.get.firstnonblank
0006               * Get column of first non-blank character in specified line
0007               ***************************************************************
0008               * bl @fb.get.firstnonblank
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * @outparm1 = Column containing first non-blank character
0012               * @outparm2 = Character
0013               ********|*****|*********************|**************************
0014               fb.get.firstnonblank:
0015 6A9E 0649  14         dect  stack
0016 6AA0 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6AA2 04E0  34         clr   @fb.column
     6AA4 A10C 
0021 6AA6 06A0  32         bl    @fb.calc_pointer
     6AA8 6A76 
0022 6AAA 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6AAC 6FB8 
0023 6AAE C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6AB0 A108 
0024 6AB2 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6AB4 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6AB6 A102 
0027 6AB8 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6ABA D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6ABC 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6ABE 0285  22         ci    tmp1,>2000            ; Whitespace?
     6AC0 2000 
0036 6AC2 1503  14         jgt   fb.get.firstnonblank.match
0037 6AC4 0606  14         dec   tmp2                  ; Counter--
0038 6AC6 16F9  14         jne   fb.get.firstnonblank.loop
0039 6AC8 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6ACA 6120  34         s     @fb.current,tmp0      ; Calculate column
     6ACC A102 
0045 6ACE 0604  14         dec   tmp0
0046 6AD0 C804  38         mov   tmp0,@outparm1        ; Save column
     6AD2 2F30 
0047 6AD4 D805  38         movb  tmp1,@outparm2        ; Save character
     6AD6 2F32 
0048 6AD8 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6ADA 04E0  34         clr   @outparm1             ; X=0
     6ADC 2F30 
0054 6ADE 04E0  34         clr   @outparm2             ; Null
     6AE0 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6AE2 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6AE4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0112                                                   ; Get column of first non-blank character
0113                       copy  "fb.refresh.asm"      ; Refresh framebuffer
**** **** ****     > fb.refresh.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Refresh frame buffer with editor buffer content
0003               
0004               ***************************************************************
0005               * fb.refresh
0006               * Refresh frame buffer with editor buffer content
0007               ***************************************************************
0008               * bl @fb.refresh
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to start with (becomes @fb.topline)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               ********|*****|*********************|**************************
0019               fb.refresh:
0020 6AE6 0649  14         dect  stack
0021 6AE8 C64B  30         mov   r11,*stack            ; Push return address
0022 6AEA 0649  14         dect  stack
0023 6AEC C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6AEE 0649  14         dect  stack
0025 6AF0 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6AF2 0649  14         dect  stack
0027 6AF4 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6AF6 C820  54         mov   @parm1,@fb.topline
     6AF8 2F20 
     6AFA A104 
0032 6AFC 04E0  34         clr   @parm2                ; Target row in frame buffer
     6AFE 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6B00 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6B02 2F20 
     6B04 A204 
0037 6B06 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6B08 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6B0A 6EBA 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6B0C 05A0  34         inc   @parm1                ; Next line in editor buffer
     6B0E 2F20 
0048 6B10 05A0  34         inc   @parm2                ; Next row in frame buffer
     6B12 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6B14 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6B16 2F20 
     6B18 A204 
0053 6B1A 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6B1C 8820  54         c     @parm2,@fb.scrrows
     6B1E 2F22 
     6B20 A11A 
0056 6B22 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6B24 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6B26 C120  34         mov   @parm2,tmp0           ; Current row
     6B28 2F22 
0064 6B2A C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6B2C A11A 
0065 6B2E 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6B30 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6B32 A10E 
0067               
0068 6B34 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6B36 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6B38 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6B3A A10E 
0072 6B3C A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6B3E A100 
0073               
0074 6B40 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6B42 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6B44 06A0  32         bl    @xfilm                ; \ Fill memory
     6B46 2240 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6B48 0720  34         seto  @fb.dirty             ; Refresh screen
     6B4A A116 
0086 6B4C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6B4E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6B50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6B52 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6B54 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0114                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
**** **** ****     > fb.restore.asm
0001               * FILE......: fb.restore.asm
0002               * Purpose...: Restore frame buffer to normal operation
0003               
0004               ***************************************************************
0005               * fb.restore
0006               * Restore frame buffer to normal operation
0007               * (e.g. after command has completed)
0008               ***************************************************************
0009               *  bl   @fb.restore
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = cursor YX position
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * NONE
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * NONE
0019               ********|*****|*********************|**************************
0020               fb.restore:
0021 6B56 0649  14         dect  stack
0022 6B58 C64B  30         mov   r11,*stack            ; Save return address
0023 6B5A 0649  14         dect  stack
0024 6B5C C660  46         mov   @parm1,*stack         ; Push @parm1
     6B5E 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6B60 C820  54         mov   @fb.topline,@parm1
     6B62 A104 
     6B64 2F20 
0029 6B66 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6B68 6AE6 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6B6A 0720  34         seto  @parm1                ; Skip Asserts
     6B6C 2F20 
0035 6B6E 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6B70 7DF2 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6B72 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6B74 A018 
     6B76 2F20 
0042 6B78 06A0  32         bl    @pane.action.colorscheme.statlines
     6B7A 785C 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6B7C 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6B7E A118 
0050               
0051 6B80 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6B82 7894 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6B84 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6B86 2F20 
0057 6B88 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6B8A 2F20 
     6B8C 832A 
0058 6B8E C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6B90 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1390892
0115                       ;-----------------------------------------------------------------------
0116                       ; Logic for Index management
0117                       ;-----------------------------------------------------------------------
0118                       copy  "idx.update.asm"      ; Index management - Update entry
**** **** ****     > idx.update.asm
0001               * FILE......: idx.update.asm
0002               * Purpose...: Update index entry
0003               
0004               ***************************************************************
0005               * idx.entry.update
0006               * Update index entry - Each entry corresponds to a line
0007               ***************************************************************
0008               * bl @idx.entry.update
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1    = Line number in editor buffer
0012               * @parm2    = Pointer to line in editor buffer
0013               * @parm3    = SAMS page
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = Pointer to updated index entry
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               ********|*****|*********************|**************************
0021               idx.entry.update:
0022 6B92 0649  14         dect  stack
0023 6B94 C64B  30         mov   r11,*stack            ; Save return address
0024 6B96 0649  14         dect  stack
0025 6B98 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B9A 0649  14         dect  stack
0027 6B9C C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6B9E C120  34         mov   @parm1,tmp0           ; Get line number
     6BA0 2F20 
0032 6BA2 C160  34         mov   @parm2,tmp1           ; Get pointer
     6BA4 2F22 
0033 6BA6 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6BA8 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6BAA 0FFF 
0039 6BAC 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6BAE 06E0  34         swpb  @parm3
     6BB0 2F24 
0044 6BB2 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6BB4 2F24 
0045 6BB6 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6BB8 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6BBA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BBC 31A0 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6BBE C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6BC0 2F30 
0056 6BC2 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6BC4 B000 
0057 6BC6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6BC8 2F30 
0058 6BCA 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6BCC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BCE 31A0 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6BD0 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6BD2 2F30 
0068 6BD4 04E4  34         clr   @idx.top(tmp0)        ; /
     6BD6 B000 
0069 6BD8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6BDA 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6BDC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6BDE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6BE0 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6BE2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0119                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
**** **** ****     > idx.pointer.asm
0001               * FILE......: idx.pointer.asm
0002               * Purpose...: Get pointer to line in editor buffer
0003               
0004               ***************************************************************
0005               * idx.pointer.get
0006               * Get pointer to editor buffer line content
0007               ***************************************************************
0008               * bl @idx.pointer.get
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Pointer to editor buffer line content
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               idx.pointer.get:
0021 6BE4 0649  14         dect  stack
0022 6BE6 C64B  30         mov   r11,*stack            ; Save return address
0023 6BE8 0649  14         dect  stack
0024 6BEA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6BEC 0649  14         dect  stack
0026 6BEE C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6BF0 0649  14         dect  stack
0028 6BF2 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6BF4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6BF6 2F20 
0033               
0034 6BF8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6BFA 31A0 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6BFC C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6BFE 2F30 
0039 6C00 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C02 B000 
0040               
0041 6C04 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6C06 C185  18         mov   tmp1,tmp2             ; \
0047 6C08 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6C0A 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6C0C 00FF 
0052 6C0E 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6C10 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6C12 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6C14 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6C16 2F30 
0059 6C18 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6C1A 2F32 
0060 6C1C 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6C1E 04E0  34         clr   @outparm1
     6C20 2F30 
0066 6C22 04E0  34         clr   @outparm2
     6C24 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6C26 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6C28 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6C2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6C2C C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6C2E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0120                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Delete index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.delete.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.delete.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_delete
0012               ********|*****|*********************|**************************
0013               _idx.entry.delete.reorg:
0014                       ;------------------------------------------------------
0015                       ; Reorganize index entries
0016                       ;------------------------------------------------------
0017 6C30 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C32 B000 
0018 6C34 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6C36 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6C38 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6C3A 0606  14         dec   tmp2                  ; tmp2--
0026 6C3C 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6C3E 045B  20         b     *r11                  ; Return to caller
0029               
0030               
0031               
0032               ***************************************************************
0033               * idx.entry.delete
0034               * Delete index entry - Close gap created by delete
0035               ***************************************************************
0036               * bl @idx.entry.delete
0037               *--------------------------------------------------------------
0038               * INPUT
0039               * @parm1    = Line number in editor buffer to delete
0040               * @parm2    = Line number of last line to check for reorg
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0,tmp1,tmp2,tmp3
0044               ********|*****|*********************|**************************
0045               idx.entry.delete:
0046 6C40 0649  14         dect  stack
0047 6C42 C64B  30         mov   r11,*stack            ; Save return address
0048 6C44 0649  14         dect  stack
0049 6C46 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6C48 0649  14         dect  stack
0051 6C4A C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6C4C 0649  14         dect  stack
0053 6C4E C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6C50 0649  14         dect  stack
0055 6C52 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6C54 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C56 2F20 
0060               
0061 6C58 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C5A 31A0 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6C5C C120  34         mov   @outparm1,tmp0        ; Index offset
     6C5E 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6C60 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C62 2F22 
0070 6C64 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6C66 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6C68 2F20 
0074 6C6A 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6C6C 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C6E B000 
0081 6C70 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6C72 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6C74 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6C76 2F22 
0088 6C78 0287  22         ci    tmp3,2048
     6C7A 0800 
0089 6C7C 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6C7E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6C80 3132 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6C82 C120  34         mov   @parm1,tmp0           ; Restore line number
     6C84 2F20 
0103 6C86 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6C88 06A0  32         bl    @_idx.entry.delete.reorg
     6C8A 6C30 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6C8C 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C8E 3166 
0111                                                   ; Restore memory window layout
0112               
0113 6C90 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6C92 06A0  32         bl    @_idx.entry.delete.reorg
     6C94 6C30 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6C96 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6C98 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6C9A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6C9C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6C9E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6CA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6CA2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0121                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Insert index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.insert.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.insert.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_insert
0012               ********|*****|*********************|**************************
0013               _idx.entry.insert.reorg:
0014                       ;------------------------------------------------------
0015                       ; Assert 1
0016                       ;------------------------------------------------------
0017 6CA4 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6CA6 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6CA8 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6CAA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CAC FFCE 
0026 6CAE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CB0 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6CB2 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6CB4 B000 
0031 6CB6 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6CB8 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6CBA 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6CBC C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6CBE 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6CC0 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6CC2 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6CC4 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6CC6 AFFE 
0042 6CC8 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6CCA C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6CCC 0644  14         dect  tmp0                  ; Move pointer up
0050 6CCE 0645  14         dect  tmp1                  ; Move pointer up
0051 6CD0 0606  14         dec   tmp2                  ; Next index entry
0052 6CD2 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6CD4 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6CD6 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6CD8 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               
0065               ***************************************************************
0066               * idx.entry.insert
0067               * Insert index entry
0068               ***************************************************************
0069               * bl @idx.entry.insert
0070               *--------------------------------------------------------------
0071               * INPUT
0072               * @parm1    = Line number in editor buffer to insert
0073               * @parm2    = Line number of last line to check for reorg
0074               *--------------------------------------------------------------
0075               * OUTPUT
0076               * NONE
0077               *--------------------------------------------------------------
0078               * Register usage
0079               * tmp0,tmp2
0080               ********|*****|*********************|**************************
0081               idx.entry.insert:
0082 6CDA 0649  14         dect  stack
0083 6CDC C64B  30         mov   r11,*stack            ; Save return address
0084 6CDE 0649  14         dect  stack
0085 6CE0 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6CE2 0649  14         dect  stack
0087 6CE4 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6CE6 0649  14         dect  stack
0089 6CE8 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6CEA 0649  14         dect  stack
0091 6CEC C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6CEE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6CF0 2F22 
0096 6CF2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6CF4 2F20 
0097 6CF6 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6CF8 C1E0  34         mov   @parm2,tmp3
     6CFA 2F22 
0104 6CFC 0287  22         ci    tmp3,2048
     6CFE 0800 
0105 6D00 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D02 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D04 3132 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6D06 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D08 2F22 
0117 6D0A 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6D0C 06A0  32         bl    @_idx.entry.insert.reorg
     6D0E 6CA4 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6D10 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D12 3166 
0125                                                   ; Restore memory window layout
0126               
0127 6D14 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6D16 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D18 2F22 
0133               
0134 6D1A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D1C 31A0 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6D1E C120  34         mov   @outparm1,tmp0        ; Index offset
     6D20 2F30 
0139               
0140 6D22 06A0  32         bl    @_idx.entry.insert.reorg
     6D24 6CA4 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6D26 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6D28 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6D2A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6D2C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6D2E C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6D30 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0122                       ;-----------------------------------------------------------------------
0123                       ; Logic for Editor Buffer
0124                       ;-----------------------------------------------------------------------
0125                       copy  "edb.utils.asm"          ; Editor buffer utilities
**** **** ****     > edb.utils.asm
0001               * FILE......: edb.utils.asm
0002               * Purpose...: Editor buffer utilities
0003               
0004               
0005               ***************************************************************
0006               * edb.adjust.hipage
0007               * Check and increase highest SAMS page of editor buffer
0008               ***************************************************************
0009               *  bl   @edb.adjust.hipage
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @edb.next_free.ptr = Pointer to next free line
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.adjust.hipage:
0020 6D32 0649  14         dect  stack
0021 6D34 C64B  30         mov   r11,*stack            ; Save return address
0022 6D36 0649  14         dect  stack
0023 6D38 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D3A 0649  14         dect  stack
0025 6D3C C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6D3E C120  34         mov   @edb.next_free.ptr,tmp0
     6D40 A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6D42 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D44 0FFF 
0035 6D46 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D48 0052 
0036 6D4A 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D4C 0FF0 
0037 6D4E 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6D50 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D52 A218 
0043 6D54 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D56 A200 
     6D58 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6D5A C120  34         mov   @edb.sams.hipage,tmp0
     6D5C A218 
0050 6D5E C160  34         mov   @edb.top.ptr,tmp1
     6D60 A200 
0051 6D62 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D64 257A 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6D66 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6D68 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D6A FFCE 
0061 6D6C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D6E 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6D70 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6D72 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6D74 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6D76 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0126                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
**** **** ****     > edb.line.mappage.asm
0001               * FILE......: edb.line.mappage.asm
0002               * Purpose...: Editor buffer SAMS setup
0003               
0004               
0005               ***************************************************************
0006               * edb.line.mappage
0007               * Activate editor buffer SAMS page for line
0008               ***************************************************************
0009               * bl  @edb.line.mappage
0010               *
0011               * tmp0 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * outparm1 = Pointer to line in editor buffer
0015               * outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ***************************************************************
0020               edb.line.mappage:
0021 6D78 0649  14         dect  stack
0022 6D7A C64B  30         mov   r11,*stack            ; Push return address
0023 6D7C 0649  14         dect  stack
0024 6D7E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6D80 0649  14         dect  stack
0026 6D82 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6D84 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6D86 A204 
0031 6D88 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6D8A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D8C FFCE 
0037 6D8E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D90 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6D92 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6D94 2F20 
0043               
0044 6D96 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6D98 6BE4 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6D9A C120  34         mov   @outparm2,tmp0        ; SAMS page
     6D9C 2F32 
0050 6D9E C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6DA0 2F30 
0051 6DA2 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6DA4 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6DA6 A008 
0057 6DA8 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6DAA 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6DAC 257A 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6DAE C820  54         mov   @outparm2,@tv.sams.c000
     6DB0 2F32 
     6DB2 A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6DB4 C820  54         mov   @outparm2,@edb.sams.page
     6DB6 2F32 
     6DB8 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6DBA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6DBC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6DBE C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6DC0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0127                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
**** **** ****     > edb.line.pack.fb.asm
0001               * FILE......: edb.line.pack.fb.asm
0002               * Purpose...: Pack current line in framebuffer to editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.pack.fb
0006               * Pack current line in framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.pack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.top       = Address of top row in frame buffer
0012               * @fb.row       = Current row in frame buffer
0013               * @fb.column    = Current column in frame buffer
0014               * @fb.colsline  = Columns per line in frame buffer
0015               *--------------------------------------------------------------
0016               * OUTPUT
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Memory usage
0022               * rambuf   = Saved @fb.column
0023               * rambuf+2 = Saved beginning of row
0024               * rambuf+4 = Saved length of row
0025               ********|*****|*********************|**************************
0026               edb.line.pack.fb:
0027 6DC2 0649  14         dect  stack
0028 6DC4 C64B  30         mov   r11,*stack            ; Save return address
0029 6DC6 0649  14         dect  stack
0030 6DC8 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6DCA 0649  14         dect  stack
0032 6DCC C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6DCE 0649  14         dect  stack
0034 6DD0 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6DD2 0649  14         dect  stack
0036 6DD4 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6DD6 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6DD8 A10C 
     6DDA 2F6A 
0041 6DDC 04E0  34         clr   @fb.column
     6DDE A10C 
0042 6DE0 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6DE2 6A76 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6DE4 04C4  14         clr   tmp0                  ; Counter
0047 6DE6 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6DE8 C160  34         mov   @fb.current,tmp1      ; Get position
     6DEA A102 
0049 6DEC C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6DEE 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6DF0 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6DF2 0986  56         srl   tmp2,8                ; Right justify
0056 6DF4 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6DF6 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6DF8 0286  22         ci    tmp2,32               ; Was it a space character?
     6DFA 0020 
0063 6DFC 1301  14         jeq   edb.line.pack.fb.check80
0064 6DFE C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6E00 0284  22         ci    tmp0,colrow
     6E02 0050 
0070 6E04 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6E06 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6E08 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E0A FFCE 
0078 6E0C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E0E 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6E10 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6E12 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6E14 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6E16 2F6E 
0086 6E18 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6E1A C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6E1C 2F6E 
0092               
0093 6E1E 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6E20 C184  18         mov   tmp0,tmp2             ; \
0096 6E22 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6E24 0586  14         inc   tmp2                  ; /
0098               
0099 6E26 C107  18         mov   tmp3,tmp0             ; \
0100 6E28 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6E2A 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6E2C DD05  32         movb  tmp1,*tmp0+
0104 6E2E 0606  14         dec   tmp2
0105 6E30 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6E32 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E34 6D32 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6E36 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6E38 A104 
     6E3A 2F20 
0117 6E3C A820  54         a     @fb.row,@parm1        ; /
     6E3E A106 
     6E40 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6E42 C820  54         mov   @edb.next_free.ptr,@parm2
     6E44 A208 
     6E46 2F22 
0123                                                   ; Pointer to new line
0124 6E48 C820  54         mov   @edb.sams.hipage,@parm3
     6E4A A218 
     6E4C 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6E4E 06A0  32         bl    @idx.entry.update     ; Update index
     6E50 6B92 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6E52 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6E54 2F6C 
0136 6E56 C160  34         mov   @edb.next_free.ptr,tmp1
     6E58 A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6E5A 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6E5C A208 
0140               
0141 6E5E C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6E60 2F6E 
0142 6E62 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6E64 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6E66 0286  22         ci    tmp2,2
     6E68 0002 
0150 6E6A 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6E6C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6E6E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6E70 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6E72 0286  22         ci    tmp2,1
     6E74 0001 
0157 6E76 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6E78 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6E7A 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6E7C 06A0  32         bl    @xpym2m               ; Copy memory block
     6E7E 24E4 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6E80 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6E82 2F6E 
     6E84 A208 
0171                                                      ; Add length of line
0172               
0173 6E86 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6E88 A208 
0174 6E8A 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6E8C 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6E8E 000F 
0176 6E90 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6E92 A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6E94 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6E96 2F6A 
     6E98 A10C 
0182               
0183 6E9A 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6E9C A218 
     6E9E A216 
0184 6EA0 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6EA2 C120  34         mov   @edb.sams.page,tmp0
     6EA4 A216 
0187 6EA6 C160  34         mov   @edb.top.ptr,tmp1
     6EA8 A200 
0188 6EAA 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EAC 257A 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6EAE C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6EB0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6EB2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6EB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6EB6 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6EB8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0128                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
**** **** ****     > edb.line.unpack.fb.asm
0001               * FILE......: edb.line.unpack.fb.asm
0002               * Purpose...: Unpack line from editor buffer to frame buffer
0003               
0004               ***************************************************************
0005               * edb.line.unpack.fb
0006               * Unpack specified line to framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.unpack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to unpack in editor buffer (base 0)
0012               * @parm2 = Target row in frame buffer
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * @outparm1 = Length of unpacked line
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Memory usage
0021               * rambuf    = Saved @parm1 of edb.line.unpack.fb
0022               * rambuf+2  = Saved @parm2 of edb.line.unpack.fb
0023               * rambuf+4  = Source memory address in editor buffer
0024               * rambuf+6  = Destination memory address in frame buffer
0025               * rambuf+8  = Length of line
0026               ********|*****|*********************|**************************
0027               edb.line.unpack.fb:
0028 6EBA 0649  14         dect  stack
0029 6EBC C64B  30         mov   r11,*stack            ; Save return address
0030 6EBE 0649  14         dect  stack
0031 6EC0 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6EC2 0649  14         dect  stack
0033 6EC4 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6EC6 0649  14         dect  stack
0035 6EC8 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6ECA C820  54         mov   @parm1,@rambuf
     6ECC 2F20 
     6ECE 2F6A 
0040 6ED0 C820  54         mov   @parm2,@rambuf+2
     6ED2 2F22 
     6ED4 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6ED6 C120  34         mov   @fb.colsline,tmp0
     6ED8 A10E 
0045 6EDA 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6EDC 2F22 
0046 6EDE C1A0  34         mov   @fb.top.ptr,tmp2
     6EE0 A100 
0047 6EE2 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6EE4 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6EE6 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6EE8 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6EEA 2F20 
     6EEC A204 
0053 6EEE 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6EF0 04E0  34         clr   @rambuf+8             ; Set length=0
     6EF2 2F72 
0056 6EF4 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6EF6 C120  34 !       mov   @parm1,tmp0
     6EF8 2F20 
0061 6EFA 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6EFC 6D78 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6EFE C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F00 2F30 
0069 6F02 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6F04 04E0  34         clr   @rambuf+8             ; Set length=0
     6F06 2F72 
0073 6F08 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6F0A C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6F0C C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6F0E 2F6E 
0080 6F10 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6F12 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6F14 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F16 0050 
0085                                                   ; /
0086 6F18 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6F1A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F1C FFCE 
0091 6F1E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F20 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6F22 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F24 2F70 
0097 6F26 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F28 2F72 
0098               
0099 6F2A 04C5  14         clr   tmp1                  ; Fill with >00
0100 6F2C C1A0  34         mov   @fb.colsline,tmp2
     6F2E A10E 
0101 6F30 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F32 2F72 
0102 6F34 0586  14         inc   tmp2
0103               
0104 6F36 06A0  32         bl    @xfilm                ; Fill CPU memory
     6F38 2240 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6F3A C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6F3C 2F72 
0113 6F3E 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6F40 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6F42 2F6E 
0116 6F44 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6F46 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6F48 0286  22         ci    tmp2,80               ; Check line length
     6F4A 0050 
0122 6F4C 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6F4E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F50 FFCE 
0127 6F52 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F54 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6F56 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6F58 2F30 
0133               
0134 6F5A 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6F5C 24E4 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6F5E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6F60 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6F62 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6F64 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6F66 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0129                       copy  "edb.line.getlen.asm"    ; Get line length
**** **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Get length of specified line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.getlength
0006               * Get length of specified line
0007               ***************************************************************
0008               *  bl   @edb.line.getlength
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number (base 0)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Length of line
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1
0019               ********|*****|*********************|**************************
0020               edb.line.getlength:
0021 6F68 0649  14         dect  stack
0022 6F6A C64B  30         mov   r11,*stack            ; Push return address
0023 6F6C 0649  14         dect  stack
0024 6F6E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6F70 0649  14         dect  stack
0026 6F72 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6F74 04E0  34         clr   @outparm1             ; Reset length
     6F76 2F30 
0031 6F78 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6F7A 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 6F7C C120  34         mov   @parm1,tmp0           ; \
     6F7E 2F20 
0036 6F80 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 6F82 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     6F84 A204 
0039 6F86 1101  14         jlt   !                     ; No, continue processing
0040 6F88 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 6F8A C120  34 !       mov   @parm1,tmp0           ; Get line
     6F8C 2F20 
0046               
0047 6F8E 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F90 6D78 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 6F92 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6F94 2F30 
0053 6F96 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 6F98 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 6F9A C805  38         mov   tmp1,@outparm1        ; Save length
     6F9C 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 6F9E 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6FA0 0050 
0064 6FA2 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 6FA4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FA6 FFCE 
0070 6FA8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FAA 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 6FAC 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6FAE 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 6FB0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 6FB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 6FB4 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 6FB6 045B  20         b     *r11                  ; Return to caller
0084               
0085               
0086               
0087               ***************************************************************
0088               * edb.line.getlength2
0089               * Get length of current row (as seen from editor buffer side)
0090               ***************************************************************
0091               *  bl   @edb.line.getlength2
0092               *--------------------------------------------------------------
0093               * INPUT
0094               * @fb.row = Row in frame buffer
0095               *--------------------------------------------------------------
0096               * OUTPUT
0097               * @fb.row.length = Length of row
0098               *--------------------------------------------------------------
0099               * Register usage
0100               * tmp0
0101               ********|*****|*********************|**************************
0102               edb.line.getlength2:
0103 6FB8 0649  14         dect  stack
0104 6FBA C64B  30         mov   r11,*stack            ; Save return address
0105 6FBC 0649  14         dect  stack
0106 6FBE C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 6FC0 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6FC2 A104 
0111 6FC4 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6FC6 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 6FC8 C804  38         mov   tmp0,@parm1
     6FCA 2F20 
0116 6FCC 06A0  32         bl    @edb.line.getlength
     6FCE 6F68 
0117 6FD0 C820  54         mov   @outparm1,@fb.row.length
     6FD2 2F30 
     6FD4 A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 6FD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 6FD8 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 6FDA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0130                       copy  "edb.line.copy.asm"      ; Copy line
**** **** ****     > edb.line.copy.asm
0001               * FILE......: edb.line.copy.asm
0002               * Purpose...: Copy line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.copy
0006               * Copy line in editor buffer
0007               ***************************************************************
0008               *  bl   @edb.line.copy
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Source line number in editor buffer
0012               * @parm2 = Target line number in editor buffer
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * NONE
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Memory usage
0021               * rambuf    = Length of source line
0022               * rambuf+2  = line number of target line
0023               * rambuf+4  = Pointer to source line in editor buffer
0024               * rambuf+6  = Pointer to target line in editor buffer
0025               *--------------------------------------------------------------
0026               * Remarks
0027               * @parm1 and @parm2 must be provided in base 1, but internally
0028               * we work with base 0!
0029               ********|*****|*********************|**************************
0030               edb.line.copy:
0031 6FDC 0649  14         dect  stack
0032 6FDE C64B  30         mov   r11,*stack            ; Save return address
0033 6FE0 0649  14         dect  stack
0034 6FE2 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 6FE4 0649  14         dect  stack
0036 6FE6 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 6FE8 0649  14         dect  stack
0038 6FEA C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 6FEC 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     6FEE 2F20 
     6FF0 A204 
0043 6FF2 1204  14         jle   !
0044 6FF4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FF6 FFCE 
0045 6FF8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FFA 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 6FFC C120  34 !       mov   @parm2,tmp0           ; Get target line number
     6FFE 2F22 
0050 7000 0604  14         dec   tmp0                  ; Base 0
0051 7002 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     7004 2F6C 
0052 7006 04E0  34         clr   @rambuf               ; Set source line length=0
     7008 2F6A 
0053 700A 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     700C 2F6E 
0054 700E 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     7010 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 7012 C120  34         mov   @parm1,tmp0           ; Get source line number
     7014 2F20 
0059 7016 0604  14         dec   tmp0                  ; Base 0
0060               
0061 7018 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     701A 6D78 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 701C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     701E 2F30 
0069 7020 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 7022 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 7024 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 7026 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     7028 2F6A 
0077 702A 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     702C 2F6A 
0078 702E C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     7030 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 7032 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     7034 0050 
0083 7036 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 7038 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     703A FFCE 
0088 703C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     703E 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 7040 A820  54         a     @w$1000,@edb.top.ptr
     7042 201A 
     7044 A200 
0094 7046 A820  54         a     @w$1000,@edb.next_free.ptr
     7048 201A 
     704A A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 704C 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     704E 6D32 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 7050 C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     7052 2F6E 
0111 7054 C160  34         mov   @edb.next_free.ptr,tmp1
     7056 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 7058 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     705A 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 705C 06A0  32         bl    @xpym2m               ; Copy memory block
     705E 24E4 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 7060 6820  54         s     @w$1000,@edb.top.ptr
     7062 201A 
     7064 A200 
0127 7066 6820  54         s     @w$1000,@edb.next_free.ptr
     7068 201A 
     706A A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 706C C820  54         mov   @edb.next_free.ptr,@rambuf+6
     706E A208 
     7070 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 7072 C120  34         mov   @edb.sams.page,tmp0
     7074 A216 
0138 7076 C160  34         mov   @edb.top.ptr,tmp1
     7078 A200 
0139 707A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     707C 257A 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 707E C120  34         mov   @tv.sams.d000,tmp0
     7080 A00A 
0146 7082 0205  20         li    tmp1,>d000
     7084 D000 
0147 7086 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7088 257A 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 708A A820  54         a     @rambuf,@edb.next_free.ptr
     708C 2F6A 
     708E A208 
0154                                                      ; Add length of line
0155               
0156 7090 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7092 A208 
0157 7094 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7096 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7098 000F 
0159 709A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     709C A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 709E C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     70A0 2F6C 
     70A2 2F20 
0165 70A4 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     70A6 2F70 
     70A8 2F22 
0166 70AA C820  54         mov   @edb.sams.hipage,@parm3
     70AC A218 
     70AE 2F24 
0167                                                   ; SAMS page to use
0168               
0169 70B0 06A0  32         bl    @idx.entry.update     ; Update index
     70B2 6B92 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 70B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 70B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 70B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 70BA C2F9  30         mov   *stack+,r11           ; Pop r11
0182 70BC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0131                       copy  "edb.line.del.asm"       ; Delete line
**** **** ****     > edb.line.del.asm
0001               * FILE......: edb.line.del.asm
0002               * Purpose...: Delete line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.del
0006               * Delete line in editor buffer
0007               ***************************************************************
0008               *  bl   @edb.line.del
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Remarks
0020               * @parm1 must be provided in base 1, but internally we work
0021               * with base 0!
0022               ********|*****|*********************|**************************
0023               edb.line.del:
0024 70BE 0649  14         dect  stack
0025 70C0 C64B  30         mov   r11,*stack            ; Save return address
0026 70C2 0649  14         dect  stack
0027 70C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 70C6 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     70C8 2F20 
     70CA A204 
0032 70CC 1204  14         jle   !
0033 70CE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D0 FFCE 
0034 70D2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70D4 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 70D6 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70D8 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 70DA C120  34          mov   @edb.lines,tmp0      ; \
     70DC A204 
0043 70DE 0284  22          ci    tmp0,1               ; | Only single line?
     70E0 0001 
0044 70E2 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 70E4 0620  34         dec   @parm1                ; Base 0
     70E6 2F20 
0049 70E8 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     70EA A204 
     70EC 2F22 
0050               
0051 70EE 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     70F0 6C40 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 70F2 0620  34         dec   @edb.lines            ; One line less in editor buffer
     70F4 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 70F6 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     70F8 A20C 
     70FA 2022 
0061 70FC 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 70FE 8820  54         c     @parm1,@edb.block.m1  ; \
     7100 2F20 
     7102 A20C 
0064 7104 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 7106 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 7108 8820  54         c     @edb.block.m1,@w$0001 ; \
     710A A20C 
     710C 2002 
0068 710E 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 7110 0620  34         dec   @edb.block.m1         ; M1--
     7112 A20C 
0071 7114 0720  34         seto  @fb.colorize          ; Set colorize flag
     7116 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 7118 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     711A A20E 
     711C 2022 
0077 711E 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 7120 8820  54         c     @parm1,@edb.block.m2  ; \
     7122 2F20 
     7124 A20E 
0080 7126 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 7128 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 712A 8820  54         c     @edb.block.m2,@w$0001 ; \
     712C A20E 
     712E 2002 
0084 7130 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 7132 0620  34         dec   @edb.block.m2         ; M2--
     7134 A20E 
0087 7136 0720  34         seto  @fb.colorize          ; Set colorize flag
     7138 A110 
0088 713A 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 713C 04E0  34         clr   @parm1                ; 1st line
     713E 2F20 
0094 7140 04E0  34         clr   @parm2                ; 1st line
     7142 2F22 
0095               
0096 7144 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7146 6C40 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 7148 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 714A C2F9  30         mov   *stack+,r11           ; Pop r11
0105 714C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0132                       copy  "edb.block.mark.asm"     ; Mark code block
**** **** ****     > edb.block.mark.asm
0001               * FILE......: edb.block.mark.asm
0002               * Purpose...: Mark line for block operation
0003               
0004               ***************************************************************
0005               * edb.block.mark.m1
0006               * Mark M1 line for block operation
0007               ***************************************************************
0008               *  bl   @edb.block.mark.m1
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * NONE
0018               ********|*****|*********************|**************************
0019               edb.block.mark.m1:
0020 714E 0649  14         dect  stack
0021 7150 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 7152 C820  54         mov   @fb.row,@parm1
     7154 A106 
     7156 2F20 
0026 7158 06A0  32         bl    @fb.row2line          ; Row to editor line
     715A 6A5C 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 715C 05A0  34         inc   @outparm1             ; Add base 1
     715E 2F30 
0032               
0033 7160 C820  54         mov   @outparm1,@edb.block.m1
     7162 2F30 
     7164 A20C 
0034                                                   ; Set block marker M1
0035 7166 0720  34         seto  @fb.colorize          ; Set colorize flag
     7168 A110 
0036 716A 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     716C A116 
0037 716E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7170 A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 7172 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7174 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               ***************************************************************
0047               * edb.block.mark.m2
0048               * Mark M2 line for block operation
0049               ***************************************************************
0050               *  bl   @edb.block.mark.m2
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * NONE
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * NONE
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * NONE
0060               ********|*****|*********************|**************************
0061               edb.block.mark.m2:
0062 7176 0649  14         dect  stack
0063 7178 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 717A C820  54         mov   @fb.row,@parm1
     717C A106 
     717E 2F20 
0068 7180 06A0  32         bl    @fb.row2line          ; Row to editor line
     7182 6A5C 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7184 05A0  34         inc   @outparm1             ; Add base 1
     7186 2F30 
0074               
0075 7188 C820  54         mov   @outparm1,@edb.block.m2
     718A 2F30 
     718C A20E 
0076                                                   ; Set block marker M2
0077               
0078 718E 0720  34         seto  @fb.colorize          ; Set colorize flag
     7190 A110 
0079 7192 0720  34         seto  @fb.dirty             ; Trigger refresh
     7194 A116 
0080 7196 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7198 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 719A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 719C 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * edb.block.mark
0092               * Mark either M1 or M2 line for block operation
0093               ***************************************************************
0094               *  bl   @edb.block.mark
0095               *--------------------------------------------------------------
0096               * INPUT
0097               * NONE
0098               *--------------------------------------------------------------
0099               * OUTPUT
0100               * NONE
0101               *--------------------------------------------------------------
0102               * Register usage
0103               * tmp0, tmp1
0104               ********|*****|*********************|**************************
0105               edb.block.mark:
0106 719E 0649  14         dect  stack
0107 71A0 C64B  30         mov   r11,*stack            ; Push return address
0108 71A2 0649  14         dect  stack
0109 71A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 71A6 0649  14         dect  stack
0111 71A8 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 71AA C820  54         mov   @fb.row,@parm1
     71AC A106 
     71AE 2F20 
0116 71B0 06A0  32         bl    @fb.row2line          ; Row to editor line
     71B2 6A5C 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 71B4 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     71B6 2F30 
0122 71B8 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 71BA C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     71BC A20C 
0127 71BE 0584  14         inc   tmp0                  ; /
0128 71C0 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 71C2 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     71C4 714E 
0135 71C6 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 71C8 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     71CA A20C 
0141 71CC 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 71CE 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     71D0 7176 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 71D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 71D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 71D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 71D8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0133                       copy  "edb.block.reset.asm"    ; Reset markers
**** **** ****     > edb.block.reset.asm
0001               ***************************************************************
0002               * edb.block.mark.reset
0003               * Reset block markers M1/M2
0004               ***************************************************************
0005               *  bl   @edb.block.mark.reset
0006               *--------------------------------------------------------------
0007               * INPUT
0008               * NONE
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * NONE
0015               ********|*****|*********************|**************************
0016               edb.block.reset:
0017 71DA 0649  14         dect  stack
0018 71DC C64B  30         mov   r11,*stack            ; Push return address
0019 71DE 0649  14         dect  stack
0020 71E0 C660  46         mov   @wyx,*stack           ; Push cursor position
     71E2 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 71E4 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     71E6 A20C 
0025 71E8 0720  34         seto  @edb.block.m2         ; /
     71EA A20E 
0026               
0027 71EC 0720  34         seto  @fb.colorize          ; Set colorize flag
     71EE A110 
0028 71F0 0720  34         seto  @fb.dirty             ; Trigger refresh
     71F2 A116 
0029 71F4 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71F6 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 71F8 0720  34         seto  @parm1
     71FA 2F20 
0034 71FC 06A0  32         bl    @pane.action.colorscheme.load
     71FE 76EA 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 7200 C820  54         mov   @tv.color,@parm1      ; Set normal color
     7202 A018 
     7204 2F20 
0042 7206 06A0  32         bl    @pane.action.colorscheme.statlines
     7208 785C 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 720A 06A0  32         bl    @hchar
     720C 27C8 
0048 720E 0034                   byte 0,52,32,18           ; Remove markers
     7210 2012 
0049 7212 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     7214 2037 
0050 7216 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 7218 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     721A 832A 
0056 721C C2F9  30         mov   *stack+,r11           ; Pop r11
0057 721E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0134                       copy  "edb.block.copy.asm"     ; Copy code block
**** **** ****     > edb.block.copy.asm
0001               * FILE......: edb.block.copy.asm
0002               * Purpose...: Copy code block
0003               
0004               ***************************************************************
0005               * edb.block.copy
0006               * Copy code block
0007               ***************************************************************
0008               *  bl   @edb.block.copy
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Copying block...")
0013               *          (>ffff = Display message "Moving block....")
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.copy:
0027 7220 0649  14         dect  stack
0028 7222 C64B  30         mov   r11,*stack            ; Save return address
0029 7224 0649  14         dect  stack
0030 7226 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7228 0649  14         dect  stack
0032 722A C645  30         mov   tmp1,*stack           ; Push tmp1
0033 722C 0649  14         dect  stack
0034 722E C646  30         mov   tmp2,*stack           ; Push tmp2
0035 7230 0649  14         dect  stack
0036 7232 C660  46         mov   @parm1,*stack         ; Push parm1
     7234 2F20 
0037 7236 04E0  34         clr   @outparm1             ; No action (>0000)
     7238 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 723A 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     723C A20C 
     723E 2022 
0042 7240 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 7242 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7244 A20E 
     7246 2022 
0045 7248 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 724A 8820  54         c     @edb.block.m1,@edb.block.m2
     724C A20C 
     724E A20E 
0048                                                   ; M1 > M2 ?
0049 7250 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 7252 C820  54         mov   @fb.row,@parm1
     7254 A106 
     7256 2F20 
0054 7258 06A0  32         bl    @fb.row2line          ; Row to editor line
     725A 6A5C 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 725C C120  34         mov   @outparm1,tmp0        ; \
     725E 2F30 
0060 7260 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 7262 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     7264 A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7266 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7268 2F30 
0066 726A 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 726C 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     726E 2F30 
0069 7270 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 7272 06A0  32         bl    @cpym2m
     7274 24DE 
0072 7276 3944                   data txt.block.inside,tv.error.msg,53
     7278 A02A 
     727A 0035 
0073               
0074 727C 06A0  32         bl    @pane.errline.show    ; Show error line
     727E 7B36 
0075               
0076 7280 04E0  34         clr   @outparm1             ; No action (>0000)
     7282 2F30 
0077 7284 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 7286 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7288 A01C 
     728A 2F20 
0082 728C 06A0  32         bl    @pane.action.colorscheme.statlines
     728E 785C 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 7290 06A0  32         bl    @hchar
     7292 27C8 
0088 7294 1D00                   byte pane.botrow,0,32,55
     7296 2037 
0089 7298 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 729A C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 729C 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 729E 06A0  32         bl    @putat
     72A0 2446 
0098 72A2 1D00                   byte pane.botrow,0
0099 72A4 34CE                   data txt.block.copy   ; Display "Copying block...."
0100 72A6 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 72A8 06A0  32         bl    @putat
     72AA 2446 
0104 72AC 1D00                   byte pane.botrow,0
0105 72AE 34E0                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 72B0 C120  34         mov   @edb.block.m1,tmp0    ; M1
     72B2 A20C 
0111 72B4 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     72B6 A20E 
0112 72B8 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 72BA 0586  14         inc   tmp2                  ; /
0114               
0115 72BC C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     72BE A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 72C0 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     72C2 2F20 
0121 72C4 0620  34         dec   @parm1                ; Base 0 offset for index required
     72C6 2F20 
0122 72C8 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72CA A204 
     72CC 2F22 
0123               
0124 72CE 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     72D0 6CDA 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 72D2 8805  38         c     tmp1,@edb.block.m1
     72D4 A20C 
0131 72D6 1506  14         jgt   edb.block.copy.loop.docopy
0132 72D8 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 72DA 05A0  34         inc   @edb.block.m1         ; M1++
     72DC A20C 
0135 72DE 05A0  34         inc   @edb.block.m2         ; M2++
     72E0 A20E 
0136 72E2 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 72E4 C804  38         mov   tmp0,@parm1           ; Source line for copy
     72E6 2F20 
0142 72E8 C805  38         mov   tmp1,@parm2           ; Target line for copy
     72EA 2F22 
0143               
0144 72EC 06A0  32         bl    @edb.line.copy        ; Copy line
     72EE 6FDC 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 72F0 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     72F2 A204 
0151 72F4 0584  14         inc   tmp0                  ; Next source line
0152 72F6 0585  14         inc   tmp1                  ; Next target line
0153 72F8 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 72FA 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 72FC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72FE A206 
0159 7300 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     7302 A116 
0160 7304 0720  34         seto  @outparm1             ; Copy completed
     7306 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 7308 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     730A 2F20 
0166 730C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 730E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 7310 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 7312 C2F9  30         mov   *stack+,r11           ; Pop R11
0170 7314 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0135                       copy  "edb.block.del.asm"      ; Delete code block
**** **** ****     > edb.block.del.asm
0001               * FILE......: edb.block.del.asm
0002               * Purpose...: Delete code block
0003               
0004               ***************************************************************
0005               * edb.block.delete
0006               * Delete code block
0007               ***************************************************************
0008               *  bl   @edb.block.delete
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Deleting block")
0013               *          (>ffff = Skip message display)
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.delete:
0027 7316 0649  14         dect  stack
0028 7318 C64B  30         mov   r11,*stack            ; Save return address
0029 731A 0649  14         dect  stack
0030 731C C644  30         mov   tmp0,*stack           ; Push tmp0
0031 731E 0649  14         dect  stack
0032 7320 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7322 0649  14         dect  stack
0034 7324 C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 7326 04E0  34         clr   @outparm1             ; No action (>0000)
     7328 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 732A C120  34         mov   @edb.block.m1,tmp0    ; \
     732C A20C 
0041 732E 0584  14         inc   tmp0                  ; | M1 unset?
0042 7330 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 7332 C160  34         mov   @edb.block.m2,tmp1    ; \
     7334 A20E 
0045 7336 0584  14         inc   tmp0                  ; | M2 unset?
0046 7338 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 733A C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     733C 2F20 
0051 733E 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 7340 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     7342 A01C 
     7344 2F20 
0056               
0057 7346 06A0  32         bl    @pane.action.colorscheme.statlines
     7348 785C 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 734A 06A0  32         bl    @hchar
     734C 27C8 
0063 734E 1D00                   byte pane.botrow,0,32,55
     7350 2037 
0064 7352 FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 7354 06A0  32         bl    @putat
     7356 2446 
0067 7358 1D00                   byte pane.botrow,0
0068 735A 34BA                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 735C C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     735E A20C 
0074 7360 0604  14         dec   tmp0                  ; Base 0
0075               
0076 7362 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     7364 A20E 
0077 7366 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7368 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     736A 2F20 
0080 736C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     736E A204 
     7370 2F22 
0081 7372 0620  34         dec   @parm2                ; Base 0
     7374 2F22 
0082               
0083 7376 C185  18         mov   tmp1,tmp2             ; \
0084 7378 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 737A 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 737C 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     737E 6C40 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 7380 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     7382 A204 
0095 7384 0620  34         dec   @parm2                ; /
     7386 2F22 
0096               
0097 7388 0606  14         dec   tmp2
0098 738A 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 738C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     738E A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 7390 8820  54         c     @fb.topline,@edb.lines
     7392 A104 
     7394 A204 
0104                                                   ; Beyond editor buffer?
0105 7396 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7398 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     739A A104 
     739C 2F20 
0108 739E 1002  14         jmp   edb.block.delete.fb.refresh
0109 73A0 04E0  34 !       clr   @parm1                ; Set line to start with
     73A2 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 73A4 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     73A6 6AE6 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 73A8 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     73AA 71DA 
0119               
0120 73AC 0720  34         seto  @outparm1             ; Delete completed
     73AE 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 73B0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 73B2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 73B4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 73B6 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.1390892
0136                       ;-----------------------------------------------------------------------
0137                       ; Command buffer handling
0138                       ;-----------------------------------------------------------------------
0139                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
**** **** ****     > cmdb.refresh.asm
0001               * FILE......: cmdb.refresh.asm
0002               * Purpose...: Stevie Editor - Command buffer
0003               
0004               ***************************************************************
0005               * cmdb.refresh
0006               * Refresh command buffer content
0007               ***************************************************************
0008               * bl @cmdb.refresh
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.refresh:
0022 73B8 0649  14         dect  stack
0023 73BA C64B  30         mov   r11,*stack            ; Save return address
0024 73BC 0649  14         dect  stack
0025 73BE C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73C0 0649  14         dect  stack
0027 73C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73C4 0649  14         dect  stack
0029 73C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 73C8 0649  14         dect  stack
0031 73CA C660  46         mov   @wyx,*stack           ; Push cursor position
     73CC 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 73CE C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     73D0 A310 
     73D2 832A 
0036               
0037 73D4 05A0  34         inc   @wyx                  ; X +1 for prompt
     73D6 832A 
0038               
0039 73D8 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     73DA 23FE 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 73DC 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     73DE A327 
0044 73E0 0206  20         li    tmp2,1*79             ; Command length
     73E2 004F 
0045               
0046 73E4 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     73E6 2490 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 73E8 C820  54         mov   @cmdb.yxprompt,@wyx
     73EA A310 
     73EC 832A 
0054 73EE 06A0  32         bl    @putstr
     73F0 2422 
0055 73F2 397A                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 73F4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     73F6 832A 
0061 73F8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 73FA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 73FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 73FE C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7400 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0140                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
0001               * FILE......: cmdb.cmd.asm
0002               * Purpose...: Stevie Editor - Command line
0003               
0004               ***************************************************************
0005               * cmdb.cmd.clear
0006               * Clear current command
0007               ***************************************************************
0008               * bl @cmdb.cmd.clear
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.cmd.clear:
0022 7402 0649  14         dect  stack
0023 7404 C64B  30         mov   r11,*stack            ; Save return address
0024 7406 0649  14         dect  stack
0025 7408 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 740A 0649  14         dect  stack
0027 740C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 740E 0649  14         dect  stack
0029 7410 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 7412 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     7414 A326 
0034 7416 06A0  32         bl    @film                 ; Clear command
     7418 223A 
0035 741A A327                   data  cmdb.cmd,>00,80
     741C 0000 
     741E 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 7420 C120  34         mov   @cmdb.yxprompt,tmp0
     7422 A310 
0040 7424 0584  14         inc   tmp0
0041 7426 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     7428 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 742A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 742C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 742E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7430 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7432 045B  20         b     *r11                  ; Return to caller
0051               
0052               
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * cmdb.cmdb.getlength
0059               * Get length of current command
0060               ***************************************************************
0061               * bl @cmdb.cmd.getlength
0062               *--------------------------------------------------------------
0063               * INPUT
0064               * @cmdb.cmd
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               * @outparm1
0068               *--------------------------------------------------------------
0069               * Register usage
0070               * none
0071               *--------------------------------------------------------------
0072               * Notes
0073               ********|*****|*********************|**************************
0074               cmdb.cmd.getlength:
0075 7434 0649  14         dect  stack
0076 7436 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 7438 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     743A 2ACE 
0081 743C A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     743E 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 7440 C820  54         mov   @waux1,@outparm1     ; Save length of string
     7442 833C 
     7444 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 7446 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 7448 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               
0094               
0095               
0096               ***************************************************************
0097               * cmdb.cmd.addhist
0098               * Add command to history
0099               ***************************************************************
0100               * bl @cmdb.cmd.addhist
0101               *--------------------------------------------------------------
0102               * INPUT
0103               *
0104               * @cmdb.cmd
0105               *--------------------------------------------------------------
0106               * OUTPUT
0107               * @outparm1     (Length in LSB)
0108               *--------------------------------------------------------------
0109               * Register usage
0110               * tmp0
0111               *--------------------------------------------------------------
0112               * Notes
0113               ********|*****|*********************|**************************
0114               cmdb.cmd.history.add:
0115 744A 0649  14         dect  stack
0116 744C C64B  30         mov   r11,*stack            ; Save return address
0117 744E 0649  14         dect  stack
0118 7450 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 7452 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     7454 7434 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 7456 C120  34         mov   @outparm1,tmp0        ; Check length
     7458 2F30 
0127 745A 1300  14         jeq   cmdb.cmd.history.add.exit
0128                                                   ; Exit early if length = 0
0129                       ;------------------------------------------------------
0130                       ; Add command to history
0131                       ;------------------------------------------------------
0132               
0133               
0134               
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138               cmdb.cmd.history.add.exit:
0139 745C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 745E C2F9  30         mov   *stack+,r11           ; Pop r11
0141 7460 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0141                       ;-----------------------------------------------------------------------
0142                       ; User hook, background tasks
0143                       ;-----------------------------------------------------------------------
0144                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7462 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7464 200A 
0009 7466 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 7468 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     746A 833C 
     746C 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 746E 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7470 200A 
0016 7472 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     7474 2F40 
     7476 2F42 
0017 7478 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 747A 0204  20         li    tmp0,250              ; \
     747C 00FA 
0022 747E 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 7480 16FE  14         jne   -!                    ; /
0024 7482 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     7484 2F40 
     7486 2F42 
0025 7488 0460  28         b     @edkey.key.process    ; Process key
     748A 60D4 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 748C 04E0  34         clr   @keycode1
     748E 2F40 
0031 7490 04E0  34         clr   @keycode2
     7492 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 7494 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7496 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 7498 0604  14         dec   tmp0
0042 749A 16FE  14         jne   hook.keyscan.bounce.loop
0043 749C 0460  28         b     @hookok               ; Return
     749E 2D4E 
0044               
**** **** ****     > stevie_b1.asm.1390892
0145                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 74A0 0649  14         dect  stack
0009 74A2 C64B  30         mov   r11,*stack            ; Save return address
0010 74A4 0649  14         dect  stack
0011 74A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 74A8 0649  14         dect  stack
0013 74AA C660  46         mov   @wyx,*stack           ; Push cursor position
     74AC 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 74AE 20A0  38         coc   @wbit10,config
     74B0 200C 
0019 74B2 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 74B4 06A0  32         bl    @putat
     74B6 2446 
0024 74B8 1D4E                   byte pane.botrow,78
0025 74BA 35EE                   data txt.ws4
0026 74BC 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74BE 06A0  32         bl    @putat
     74C0 2446 
0032 74C2 1D4E                   byte pane.botrow,78
0033 74C4 35DE                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74C6 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74C8 A302 
0039 74CA 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74CC C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74CE A318 
0045 74D0 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 74D2 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74D4 799C 
0048 74D6 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74D8 A318 
0049 74DA 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 74DC C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74DE A116 
0054 74E0 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 74E2 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     74E4 A11A 
     74E6 2F20 
0057               
0058               task.vdp.panes.dump:
0059 74E8 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     74EA 7E04 
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 74EC C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     74EE A110 
0066 74F0 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 74F2 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     74F4 7DF2 
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 74F6 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     74F8 A116 
0074 74FA 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     74FC A118 
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 74FE C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     7500 A118 
0080 7502 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 7504 06A0  32         bl    @pane.topline         ; Draw top line
     7506 7A82 
0083 7508 06A0  32         bl    @pane.botline         ; Draw bottom line
     750A 7BD0 
0084 750C 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     750E A118 
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 7510 C120  34         mov   @tv.ruler.visible,tmp0
     7512 A010 
0089                                                   ; Should ruler be visible?
0090 7514 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 7516 06A0  32         bl    @cpym2v
     7518 248A 
0093 751A 0050                   data vdp.fb.toprow.sit
0094 751C A11E                   data fb.ruler.sit
0095 751E 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 7520 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7522 832A 
0101 7524 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7526 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7528 0460  28         b     @slotok
     752A 2DCA 
**** **** ****     > stevie_b1.asm.1390892
0146               
0148               
0149                       copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 752C 0649  14         dect  stack
0009 752E C64B  30         mov   r11,*stack            ; Save return address
0010 7530 0649  14         dect  stack
0011 7532 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7534 0649  14         dect  stack
0013 7536 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7538 0649  14         dect  stack
0015 753A C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 753C C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     753E A022 
0020               
0021 7540 0284  22         ci    tmp0,pane.focus.fb
     7542 0000 
0022 7544 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7546 0284  22         ci    tmp0,pane.focus.cmdb
     7548 0001 
0025 754A 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 754C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     754E FFCE 
0031 7550 06A0  32         bl    @cpu.crash            ; / Halt system.
     7552 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7554 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7556 A30A 
     7558 832A 
0037 755A E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     755C 2020 
0038 755E 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7560 26F4 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7562 100D  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7564 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7566 2020 
0048 7568 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     756A 26F4 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 756C C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     756E A010 
     7570 A010 
0053 7572 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0054 7574 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     7576 1000 
0055 7578 1002  14         jmp   task.vdp.copy.sat.write
0056               task.vdp.copy.sat.fb.noruler:
0057 757A 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     757C 0800 
0058                       ;------------------------------------------------------
0059                       ; Dump sprite attribute table
0060                       ;------------------------------------------------------
0061               task.vdp.copy.sat.write:
0062 757E C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7580 2F5A 
0063                       ;------------------------------------------------------
0064                       ; Handle column and row indicators
0065                       ;------------------------------------------------------
0066 7582 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7584 A010 
     7586 A010 
0067                                                   ; Is ruler visible?
0068 7588 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0069               
0070 758A 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     758C FF00 
0071 758E 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     7590 00F0 
0072 7592 C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     7594 2F5E 
0073               
0074 7596 C120  34         mov   @ramsat,tmp0
     7598 2F5A 
0075 759A 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     759C 00FF 
0076 759E 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     75A0 0800 
0077 75A2 C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     75A4 2F62 
0078               
0079 75A6 1005  14         jmp   task.vdp.copy.sat.write2
0080                       ;------------------------------------------------------
0081                       ; Do not show column and row indicators
0082                       ;------------------------------------------------------
0083               task.vdp.copy.sat.hide.indicators:
0084 75A8 04C5  14         clr   tmp1
0085 75AA D805  38         movb  tmp1,@ramsat+7        ; Hide line indicator    <
     75AC 2F61 
0086 75AE D805  38         movb  tmp1,@ramsat+11       ; Hide column indicator  v
     75B0 2F65 
0087                       ;------------------------------------------------------
0088                       ; Dump to VDP
0089                       ;------------------------------------------------------
0090               task.vdp.copy.sat.write2:
0091 75B2 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75B4 248A 
0092 75B6 2180                   data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
     75B8 2F5A 
     75BA 000E 
0093                                                   ; | i  tmp1 = ROM/RAM source
0094                                                   ; / i  tmp2 = Number of bytes to write
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               task.vdp.copy.sat.exit:
0099 75BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 75BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 75C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 75C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 75C4 0460  28         b     @slotok               ; Exit task
     75C6 2DCA 
**** **** ****     > stevie_b1.asm.1390892
0150                       copy  "task.vdp.cursor.f18a.asm"   ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 75C8 0649  14         dect  stack
0009 75CA C64B  30         mov   r11,*stack            ; Save return address
0010 75CC 0649  14         dect  stack
0011 75CE C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 75D0 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     75D2 A112 
0016 75D4 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 75D6 04C4  14         clr   tmp0
0021 75D8 D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     75DA 2F5D 
0022 75DC 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 75DE C820  54         mov   @tv.curshape,@ramsat+2
     75E0 A014 
     75E2 2F5C 
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 75E4 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75E6 248A 
0035 75E8 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     75EA 2F5A 
     75EC 0004 
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 75EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 75F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 75F2 0460  28         b     @slotok               ; Exit task
     75F4 2DCA 
**** **** ****     > stevie_b1.asm.1390892
0151               
0157               
0158                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 75F6 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     75F8 A024 
0010 75FA 1301  14         jeq   task.oneshot.exit
0011               
0012 75FC 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 75FE 0460  28         b     @slotok                ; Exit task
     7600 2DCA 
**** **** ****     > stevie_b1.asm.1390892
0159                       ;-----------------------------------------------------------------------
0160                       ; Screen pane utilities
0161                       ;-----------------------------------------------------------------------
0162                       copy  "pane.utils.asm"             ; Pane utility functions
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
0003               
0004               ***************************************************************
0005               * pane.clearmsg.task.callback
0006               * Remove message
0007               ***************************************************************
0008               * Called from one-shot task
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ********|*****|*********************|**************************
0019               pane.clearmsg.task.callback:
0020 7602 0649  14         dect  stack
0021 7604 C64B  30         mov   r11,*stack            ; Push return address
0022 7606 0649  14         dect  stack
0023 7608 C660  46         mov   @wyx,*stack           ; Push cursor position
     760A 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 760C 06A0  32         bl    @hchar
     760E 27C8 
0028 7610 0034                   byte 0,52,32,18
     7612 2012 
0029 7614 FFFF                   data EOL              ; Clear message
0030               
0031 7616 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7618 A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 761A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     761C 832A 
0037 761E C2F9  30         mov   *stack+,r11           ; Pop R11
0038 7620 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.1390892
0163                       copy  "pane.utils.hint.asm"        ; Show hint in pane
**** **** ****     > pane.utils.hint.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Show hint message in pane
0003               
0004               ***************************************************************
0005               * pane.show_hintx
0006               * Show hint message
0007               ***************************************************************
0008               * bl  @pane.show_hintx
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Cursor YX position
0012               * @parm2 = Pointer to Length-prefixed string
0013               *--------------------------------------------------------------
0014               * OUTPUT test
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               pane.show_hintx:
0021 7622 0649  14         dect  stack
0022 7624 C64B  30         mov   r11,*stack            ; Save return address
0023 7626 0649  14         dect  stack
0024 7628 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 762A 0649  14         dect  stack
0026 762C C645  30         mov   tmp1,*stack           ; Push tmp1
0027 762E 0649  14         dect  stack
0028 7630 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7632 0649  14         dect  stack
0030 7634 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 7636 C820  54         mov   @parm1,@wyx           ; Set cursor
     7638 2F20 
     763A 832A 
0035 763C C160  34         mov   @parm2,tmp1           ; Get string to display
     763E 2F22 
0036 7640 06A0  32         bl    @xutst0               ; Display string
     7642 2424 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 7644 C120  34         mov   @parm2,tmp0
     7646 2F22 
0041 7648 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 764A 0984  56         srl   tmp0,8                ; Right justify
0043 764C C184  18         mov   tmp0,tmp2
0044 764E C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 7650 0506  16         neg   tmp2
0046 7652 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7654 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 7656 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7658 2F20 
0051 765A A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 765C C804  38         mov   tmp0,@wyx             ; / Set cursor
     765E 832A 
0053               
0054 7660 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7662 23FE 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 7664 0205  20         li    tmp1,32               ; Byte to fill
     7666 0020 
0059               
0060 7668 06A0  32         bl    @xfilv                ; Clear line
     766A 2298 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 766C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 766E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 7670 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 7672 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 7674 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7676 045B  20         b     *r11                  ; Return to caller
0074               
0075               
0076               
0077               ***************************************************************
0078               * pane.show_hint
0079               * Show hint message (data parameter version)
0080               ***************************************************************
0081               * bl  @pane.show_hint
0082               *     data p1,p2
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * p1 = Cursor YX position
0086               * p2 = Pointer to Length-prefixed string
0087               *--------------------------------------------------------------
0088               * OUTPUT
0089               * none
0090               *--------------------------------------------------------------
0091               * Register usage
0092               * none
0093               ********|*****|*********************|**************************
0094               pane.show_hint:
0095 7678 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     767A 2F20 
0096 767C C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     767E 2F22 
0097 7680 0649  14         dect  stack
0098 7682 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 7684 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7686 7622 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 7688 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 768A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0164                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
**** **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               ***************************************************************
0005               * pane.action.colorschene.cycle
0006               * Cycle through available color scheme
0007               ***************************************************************
0008               * bl  @pane.action.colorscheme.cycle
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.action.colorscheme.cycle:
0017 768C 0649  14         dect  stack
0018 768E C64B  30         mov   r11,*stack            ; Push return address
0019 7690 0649  14         dect  stack
0020 7692 C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 7694 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7696 A012 
0023 7698 0284  22         ci    tmp0,tv.colorscheme.entries
     769A 000A 
0024                                                   ; Last entry reached?
0025 769C 1103  14         jlt   !
0026 769E 0204  20         li    tmp0,1                ; Reset color scheme index
     76A0 0001 
0027 76A2 1001  14         jmp   pane.action.colorscheme.switch
0028 76A4 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 76A6 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     76A8 A012 
0034               
0035 76AA 06A0  32         bl    @pane.action.colorscheme.load
     76AC 76EA 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 76AE C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     76B0 832A 
     76B2 833C 
0041               
0042 76B4 06A0  32         bl    @putnum
     76B6 2A58 
0043 76B8 003E                   byte 0,62
0044 76BA A012                   data tv.colorscheme,rambuf,>3020
     76BC 2F6A 
     76BE 3020 
0045               
0046 76C0 06A0  32         bl    @putat
     76C2 2446 
0047 76C4 0034                   byte 0,52
0048 76C6 397C                   data txt.colorscheme  ; Show color palette message
0049               
0050 76C8 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     76CA 833C 
     76CC 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 76CE 0204  20         li    tmp0,12000
     76D0 2EE0 
0055 76D2 0604  14 !       dec   tmp0
0056 76D4 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 76D6 0204  20         li    tmp0,pane.clearmsg.task.callback
     76D8 7602 
0061 76DA C804  38         mov   tmp0,@tv.task.oneshot
     76DC A024 
0062               
0063 76DE 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     76E0 2E34 
0064 76E2 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 76E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 76E6 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 76E8 045B  20         b     *r11                  ; Return to caller
0072               
0073               
0074               
0075               ***************************************************************
0076               * pane.action.colorscheme.load
0077               * Load color scheme
0078               ***************************************************************
0079               * bl  @pane.action.colorscheme.load
0080               *--------------------------------------------------------------
0081               * INPUT
0082               * @tv.colorscheme = Index into color scheme table
0083               * @parm1          = Skip screen off if >FFFF
0084               * @parm2          = Skip colorizing marked lines if >FFFF
0085               *--------------------------------------------------------------
0086               * OUTPUT
0087               * none
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0,tmp1,tmp2,tmp3,tmp4
0091               ********|*****|*********************|**************************
0092               pane.action.colorscheme.load:
0093 76EA 0649  14         dect  stack
0094 76EC C64B  30         mov   r11,*stack            ; Save return address
0095 76EE 0649  14         dect  stack
0096 76F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0097 76F2 0649  14         dect  stack
0098 76F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 76F6 0649  14         dect  stack
0100 76F8 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 76FA 0649  14         dect  stack
0102 76FC C647  30         mov   tmp3,*stack           ; Push tmp3
0103 76FE 0649  14         dect  stack
0104 7700 C648  30         mov   tmp4,*stack           ; Push tmp4
0105 7702 0649  14         dect  stack
0106 7704 C660  46         mov   @parm1,*stack         ; Push parm1
     7706 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7708 C120  34         mov   @parm1,tmp0
     770A 2F20 
0111 770C 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     770E FFFF 
0112 7710 1302  14         jeq   !                     ; Yes, so skip screen off
0113 7712 06A0  32         bl    @scroff               ; Turn screen off
     7714 2692 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7716 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7718 A012 
0118 771A 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 771C 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 771E 0224  22         ai    tmp0,tv.colorscheme.table
     7720 33D2 
0122                                                   ; Add base for color scheme data table
0123 7722 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 7724 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7726 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 7728 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 772A 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     772C 00FF 
0130 772E C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7730 A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 7732 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 7734 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7736 FF00 
0136 7738 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 773A C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 773C C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 773E 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 7740 C806  38         mov   tmp2,@tv.busycolor    ; /
     7742 A01C 
0142               
0143 7744 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     7746 00FF 
0144 7748 C805  38         mov   tmp1,@tv.markcolor    ; /
     774A A01A 
0145               
0146 774C C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 774E 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 7750 C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     7752 A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 7754 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 7756 0245  22         andi  tmp1,>000f            ; Only keep P
     7758 000F 
0154 775A 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 775C C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     775E A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 7760 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 7762 0245  22         andi  tmp1,>00f0            ; Only keep O
     7764 00F0 
0161 7766 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 7768 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     776A 2F61 
0163 776C D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     776E 2F65 
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 7770 C147  18         mov   tmp3,tmp1             ; Get work copy
0168 7772 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 7774 0265  22         ori   tmp1,>0700
     7776 0700 
0170 7778 C105  18         mov   tmp1,tmp0
0171 777A 06A0  32         bl    @putvrx               ; Write VDP register
     777C 2338 
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 777E C120  34         mov   @tv.ruler.visible,tmp0
     7780 A010 
0176 7782 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 7784 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7786 18A0 
0178                                                   ; VDP start address (frame buffer area)
0179 7788 0206  20         li    tmp2,(pane.botrow-2)*80
     778A 0870 
0180                                                   ; Number of bytes to fill
0181 778C 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 778E 0204  20         li    tmp0,vdp.fb.toprow.tat
     7790 1850 
0184                                                   ; VDP start address (frame buffer area)
0185 7792 0206  20         li    tmp2,(pane.botrow-1)*80
     7794 08C0 
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 7796 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 7798 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 779A 06A0  32         bl    @xfilv                ; Fill colors
     779C 2298 
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 779E C120  34         mov   @parm2,tmp0
     77A0 2F22 
0199 77A2 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     77A4 FFFF 
0200 77A6 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 77A8 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     77AA A110 
0203 77AC 06A0  32         bl    @fb.colorlines
     77AE 7DF2 
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 77B0 C120  34         mov   @cmdb.visible,tmp0
     77B2 A302 
0209 77B4 130F  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 77B6 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     77B8 1FD0 
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 77BA C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     77BC A020 
0216 77BE 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     77C0 0050 
0217 77C2 06A0  32         bl    @xfilv                ; Fill colors
     77C4 2298 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 77C6 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     77C8 2020 
0225                                                   ; VDP start address (CMDB top line + 1)
0226 77CA C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 77CC 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     77CE 00F0 
0228 77D0 06A0  32         bl    @xfilv                ; Fill colors
     77D2 2298 
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232                       ;-------------------------------------------------------
0233                       ; Dump colors for error line (TAT)
0234                       ;-------------------------------------------------------
0235               pane.action.colorscheme.errpane:
0236 77D4 C120  34         mov   @tv.error.visible,tmp0
     77D6 A028 
0237 77D8 130A  14         jeq   pane.action.colorscheme.statline
0238                                                   ; Skip if error line pane is hidden
0239               
0240 77DA 0205  20         li    tmp1,>00f6            ; White on dark red
     77DC 00F6 
0241 77DE C805  38         mov   tmp1,@parm1           ; Pass color combination
     77E0 2F20 
0242               
0243 77E2 0205  20         li    tmp1,pane.botrow-1    ;
     77E4 001C 
0244 77E6 C805  38         mov   tmp1,@parm2           ; Error line on screen
     77E8 2F22 
0245               
0246 77EA 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77EC 78B4 
0247                                                   ; \ i  @parm1 = Color combination
0248                                                   ; / i  @parm2 = Row on physical screen
0249                       ;-------------------------------------------------------
0250                       ; Dump colors for top line and bottom line (TAT)
0251                       ;-------------------------------------------------------
0252               pane.action.colorscheme.statline:
0253 77EE C160  34         mov   @tv.color,tmp1
     77F0 A018 
0254 77F2 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     77F4 00FF 
0255 77F6 C805  38         mov   tmp1,@parm1           ; Set color combination
     77F8 2F20 
0256               
0257               
0258 77FA 04E0  34         clr   @parm2                ; Top row on screen
     77FC 2F22 
0259 77FE 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7800 78B4 
0260                                                   ; \ i  @parm1 = Color combination
0261                                                   ; / i  @parm2 = Row on physical screen
0262               
0263 7802 0205  20         li    tmp1,pane.botrow
     7804 001D 
0264 7806 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7808 2F22 
0265 780A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     780C 78B4 
0266                                                   ; \ i  @parm1 = Color combination
0267                                                   ; / i  @parm2 = Row on physical screen
0268                       ;-------------------------------------------------------
0269                       ; Dump colors for ruler if visible (TAT)
0270                       ;-------------------------------------------------------
0271 780E C160  34         mov   @tv.ruler.visible,tmp1
     7810 A010 
0272 7812 1307  14         jeq   pane.action.colorscheme.cursorcolor
0273               
0274 7814 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     7816 7DE0 
0275 7818 06A0  32         bl    @cpym2v
     781A 248A 
0276 781C 1850                   data vdp.fb.toprow.tat
0277 781E A16E                   data fb.ruler.tat
0278 7820 0050                   data 80               ; Show ruler colors
0279                       ;-------------------------------------------------------
0280                       ; Dump cursor FG color to sprite table (SAT)
0281                       ;-------------------------------------------------------
0282               pane.action.colorscheme.cursorcolor:
0283 7822 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7824 A016 
0284               
0285 7826 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7828 A022 
0286 782A 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     782C 0000 
0287 782E 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0288                                                   ; Yes, set cursor color
0289               
0290               pane.action.colorscheme.cursorcolor.cmdb:
0291 7830 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     7832 00F0 
0292 7834 0A48  56         sla   tmp4,4                ; Move to MSB
0293 7836 1003  14         jmp   !
0294               
0295               pane.action.colorscheme.cursorcolor.fb:
0296 7838 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     783A 000F 
0297 783C 0A88  56         sla   tmp4,8                ; Move to MSB
0298               
0299 783E D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7840 2F5D 
0300 7842 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7844 A015 
0301                       ;-------------------------------------------------------
0302                       ; Exit
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.load.exit:
0305 7846 06A0  32         bl    @scron                ; Turn screen on
     7848 269A 
0306 784A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     784C 2F20 
0307 784E C239  30         mov   *stack+,tmp4          ; Pop tmp4
0308 7850 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0309 7852 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0310 7854 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0311 7856 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0312 7858 C2F9  30         mov   *stack+,r11           ; Pop R11
0313 785A 045B  20         b     *r11                  ; Return to caller
0314               
0315               
0316               
0317               ***************************************************************
0318               * pane.action.colorscheme.statline
0319               * Set color combination for bottom status line
0320               ***************************************************************
0321               * bl @pane.action.colorscheme.statlines
0322               *--------------------------------------------------------------
0323               * INPUT
0324               * @parm1 = Color combination to set
0325               *--------------------------------------------------------------
0326               * OUTPUT
0327               * none
0328               *--------------------------------------------------------------
0329               * Register usage
0330               * tmp0, tmp1, tmp2
0331               ********|*****|*********************|**************************
0332               pane.action.colorscheme.statlines:
0333 785C 0649  14         dect  stack
0334 785E C64B  30         mov   r11,*stack            ; Save return address
0335 7860 0649  14         dect  stack
0336 7862 C644  30         mov   tmp0,*stack           ; Push tmp0
0337                       ;------------------------------------------------------
0338                       ; Bottom line
0339                       ;------------------------------------------------------
0340 7864 0204  20         li    tmp0,pane.botrow
     7866 001D 
0341 7868 C804  38         mov   tmp0,@parm2           ; Last row on screen
     786A 2F22 
0342 786C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     786E 78B4 
0343                                                   ; \ i  @parm1 = Color combination
0344                                                   ; / i  @parm2 = Row on physical screen
0345                       ;------------------------------------------------------
0346                       ; Exit
0347                       ;------------------------------------------------------
0348               pane.action.colorscheme.statlines.exit:
0349 7870 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0350 7872 C2F9  30         mov   *stack+,r11           ; Pop R11
0351 7874 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0165                       copy  "pane.cursor.asm"            ; Cursor utility functions
**** **** ****     > pane.cursor.asm
0001               * FILE......: pane.cursor.asm
0002               * Purpose...: Cursor utility functions for panes
0003               
0004               ***************************************************************
0005               * pane.cursor.hide
0006               * Hide cursor
0007               ***************************************************************
0008               * bl  @pane.cursor.hide
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ********|*****|*********************|**************************
0019               pane.cursor.hide:
0020 7876 0649  14         dect  stack
0021 7878 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 787A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     787C 2292 
0026 787E 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     7880 0000 
     7882 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 7884 06A0  32         bl    @clslot
     7886 2E26 
0031 7888 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 788A 06A0  32         bl    @clslot
     788C 2E26 
0034 788E 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 7890 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 7892 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               ***************************************************************
0045               * pane.cursor.blink
0046               * Blink cursor
0047               ***************************************************************
0048               * bl  @pane.cursor.blink
0049               *--------------------------------------------------------------
0050               * INPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * Register usage
0057               * none
0058               ********|*****|*********************|**************************
0059               pane.cursor.blink:
0060 7894 0649  14         dect  stack
0061 7896 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7898 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     789A 2292 
0066 789C 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     789E 0000 
     78A0 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 78A2 06A0  32         bl    @mkslot
     78A4 2E08 
0073 78A6 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     78A8 752C 
0074 78AA 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     78AC 75C8 
0075 78AE FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 78B0 C2F9  30         mov   *stack+,r11           ; Pop R11
0090 78B2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0166                       ;-----------------------------------------------------------------------
0167                       ; Screen panes
0168                       ;-----------------------------------------------------------------------
0169                       copy  "colors.line.set.asm"        ; Set color combination for line
**** **** ****     > colors.line.set.asm
0001               * FILE......: colors.line.set
0002               * Purpose...: Set color combination for line
0003               
0004               ***************************************************************
0005               * colors.line.set
0006               * Set color combination for line in VDP TAT
0007               ***************************************************************
0008               * bl  @colors.line.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Foreground / Background color
0012               * @parm2 = Row on physical screen
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               colors.line.set:
0021 78B4 0649  14         dect  stack
0022 78B6 C64B  30         mov   r11,*stack            ; Save return address
0023 78B8 0649  14         dect  stack
0024 78BA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 78BC 0649  14         dect  stack
0026 78BE C645  30         mov   tmp1,*stack           ; Push tmp1
0027 78C0 0649  14         dect  stack
0028 78C2 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 78C4 0649  14         dect  stack
0030 78C6 C660  46         mov   @parm1,*stack         ; Push parm1
     78C8 2F20 
0031 78CA 0649  14         dect  stack
0032 78CC C660  46         mov   @parm2,*stack         ; Push parm2
     78CE 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 78D0 C120  34         mov   @parm2,tmp0           ; Get target line
     78D2 2F22 
0037 78D4 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     78D6 0050 
0038 78D8 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 78DA C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 78DC 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     78DE 1800 
0042 78E0 C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     78E2 2F20 
0043 78E4 0206  20         li    tmp2,80               ; Number of bytes to fill
     78E6 0050 
0044               
0045 78E8 06A0  32         bl    @xfilv                ; Fill colors
     78EA 2298 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 78EC C839  50         mov   *stack+,@parm2        ; Pop @parm2
     78EE 2F22 
0054 78F0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78F2 2F20 
0055 78F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 78F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 78F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 78FA C2F9  30         mov   *stack+,r11           ; Pop R11
0059 78FC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0170                       copy  "pane.cmdb.asm"              ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.1390892
0171                       copy  "pane.cmdb.show.asm"         ; Show command buffer pane
**** **** ****     > pane.cmdb.show.asm
0001               * FILE......: pane.cmdb.show.asm
0002               * Purpose...: Show command buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.show
0006               * Show command buffer pane
0007               ***************************************************************
0008               * bl @pane.cmdb.show
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               pane.cmdb.show:
0022 78FE 0649  14         dect  stack
0023 7900 C64B  30         mov   r11,*stack            ; Save return address
0024 7902 0649  14         dect  stack
0025 7904 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7906 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7908 832A 
     790A A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 790C 0204  20         li    tmp0,pane.botrow
     790E 001D 
0033 7910 6120  34         s     @cmdb.scrrows,tmp0
     7912 A306 
0034 7914 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7916 A11A 
0035               
0036 7918 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 791A C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     791C A30E 
0038               
0039 791E 0224  22         ai    tmp0,>0100
     7920 0100 
0040 7922 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7924 A310 
0041 7926 0584  14         inc   tmp0
0042 7928 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     792A A30A 
0043               
0044 792C 0720  34         seto  @cmdb.visible         ; Show pane
     792E A302 
0045 7930 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7932 A318 
0046               
0047 7934 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7936 0001 
0048 7938 C804  38         mov   tmp0,@tv.pane.focus   ; /
     793A A022 
0049               
0050 793C 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     793E 7B9E 
0051               
0052 7940 0720  34         seto  @parm1                ; Do not turn screen off while
     7942 2F20 
0053                                                   ; reloading color scheme
0054               
0055 7944 06A0  32         bl    @pane.action.colorscheme.load
     7946 76EA 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 7948 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 794A C2F9  30         mov   *stack+,r11           ; Pop r11
0065 794C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0172                       copy  "pane.cmdb.hide.asm"         ; Hide command buffer pane
**** **** ****     > pane.cmdb.hide.asm
0001               * FILE......: pane.cmdb.hide.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.hide
0006               * Hide command buffer pane
0007               ***************************************************************
0008               * bl @pane.cmdb.hide
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Hiding the command buffer automatically passes pane focus
0020               * to frame buffer.
0021               ********|*****|*********************|**************************
0022               pane.cmdb.hide:
0023 794E 0649  14         dect  stack
0024 7950 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 7952 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7954 A11C 
     7956 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 7958 C820  54         mov   @tv.error.visible,@tv.error.visible
     795A A028 
     795C A028 
0033 795E 1302  14         jeq   !
0034 7960 0620  34         dec   @fb.scrrows
     7962 A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 7964 06A0  32 !       bl    @hchar
     7966 27C8 
0039 7968 1C00                   byte pane.botrow-1,0,32,80*2
     796A 20A0 
0040 796C FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Adjust frame buffer size if ruler visible
0043                       ;------------------------------------------------------
0044 796E C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7970 A010 
     7972 A010 
0045 7974 1302  14         jeq   pane.cmdb.hide.rest
0046 7976 0620  34         dec   @fb.scrrows
     7978 A11A 
0047                       ;------------------------------------------------------
0048                       ; Hide command buffer pane (rest)
0049                       ;------------------------------------------------------
0050               pane.cmdb.hide.rest:
0051 797A C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     797C A304 
     797E 832A 
0052 7980 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7982 A302 
0053 7984 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7986 A116 
0054 7988 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     798A A022 
0055                       ;------------------------------------------------------
0056                       ; Reload current color scheme
0057                       ;------------------------------------------------------
0058 798C 0720  34         seto  @parm1                ; Do not turn screen off while
     798E 2F20 
0059                                                   ; reloading color scheme
0060               
0061 7990 06A0  32         bl    @pane.action.colorscheme.load
     7992 76EA 
0062                                                   ; Reload color scheme
0063                                                   ; i  parm1 = Skip screen off if >FFFF
0064                       ;------------------------------------------------------
0065                       ; Show cursor again
0066                       ;------------------------------------------------------
0067 7994 06A0  32         bl    @pane.cursor.blink
     7996 7894 
0068                       ;------------------------------------------------------
0069                       ; Exit
0070                       ;------------------------------------------------------
0071               pane.cmdb.hide.exit:
0072 7998 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 799A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0173                       copy  "pane.cmdb.draw.asm"         ; Draw command buffer pane contents
**** **** ****     > pane.cmdb.draw.asm
0001               * FILE......: pane.cmdb.draw.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.draw
0006               * Draw Stevie Command Buffer in pane
0007               ***************************************************************
0008               * bl  @pane.cmdb.draw
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0, tmp1, tmp2
0015               ********|*****|*********************|**************************
0016               pane.cmdb.draw:
0017 799C 0649  14         dect  stack
0018 799E C64B  30         mov   r11,*stack            ; Save return address
0019 79A0 0649  14         dect  stack
0020 79A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79A4 0649  14         dect  stack
0022 79A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 79A8 0649  14         dect  stack
0024 79AA C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 79AC C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     79AE A31C 
     79B0 2F20 
0029 79B2 0204  20         li    tmp0,80
     79B4 0050 
0030 79B6 C804  38         mov   tmp0,@parm2           ; Set requested length
     79B8 2F22 
0031 79BA 0204  20         li    tmp0,1
     79BC 0001 
0032 79BE C804  38         mov   tmp0,@parm3           ; Set character to fill
     79C0 2F24 
0033 79C2 0204  20         li    tmp0,rambuf
     79C4 2F6A 
0034 79C6 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79C8 2F26 
0035               
0036               
0037 79CA 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79CC 3302 
0038                                                   ; \ i  @parm1 = Pointer to string
0039                                                   ; | i  @parm2 = Requested length
0040                                                   ; | i  @parm3 = Fill character
0041                                                   ; | i  @parm4 = Pointer to buffer with
0042                                                   ; /             output string
0043               
0044 79CE C820  54         mov   @cmdb.yxtop,@wyx      ; \
     79D0 A30E 
     79D2 832A 
0045 79D4 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     79D6 2F30 
0046 79D8 06A0  32         bl    @xutst0               ; /
     79DA 2424 
0047                       ;------------------------------------------------------
0048                       ; Check dialog id
0049                       ;------------------------------------------------------
0050 79DC 04E0  34         clr   @waux1                ; Default is show prompt
     79DE 833C 
0051               
0052 79E0 C120  34         mov   @cmdb.dialog,tmp0
     79E2 A31A 
0053 79E4 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     79E6 0063 
0054 79E8 120E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0055 79EA 0720  34         seto  @waux1                ; /
     79EC 833C 
0056                       ;------------------------------------------------------
0057                       ; Show info message instead of prompt
0058                       ;------------------------------------------------------
0059 79EE C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     79F0 A31E 
0060 79F2 1309  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0061               
0062 79F4 06A0  32         bl    @at
     79F6 26D2 
0063 79F8 1A00                   byte pane.botrow-3,0  ; Position cursor
0064               
0065 79FA D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     79FC A326 
0066 79FE D195  26         movb  *tmp1,tmp2            ; |
0067 7A00 0986  56         srl   tmp2,8                ; |
0068 7A02 06A0  32         bl    @xutst0               ; /  Display info message
     7A04 2424 
0069                       ;------------------------------------------------------
0070                       ; Clear lines after prompt in command buffer
0071                       ;------------------------------------------------------
0072               pane.cmdb.draw.clear:
0073 7A06 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7A08 A326 
0074 7A0A 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0075 7A0C A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7A0E A310 
0076 7A10 C804  38         mov   tmp0,@wyx             ; /
     7A12 832A 
0077               
0078 7A14 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7A16 23FE 
0079                                                   ; \ i  @wyx = Cursor position
0080                                                   ; / o  tmp0 = VDP target address
0081               
0082 7A18 0205  20         li    tmp1,32
     7A1A 0020 
0083               
0084 7A1C C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7A1E A326 
0085 7A20 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0086 7A22 0506  16         neg   tmp2                  ; | Based on command & prompt length
0087 7A24 0226  22         ai    tmp2,2*80 - 1         ; /
     7A26 009F 
0088               
0089 7A28 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7A2A 2298 
0090                                                   ; | i  tmp0 = VDP target address
0091                                                   ; | i  tmp1 = Byte to fill
0092                                                   ; / i  tmp2 = Number of bytes to fill
0093                       ;------------------------------------------------------
0094                       ; Display pane hint in command buffer
0095                       ;------------------------------------------------------
0096               pane.cmdb.draw.hint:
0097 7A2C 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A2E 001C 
0098 7A30 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0099 7A32 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A34 2F20 
0100 7A36 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A38 A320 
     7A3A 2F22 
0101               
0102 7A3C 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A3E 7622 
0103                                                   ; \ i  parm1 = Pointer to string with hint
0104                                                   ; / i  parm2 = YX position
0105                       ;------------------------------------------------------
0106                       ; Display keys in status line
0107                       ;------------------------------------------------------
0108 7A40 0204  20         li    tmp0,pane.botrow      ; \
     7A42 001D 
0109 7A44 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0110 7A46 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A48 2F20 
0111 7A4A C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A4C A322 
     7A4E 2F22 
0112               
0113 7A50 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A52 7622 
0114                                                   ; \ i  parm1 = Pointer to string with hint
0115                                                   ; / i  parm2 = YX position
0116                       ;------------------------------------------------------
0117                       ; ALPHA-Lock key down?
0118                       ;------------------------------------------------------
0119 7A54 20A0  38         coc   @wbit10,config
     7A56 200C 
0120 7A58 1306  14         jeq   pane.cmdb.draw.alpha.down
0121                       ;------------------------------------------------------
0122                       ; AlPHA-Lock is up
0123                       ;------------------------------------------------------
0124 7A5A 06A0  32         bl    @hchar
     7A5C 27C8 
0125 7A5E 1D4E                   byte pane.botrow,78,32,2
     7A60 2002 
0126 7A62 FFFF                   data eol
0127               
0128 7A64 1004  14         jmp   pane.cmdb.draw.promptcmd
0129                       ;------------------------------------------------------
0130                       ; AlPHA-Lock is down
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.alpha.down:
0133 7A66 06A0  32         bl    @putat
     7A68 2446 
0134 7A6A 1D4E                   byte   pane.botrow,78
0135 7A6C 35DE                   data   txt.alpha.down
0136                       ;------------------------------------------------------
0137                       ; Command buffer content
0138                       ;------------------------------------------------------
0139               pane.cmdb.draw.promptcmd:
0140 7A6E C120  34         mov   @waux1,tmp0           ; Flag set?
     7A70 833C 
0141 7A72 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0142 7A74 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7A76 73B8 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               pane.cmdb.draw.exit:
0147 7A78 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0148 7A7A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0149 7A7C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 7A7E C2F9  30         mov   *stack+,r11           ; Pop r11
0151 7A80 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1390892
0174               
0175                       copy  "pane.topline.asm"           ; Top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: Pane "status top line"
0003               
0004               ***************************************************************
0005               * pane.topline
0006               * Draw top line
0007               ***************************************************************
0008               * bl  @pane.topline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.topline:
0017 7A82 0649  14         dect  stack
0018 7A84 C64B  30         mov   r11,*stack            ; Save return address
0019 7A86 0649  14         dect  stack
0020 7A88 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7A8A 0649  14         dect  stack
0022 7A8C C660  46         mov   @wyx,*stack           ; Push cursor position
     7A8E 832A 
0023                       ;------------------------------------------------------
0024                       ; Show if text was changed in editor buffer
0025                       ;------------------------------------------------------
0026 7A90 C120  34         mov   @edb.dirty,tmp0
     7A92 A206 
0027 7A94 1305  14         jeq   pane.topline.blank
0028                       ;------------------------------------------------------
0029                       ; Show "*"
0030                       ;------------------------------------------------------
0031 7A96 06A0  32         bl    @putat
     7A98 2446 
0032 7A9A 0000                   byte 0,0              ; y=0, x=0
0033 7A9C 34A0                   data txt.star
0034 7A9E 1004  14         jmp   pane.topline.file
0035                       ;------------------------------------------------------
0036                       ; Show " "
0037                       ;------------------------------------------------------
0038               pane.topline.blank:
0039 7AA0 06A0  32         bl    @putat
     7AA2 2446 
0040 7AA4 0000                   byte 0,0              ; y=0, x=0
0041 7AA6 35E4                   data txt.ws1          ; Single white space
0042                       ;------------------------------------------------------
0043                       ; Show current file
0044                       ;------------------------------------------------------
0045               pane.topline.file:
0046 7AA8 06A0  32         bl    @at
     7AAA 26D2 
0047 7AAC 0002                   byte 0,2              ; y=0, x=2
0048               
0049 7AAE C820  54         mov   @edb.filename.ptr,@parm1
     7AB0 A212 
     7AB2 2F20 
0050                                                   ; Get string to display
0051 7AB4 0204  20         li    tmp0,47
     7AB6 002F 
0052 7AB8 C804  38         mov   tmp0,@parm2           ; Set requested length
     7ABA 2F22 
0053 7ABC 0204  20         li    tmp0,32
     7ABE 0020 
0054 7AC0 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7AC2 2F24 
0055 7AC4 0204  20         li    tmp0,rambuf
     7AC6 2F6A 
0056 7AC8 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7ACA 2F26 
0057               
0058               
0059 7ACC 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7ACE 3302 
0060                                                   ; \ i  @parm1 = Pointer to string
0061                                                   ; | i  @parm2 = Requested length
0062                                                   ; | i  @parm3 = Fill characgter
0063                                                   ; | i  @parm4 = Pointer to buffer with
0064                                                   ; /             output string
0065               
0066 7AD0 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7AD2 2F30 
0067 7AD4 06A0  32         bl    @xutst0               ; /
     7AD6 2424 
0068                       ;------------------------------------------------------
0069                       ; Show M1 marker
0070                       ;------------------------------------------------------
0071 7AD8 C120  34         mov   @edb.block.m1,tmp0    ; \
     7ADA A20C 
0072 7ADC 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0073 7ADE 1326  14         jeq   pane.topline.exit     ; /
0074               
0075 7AE0 06A0  32         bl    @putat
     7AE2 2446 
0076 7AE4 0034                   byte 0,52
0077 7AE6 3536                   data txt.m1           ; Show M1 marker message
0078               
0079 7AE8 C820  54         mov   @edb.block.m1,@parm1
     7AEA A20C 
     7AEC 2F20 
0080 7AEE 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7AF0 32D6 
0081                                                   ; \ i @parm1           = uint16
0082                                                   ; / o @unpacked.string = Output string
0083               
0084 7AF2 0204  20         li    tmp0,>0500
     7AF4 0500 
0085 7AF6 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7AF8 2F44 
0086               
0087 7AFA 06A0  32         bl    @putat
     7AFC 2446 
0088 7AFE 0037                   byte 0,55
0089 7B00 2F44                   data unpacked.string  ; Show M1 value
0090                       ;------------------------------------------------------
0091                       ; Show M2 marker
0092                       ;------------------------------------------------------
0093 7B02 C120  34         mov   @edb.block.m2,tmp0    ; \
     7B04 A20E 
0094 7B06 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0095 7B08 1311  14         jeq   pane.topline.exit     ; /
0096               
0097 7B0A 06A0  32         bl    @putat
     7B0C 2446 
0098 7B0E 003E                   byte 0,62
0099 7B10 353A                   data txt.m2           ; Show M2 marker message
0100               
0101 7B12 C820  54         mov   @edb.block.m2,@parm1
     7B14 A20E 
     7B16 2F20 
0102 7B18 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B1A 32D6 
0103                                                   ; \ i @parm1           = uint16
0104                                                   ; / o @unpacked.string = Output string
0105               
0106 7B1C 0204  20         li    tmp0,>0500
     7B1E 0500 
0107 7B20 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B22 2F44 
0108               
0109 7B24 06A0  32         bl    @putat
     7B26 2446 
0110 7B28 0041                   byte 0,65
0111 7B2A 2F44                   data unpacked.string  ; Show M2 value
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               pane.topline.exit:
0116 7B2C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B2E 832A 
0117 7B30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 7B32 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 7B34 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1390892
0176                       copy  "pane.errline.asm"           ; Error line
**** **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Stevie Editor - Error line pane
0003               
0004               ***************************************************************
0005               * pane.errline.show
0006               * Show command buffer pane
0007               ***************************************************************
0008               * bl @pane.errline.show
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               pane.errline.show:
0022 7B36 0649  14         dect  stack
0023 7B38 C64B  30         mov   r11,*stack            ; Save return address
0024 7B3A 0649  14         dect  stack
0025 7B3C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7B3E 0649  14         dect  stack
0027 7B40 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7B42 0205  20         li    tmp1,>00f6            ; White on dark red
     7B44 00F6 
0030 7B46 C805  38         mov   tmp1,@parm1
     7B48 2F20 
0031               
0032 7B4A 0205  20         li    tmp1,pane.botrow-1    ;
     7B4C 001C 
0033 7B4E C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B50 2F22 
0034               
0035 7B52 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B54 78B4 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7B56 0204  20         li    tmp0,tv.error.msg
     7B58 A02A 
0043 7B5A C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7B5C 2F20 
0044               
0045 7B5E 0204  20         li    tmp0,80
     7B60 0050 
0046 7B62 C804  38         mov   tmp0,@parm2           ; Set requested length
     7B64 2F22 
0047               
0048 7B66 0204  20         li    tmp0,32
     7B68 0020 
0049 7B6A C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B6C 2F24 
0050               
0051 7B6E 0204  20         li    tmp0,rambuf
     7B70 2F6A 
0052 7B72 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B74 2F26 
0053               
0054 7B76 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B78 3302 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7B7A 06A0  32         bl    @at
     7B7C 26D2 
0064 7B7E 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7B80 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7B82 2F30 
0067 7B84 06A0  32         bl    @xutst0               ; /
     7B86 2424 
0068               
0069 7B88 C120  34         mov   @fb.scrrows.max,tmp0
     7B8A A11C 
0070 7B8C 0604  14         dec   tmp0
0071 7B8E C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7B90 A11A 
0072               
0073 7B92 0720  34         seto  @tv.error.visible     ; Error line is visible
     7B94 A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7B96 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7B98 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7B9A C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7B9C 045B  20         b     *r11                  ; Return to caller
0082               
0083               
0084               
0085               ***************************************************************
0086               * pane.errline.hide
0087               * Hide error line
0088               ***************************************************************
0089               * bl @pane.errline.hide
0090               *--------------------------------------------------------------
0091               * INPUT
0092               * none
0093               *--------------------------------------------------------------
0094               * OUTPUT
0095               * none
0096               *--------------------------------------------------------------
0097               * Register usage
0098               * none
0099               *--------------------------------------------------------------
0100               * Hiding the error line passes pane focus to frame buffer.
0101               ********|*****|*********************|**************************
0102               pane.errline.hide:
0103 7B9E 0649  14         dect  stack
0104 7BA0 C64B  30         mov   r11,*stack            ; Save return address
0105 7BA2 0649  14         dect  stack
0106 7BA4 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7BA6 06A0  32         bl    @errline.init         ; Clear error line
     7BA8 326A 
0111               
0112 7BAA C120  34         mov   @tv.color,tmp0        ; Get colors
     7BAC A018 
0113 7BAE 0984  56         srl   tmp0,8                ; Right aligns
0114 7BB0 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7BB2 2F20 
0115               
0116               
0117 7BB4 0205  20         li    tmp1,pane.botrow-1    ;
     7BB6 001C 
0118 7BB8 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BBA 2F22 
0119               
0120 7BBC 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BBE 78B4 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7BC0 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7BC2 A028 
0125 7BC4 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7BC6 A11C 
     7BC8 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7BCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7BCC C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7BCE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0177                       copy  "pane.botline.asm"           ; Bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Pane "status bottom line"
0003               
0004               ***************************************************************
0005               * pane.botline
0006               * Draw Stevie bottom line
0007               ***************************************************************
0008               * bl  @pane.botline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.botline:
0017 7BD0 0649  14         dect  stack
0018 7BD2 C64B  30         mov   r11,*stack            ; Save return address
0019 7BD4 0649  14         dect  stack
0020 7BD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7BD8 0649  14         dect  stack
0022 7BDA C660  46         mov   @wyx,*stack           ; Push cursor position
     7BDC 832A 
0023               
0024                       ;------------------------------------------------------
0025                       ; Show block shortcuts if set
0026                       ;------------------------------------------------------
0027 7BDE C120  34         mov   @edb.block.m2,tmp0    ; \
     7BE0 A20E 
0028 7BE2 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0029                                                   ; /
0030 7BE4 1305  14         jeq   pane.botline.show_keys
0031               
0032 7BE6 06A0  32         bl    @putat
     7BE8 2446 
0033 7BEA 1D00                   byte pane.botrow,0
0034 7BEC 355A                   data txt.keys.block   ; Show block shortcuts
0035               
0036 7BEE 1004  14         jmp   pane.botline.show_mode
0037                       ;------------------------------------------------------
0038                       ; Show default message
0039                       ;------------------------------------------------------
0040               pane.botline.show_keys:
0041 7BF0 06A0  32         bl    @putat
     7BF2 2446 
0042 7BF4 1D00                   byte pane.botrow,0
0043 7BF6 353E                   data txt.keys.default ; Show default shortcuts
0044                       ;------------------------------------------------------
0045                       ; Show text editing mode
0046                       ;------------------------------------------------------
0047               pane.botline.show_mode:
0048 7BF8 C120  34         mov   @edb.insmode,tmp0
     7BFA A20A 
0049 7BFC 1605  14         jne   pane.botline.show_mode.insert
0050                       ;------------------------------------------------------
0051                       ; Overwrite mode
0052                       ;------------------------------------------------------
0053 7BFE 06A0  32         bl    @putat
     7C00 2446 
0054 7C02 1D37                   byte  pane.botrow,55
0055 7C04 3498                   data  txt.ovrwrite
0056 7C06 1004  14         jmp   pane.botline.show_linecol
0057                       ;------------------------------------------------------
0058                       ; Insert mode
0059                       ;------------------------------------------------------
0060               pane.botline.show_mode.insert:
0061 7C08 06A0  32         bl    @putat
     7C0A 2446 
0062 7C0C 1D37                   byte  pane.botrow,55
0063 7C0E 349C                   data  txt.insert
0064                       ;------------------------------------------------------
0065                       ; Show "line,column"
0066                       ;------------------------------------------------------
0067               pane.botline.show_linecol:
0068 7C10 C820  54         mov   @fb.row,@parm1
     7C12 A106 
     7C14 2F20 
0069 7C16 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C18 6A5C 
0070                                                   ; \ i @fb.topline = Top line in frame buffer
0071                                                   ; | i @parm1      = Row in frame buffer
0072                                                   ; / o @outparm1   = Matching line in EB
0073               
0074 7C1A 05A0  34         inc   @outparm1             ; Add base 1
     7C1C 2F30 
0075                       ;------------------------------------------------------
0076                       ; Show line
0077                       ;------------------------------------------------------
0078 7C1E 06A0  32         bl    @putnum
     7C20 2A58 
0079 7C22 1D3B                   byte  pane.botrow,59  ; YX
0080 7C24 2F30                   data  outparm1,rambuf
     7C26 2F6A 
0081 7C28 3020                   byte  48              ; ASCII offset
0082                             byte  32              ; Padding character
0083                       ;------------------------------------------------------
0084                       ; Show comma
0085                       ;------------------------------------------------------
0086 7C2A 06A0  32         bl    @putat
     7C2C 2446 
0087 7C2E 1D40                   byte  pane.botrow,64
0088 7C30 3490                   data  txt.delim
0089                       ;------------------------------------------------------
0090                       ; Show column
0091                       ;------------------------------------------------------
0092 7C32 06A0  32         bl    @film
     7C34 223A 
0093 7C36 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7C38 0020 
     7C3A 000C 
0094               
0095 7C3C C820  54         mov   @fb.column,@waux1
     7C3E A10C 
     7C40 833C 
0096 7C42 05A0  34         inc   @waux1                ; Offset 1
     7C44 833C 
0097               
0098 7C46 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C48 29DA 
0099 7C4A 833C                   data  waux1,rambuf
     7C4C 2F6A 
0100 7C4E 3020                   byte  48              ; ASCII offset
0101                             byte  32              ; Fill character
0102               
0103 7C50 06A0  32         bl    @trimnum              ; Trim number to the left
     7C52 2A32 
0104 7C54 2F6A                   data  rambuf,rambuf+5,32
     7C56 2F6F 
     7C58 0020 
0105               
0106 7C5A 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7C5C 0600 
0107 7C5E D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7C60 2F6F 
0108               
0109                       ;------------------------------------------------------
0110                       ; Decide if row length is to be shown
0111                       ;------------------------------------------------------
0112 7C62 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7C64 A10C 
0113 7C66 0584  14         inc   tmp0                  ; /
0114 7C68 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7C6A A108 
0115 7C6C 1101  14         jlt   pane.botline.show_linecol.linelen
0116 7C6E 102B  14         jmp   pane.botline.show_linecol.colstring
0117                                                   ; Yes, skip showing row length
0118                       ;------------------------------------------------------
0119                       ; Add ',' delimiter and length of line to string
0120                       ;------------------------------------------------------
0121               pane.botline.show_linecol.linelen:
0122 7C70 C120  34         mov   @fb.column,tmp0       ; \
     7C72 A10C 
0123 7C74 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7C76 2F71 
0124 7C78 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7C7A 0009 
0125 7C7C 1101  14         jlt   !                     ; | column.
0126 7C7E 0585  14         inc   tmp1                  ; /
0127               
0128 7C80 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7C82 2D00 
0129 7C84 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0130               
0131 7C86 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7C88 833C 
0132               
0133 7C8A 06A0  32         bl    @mknum
     7C8C 29DA 
0134 7C8E A108                   data  fb.row.length,rambuf
     7C90 2F6A 
0135 7C92 3020                   byte  48              ; ASCII offset
0136                             byte  32              ; Padding character
0137               
0138 7C94 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7C96 833C 
0139               
0140 7C98 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7C9A A108 
0141 7C9C 0284  22         ci    tmp0,10               ; /
     7C9E 000A 
0142 7CA0 110B  14         jlt   pane.botline.show_line.1digit
0143                       ;------------------------------------------------------
0144                       ; Assert
0145                       ;------------------------------------------------------
0146 7CA2 0284  22         ci    tmp0,80
     7CA4 0050 
0147 7CA6 1204  14         jle   pane.botline.show_line.2digits
0148                       ;------------------------------------------------------
0149                       ; Asserts failed
0150                       ;------------------------------------------------------
0151 7CA8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7CAA FFCE 
0152 7CAC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7CAE 2026 
0153                       ;------------------------------------------------------
0154                       ; Show length of line (2 digits)
0155                       ;------------------------------------------------------
0156               pane.botline.show_line.2digits:
0157 7CB0 0204  20         li    tmp0,rambuf+3
     7CB2 2F6D 
0158 7CB4 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0159 7CB6 1002  14         jmp   pane.botline.show_line.rest
0160                       ;------------------------------------------------------
0161                       ; Show length of line (1 digits)
0162                       ;------------------------------------------------------
0163               pane.botline.show_line.1digit:
0164 7CB8 0204  20         li    tmp0,rambuf+4
     7CBA 2F6E 
0165               pane.botline.show_line.rest:
0166 7CBC DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0167 7CBE DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CC0 2F6A 
0168 7CC2 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CC4 2F6A 
0169                       ;------------------------------------------------------
0170                       ; Show column string
0171                       ;------------------------------------------------------
0172               pane.botline.show_linecol.colstring:
0173 7CC6 06A0  32         bl    @putat
     7CC8 2446 
0174 7CCA 1D41                   byte pane.botrow,65
0175 7CCC 2F6F                   data rambuf+5         ; Show string
0176                       ;------------------------------------------------------
0177                       ; Show lines in buffer unless on last line in file
0178                       ;------------------------------------------------------
0179 7CCE C820  54         mov   @fb.row,@parm1
     7CD0 A106 
     7CD2 2F20 
0180 7CD4 06A0  32         bl    @fb.row2line
     7CD6 6A5C 
0181 7CD8 8820  54         c     @edb.lines,@outparm1
     7CDA A204 
     7CDC 2F30 
0182 7CDE 1605  14         jne   pane.botline.show_lines_in_buffer
0183               
0184 7CE0 06A0  32         bl    @putat
     7CE2 2446 
0185 7CE4 1D48                   byte pane.botrow,72
0186 7CE6 3492                   data txt.bottom
0187               
0188 7CE8 1009  14         jmp   pane.botline.exit
0189                       ;------------------------------------------------------
0190                       ; Show lines in buffer
0191                       ;------------------------------------------------------
0192               pane.botline.show_lines_in_buffer:
0193 7CEA C820  54         mov   @edb.lines,@waux1
     7CEC A204 
     7CEE 833C 
0194               
0195 7CF0 06A0  32         bl    @putnum
     7CF2 2A58 
0196 7CF4 1D48                   byte pane.botrow,72   ; YX
0197 7CF6 833C                   data waux1,rambuf
     7CF8 2F6A 
0198 7CFA 3020                   byte 48
0199                             byte 32
0200                       ;------------------------------------------------------
0201                       ; Exit
0202                       ;------------------------------------------------------
0203               pane.botline.exit:
0204 7CFC C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7CFE 832A 
0205 7D00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0206 7D02 C2F9  30         mov   *stack+,r11           ; Pop r11
0207 7D04 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1390892
0178                       ;-----------------------------------------------------------------------
0179                       ; Stubs using trampoline
0180                       ;-----------------------------------------------------------------------
0181                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "vdp.patterns.dump"
0007               * bank0 vec.1
0008               ********|*****|*********************|**************************
0009               vdp.patterns.dump:
0010 7D06 0649  14         dect  stack
0011 7D08 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7D0A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D0C 3008 
0016 7D0E 6000                   data bank0.rom        ; | i  p0 = bank address
0017 7D10 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0018 7D12 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7D14 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7D16 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7D18 0649  14         dect  stack
0032 7D1A C64B  30         mov   r11,*stack            ; Save return address
0033 7D1C 0649  14         dect  stack
0034 7D1E C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7D20 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D22 3008 
0039 7D24 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7D26 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0041 7D28 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7D2A C120  34         mov   @outparm1,tmp0
     7D2C 2F30 
0046 7D2E 1304  14         jeq   fm.loadfile.exit
0047               
0048 7D30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7D32 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7D34 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D36 7DAA 
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7D38 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7D3A C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7D3C 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7D3E 0649  14         dect  stack
0066 7D40 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7D42 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D44 3008 
0071 7D46 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7D48 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0073 7D4A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7D4C C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7D4E 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7D50 0649  14         dect  stack
0087 7D52 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7D54 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D56 3008 
0092 7D58 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7D5A 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0094 7D5C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7D5E C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7D60 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               **************************************************************
0103               * Stub for "fm.fastmode"
0104               * bank2 vec.4
0105               ********|*****|*********************|**************************
0106               fm.fastmode:
0107 7D62 0649  14         dect  stack
0108 7D64 C64B  30         mov   r11,*stack            ; Save return address
0109                       ;------------------------------------------------------
0110                       ; Call function in bank 2
0111                       ;------------------------------------------------------
0112 7D66 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D68 3008 
0113 7D6A 6004                   data bank2.rom        ; | i  p0 = bank address
0114 7D6C 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0115 7D6E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119 7D70 C2F9  30         mov   *stack+,r11           ; Pop r11
0120 7D72 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * Stub for "About dialog"
0128               * bank3 vec.1
0129               ********|*****|*********************|**************************
0130               edkey.action.about:
0131 7D74 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D76 7876 
0132                       ;------------------------------------------------------
0133                       ; Show dialog
0134                       ;------------------------------------------------------
0135 7D78 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D7A 3008 
0136 7D7C 6006                   data bank3.rom        ; | i  p0 = bank address
0137 7D7E 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0138 7D80 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142 7D82 0460  28         b     @edkey.action.cmdb.show
     7D84 6944 
0143                                                   ; Show dialog in CMDB pane
0144               
0145               
0146               ***************************************************************
0147               * Stub for "Load DV80 file"
0148               * bank3 vec.2
0149               ********|*****|*********************|**************************
0150               dialog.load:
0151 7D86 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D88 7876 
0152                       ;------------------------------------------------------
0153                       ; Show dialog
0154                       ;------------------------------------------------------
0155 7D8A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D8C 3008 
0156 7D8E 6006                   data bank3.rom        ; | i  p0 = bank address
0157 7D90 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0158 7D92 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0159                       ;------------------------------------------------------
0160                       ; Exit
0161                       ;------------------------------------------------------
0162 7D94 0460  28         b     @edkey.action.cmdb.show
     7D96 6944 
0163                                                   ; Show dialog in CMDB pane
0164               
0165               
0166               ***************************************************************
0167               * Stub for "Save DV80 file"
0168               * bank3 vec.3
0169               ********|*****|*********************|**************************
0170               dialog.save:
0171 7D98 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D9A 7876 
0172                       ;------------------------------------------------------
0173                       ; Show dialog
0174                       ;------------------------------------------------------
0175 7D9C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D9E 3008 
0176 7DA0 6006                   data bank3.rom        ; | i  p0 = bank address
0177 7DA2 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0178 7DA4 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182 7DA6 0460  28         b     @edkey.action.cmdb.show
     7DA8 6944 
0183                                                   ; Show dialog in CMDB pane
0184               
0185               
0186               ***************************************************************
0187               * Stub for "Unsaved Changes"
0188               * bank3 vec.4
0189               ********|*****|*********************|**************************
0190               dialog.unsaved:
0191 7DAA 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DAC 7876 
0192                       ;------------------------------------------------------
0193                       ; Show dialog
0194                       ;------------------------------------------------------
0195 7DAE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DB0 3008 
0196 7DB2 6006                   data bank3.rom        ; | i  p0 = bank address
0197 7DB4 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0198 7DB6 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202 7DB8 0460  28         b     @edkey.action.cmdb.show
     7DBA 6944 
0203                                                   ; Show dialog in CMDB pane
0204               
0205               
0206               
0207               
0208               ***************************************************************
0209               * Stub for Dialog "File dialog"
0210               * bank3 vec.5
0211               ********|*****|*********************|**************************
0212               dialog.file:
0213 7DBC 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DBE 7876 
0214                       ;------------------------------------------------------
0215                       ; Show dialog
0216                       ;------------------------------------------------------
0217 7DC0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DC2 3008 
0218 7DC4 6006                   data bank3.rom        ; | i  p0 = bank address
0219 7DC6 7FA4                   data vec.5            ; | i  p1 = Vector with target address
0220 7DC8 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0221                       ;------------------------------------------------------
0222                       ; Exit
0223                       ;------------------------------------------------------
0224 7DCA 0460  28         b     @edkey.action.cmdb.show
     7DCC 6944 
0225                                                   ; Show dialog in CMDB pane
0226               
0227               
0228               ***************************************************************
0229               * Stub for "fb.tab.next"
0230               * bank4 vec.1
0231               ********|*****|*********************|**************************
0232               fb.tab.next:
0233 7DCE 0649  14         dect  stack
0234 7DD0 C64B  30         mov   r11,*stack            ; Save return address
0235                       ;------------------------------------------------------
0236                       ; Put cursor on next tab position
0237                       ;------------------------------------------------------
0238 7DD2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DD4 3008 
0239 7DD6 6008                   data bank4.rom        ; | i  p0 = bank address
0240 7DD8 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0241 7DDA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0242                       ;------------------------------------------------------
0243                       ; Exit
0244                       ;------------------------------------------------------
0245 7DDC C2F9  30         mov   *stack+,r11           ; Pop r11
0246 7DDE 045B  20         b     *r11                  ; Return to caller
0247               
0248               
0249               ***************************************************************
0250               * Stub for "fb.ruler.init"
0251               * bank4 vec.2
0252               ********|*****|*********************|**************************
0253               fb.ruler.init:
0254 7DE0 0649  14         dect  stack
0255 7DE2 C64B  30         mov   r11,*stack            ; Save return address
0256                       ;------------------------------------------------------
0257                       ; Setup ruler in memory
0258                       ;------------------------------------------------------
0259 7DE4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DE6 3008 
0260 7DE8 6008                   data bank4.rom        ; | i  p0 = bank address
0261 7DEA 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0262 7DEC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266 7DEE C2F9  30         mov   *stack+,r11           ; Pop r11
0267 7DF0 045B  20         b     *r11                  ; Return to caller
0268               
0269               
0270               ***************************************************************
0271               * Stub for "fb.colorlines"
0272               * bank4 vec.3
0273               ********|*****|*********************|**************************
0274               fb.colorlines:
0275 7DF2 0649  14         dect  stack
0276 7DF4 C64B  30         mov   r11,*stack            ; Save return address
0277                       ;------------------------------------------------------
0278                       ; Colorize frame buffer content
0279                       ;------------------------------------------------------
0280 7DF6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DF8 3008 
0281 7DFA 6008                   data bank4.rom        ; | i  p0 = bank address
0282 7DFC 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0283 7DFE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287 7E00 C2F9  30         mov   *stack+,r11           ; Pop r11
0288 7E02 045B  20         b     *r11                  ; Return to caller
0289               
0290               
0291               ***************************************************************
0292               * Stub for "fb.vdpdump"
0293               * bank4 vec.4
0294               ********|*****|*********************|**************************
0295               fb.vdpdump:
0296 7E04 0649  14         dect  stack
0297 7E06 C64B  30         mov   r11,*stack            ; Save return address
0298                       ;------------------------------------------------------
0299                       ; Colorize frame buffer content
0300                       ;------------------------------------------------------
0301 7E08 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E0A 3008 
0302 7E0C 6008                   data bank4.rom        ; | i  p0 = bank address
0303 7E0E 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0304 7E10 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0305                       ;------------------------------------------------------
0306                       ; Exit
0307                       ;------------------------------------------------------
0308 7E12 C2F9  30         mov   *stack+,r11           ; Pop r11
0309 7E14 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1390892
0182                       ;-----------------------------------------------------------------------
0183                       ; Program data
0184                       ;-----------------------------------------------------------------------
0185                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
**** **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Keyboard actions
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7E16 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7E18 0000 
     7E1A 6660 
0012 7E1C 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7E1E 0000 
     7E20 6162 
0013 7E22 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7E24 0000 
     7E26 617C 
0014 7E28 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7E2A 0000 
     7E2C 628C 
0015 7E2E 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E30 0000 
     7E32 62E6 
0016 7E34 BF00             data  key.fctn.h, pane.focus.fb, edkey.action.home
     7E36 0000 
     7E38 6198 
0017 7E3A C000             data  key.fctn.j, pane.focus.fb, edkey.action.pword
     7E3C 0000 
     7E3E 61DA 
0018 7E40 C100             data  key.fctn.k, pane.focus.fb, edkey.action.nword
     7E42 0000 
     7E44 622C 
0019 7E46 C200             data  key.fctn.l, pane.focus.fb, edkey.action.end
     7E48 0000 
     7E4A 61B8 
0020 7E4C 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E4E 0000 
     7E50 635A 
0021 7E52 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7E54 0000 
     7E56 6396 
0022 7E58 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7E5A 0000 
     7E5C 63D0 
0023 7E5E 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7E60 0000 
     7E62 63EC 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7E64 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7E66 0000 
     7E68 645E 
0028 7E6A 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7E6C 0000 
     7E6E 6510 
0029 7E70 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7E72 0000 
     7E74 64DC 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7E76 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7E78 0000 
     7E7A 6572 
0034 7E7C B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7E7E 0000 
     7E80 66D8 
0035 7E82 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7E84 0000 
     7E86 65EC 
0036 7E88 0100             data  key.fctn.7, pane.focus.fb, edkey.action.fb.tab.next
     7E8A 0000 
     7E8C 6896 
0037                       ;-------------------------------------------------------
0038                       ; Block marking/modifier
0039                       ;-------------------------------------------------------
0040 7E8E 9600             data  key.ctrl.v, pane.focus.fb, edkey.action.block.mark
     7E90 0000 
     7E92 67D0 
0041 7E94 0F00             data  key.fctn.9, pane.focus.fb, edkey.action.block.reset
     7E96 0000 
     7E98 67D8 
0042 7E9A 8300             data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
     7E9C 0000 
     7E9E 67E4 
0043 7EA0 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
     7EA2 0000 
     7EA4 6820 
0044 7EA6 8D00             data  key.ctrl.m, pane.focus.fb, edkey.action.block.move
     7EA8 0000 
     7EAA 684A 
0045 7EAC 8700             data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
     7EAE 0000 
     7EB0 687C 
0046                       ;-------------------------------------------------------
0047                       ; Other action keys
0048                       ;-------------------------------------------------------
0049 7EB2 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7EB4 0000 
     7EB6 6752 
0050 7EB8 9100             data  key.ctrl.q, pane.focus.fb, edkey.action.quit
     7EBA 0000 
     7EBC 6752 
0051 7EBE 9500             data  key.ctrl.u, pane.focus.fb, edkey.action.toggle.ruler
     7EC0 0000 
     7EC2 6764 
0052 7EC4 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7EC6 0000 
     7EC8 768C 
0053 7ECA 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7ECC 0000 
     7ECE 678A 
0054 7ED0 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7ED2 0000 
     7ED4 6796 
0055                       ;-------------------------------------------------------
0056                       ; Dialog keys
0057                       ;-------------------------------------------------------
0058 7ED6 8800             data  key.ctrl.h, pane.focus.fb, edkey.action.about
     7ED8 0000 
     7EDA 7D74 
0059 7EDC 8600             data  key.ctrl.f, pane.focus.fb, dialog.file
     7EDE 0000 
     7EE0 7DBC 
0060 7EE2 9300             data  key.ctrl.s, pane.focus.fb, dialog.save
     7EE4 0000 
     7EE6 7D98 
0061 7EE8 8F00             data  key.ctrl.o, pane.focus.fb, dialog.load
     7EEA 0000 
     7EEC 7D86 
0062                       ;-------------------------------------------------------
0063                       ; End of list
0064                       ;-------------------------------------------------------
0065 7EEE FFFF             data  EOL                           ; EOL
0066               
0067               
0068               
0069               
0070               *---------------------------------------------------------------
0071               * Action keys mapping table: Command Buffer (CMDB)
0072               *---------------------------------------------------------------
0073               keymap_actions.cmdb:
0074                       ;-------------------------------------------------------
0075                       ; Dialog: File
0076                       ;-------------------------------------------------------
0077 7EF0 0D00             data  key.enter, id.dialog.file, edkey.action.cmdb.close.dialog
     7EF2 0068 
     7EF4 6A48 
0078 7EF6 4E00             data  key.uc.n, id.dialog.file, edkey.action.cmdb.file.new
     7EF8 0068 
     7EFA 6956 
0079 7EFC 5300             data  key.uc.s, id.dialog.file, dialog.save
     7EFE 0068 
     7F00 7D98 
0080 7F02 4F00             data  key.uc.o, id.dialog.file, dialog.load
     7F04 0068 
     7F06 7D86 
0081 7F08 6E00             data  key.lc.n, id.dialog.file, edkey.action.cmdb.file.new
     7F0A 0068 
     7F0C 6956 
0082 7F0E 7300             data  key.lc.s, id.dialog.file, dialog.save
     7F10 0068 
     7F12 7D98 
0083 7F14 6F00             data  key.lc.o, id.dialog.file, dialog.load
     7F16 0068 
     7F18 7D86 
0084                       ;-------------------------------------------------------
0085                       ; Dialog: Open DV80 file
0086                       ;-------------------------------------------------------
0087 7F1A 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7F1C 000A 
     7F1E 6A30 
0088 7F20 0D00             data  key.enter, id.dialog.load, edkey.action.cmdb.load
     7F22 000A 
     7F24 6962 
0089                       ;-------------------------------------------------------
0090                       ; Dialog: Unsaved changes
0091                       ;-------------------------------------------------------
0092 7F26 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7F28 0065 
     7F2A 6A06 
0093 7F2C 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7F2E 0065 
     7F30 7D98 
0094                       ;-------------------------------------------------------
0095                       ; Dialog: Save DV80 file
0096                       ;-------------------------------------------------------
0097 7F32 0D00             data  key.enter, id.dialog.save, edkey.action.cmdb.save
     7F34 000B 
     7F36 69A6 
0098 7F38 0D00             data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
     7F3A 000C 
     7F3C 69A6 
0099                       ;-------------------------------------------------------
0100                       ; Dialog: About
0101                       ;-------------------------------------------------------
0102 7F3E 0F00             data  key.fctn.9, id.dialog.about, edkey.action.cmdb.close.about
     7F40 0067 
     7F42 6A3C 
0103 7F44 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.about
     7F46 0067 
     7F48 6A3C 
0104                       ;-------------------------------------------------------
0105                       ; Movement keys
0106                       ;-------------------------------------------------------
0107 7F4A 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7F4C 0001 
     7F4E 68A4 
0108 7F50 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7F52 0001 
     7F54 68B6 
0109 7F56 BF00             data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
     7F58 0001 
     7F5A 68CE 
0110 7F5C C200             data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
     7F5E 0001 
     7F60 68E2 
0111                       ;-------------------------------------------------------
0112                       ; Modifier keys
0113                       ;-------------------------------------------------------
0114 7F62 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7F64 0001 
     7F66 68FA 
0115                       ;-------------------------------------------------------
0116                       ; Other action keys
0117                       ;-------------------------------------------------------
0118 7F68 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7F6A 0001 
     7F6C 6A48 
0119 7F6E 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7F70 0001 
     7F72 6752 
0120 7F74 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7F76 0001 
     7F78 768C 
0121                       ;------------------------------------------------------
0122                       ; End of list
0123                       ;-------------------------------------------------------
0124 7F7A FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.1390892
0186                       ;-----------------------------------------------------------------------
0187                       ; Bank specific vector table
0188                       ;-----------------------------------------------------------------------
0192 7F7C 7F7C                   data $                ; Bank 1 ROM size OK.
0194                       ;-------------------------------------------------------
0195                       ; Vector table bank 1: >7f9c - >7fff
0196                       ;-------------------------------------------------------
0197                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6CDA     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0010 7F9E 6B92     vec.2   data  idx.entry.update      ;    for index functions.
0011 7FA0 6C40     vec.3   data  idx.entry.delete      ;
0012 7FA2 6BE4     vec.4   data  idx.pointer.get       ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 6DC2     vec.10  data  edb.line.pack.fb      ;
0019 7FB0 6EBA     vec.11  data  edb.line.unpack.fb    ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 6944     vec.15  data  edkey.action.cmdb.show
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 7402     vec.19  data  cmdb.cmd.clear        ;
0028 7FC2 6AE6     vec.20  data  fb.refresh            ;
0029 7FC4 7E04     vec.21  data  fb.vdpdump            ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 7894     vec.28  data  pane.cursor.blink     ;
0037 7FD4 7876     vec.29  data  pane.cursor.hide      ;
0038 7FD6 7B36     vec.30  data  pane.errline.show     ;
0039 7FD8 76EA     vec.31  data  pane.action.colorscheme.load
0040 7FDA 785C     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.1390892
0198               
0199               
0200               
0201               
0202               *--------------------------------------------------------------
0203               * Video mode configuration
0204               *--------------------------------------------------------------
0205      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0206      0004     spfbck  equ   >04                   ; Screen background color.
0207      339A     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0208      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0209      0050     colrow  equ   80                    ; Columns per row
0210      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0211      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0212      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0213      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
