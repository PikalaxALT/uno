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
sub_0158::
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

sub_0361::
	ld a, $20
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and $0f
	swap a
	ld b, a
._036f: ;Jump
	ld a, $10
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and $0f
	or b
	ld c, a
	ld a, [$cf49]
	xor c
	and c
	ld [$cf4a], a
	ld a, c
	ld [$cf49], a
	ld a, $30
	ldh [rJOYP], a
	ret
	
sub_0395::
	ld a, [$d555]
	ldh [rBGP], a
	ld a, [$d556]
	ldh [rOBP0], a
	ld a, [$d557]
	ldh [rOBP1], a
	xor a
	ld [$d554], a
	ret
	
VBlankInterrupt:: ; $03a9
	push af
	push bc
	push de
	push hl
	ld a, [$cea2]
	or a
	jr z, ._03b6
	call $ff80

._03b6:
	ld a, [$cea3]
	or a
	call nz, sub_02c2
	ld a, [$cea4]
	or a
	call nz, sub_02a7
	ld a, [$d554]
	or a
	call nz, sub_0395
	ld a, [$cf98]
	or a
	jr nz, ._03d7
	ldh a, [rLCDC]
	res 3, a
	jr ._03db
._03d7:
	ldh a, [rLCDC]
	set 3, a
._03db:
	ldh [rLCDC], a
	nop
	ei
	xor a
	ld [$cea3], a
	ld [$cea4], a
	ld [$d399], a
	ld a, [$cec9]
	inc a
	ld [$cec9], a
	ld a, [$cf97]
	inc a
	ld [$cf97], a
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f09
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d24a]
	or a
	jr z, ._0421
	dec a
	ld [$d24a], a
._0421:
	ld hl, $d24e
	inc [hl]
	jr nz, ._0429
	inc hl
	inc [hl]
._0429:
	call sub_1273
	pop hl
	pop de
	pop bc
	pop af
	reti

HBlankInterrupt:: ; $0431
	push af
	pop af
	reti

TimerInterrupt:: ; $0434
	ei
	reti

SerialInterrupt:: ; $0436
	push af
	push bc
	push de
	push hl
	ei
	call sub_13c6
	pop hl
	pop de
	pop bc
	pop af
	reti

JoypadInterrupt:: ; $0443
	push af
	ldh a, [rTIMA]
	ld [$d24d], a
	pop af
	reti
	ldh a, [rIE]
	push af
	and $fe
	ldh [rIE], a
	ldh a, [rLCDC]
	and $7f
	ldh [rLCDC], a
	pop af
	ldh [rIE], a
	ret

sub_045c::
	ldh a, [rIE]
	ld [$d3bf], a
	res 0, a
._0463:
	ldh a, [rLY]
	cp $91
	jr nz, ._0463
	ldh a, [rLCDC]
	and $7f
	ldh [rLCDC], a
	ld a, [$d3bf]
	ldh [rIE], a
	ret
	
sub_0475::
	inc b
	inc c
	jr ._047c
._0479:
	ld a, [hl+]
	ld [de], a
	inc de
._047c:
	dec c
	jr nz, ._0479
	dec b
	jr nz, ._0479
	ret

sub_0483::
	ld h, $05
	daa
	ld [hl+], a
	ld b, $39
	dec e
	ld a, [bc]
	add hl, hl
	dec b
	dec l
	rla
	inc b
	nop
	dec a

sub_0492::
	ld c, $0e
	ld de, $7ca8
	
sub_0497::
	ld hl, sp+$02
	ld a, [$cf8e]
	push af
	ld a, c
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld l, [hl]
	ld h, $00
	add hl, de
	ld e, [hl]
	pop af
	call sub_090c
	ret
	
sub_04b0::
	ld c, $0e
	ld de, $7da8
	jp sub_0497
	
sub_04b8::
	ld c, $0e
	ld de, $7ea8
	jp sub_0497
	push bc
	ld hl, sp+$04
	ld a, [hl+]
	ld d, [hl]
	ld e, a
	ld hl, sp+$06
	ld a, [hl+]
	ld b, [hl]
	ld c, a
._04cb:
	ld a, [de]
	inc de
	ld l, a
	ld a, [bc]
	inc bc
	cp l
	jr nz, ._04da
	or a
	jr nz, ._04cb
	ld e, $00
	jr ._04dc
._04da:
	ld e, $01
._04dc:
	pop bc
	ret

sub_04de::
	push bc
	ld hl, sp+$04
	ld a, [hl+]
	ld d, [hl]
	ld e, a
	ld hl, sp+$06
	ld a, [hl+]
	ld b, [hl]
	ld c, a
	push de
._04ea:
	ld a, [bc]
	ld [de], a
	inc de
	inc bc
	or a
	jr nz, ._04ea
	pop de
	pop bc
	ret

sub_04f4::
	push bc
	ld hl, sp+$04
	ld a, [hl+]
	ld d, [hl]
	ld e, a
	ld hl, sp+$06
	ld a, [hl+]
	ld b, [hl]
	ld c, a
	ld hl, sp+$08
	ld a, [hl+]
	ld h, [hl]
	ld l, a
	push hl
	push bc
	pop hl
	pop bc
._0508:
	ld a, [hl]
	ld [de], a
	inc hl
	inc de
	dec bc
	ld a, b
	or c
	jr nz, ._0508
	pop bc
	ret

