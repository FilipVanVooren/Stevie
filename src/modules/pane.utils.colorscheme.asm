* FILE......: pane.utils.colorscheme.asm
* Purpose...: Stevie Editor - Color scheme for panes

***************************************************************
* pane.action.colorschene.cycle
* Cycle through available color scheme
***************************************************************
* bl  @pane.action.colorscheme.cycle
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.action.colorscheme.cycle:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   @tv.colorscheme,tmp0  ; Load color scheme index
        ci    tmp0,tv.colorscheme.entries
                                    ; Last entry reached?
        jlt   !
        li    tmp0,1                ; Reset color scheme index
        jmp   pane.action.colorscheme.switch
!       inc   tmp0
        ;-------------------------------------------------------
        ; switch to new color scheme
        ;-------------------------------------------------------
pane.action.colorscheme.switch:
        mov   tmp0,@tv.colorscheme  ; Save index of color scheme
        bl    @pane.action.colorscheme.load
        ;-------------------------------------------------------
        ; Show current color scheme message
        ;-------------------------------------------------------  
        mov   @wyx,@waux1           ; Save cursor YX position

        bl    @filv
              data >1840,>1F,16     ; VDP start address (frame buffer area)

        bl    @putnum
              byte 0,75
              data tv.colorscheme,rambuf,>3020

        bl    @putat
              byte 0,64
              data txt.colorscheme  ; Show color scheme message

        mov   @waux1,@wyx           ; Restore cursor YX position
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------  
        li    tmp0,12000        
!       dec   tmp0
        jne   -!
        ;-------------------------------------------------------
        ; Setup one shot task for removing message
        ;-------------------------------------------------------  
        li    tmp0,pane.action.colorscheme.task.callback
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.cycle.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
        ;-------------------------------------------------------
        ; Remove colorscheme message (triggered by oneshot task)
        ;-------------------------------------------------------
pane.action.colorscheme.task.callback:
        dect  stack
        mov   r11,*stack            ; Push return address
       
        bl    @filv 
              data >003C,>00,20     ; Remove message

        seto  @parm1
        bl    @pane.action.colorscheme.load
                                    ; Reload current colorscheme
                                    ; \ i  parm1 = Do not turn screen off
                                    ; /

        seto  @fb.dirty             ; Trigger frame buffer refresh
        clr   @tv.task.oneshot      ; Reset oneshot task        
        
        mov   *stack+,r11           ; Pop R11        
        b     *r11                  ; Return to task



***************************************************************
* pane.action.colorscheme.load
* Load color scheme
***************************************************************
* bl  @pane.action.colorscheme.load
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into color scheme table
* @parm1          = Skip screen off if >FFFF
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
********|*****|*********************|**************************
pane.action.colorscheme.load:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        dect  stack
        mov   @parm1,*stack         ; Push parm1        
        ;-------------------------------------------------------
        ; Turn screen of
        ;-------------------------------------------------------
        mov   @parm1,tmp0
        ci    tmp0,>ffff            ; Skip flag set?
        jeq   !                     ; Yes, so skip screen off
        bl    @scroff               ; Turn screen off        
        ;-------------------------------------------------------
        ; Get FG/BG colors framebuffer text
        ;-------------------------------------------------------
