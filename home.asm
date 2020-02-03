INCLUDE "constants/hardware_constants.inc"

SECTION "RST00",ROM0[$00]
_rst00::
	jp _start ; $0150
	db $82, $28, $00, $e5, $82

SECTION "RST08",ROM0[$08]
_rst08::
	jp _start ; $0150
	db $36, $ff, $75, $ec, $2b

SECTION "RST10",ROM0[$10]
_rst10::
	jp _start ; $0150
	db $06, $00, $57, $a1, $8c

SECTION "RST18",ROM0[$18]
_rst18::
	jp _start ; $0150
	db $ff, $d0, $83, $c4, $08

SECTION "RST20",ROM0[$20]
_rst20::
	jp _start ; $0150
	db $e8, $a1, $90, $c9, $06

SECTION "RST28",ROM0[$28]
_rst28::
	jp _start ; $0150
	db $39, $7d, $ec, $74, $33

SECTION "RST30",ROM0[$30]
_rst30::
	jp _start ; $0150
	db $8d, $5c, $08, $ff, $39

SECTION "RST38",ROM0[$38]
_rst38::
	jp _start ; $0150
	db $90, $8a, $0b, $88, $4d

SECTION "VBlankIntr",ROM0[$40]
_vblank_intr::
	jp VBlankInterrupt ; $03a9
	db $89, $de, $eb, $07, $90

SECTION "HBlankIntr",ROM0[$48]
_hblank_intr::
	jp HBlankInterrupt ; $0431
	db $02, $89, $f2, $2b, $35

SECTION "TimerIntr",ROM0[$50]
_timer_intr::
	jp TimerInterrupt ; $0434
	db $00, $39, $fe, $73, $f0

SECTION "SerialIntr",ROM0[$58]
_serial_intr::
	jp SerialInterrupt ; 0436
	db $88, $0a, $4b, $39, $5d

SECTION "JoypadIntr",ROM0[$60]
_joypad_intr::
	jp JoypadInterrupt ; $443
	db $8b, $7d, $ec, $03, $3d

INCBIN "baserom.gbc",$68,$100-$68

SECTION "Header",ROM0[$100]
_init::
	nop
	jp _start ; $0150
SECTION "Cart Header", ROM0 [$104]
NintendoLogo: ; 104
	ds $30
NintendoLogoEnd ; 134

ROMHeader: ; 134
ROMTitle:
	ds $0f
GBCFlags: ; 143
	ds $1
GBCLicense: ; 144
	ds $2
SGBFlag: ; 146
	ds $1
MBCType: ; 147
	ds $1
ROMSize: ; 148
	ds $1
RAMSize: ; 149
	ds $1
DestCode: ; 14a
	ds $1
OldLicense: ; 14b
	ds $1
VersionNumber:
	ds $1
ROMHeaderEnd
HeaderChecksum:
	ds $1
GlobalChecksum:
	ds $2

SECTION "Start",ROM0[$150]
_start::
	di
	ld hl, wc400
	ld sp, hl
	call sub_0243
	di
	ld hl, wc400
	ld sp, hl
	call sub_045c
	call sub_0228
	call sub_025c
	call sub_139c
	call sub_138c
	ld a, $00
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
._0174:
	call sub_0361
	ld a, [$cf49]
	or a
	jr nz, ._0174
._017d:
	ldh a, [rLY]
	cp $90
	jr nc, ._017d
	ld a, $00
	ldh [rLCDC], a
	ld a, $00
	ldh [rSCY], a
	ldh [rSCX], a
	ld a, $40
	ldh [rSTAT], a
	ld a, $50
	ldh [rLYC], a
	ld a, $01
	ldh [rIE], a
	ld a, $2d
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	ld a, [GBCFlags]
	bit 7, a
	ld a, $01
	jr z, ._01ac
	or $80
._01ac:
	ld a, $01
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, BANK(sub_7f00)
	di
	ld [MBC5RomBank], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call sub_7f00
	pop af
	di
	ld [MBC5RomBank], a
	ld [$cf8e], a
	ei
	ld a, $00
	call sub_021f
	ld a, [$cf95]
	or a
	ld e, $83
	jr nz, ._01dd
	ld e, $93
