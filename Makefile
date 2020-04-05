#
# Created:  Sat 04 Apr 2020 12:16:00 PM PDT
# Modified: Sat 04 Apr 2020 12:38:50 PM PDT
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

PACKAGE = nsis-select
PACKAGE_VERSION = 0.0.1

DISTFILE = $(PACKAGE)-$(PACKAGE_VERSION).zip
BINDISTFILE = $(PACKAGE)-$(PACKAGE_VERSION)-bin.zip
DISTDIR = ./$(PACKAGE)-$(PACKAGE_VERSION)
NSIS_HEADER = nsis/include/Select.nsh

all:
	$(MAKE) -C src

dist: clean
	mkdir -p $(DISTDIR)
	find . -not -name '.' \
		-not -wholename './.git*' \
		-not -wholename './src/.obj*' \
		-not -wholename '$(DISTDIR)*' \
		-type d -exec mkdir $(DISTDIR)/{} \;
	find . -not -name '.' \
		-not -name 'Select.dll' \
		-not -wholename './.git*' \
		-not -wholename './src/.obj*' \
		-not -wholename '$(DISTDIR)*' \
		-type f -exec cp {} $(DISTDIR)/{} \;
	7z -tzip -mx=9 a $(DISTFILE) $(DISTDIR)
	-rm -rf $(DISTDIR)

bin-dist: clean all
	mkdir -p $(DISTDIR)
	find . -not -name '.' \
		-not -wholename './.git*' \
		-not -wholename './src' \
		-not -wholename './src/*' \
		-not -wholename '$(DISTDIR)*' \
		-type d -exec mkdir $(DISTDIR)/{} \;
	find . -not -name '.' \
		-not -name 'Makefile' \
		-not -name '.keep' \
		-not -wholename './.git*' \
		-not -wholename './src/*' \
		-not -wholename '$(DISTDIR)*' \
		-type f -exec cp {} $(DISTDIR)/{} \;
	7z -tzip -mx=9 a $(BINDISTFILE) $(DISTDIR)
	-rm -rf $(DISTDIR)

clean:
	$(MAKE) -C src clean
	rm -rf $(DISTDIR)
	-rm -f $(DISTFILE)
	-rm -f $(BINDISTFILE)

.PHONY: all clean dist bin-dist
