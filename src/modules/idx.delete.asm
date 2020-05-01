* FILE......: idx_delete.asm
* Purpose...: TiVi Editor - Delete index slot

*//////////////////////////////////////////////////////////////
*              TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////


***************************************************************
* idx.entry.delete._reorg.simple
* Reorganize index slot entries (simple version < 2048 lines)
***************************************************************
* bl @idx.entry.delete
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete
*--------------------------------------------------------------
idx.entry.delete._reorg.simple:
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
!       mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
        inct  tmp0                  ; Next index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed
        b     *r11                  ; Return to caller



***************************************************************
* idx.entry.delete
* Delete index entry - Close gap created by delete
***************************************************************
* bl @idx.entry.delete
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer to delete
* @parm2    = Line number of last line to check for reorg
*--------------------------------------------------------------
* Register usage
* tmp0,tmp2
*--------------------------------------------------------------
idx.entry.delete:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Get index slot
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer

        bl    @idx._samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page
        
        mov   @outparm1,tmp0        ; Index offset
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop         
        jeq   idx.entry.delete.lastline
                                    ; Special treatment if last line
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @parm2,tmp1
        ci    tmp1,2048             ; No more than 2048 lines in index
        jle   idx.entry.delete.reorg.simple
        ;------------------------------------------------------
        ; Call table
        ;------------------------------------------------------
idx.entry.delete.reorg.simple:
        bl    @idx.entry.delete._reorg.simple                                          
        jmp   idx.entry.delete.lastline
        ;------------------------------------------------------
        ; Last line 
        ;------------------------------------------------------      
idx.entry.delete.lastline:
        clr   @idx.top(tmp0)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