sub_0513::
	ld a, [$d5bb]
	dec a
	ret z
._0518:
	ld a, $00
	ld b, $09
	ld c, $01
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f2a
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ret

sub_053f::
	ld a, [$d5bb]
	dec a
	ret z
._0544:
	ld hl, sp+$02
	ld a, [hl]
	ld b, $0f
	ld c, $01
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f2a
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ret

sub_056c::
	ld a, [$d5bc]
	dec a
	ret z
._0571:
	ld hl, sp+$02
	ld a, [hl]
	ld [$d3be], a
	ld [$d3c0], a
	ret

sub_057b::
	ld a, [$d5bc]
	dec a
	ret z
._0580:
	ld a, $fe
	ld [$d3be], a
	ld [$d3c0], a
	ret

sub_0589::
	ld a, [$d5bc]
	dec a
	jr nz, ._0595
	ld a, $fe
	ld [$d3c0], a
	ret
._0595:
	ld a, [$d3be]
	ld [$d3c0], a
	ret

sub_059c::
	ld a, [$d5bc]
	dec a
	ret z
._05a1:
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f12
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ret

sub_05c2::
	ld a, [$d5bc]
	dec a
	ret z
._05c7:
	ld [$d398], a
	ld a, [$cf8e]
	push af
	ld a, $01
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ld a, [$d398]
	call $7f15
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ret

sub_05e8::
	ld l, $1a
	call sub_0f22
	ld a, $80
	ld hl, $7a00
	ld bc, $0180
	ld de, $8800
	call sub_0f17
	call sub_0f32
	ret

sub_05ff::
	ld a, [$cf95]
	or a
	jr nz, ._061c
	ld l, $20
	call sub_0f22
	ld a, $80
	ld hl, $78ca
	ld bc, $0180
	ld de, $8000
	call sub_0f17
	call sub_0f32
	ret
._061c:
	ld l, $21
	call sub_0f22
	ld a, $80
	ld hl, $78a0
	ld bc, $0180
	ld de, $9000
	call sub_0f17
	call sub_0f32
	ret

sub_0633::
	ld l, $38
	call sub_0f22
	ld a, $80
	ld hl, $7aca
	ld bc, $011c
	ld de, $9370
	call sub_0f17
	call sub_0f32
	ret

sub_064a::
	ld l, $26
	call sub_0f22
	ld hl, $7848
	ld bc, $0118
	ld a, $80
	ld de, $8040
	call sub_0f17
	call sub_0f32
	ret

sub_0661::
	ld l, $28
	call sub_0f22
	ld hl, $7718
	ld bc, GBCLicense
	ld a, $80
	ld de, $8000
	call sub_0f17
	call sub_0f32
	ret

sub_0678::
	ld l, $0d
	call sub_0f22
	ld hl, $7d58
	ld bc, $0078
	ld a, $00
	ld de, $8600
	call sub_0f17
	call sub_0f32
	ret

sub_068f::
	ld hl, sp+$02
	ld a, [$cf8e]
	push af
	call sub_0719
	ld a, c
	ld [$cf53], a
	ld a, b
	ld [$cf54], a
	ld a, d
	ld [$cf93], a
	ld a, [$cf95]
	or a
	jr z, ._06b7
	ld a, $80
	ld bc, $0200
	ld de, $8800
	call sub_0f17
	jr ._06cd
._06b7:
	ld a, $00
	ld bc, $00ac
	ld de, $8350
	call sub_0f17
	ld a, $80
	ld bc, $01d4
	ld de, $88b0
	call sub_0f17
._06cd:
	ld l, $09
	call sub_0f22
	ld a, $80
	ld hl, $538a
	ld bc, $0010
	ld de, $8000
	call sub_0f17
	ld l, $09
	call sub_0f22
	ld a, $00
	ld hl, $538a
	ld bc, $0010
	ld de, $8000
	call sub_0f17
	ld l, $04
	call sub_0f22
	ld hl, $7f67
	ld bc, $0008
	ld de, $82f0
	ld a, [$cf95]
	or a
	jr z, ._070a
	ld de, $8780
._070a:
	ld a, $00
	call sub_0f17
	pop af
	di
	ld [$2000], a
	ld [$cf8e], a
	ei
	ret

sub_0719::
INCBIN "baserom.gbc",$0719,$0869-$0719

sub_0869::
INCBIN "baserom.gbc",$0869,$0909-$0869

sub_0909::
INCBIN "baserom.gbc",$0909,$090c-$0909

sub_090c::
INCBIN "baserom.gbc",$090c,$0a02-$090c

sub_0a02::
INCBIN "baserom.gbc",$0a02,$0b25-$0a02

sub_0b25::
INCBIN "baserom.gbc",$0b25,$0f17-$0b25

sub_0f17::
INCBIN "baserom.gbc",$0f17,$0f22-$0f17

sub_0f22::
INCBIN "baserom.gbc",$0f22,$0f32-$0f22

sub_0f32::
INCBIN "baserom.gbc",$0f32,$1273-$0f32

sub_1273::
INCBIN "baserom.gbc",$1273,$138c-$1273

sub_138c::
INCBIN "baserom.gbc",$138c,$139c-$138c

sub_139c::
INCBIN "baserom.gbc",$139c,$13c6-$139c

sub_13c6::
INCBIN "baserom.gbc",$13c6,$3447-$13c6

sub_3447::
INCBIN "baserom.gbc",$3447,$4000-$3447