!       mov   @tv.colorscheme,tmp0  ; Get color scheme index 
        dec   tmp0                  ; Internally work with base 0

        sla   tmp0,3                ; Offset into color scheme data table
        ai    tmp0,tv.colorscheme.table
                                    ; Add base for color scheme data table
        mov   *tmp0+,tmp3           ; Get colors ABCD
        mov   tmp3,@tv.color        ; Save colors ABCD
        ;-------------------------------------------------------
        ; Get and save cursor color
        ;-------------------------------------------------------
        mov   *tmp0,tmp4            ; Get colors EFGH
        andi  tmp4,>00ff            ; Only keep LSB (GH)
        mov   tmp4,@tv.curcolor     ; Save cursor color
        ;-------------------------------------------------------
        ; Get FG/BG colors framebuffer marked text & CMDB pane
        ;-------------------------------------------------------
        mov   *tmp0+,tmp4           ; Get colors EFGH again
        andi  tmp4,>ff00            ; Only keep MSB (EF)
        srl   tmp4,8                ; MSB to LSB

        mov   *tmp0+,tmp0           ; Get colors IJKL

        mov   tmp0,tmp1             ; \ Right align IJ and
        srl   tmp1,8                ; | save to @tv.busycolor
        mov   tmp1,@tv.busycolor    ; / 

        mov   tmp0,tmp1             ; \ Right align KL and
        andi  tmp1,>00ff            ; | save to @tv.markcolor
        mov   tmp1,@tv.markcolor    ; /
                                 
        ;-------------------------------------------------------
        ; Dump colors to VDP register 7 (text mode)
        ;-------------------------------------------------------
        mov   tmp3,tmp1             ; Get work copy
        srl   tmp1,8                ; MSB to LSB (frame buffer colors)
        ori   tmp1,>0700
        mov   tmp1,tmp0
        bl    @putvrx               ; Write VDP register
        ;-------------------------------------------------------
        ; Dump colors for frame buffer pane (TAT)
        ;-------------------------------------------------------
        li    tmp0,>1800            ; VDP start address (frame buffer area)
        mov   tmp3,tmp1             ; Get work copy of colors ABCD
        srl   tmp1,8                ; MSB to LSB (frame buffer colors)
        li    tmp2,29*80            ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Dump colors for CMDB pane (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.cmdbpane:        
        mov   @cmdb.visible,tmp0
        jeq   pane.action.colorscheme.errpane
                                    ; Skip if CMDB pane is hidden

        li    tmp0,>1fd0            ; VDP start address (bottom status line)
        mov   tmp4,tmp1             ; Get work copy fg/bg color
        li    tmp2,5*80             ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Dump fixed colors for error line pane (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.errpane:        
        mov   @tv.error.visible,tmp0
        jeq   pane.action.colorscheme.statusline
                                    ; Skip if error line pane is hidden
                                    
        li    tmp1,>00f6            ; White on dark red
        mov   tmp1,@parm1           ; Pass color combination

        bl    @pane.action.colorcombo.errline
                                    ; Load color combination for error line
                                    ; \ i  @parm1 = Color combination
                                    ; /
        ;-------------------------------------------------------
        ; Dump colors for bottom status line pane (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.statusline:        
        mov   @tv.color,@parm1      ; Pass color combination

        bl    @pane.action.colorcombo.botline
                                    ; Load color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; /
        ;-------------------------------------------------------        
        ; Dump cursor FG color to sprite table (SAT)
        ;-------------------------------------------------------
pane.action.colorscheme.cursorcolor:
        mov   @tv.curcolor,tmp4     ; Get cursor color        
        sla   tmp4,8                ; Move to MSB
        movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
        movb  tmp4,@tv.curshape+1   ; Save cursor color                                    
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.load.exit:
        bl    @scron                ; Turn screen on
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
  


***************************************************************
* pane.action.colorcombo.errline
* Load color scheme for error line
***************************************************************
* bl  @pane.action.colorcombo.errline
*--------------------------------------------------------------
* INPUT
* @parm1 = Foreground / Background color
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.action.colorcombo.errline:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push parm1        
        ;-------------------------------------------------------
        ; Load error line colors
        ;-------------------------------------------------------
        mov   @parm1,tmp1           ; Get FG/BG color

        li    tmp0,>20C0            ; VDP start address (error line)
        li    tmp2,80               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorcombo.errline.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller






***************************************************************
* pane.action.colorcombo.botline
* Load color combination for error line
***************************************************************
* bl  @pane.action.colorcombo.botline
*--------------------------------------------------------------
* INPUT
* @parm1 = Foreground / Background color
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.action.colorcombo.botline:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push parm1              
        ;-------------------------------------------------------
        ; Dump colors for bottom status line pane (TAT)
        ;-------------------------------------------------------
        li    tmp0,>2110            ; VDP start address (bottom status line)
        mov   @parm1,tmp1           ; Get color
        andi  tmp1,>00ff            ; Only keep LSB (status line colors)
        li    tmp2,80               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorcombo.botline.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller                                    