* FILE......: fm.run.ea5.asm
* Purpose...: File Manager - Run EA5 program image

***************************************************************
* fm.run.ea5
* Run EA5 program image
***************************************************************
* bl  @fm.run.ea5
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.run.ea5:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        dect  stack
        mov   @parm4,*stack         ; Push @parm4
        dect  stack
        mov   @parm5,*stack         ; Push @parm5
        dect  stack
        mov   @parm6,*stack         ; Push @parm6
        ;-------------------------------------------------------        
        ; Exit early if editor buffer is dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp1       ; Get dirty flag
        jeq   !                     ; Load file unless dirty

        seto  @outparm1             ; \ Editor buffer dirty, set flag
        jmp   fm.run.ea5.exit       ; / and exit early 
        ;-------------------------------------------------------
        ; Load EA5 program image into memory
        ;-------------------------------------------------------        
!       clr   @parm2                ; Skip callback 1
        clr   @parm3                ; Skip callback 2
        clr   @parm4                ; Skip callback 3
        clr   @parm5                ; Skip callback 4
        clr   @parm6                ; Skip callback 5

        bl    @fh.file.load.bin     ; Load binary image into memory
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "Before Open file"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "Read line from file"
                                    ; | i  @parm4 = Pointer to callback
                                    ; |             "Close file"
                                    ; | i  @parm5 = Pointer to callback 
                                    ; |             "File I/O error"
                                    ; | i  @parm6 = Pointer to callback
                                    ; /             "Memory full error"

        clr   @outparm1             ; Reset                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.run.ea5.exit:
        mov   *stack+,@parm6        ; Pop @parm6
        mov   *stack+,@parm5        ; Pop @parm5
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