._01dd:
	ld a, e
	ldh [rLCDC], a
	ld a, $40
	ldh [rLYC], a
	ld a, $44
	ldh [rSTAT], a
	ld a, $03
	or $08
	or $04
	or $10
	ldh [rIE], a
	ld a, $00
	ld [$cf52], a
	ld c, $0a
	ld hl, $ff80
	ld de, sub_0252
._01ff:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, ._01ff
	call sub_02a7
	ei
._0209:
	call sub_027c
	call sub_3447
._020f:
	ld a, [$cec9]
	or a
	jr z, ._020f
	ld [$ceca], a
	xor a
	ld [$cec9], a
	jp ._0209

sub_021f::
	ld a, $9c
	ldh [rTMA], a
	ld a, 1 << rTAC_ON
	ldh [rTAC], a
	ret

sub_0228::
	ld a, [$cf95]
	or a
	jr nz, ._0242
	ld hl, rKEY1
	bit 7, [hl]
	jr nz, ._0242
	set 0, [hl]
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ld a, $30
	ldh [rJOYP], a
	stop
._0242:
	ret

sub_0243::
	ld e, $00
	cp $11
	ld [$cf96], a
	jr z, ._024d
	inc e
._024d:
	ld a, e
	ld [$cf95], a
	ret

sub_0252::
	ld a, $cc
	ldh [$ff46], a
	ld a, $28
._0258:
	dec a
	jr nz, ._0258
	ret

sub_025c::
	pop de
	ld hl, wc400
	ld a, [$cf96]
	push af
	ld a, [$cf95]
	push af
	ld bc, $1c00
._026b:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, ._026b
	pop af
	ld [$cf95], a
	pop af
	ld [$cf96], a
	push de
	ret

sub_027c::
	call sub_0361
	call sub_0283
	ret

sub_0283::
	ld a, [$cf4a]
	and $f0
	jr z, ._0296
	ld a, $11
._028c:
	ld [$cf91], a
	ld a, [$cf49]
._0292:
	ld [$cf90], a
	ret
._0296:
	ld a, [$cf91]
	or a
	jr nz, ._02a0
	ld a, $05
	jr ._028c
._02a0:
	dec a
	ld [$cf91], a
	xor a
	jr ._0292
sub_02a7::
	ld a, $80
	ldh [rBGPI], a
	ld b, $40
	xor a
	dec a
._02af:
	ldh [rBGPD], a
	dec b
	jr nz, ._02af
	ld a, $80
	ldh [rOBPI], a
	ld b, $40
	xor a
	dec a
._02bc:
	ldh [rOBPD], a
	dec b
	jr nz, ._02bc
	ret

sub_02c2::
	ld a, $80
	ldh [rBGPI], a
	ld hl, $cda0
	ld b, $40
._02cb:
	ld a, [hli]
	ldh [rBGPD], a
	dec b
	jr nz, ._02cb
	ld a, $80
	ldh [rOBPI], a
	ld hl, $cde0
	ld b, $40
._02da:
	ld a, [hli]
	ldh [rOBPD], a
	dec b
	jr nz, ._02da
	ret

INCBIN "baserom.gbc",$02e1,$0361-$02e1

sub_0361:: ; $0361
INCBIN "baserom.gbc",$0361,$03a9-$0361

VBlankInterrupt:: ; $03a9
INCBIN "baserom.gbc",$03a9,$0431-$03a9

HBlankInterrupt:: ; $0431
INCBIN "baserom.gbc",$0431,$0434-$0431

TimerInterrupt:: ; $0434
INCBIN "baserom.gbc",$0434,$0436-$0434

SerialInterrupt:: ; $0436
INCBIN "baserom.gbc",$0436,$0443-$0436

JoypadInterrupt:: ; $0443
INCBIN "baserom.gbc",$0443,$045c-$0443

sub_045c::
INCBIN "baserom.gbc",$045c,$138c-$045c

sub_138c::
INCBIN "baserom.gbc",$138c,$139c-$138c

sub_139c::
INCBIN "baserom.gbc",$139c,$3447-$139c

sub_3447::
INCBIN "baserom.gbc",$3447,$4000-$3447
