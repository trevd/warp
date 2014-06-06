# Figure out which compiler to use (prefer gdc, fall back to dmd).
ifeq (,$(DC))
	DC:=$(shell which gdc 2>/dev/null)
ifeq (,$(DC))
	DC:=dmd
endif
endif

ifeq (gdc,$(notdir $(DC)))
	DFLAGS=
	OFSYNTAX=-o
else
ifeq (dmd,$(notdir $(DC)))
	DFLAGS=-c -O -inline -release
else
    $(error Unsupported compiler: $(DC))
endif
endif

CC=cc
CXX=c++
CFLAGS=
CXXFLAGS=
# warp sources
SRCS=

# Binaries generated
BIN:=warp $(WARPDRIVE)

# Rules

all : warp warpdrive

clean :
	rm -rf warp warpdrive warp.o warpdrive.o

warp : 
	gdc -O2 -frelease -fno-bounds-check -fbuiltin \
	cmdline.d constexpr.d context.d directive.d expanded.d file.d \
	id.d lexer.d loc.d macros.d main.d number.d outdeps.d ranges.d skip.d \
	sources.d stringlit.d textbuf.d charclass.d \
	-o warp

warpdrive : 
	gdc  -O2 -frelease -fno-bounds-check -fbuiltin -m64 -L/usr/lib/x86_64-linux-gnu -Xlinker --export-dynamic \
	-lphobos2 -lpthread -ltango-dmd -lm -lrt \
	warpdrive.d -o warpdrive
