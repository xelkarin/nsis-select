#
# Created:  Sat 04 Apr 2020 12:09:58 PM PDT
# Modified: Sat 04 Apr 2020 12:56:40 PM PDT
#
# Copyright (c) 2020, Robert Gill
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

DLLNAME = Select.dll
CCPATH  = /usr/bin
HOST = i686-w64-mingw32
CC = $(CCPATH)/$(HOST)-gcc
RC = $(CCPATH)/$(HOST)-windres

CFLAGS = -Wall -march=i686 -Os -fomit-frame-pointer
EXTRA_LDFLAGS := $(LDFLAGS)
override LDFLAGS := -s $(EXTRA_LDFLAGS)

ifdef DEBUG
CFLAGS  = -Wall -march=i686 -Og -g3 $(EXTRA_CFLAGS)
override LDFLAGS  =
override LDFLAGS := $(EXTRA_LDFLAGS)
endif

CPPFLAGS += -DNSISCALL="__attribute__((__stdcall__))"
override LDFLAGS += -mwindows -Wl,--kill-at -static-libgcc -shared
UNICODE_CPPFLAGS = -DUNICODE -D_UNICODE
UNICODE_LDFLAGS  = -municode

OBJECTS = pluginapi.o select.o select.res

ANSI_OUTDIR = ../nsis/plugins/x86-ansi
ANSI_DLL = $(ANSI_OUTDIR)/$(DLLNAME)
ANSI_OBJDIR = .obj/ansi
ANSI_OBJECTS = $(foreach O,$(OBJECTS),$(ANSI_OBJDIR)/$O)

UNICODE_OUTDIR = ../nsis/plugins/x86-unicode
UNICODE_DLL = $(UNICODE_OUTDIR)/$(DLLNAME)
UNICODE_OBJDIR = .obj/unicode
UNICODE_OBJECTS = $(foreach O,$(OBJECTS),$(UNICODE_OBJDIR)/$O)

.SUFFIXES: .rc .res

all: ansi unicode

ansi: $(ANSI_DLL)

unicode: $(UNICODE_DLL)

$(ANSI_DLL): $(ANSI_OBJECTS)
	$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@

$(UNICODE_DLL): $(UNICODE_OBJECTS)
	$(CC) $^ $(UNICODE_LDFLAGS) $(LDFLAGS) $(LDLIBS) -o $@

$(ANSI_OBJDIR)/%.o: %.c | .obj/ansi
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(ANSI_OBJDIR)/%.res: %.rc | .obj/ansi
	$(RC) $(CPPFLAGS) -O coff -o $@ $<

$(UNICODE_OBJDIR)/%.o: %.c | .obj/unicode
	$(CC) $(CFLAGS) $(CPPFLAGS) $(UNICODE_CPPFLAGS) -c $< -o $@

$(UNICODE_OBJDIR)/%.res: %.rc | .obj/unicode
	$(RC) $(CPPFLAGS) $(UNICODE_CPPFLAGS) -O coff -o $@ $<

.obj/ansi:
	-mkdir -p .obj/ansi

.obj/unicode:
	-mkdir -p .obj/unicode

clean:
	-rm -f $(ANSI_DLL) $(UNICODE_DLL)
	-rm -rf .obj

.PHONY: all clean ansi unicode
