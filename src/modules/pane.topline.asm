* FILE......: pane.topline.asm
* Purpose...: Pane top line of screen

***************************************************************
* pane.topline.draw
* Draw top line
***************************************************************
* bl  @pane.topline.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.topline:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Show separators
        ;------------------------------------------------------
        bl    @hchar
              byte 0,50,16,1        ; Vertical line 1
              byte 0,70,16,1        ; Vertical line 2
              data eol        
        ;------------------------------------------------------
        ; Show buffer number
        ;------------------------------------------------------
        bl    @putat 
              byte  0,0
              data  txt.bufnum
        ;------------------------------------------------------
        ; Show current file
        ;------------------------------------------------------ 
        bl    @setx
              data 3                ; Position cursor

        mov   @edb.filename.ptr,tmp1
                                    ; Get string to display
        bl    @xutst0               ; Display string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.topline.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return