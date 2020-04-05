/*
 * Created:  Sat 04 Apr 2020 10:57:02 AM PDT
 * Modified: Sun 05 Apr 2020 02:00:08 PM PDT
 *
 * Copyright (c) 2020, Robert Gill
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <winspool.h>

#include "pluginapi.h"
#include "select.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * string_size is a parameter passed to NSIS plugin functions,
 * the BUF_SIZE macro should only be used within those.
 */
#define BUF_SIZE (string_size * sizeof(TCHAR))

#define MAX(a,b) (((a)>(b))?(a):(b))

static HINSTANCE g_hInstance;
static HWND      g_hWnd;
static LPTSTR    g_Selection;

#define ERRBUF_SIZE 1024
static TCHAR errbuf[ERRBUF_SIZE];

static UINT_PTR
plugin_callback (enum NSPIM msg)
{
  return 0;
}

static void NSISCALL
pusherrmsg (LPCTSTR msg, DWORD err)
{
  TCHAR *p;
  int len;
  lstrcpy (errbuf, msg);

  if (err > 0)
    {
      lstrcat (errbuf, _T (": "));
      len = lstrlen (errbuf);
      FormatMessage (FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                     NULL, err, 0, errbuf + len,
                     (ERRBUF_SIZE - len) * sizeof (TCHAR), NULL);
    }

  p = errbuf + lstrlen(errbuf) - 1;
  while (p != errbuf && isspace(*p)) p--;
  if (p != errbuf) *(p + 1) = '\0';

  pushstring (errbuf);
}

static INT_PTR CALLBACK
select_dialog_proc (HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
  unsigned int idx, len;

  static HWND hwndParent;
  static HWND hCombo;

  switch (msg)
    {
    case WM_INITDIALOG:
      hwndParent = (HWND) lParam;
      hCombo = GetDlgItem (hwnd, IDC_COMBO);
      SendMessage (hCombo, CB_RESETCONTENT, 0, 0);
      SendMessage (hCombo, CB_SETCURSEL, 0, 0);
      return TRUE;

    case WM_SHOWWINDOW:
      if (wParam == TRUE)
        EnableWindow (hwndParent, FALSE);
      else
        EnableWindow (hwndParent, TRUE);
      return TRUE;

    case WM_COMMAND:
      if (LOWORD (wParam) == IDOK)
        {
          idx = SendMessage (hCombo, CB_GETCURSEL, 0, 0);
          len = SendMessage (hCombo, CB_GETLBTEXTLEN, idx, 0);
          g_Selection = GlobalAlloc (GPTR, (len + 1) * sizeof (TCHAR));
          SendMessage (hCombo, CB_GETLBTEXT, idx, (LPARAM) g_Selection);
          SendMessage (hwnd, WM_CLOSE, 0, 0);
          return TRUE;
        }
      return FALSE;

    case WM_CLOSE:
      EnableWindow (hwndParent, TRUE);
      DestroyWindow (hwnd);
      return TRUE;

    case WM_DESTROY:
      g_hWnd = NULL;
      hCombo = NULL;
      return FALSE;

    default:
      return FALSE;
    }
}

void DLLEXPORT
nsCreateSelectDialog (HWND hwndParent, int string_size, LPTSTR variables,
                      stack_t **stacktop, extra_parameters *extra)
{
  EXDLL_INIT ();
  if (g_hWnd != NULL)
    {
      pusherrmsg (_T ("Dialog already created"), 0);
      pushint (0);
      return;
    }

  extra->RegisterPluginCallback (g_hInstance, plugin_callback);
  g_hWnd = CreateDialogParam (g_hInstance,
                              MAKEINTRESOURCE (IDD_SELECT),
                              hwndParent,
                              select_dialog_proc,
                              (LPARAM) hwndParent);

  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Unable to create dialog"), GetLastError ());
      pushint (0);
      return;
    }

  pushint (1);
}

void DLLEXPORT
nsSelectDialogSetTitle (HWND hwndParent, int string_size, LPTSTR variables,
                        stack_t **stacktop, extra_parameters *extra)
{
  LPTSTR title;

  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  title = GlobalAlloc (GPTR, BUF_SIZE);
  popstring (title);

  if (!SetWindowText (g_hWnd, title))
    {
      pusherrmsg (_T ("Unable to set window title"), GetLastError ());
      pushint (0);
      goto cleanup;
    }

  pushint (1);

cleanup:
  GlobalFree (title);
}

