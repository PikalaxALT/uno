ASM  := rgbasm
LINK := rgblink
GFX  := rgbgfx
FIX  := rgbfix
MD5  := md5sum -c

SOURCES := \
	home.asm \
	main.asm

OBJS := $(SOURCES:%.asm=%.o)

ROM := uno.gbc
MAP := $(ROM:%.gbc=%.map)
SYM := $(ROM:%.gbc=%.sym)

ROM_CODE  := AUNE
ROM_TITLE := UNO

.PHONY: all clean compare
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:

all: $(ROM)

compare: $(ROM)
	$(MD5) rom.md5

clean:
	$(RM) $(ROM) $(MAP) $(SYM) $(OBJS)

$(ROM): $(OBJS)
	$(LINK) -n $(SYM) -m $(MAP) -o $@ $(OBJS)
	$(FIX) -cjv -i $(ROM_CODE) -t $(ROM_TITLE) -k 58 -m 0x19 -l 0x33 -r 0 -p 0 $@

$(OBJS): %.o: %.asm
	$(ASM) -o $@ $<
