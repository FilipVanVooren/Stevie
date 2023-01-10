* FILE......: rom.vectors.bank3.asm
* Purpose...: Bank 3 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#3'

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
        aorg  bankx.vectab

vec.1   data  dialog.help           ; Dialog "About"
vec.2   data  dialog.load           ; Dialog "Load file"
vec.3   data  dialog.save           ; Dialog "Save file"
vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
vec.5   data  dialog.print          ; Dialog "Print file"
vec.6   data  dialog.file           ; Dialog "File"
vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
vec.9   data  dialog.clipdev        ; Dialog "Configure clipboard device"
vec.10  data  dialog.config         ; Dialog "Configure"
vec.11  data  dialog.append         ; Dialog "Append file"
vec.12  data  dialog.cartridge      ; Dialog "Cartridge"
vec.13  data  dialog.basic          ; Dialog "TI Basic"
vec.14  data  dialog.shortcuts      ; Dialog "Shortcuts"
vec.15  data  dialog.editor         ; Dialog "Configure editor"
vec.16  data  dialog.goto           ; Dialog "Go to line"
vec.17  data  dialog.font           ; Dialog "Configure font"
vec.18  data  error.display         ; Show error message
vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
vec.22  data  pane.cmdb.draw        ; Draw content in command
vec.23  data  tibasic.buildstr      ; Build TI Basic session identifier string
vec.24  data  cmdb.refresh          ;
vec.25  data  cmdb.cmd.clear        ;
vec.26  data  cmdb.cmd.getlength    ;
vec.27  data  cmdb.cmd.preset       ;
vec.28  data  cmdb.cmd.set          ;
vec.29  data  dialog.hearts.tat     ; Dump color for hearts in TI-Basic dialog
vec.30  data  dialog.menu           ; Dialog "Main Menu"
vec.31  data  tibasic.am.toggle     ; Toggle AutoUnpack in Run TI-Basic dialog
vec.32  data  fm.fastmode           ; Toggle FastMode on/off in Load dialog
