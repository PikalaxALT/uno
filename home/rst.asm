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
