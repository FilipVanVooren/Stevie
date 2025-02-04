* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.

*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        ;-------------------------------------------------------
        ; Show dialog "unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   !
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Quit Stevie
        ;-------------------------------------------------------
!       b     @tv.quit


*---------------------------------------------------------------
* Copy code block or open "Insert from clipboard" dialog
*---------------------------------------------------------------
edkey.action.copyblock_or_clipboard:
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   !
        b     @edkey.action.block.copy
                                    ; Copy code block
!       b     @dialog.clipboard     ; Open "Insert from clipboard" dialog


*---------------------------------------------------------------
* Reset results of find operation
*---------------------------------------------------------------
edkey.action.find.reset:
        bl    @edb.find.init        ; Reset search results
        seto  @fb.dirty             ; Frame buffer dirty        
        seto  @fb.status.dirty      ; Trigger status lines update
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.find.reset.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main        
