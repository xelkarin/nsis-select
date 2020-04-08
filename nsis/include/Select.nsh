;
; Created:  Sat 04 Apr 2020 12:31:06 PM PDT
; Modified: Mon 06 Apr 2020 08:28:42 PM PDT
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

!ifndef __SELECT_NSH__
!define __SELECT_NSH__

;;
; === CreateSelectDialog
;
; *Usage:* `${CreateSelectDialog} RET ERR`
;
; Creates a `SelectDialog`, which then may be updated with additional function
; calls (add items, set text, etc.). This function must be called before any of
; the following functions. The `SelectDialog` may then be shown by calling the
; `ShowSelectDialog` function.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _CreateSelectDialog _RET _ERR
StrCpy ${_ERR} ""
Select::nsCreateSelectDialog
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define CreateSelectDialog "!insertmacro _CreateSelectDialog"

;;
; === SelectDialogSetTitle
;
; *Usage:* `${SelectDialogSetTitle} TITLE RET ERR`
;
; Set the ``SelectDialog``'s title to `TITLE`.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _SelectDialogSetTitle _TITLE _RET _ERR
StrCpy ${_ERR} ""
Push "${_TITLE}"
Select::nsSelectDialogSetTitle
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define SelectDialogSetTitle "!insertmacro _SelectDialogSetTitle"

;;
; === SelectDialogSetText
;
; *Usage:* `${SelectDialogSetText} TEXT RET ERR`
;
; Set the ``SelectDialog``'s message text (displayed just above the selection
; combo box) to `TEXT`.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _SelectDialogSetText _TEXT _RET _ERR
StrCpy ${_ERR} ""
Push "${_TEXT}"
Select::nsSelectDialogSetText
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define SelectDialogSetText "!insertmacro _SelectDialogSetText"

;;
; === SelectDialogAddItem
;
; *Usage:* `${SelectDialogAddItem} ITEM RET ERR`
;
; Add `ITEM` to the ``SelectDialog``'s combo box. Call `SelectDialogAddItem`
; multiple times to add multiple items. Items added will appear in the
; ``SelectDialog``'s combo box list in the order they are added.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _SelectDialogAddItem _ITEM _RET _ERR
StrCpy ${_ERR} ""
Push "${_ITEM}"
Select::nsSelectDialogAddItem
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define SelectDialogAddItem "!insertmacro _SelectDialogAddItem"

;;
; === SelectDialogSetSelection
;
; *Usage:* `${SelectDialogSetSelection} ITEM RET ERR`
;
; Set the ``SelectDialog``'s current selection to `ITEM`. `ITEM` must have
; already been added to the `SelectDialog` via `SelectDialogAddItem`.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _SelectDialogSetSelection _ITEM _RET _ERR
StrCpy ${_ERR} ""
Push "${_ITEM}"
Select::nsSelectDialogSetSelection
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define SelectDialogSetSelection "!insertmacro _SelectDialogSetSelection"

;;
; === ShowSelectDialog
;
; *Usage:* `${ShowSelectDialog} RET RESULT`
;
; Show the `SelectDialog`. On success the selected item will be return in the
; variable specified by `RESULT`. The `SelectDialog` is destroyed upon
; completion of this function.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `RESULT` will contain the selected item, or an error message if an error
; occurs.
;
!macro _ShowSelectDialog _RET _RESULT
StrCpy ${_RESULT} ""
Select::nsShowSelectDialog
Pop ${_RET}
Pop ${_RESULT}
!macroend
!define ShowSelectDialog "!insertmacro _ShowSelectDialog"

;;
; === DestroySelectDialog
;
; *Usage:* `${DestroySelectDialog} RET ERR`
;
; Destroy the `SelectDialog` freeing up resources allocated. This should be
; used if for some reason `ShowSelectDialog` is never called.
;
; A return code is returned in the variable specified by `RET`. It will contain
; `0` if an error has occured, or `1` on success. The variable specified by
; `ERR` will contain the error message when an error occurs.
;
!macro _DestroySelectDialog _RET _ERR
StrCpy ${_ERR} ""
Select::nsDestroySelectDialog
Pop ${_RET}
StrCmp ${_RET} "1" +2
Pop ${_ERR}
!macroend
!define DestroySelectDialog "!insertmacro _DestroySelectDialog"

!endif ; __SELECT_NSH__
