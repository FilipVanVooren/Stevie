* basic......: dialog.cart.type.asm
* Purpose....: Dialog "Cartridge Type"

***************************************************************
* dialog.cart.type
* Open Dialog "Cartridge Type"
***************************************************************
* bl @dialog.cart.type
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.cart.type:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.cart.type
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.cart.type
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.cart.type
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.cart.type
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.cart.type2
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display

        clr   @cmdb.panhint         ; No hint in bottom line

        li    tmp0,txt.keys.cart.type
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.cart.type.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
