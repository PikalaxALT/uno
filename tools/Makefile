.PHONY: all clean

CC := gcc
CFLAGS := -O3 -std=c99 -Wall -Wextra -Wno-missing-field-initializers

tools := \
	lzcomp \
	png_dimensions \
	scaninc \
	palette \
	gfx \
	md5
all: $(tools)
	@:

clean:
	rm -f $(tools)

gfx md5: common.h

%: %.c
	$(CC) $(CFLAGS) -o $@ $<
