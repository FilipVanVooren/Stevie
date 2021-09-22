* FILE......: equates.asm
* Purpose...: The main equates file for Stevie editor


*===============================================================================
* Memory map
* ==========
*
* CARTRIDGE SPACE (6000-7fff)
*
*     Mem range   Bytes    BANK   Purpose
*     =========   =====    ====   ==================================
*     6000-633f               0   Cartridge header
*     6040-7fff               0   SP2 library + Stevie library
*                                 relocated to RAM space
*     ..............................................................
*     6000-633f               1   Cartridge header
*     6040-7fbf               1   Stevie program code
*     7fc0-7fff      64       1   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               2   Cartridge header
*     6040-7fbf               2   Stevie program code
*     7fc0-7fff      64       2   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               3   Cartridge header
*     6040-7fbf               3   Stevie program code
*     7fc0-7fff      64       3   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               4   Cartridge header
*     6040-7fbf               4   Stevie program code
*     7fc0-7fff      64       4   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               5   Cartridge header
*     6040-7fbf               5   Stevie program code
*     7fc0-7fff      64       5   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               6   Cartridge header
*     6040-7fbf               6   Stevie program code
*     7fc0-7fff      64       6   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               7   Cartridge header
*     6040-7fbf               7   SP2 library in cartridge space
*     7fc0-7fff      64       7   Vector table (32 vectors)
*
*
*
* VDP RAM F18a (0000-47ff)
*
*     Mem range   Bytes    Hex    Purpose
*     =========   =====   =====   =================================
*     0000-095f    2400   >0960   PNT: Pattern Name Table
*     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
*     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
*     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
*     1800-215f    2400   >0960   TAT: Tile Attribute Table
*                                      (Position based colors F18a, 80 colums)
*     2180                        SAT: Sprite Attribute Table
*                                      (Cursor in F18a, 80 cols mode)
*     2800                        SPT: Sprite Pattern Table
*                                      (Cursor in F18a, 80 columns, 2K boundary)
*===============================================================================

*--------------------------------------------------------------
* Graphics mode selection
*--------------------------------------------------------------
  .ifeq device.f18a,1

pane.botrow               equ  29      ; Bottom row on screen

  .else

pane.botrow               equ  23      ; Bottom row on screen

  .endif
*--------------------------------------------------------------
* Stevie Dialog / Pane specific equates
*--------------------------------------------------------------
pane.focus.fb             equ  0       ; Editor pane has focus
pane.focus.cmdb           equ  1       ; Command buffer pane has focus
;-----------------------------------------------------------------
;   Dialog ID's >= 100 indicate that command prompt should be 
;   hidden and no characters added to CMDB keyboard buffer
;-----------------------------------------------------------------
id.dialog.load            equ  10      ; "Load DV80 file"
id.dialog.save            equ  11      ; "Save DV80 file"
id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
id.dialog.menu            equ  100     ; "Stevie Menu"
id.dialog.unsaved         equ  101     ; "Unsaved changes"
id.dialog.block           equ  102     ; "Block move/copy/delete"
id.dialog.about           equ  103     ; "About"
id.dialog.file            equ  104     ; "File"
id.dialog.basic           equ  105     ; "Basic"
*--------------------------------------------------------------
* Stevie specific equates
*--------------------------------------------------------------
fh.fopmode.none           equ  0       ; No file operation in progress
fh.fopmode.readfile       equ  1       ; Read file from disk to memory
fh.fopmode.writefile      equ  2       ; Save file from memory to disk
vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
                                       ; VDP TAT address of 1st CMDB row 
vdp.sit.base              equ  >0000   ; VDP SIT base address                                       
vdp.sit.size              equ  (pane.botrow + 1) * 80
                                       ; VDP SIT size 80 columns, 24/30 rows
vdp.tat.base              equ  >1800   ; VDP TAT base address
tv.colorize.reset         equ  >9900   ; Colorization off
*--------------------------------------------------------------
* SPECTRA2 / Stevie startup options
*--------------------------------------------------------------
debug                     equ  1       ; Turn on spectra2 debugging
startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
cpu.scrpad.tgt            equ  >7e00   ; \ Dump of OS monitor scratchpad 
                                       ; | memory stored in cartridge ROM
                                       ; / bank3.asm
