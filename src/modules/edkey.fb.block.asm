* FILE......: edkey.fb.block.asm
* Purpose...: Mark lines for block operations

*---------------------------------------------------------------
* Mark line M1
********|*****|*********************|**************************
edkey.action.block.mark.m1:
        bl    @edb.block.mark.m1    ; Set M1 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.mark.m1.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
        


*---------------------------------------------------------------
* Mark line M2
********|*****|*********************|**************************
edkey.action.block.mark.m2:
        bl    @edb.block.mark.m2    ; Set M2 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.mark.m2.exit:
        b     @hook.keyscan.bounce  ; Back to editor main





*---------------------------------------------------------------
* Copy code block
********|*****|*********************|**************************
edkey.action.block.copy:
        bl    @edb.block.copy       ; Copy code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.copy.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete code block
********|*****|*********************|**************************
edkey.action.block.delete:
        bl    @edb.block.delete     ; Delete code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.delete.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
