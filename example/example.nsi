;
; Created:  Sun 05 Apr 2020 02:41:07 PM PDT
; Modified: Sun 05 Apr 2020 02:45:48 PM PDT
;
; Copyright (c) 2020, Robert Gill
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
;

!ifdef PLUGIN_DIR
!addplugindir /x86-unicode "${PLUGIN_DIR}"
!endif

!ifdef INCLUDE_DIR
!addincludedir "${INCLUDE_DIR}"
!endif

!include "Select.nsh"
Unicode true

Name "Select"
Caption "Select Pop-Up Dialog Example"
ShowInstDetails show

Section
  DetailPrint "Creating dialog"
  ${CreateSelectDialog} $0 $1
  StrCmp $0 "1" +3
  DetailPrint "Failed to create dialog: $1"
  Abort

  DetailPrint "Adding items"
  Push "Item 3"
  Push "Item 2"
  Push "Item 1"

  StrCpy $4 "3"
Loop:
  Pop $3
  ${SelectDialogAddItem} "$3" $0 $1
  StrCmp $0 "1" +3
  DetailPrint "Failed to add dialog item: $1"
  Abort

  IntOp $4 $4 - 1
  StrCmp $4 "0" +2
  Goto Loop

  ${SelectDialogSetSelection} "Item 1" $0 $1
  StrCmp $0 "1" +3
  DetailPrint "Failed to set current selection: $1"
  Abort

  DetailPrint "Showing dialog"
  ${ShowSelectDialog} $0 $1
  StrCmp $0 "1" +3
  DetailPrint "Failed to show dialog: $1"
  Abort

  DetailPrint "Done"
  DetailPrint "Selection: $1"
SectionEnd