*--------------------------------------------------------------
* Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
*--------------------------------------------------------------
core1.top         equ  >a000           ; Structure begin
parm1             equ  core1.top + 0   ; Function parameter 1
parm2             equ  core1.top + 2   ; Function parameter 2
parm3             equ  core1.top + 4   ; Function parameter 3
parm4             equ  core1.top + 6   ; Function parameter 4
parm5             equ  core1.top + 8   ; Function parameter 5
parm6             equ  core1.top + 10  ; Function parameter 6
parm7             equ  core1.top + 12  ; Function parameter 7
parm8             equ  core1.top + 14  ; Function parameter 8
outparm1          equ  core1.top + 16  ; Function output parameter 1
outparm2          equ  core1.top + 18  ; Function output parameter 2
outparm3          equ  core1.top + 20  ; Function output parameter 3
outparm4          equ  core1.top + 22  ; Function output parameter 4
outparm5          equ  core1.top + 24  ; Function output parameter 5
outparm6          equ  core1.top + 26  ; Function output parameter 6
outparm7          equ  core1.top + 28  ; Function output parameter 7
outparm8          equ  core1.top + 30  ; Function output parameter 8
keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
keycode1          equ  core1.top + 34  ; Current key scanned
keycode2          equ  core1.top + 36  ; Previous key scanned
unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
core1.free        equ  core1.top + 44  ; End of structure
*--------------------------------------------------------------
* Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
*--------------------------------------------------------------
core2.top         equ  >a100           ; Structure begin
timers            equ  core2.top       ; Timer table
rambuf            equ  core2.top + 64  ; RAM workbuffer
ramsat            equ  core2.top + 128 ; Sprite Attribute Table in RAM
core2.free        equ  core2.top + 160 ; End of structure
*--------------------------------------------------------------
* Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
*--------------------------------------------------------------
tv.top            equ  >a200           ; Structure begin
tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
tv.error.visible  equ  tv.top + 40     ; Error pane visible
tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
tv.free           equ  tv.top + 202    ; End of structure
*--------------------------------------------------------------
* Frame buffer structure              @>a300-a3ff   (256 bytes)
*--------------------------------------------------------------
fb.struct         equ  >a300           ; Structure begin
fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
                                       ; line X in editor buffer).
fb.row            equ  fb.struct + 6   ; Current row in frame buffer
                                       ; (offset 0 .. @fb.scrrows)
fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
fb.free           equ  fb.struct + 190 ; End of structure
*--------------------------------------------------------------
* File handle structure               @>a400-a4ff   (256 bytes)
*--------------------------------------------------------------
fh.struct         equ  >a400           ; stevie file handling structures
;***********************************************************************
; ATTENTION
; The dsrlnk variables must form a continuous memory block and keep 
; their order!
;***********************************************************************
dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte) 
fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
fh.records        equ  fh.struct + 60  ; File records counter
fh.reclen         equ  fh.struct + 62  ; Current record length
fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
fh.free           equ  fh.struct +172  ; End of structure
fh.vrecbuf        equ  >0960           ; VDP address record buffer
fh.vpab           equ  >0a60           ; VDP address PAB
*--------------------------------------------------------------
* Editor buffer structure             @>a500-a5ff   (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >a500           ; Begin structure
edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset) 
edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
                                       ; with current filename.
edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
                                       ; with current file type.                                    
edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved 
                                       ; for filename, but not always used.
edb.free          equ  edb.struct + 105; End of structure
*--------------------------------------------------------------
* Index structure                     @>a600-a6ff   (256 bytes)
*--------------------------------------------------------------
idx.struct        equ  >a600           ; stevie index structure
idx.sams.page     equ  idx.struct      ; Current SAMS page
idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
idx.free          equ  idx.struct + 6  ; End of structure
*--------------------------------------------------------------
* Command buffer structure            @>a700-a7ff   (256 bytes)
*--------------------------------------------------------------
cmdb.struct       equ  >a700           ; Command Buffer structure
cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB 
cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
cmdb.free         equ  cmdb.struct +121; End of structure
*--------------------------------------------------------------
* Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
*--------------------------------------------------------------
scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
*--------------------------------------------------------------
* Farjump return stack                @>af00-afff   (256 bytes)
*--------------------------------------------------------------
fj.bottom         equ  >b000           ; Return stack for trampoline function
                                       ; Grows downwards from high to low.
*--------------------------------------------------------------
* Index                               @>b000-bfff  (4096 bytes)
*--------------------------------------------------------------
idx.top           equ  >b000           ; Top of index
idx.size          equ  4096            ; Index size
*--------------------------------------------------------------
* Editor buffer                       @>c000-cfff  (4096 bytes)
*--------------------------------------------------------------
edb.top           equ  >c000           ; Editor buffer high memory
edb.size          equ  4096            ; Editor buffer size
*--------------------------------------------------------------
* Frame buffer                        @>d000-dfff  (4096 bytes)
*--------------------------------------------------------------
fb.top            equ  >d000           ; Frame buffer (80x30)
fb.size           equ  80*30           ; Frame buffer size                                     
*--------------------------------------------------------------
* Command buffer history              @>e000-efff  (4096 bytes)
*--------------------------------------------------------------
cmdb.top          equ  >e000           ; Top of command history buffer
cmdb.size         equ  4096            ; Command buffer size
*--------------------------------------------------------------
* Heap                                @>f000-ffff  (4096 bytes)
*--------------------------------------------------------------
heap.top          equ  >f000           ; Top of heap