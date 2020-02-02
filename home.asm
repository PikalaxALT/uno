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
	ds $150-$104

SECTION "Start",ROM0[$150]
_start::
	di
	ld hl, $c400
	ld sp, hl
	call sub_0243
	di
	ld hl, $c400
	ld sp, hl
	call $045c
	call sub_0228
	call sub_025c
	call $139c
	call $138c
	ld a, $00
	ldh [$ff47], a
	ldh [$ff48], a
	ldh [$ff49], a
._0174:
	call $0361
	ld a, [$cf49]
	or a
	jr nz, ._0174
._017d:
	ldh a, [$ff44]
	cp $90
	jr nc, ._017d
	ld a, $00
	ldh [$ff40], a
	ld a, $00
	ldh [$ff42], a
	ldh [$ff43], a
	ld a, $40
	ldh [$ff41], a
	ld a, $50
	ldh [$ff45], a
	ld a, $01
	ldh [$ffff], a
	ld a, $2d
	ldh [$ff47], a
	ldh [$ff48], a
	ldh [$ff49], a
	ld a, [$0143]
	bit 7, a
	ld a, $01
	jr z, ._01ac
	or $80
._01ac:
	ld a, $01
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f00
	pop af
	di
	ld [$2000], a
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
	ldh [$ff40], a
	ld a, $40
	ldh [$ff45], a
	ld a, $44
	ldh [$ff41], a
	ld a, $03
	or $08
	or $04
	or $10
	ldh [$ffff], a
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
	call $02a7
	ei
._0209:
	call sub_027c
	call $3447
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
	ldh [$ff06], a
	ld a, $04
	ldh [$ff07], a
	ret

sub_0228::
	ld a, [$cf95]
	or a
	jr nz, ._0242
	ld hl, $ff4d
	bit 7, [hl]
	jr nz, ._0242
	set 0, [hl]
	xor a
	ldh [$ff0f], a
	ldh [$ffff], a
	ld a, $30
	ldh [$ff00], a
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
	ld hl, $c400
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
	call $0361
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
	ld a, $80
	ldh [$ff68], a
	ld b, $40
	xor a
	dec a
._02af:
	ldh [$ff69], a
	dec b
	jr nz, ._02af
	ld a, $80
	ldh [$ff6a], a
	ld b, $40
	xor a
	dec a
._02bc:
	ldh [$ff6b], a
	dec b
	jr nz, ._02bc
	ret

INCBIN "baserom.gbc",$2c2,$03a9-$2c2

VBlankInterrupt:: ; $03a9
INCBIN "baserom.gbc",$03a9,$0431-$03a9

HBlankInterrupt:: ; $0431
INCBIN "baserom.gbc",$0431,$0434-$0431

TimerInterrupt:: ; $0434
INCBIN "baserom.gbc",$0434,$0436-$0434

SerialInterrupt:: ; $0436
INCBIN "baserom.gbc",$0436,$0443-$0436

JoypadInterrupt:: ; $0443
INCBIN "baserom.gbc",$0443,$4000-$0443
