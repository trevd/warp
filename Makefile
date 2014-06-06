
GDC ?= gdc
DFLAGS += -O3 -frelease -fno-bounds-check -fbuiltin

all : warp warpdrive

clean :
	rm -rf warp warpdrive

warp : 
	$(GDC) $(DFLAGS) \
	cmdline.d constexpr.d context.d directive.d expanded.d file.d \
	id.d lexer.d loc.d macros.d main.d number.d outdeps.d ranges.d skip.d \
	sources.d stringlit.d textbuf.d charclass.d \
	-o warp

warpdrive : 
	$(GDC) $(DFLAGS)  \
	warpdrive.d -o warpdrive