void DLLEXPORT
nsSelectDialogSetText (HWND hwndParent, int string_size, LPTSTR variables,
                       stack_t **stacktop, extra_parameters *extra)
{
  LPTSTR text;
  HWND hText;

  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  hText = GetDlgItem (g_hWnd, IDC_TEXT);
  if (hText == NULL)
    {
      pusherrmsg (_T ("Unable to find text control"), 0);
      pushint (0);
      return;
    }

  text = GlobalAlloc (GPTR, BUF_SIZE);
  popstring (text);

  if (!SetWindowText (hText, text))
    {
      pusherrmsg (_T ("Unable to set window text"), GetLastError ());
      pushint (0);
      goto cleanup;
    }

  pushint (1);

cleanup:
  GlobalFree (text);
}

void DLLEXPORT
nsSelectDialogAddItem (HWND hwndParent, int string_size, LPTSTR variables,
                       stack_t **stacktop, extra_parameters *extra)
{
  LPTSTR buf;
  LRESULT rv;
  HWND hCombo;

  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  hCombo = GetDlgItem (g_hWnd, IDC_COMBO);
  if (hCombo == NULL)
    {
      pusherrmsg (_T ("Unable to find combo box control"), GetLastError ());
      pushint (0);
      return;
    }

  buf = GlobalAlloc (GPTR, BUF_SIZE);
  popstring (buf);
  rv = SendMessage (hCombo, CB_ADDSTRING, 0, (LPARAM) buf);
  switch (rv)
    {
    case CB_ERR:
      pusherrmsg (_T ("Error adding item to combo box"), GetLastError ());
      pushint (0);
      goto cleanup;

    case CB_ERRSPACE:
      pusherrmsg (_T ("Insufficient space"), 0);
      pushint (0);
      goto cleanup;

    default:;
      /* do nothing */
    }

  pushint (1);

cleanup:
  GlobalFree (buf);
}

void DLLEXPORT
nsSelectDialogSetSelection (HWND hwndParent, int string_size,
                            LPTSTR variables, stack_t **stacktop,
                            extra_parameters *extra)
{
  LPTSTR arg, item;
  LRESULT cnt, len, maxlen;
  HWND hCombo;
  unsigned int i;

  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  hCombo = GetDlgItem (g_hWnd, IDC_COMBO);
  if (hCombo == NULL)
    {
      pusherrmsg (_T ("Unable to find combo box"), GetLastError ());
      pushint (0);
      return;
    }

  arg = GlobalAlloc (GPTR, BUF_SIZE);
  item = GlobalAlloc (GPTR, BUF_SIZE);
  popstring (arg);

  cnt = SendMessage (hCombo, CB_GETCOUNT, 0, 0);
  if (cnt == CB_ERR)
    {
      pusherrmsg (_T ("Unable to get combo box count"), GetLastError ());
      pushint (0);
      goto cleanup;
    }

  maxlen = BUF_SIZE;
  for (i = 0; i < cnt; i++)
    {
      len = SendMessage (hCombo, CB_GETLBTEXTLEN, i, 0);
      len = (len + 1) * sizeof (TCHAR);
      if (len > maxlen)
        {
          maxlen = len;
          item = GlobalReAlloc (item, maxlen, 0);
        }
      SendMessage (hCombo, CB_GETLBTEXT, i, (LPARAM) item);
      if (lstrcmpi (arg, item) == 0)
        {
          SendMessage (hCombo, CB_SETCURSEL, i, 0);
          break;
        }
    }

  pushint (1);

cleanup:
  GlobalFree (arg);
  GlobalFree (item);
}

void DLLEXPORT
nsShowSelectDialog (HWND hwndParent, int string_size, LPTSTR variables,
                    stack_t **stacktop, extra_parameters *extra)
{
  MSG msg;

  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  ShowWindow (g_hWnd, SW_SHOWNORMAL);
  while (g_hWnd)
    {
      GetMessage (&msg, NULL, 0, 0);
      if (!IsDialogMessage (g_hWnd, &msg))
        {
          TranslateMessage (&msg);
          DispatchMessage (&msg);
        }
    }

  pushstring (g_Selection);
  pushint (1);
}

void DLLEXPORT
nsDestroySelectDialog (HWND hwndParent, int string_size, LPTSTR variables,
                       stack_t **stacktop, extra_parameters *extra)
{
  EXDLL_INIT ();
  if (g_hWnd == NULL)
    {
      pusherrmsg (_T ("Dialog has not been created"), 0);
      pushint (0);
      return;
    }

  DestroyWindow (g_hWnd);
  g_hWnd = NULL;
  pushint (1);
}

BOOL WINAPI
DllMain (HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  g_hInstance = hinstDLL;
  return TRUE;
}

#ifdef __cplusplus
} /* extern "C" */
#endif
