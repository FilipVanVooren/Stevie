* FILE......: cmdb.asm
* Purpose...: Stevie Editor - Command Buffer module

*//////////////////////////////////////////////////////////////
*        Stevie Editor - Command Buffer implementation
*//////////////////////////////////////////////////////////////


***************************************************************
* cmdb.init
* Initialize Command Buffer
***************************************************************
* bl @cmdb.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,cmdb.top         ; \ Set pointer to command buffer
        mov   tmp0,@cmdb.top.ptr    ; /

        clr   @cmdb.visible         ; Hide command buffer 
        li    tmp0,10
        mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
        mov   tmp0,@cmdb.default    ; Set default command buffer size

        li    tmp0,>1b01            ; Y=27, X=1
        mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane

        clr   @cmdb.lines           ; Number of lines in cmdb buffer
        clr   @cmdb.dirty           ; Command buffer is clean
        ;------------------------------------------------------
        ; Clear command buffer
        ;------------------------------------------------------
        bl    @film
        data  cmdb.top,>00,cmdb.size 
                                    ; Clear it all the way
cmdb.init.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller







***************************************************************
* cmdb.refresh
* Refresh command buffer content
***************************************************************
* bl @cmdb.refresh
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.refresh:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Dump Command buffer content
        ;------------------------------------------------------
        mov   @wyx,@cmdb.yxsave     ; Save YX position
        mov   @cmdb.yxtop,@wyx      ; Screen position top of CMDB pane

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.                              
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        mov   @cmdb.top.ptr,tmp1    ; Top of command buffer        
        li    tmp2,5*80

        bl    @xpym2v               ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Number of bytes to copy       
        ;------------------------------------------------------
        ; Show command buffer prompt
        ;------------------------------------------------------
        bl    @putat
              byte 27,0
              data txt.cmdb.prompt

        mov   @cmdb.yxsave,@fb.yxsave 
        mov   @cmdb.yxsave,@wyx        
                                    ; Restore YX position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.refresh.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

