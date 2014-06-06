

all : warp warpdrive

clean :
	rm -rf warp warpdrive

warp : 
	gdc -O3 -frelease -fno-bounds-check -fbuiltin \
	cmdline.d constexpr.d context.d directive.d expanded.d file.d \
	id.d lexer.d loc.d macros.d main.d number.d outdeps.d ranges.d skip.d \
	sources.d stringlit.d textbuf.d charclass.d \
	-o warp

warpdrive : 
	gdc -O3 -frelease -fno-bounds-check -fbuiltin -m64  \
	warpdrive.d -o warpdrive
