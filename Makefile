ASM  := rgbasm
LINK := rgblink
GFX  := rgbgfx
FIX  := rgbfix
MD5  := md5sum -c

ASMFLAGS :=

SCANINC := tools/scaninc

SOURCES := \
	home.asm \
	main.asm \
	wram.asm

OBJS := $(SOURCES:%.asm=%.o)

ROM := uno.gbc
MAP := $(ROM:%.gbc=%.map)
SYM := $(ROM:%.gbc=%.sym)

ROM_CODE  := AUNE
ROM_TITLE := UNO

.PHONY: all tools clean compare
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:

all: $(ROM)

tools:
	@$(MAKE) -C tools/

compare: $(ROM)
	$(MD5) rom.md5

clean:
	$(RM) $(ROM) $(MAP) $(SYM) $(OBJS)
	$(MAKE) clean -C tools/

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
define DEP
$1: $2 $$(shell tools/scaninc $2)
	$$(ASM) $$(ASMFLAGS) -L -o $$@ $$<
endef

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))
$(foreach obj, $(OBJS), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))

endif

$(ROM): $(OBJS)
	$(LINK) -n $(SYM) -m $(MAP) -o $@ $(OBJS)
	$(FIX) -cjv -i $(ROM_CODE) -t $(ROM_TITLE) -k 58 -m 0x19 -l 0x33 -r 0 -p 0 $@
