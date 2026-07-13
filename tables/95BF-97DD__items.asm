; --- WEAPON_DAMAGE --------------------------------------------
; @done
; One packed dice-spec byte per item id giving the weapon's damage roll,
; consumed by calc_attack_damage (.roll_damage). The byte splits as
; bits 5-7 = the dice-count field (b, which indexes DAMAGE_DICE_MASK $4D
; to fetch the per-die random mask c) and bits 0-4 = the faces/roll field
; (e = (byte & $1F)+1); the roll then does `GET_RND_NUMBERS; and c` and
; accumulates over the attack rounds. RLE-compressed ($FC,count,value;
; index >= $67 enables $FC decoding in lookup_addr_table). Leading DB 0 is
; padding: ADDR_TABLE stores WEAPON_DAMAGE+1, so item id N indexes from the
; following byte.
; Referenced by: ADDR_TABLE index $68 (INX_WEAPON_DAMAGE) - calc_attack_damage
		debug "WEAPON_DAMAGE: "
WEAPON_DAMAGE:
		DB 0
		DB 0,0,1,$20,0,1,$40,$20,$20,$FC,$0D,0,1,$FC,5,0
		DB $21,$FC,5,0,1,$20,$FC,6,0,4,5,$22,$40,0,$22,1
		DB $FC,4,0,$20,0,$41,$FC,5,0,1,$FC,5,0,$22,$23,4
		DB $21,2,2,$22,0,0,0,1,$FC,5,0,2,$23,4,$22,$41
		DB $FC,$0E,0,$22,$FC,7,0,3,0,$41,$22,0,2,$FC,$0A,0
		DB $43

; --- WEAPON_BONUS ---------------------------------------------
; @done
; One packed bonus byte per item id: the HIGH nibble is the weapon/item
; to-hit + damage bonus. calc_attack_damage reads WEAPON_BONUS[item]
; (GET_D_FROM_TABLE $73), takes divide_A_by_16 (= the high nibble) and
; adds it into the attack accumulator (also bumping VAR_WEAPON_BONUS). The
; low nibble is not used on the calc_attack_damage path. Same RLE-
; compressed, index-by-item-id layout as WEAPON_DAMAGE ($FC,count,value
; runs; leading DB 0 padding, base = LABEL+1).
; Referenced by: ADDR_TABLE index $73 (INX_WEAPON_BONUS) - calc_attack_damage
		debug "WEAPON_BONUS: "
WEAPON_BONUS:
		DB 0
		DB $FC,$0A,0,1,2,2,3,4,5,$FC,4,1,0,0,0,$10
		DB 3,4,5,0,4,$10,0,0,$10,2,2,$10,0,6,0,0
		DB 2,0,2,$20,$20,$10,$12,2,0,$20,4,$20,3,3,$20,$20
		DB 0,0,2,0,2,0,5,6,7,6,3,5,2,0,0,$10
		DB $20,$32,$20,0,0,0,$30,5,$30,4,0,0,$20,$FC,4,$10
		DB 3,8,5,2,1,0,1,0,0,0,2,0,1,3,$50,0
		DB 0,1,3,0,0,0,$40,0,$10,$10,3,$30,$FC,4,0,2
		DB 1,1,1,0,0,$18

; --- ITEM_SPECATT ---------------------------------------------
; @done
; One attribute byte per item id: low nibble = item/weapon TYPE (matched
; by find_equipped_by_type against a requested type), high nibble =
; special-attack / special-effect code. Same RLE-compressed,
; index-by-item-id layout as WEAPON_DAMAGE ($FC,count,value runs; leading
; DB 0 padding, base = LABEL+1).
; Referenced by: ADDR_TABLE index $6B (INX_ITEM_SPECATT) -
;                calc_attack_damage, find_special_weapon,
;                find_equipped_by_type, display_inventory_list, enemies_killed
		debug "ITEM_SPECATT: "
ITEM_SPECATT:
		DB 0
		DB 0,0,$FC,7,1,2,2,$FC,5,3,4,5,5,6,6,6
		DB 1,2,3,3,7,3,1,6,9,1,4,5,1,1,3,7
		DB 6,8,8,6,$11,1,1,1,$0A,1,1,2,1,4,5,1
		DB 1,1,9,$0A,$0A,2,7,$FC,4,3,2,2,1,1,1,$51
		DB $41,1,1,6,6,6,1,2,1,4,7,7,1,1,$31,1
		DB $21,2,3,5,4,9,$0A,$0A,$FC,4,6,8,8,2,$21,$0A
		DB $0A,9,4,7,7,8,1,0,1,$61,4,$71,7,7,$0A,7
		DB 9,$0A,$0A,$0A,7,7,$71

; --- ITEM_EQUIP -----------------------------------------------
; @done
; One class-eligibility bitmask per item id: which hero classes may
; equip/use the item. add_item_to_hero ANDs ITEM_EQUIP[item] with
; CLASS_EQUIP_MASK[hero class] (the per-class bit $80/$40/../$01, classes
; 2-4 sharing $40); a non-zero result means that class may take the item,
; so it auto-equips. So a set bit here = "this class group is allowed".
; UNCOMPRESSED (index $47 < $67, no $FC decoding) - direct byte lookup by
; item id; leading DB 0 padding, base = LABEL+1. ($FF = all classes.)
; Referenced by: ADDR_TABLE index $47 (INX_ITEM_EQUIP) -
;                add_item_to_hero, shoppe_buy  (pairs with CLASS_EQUIP_MASK)
		debug "ITEM_EQUIP: "
ITEM_EQUIP:
		DB 0
		DB $FF,$FF,$8E,$9E,$FF,$8E,$87,$9F,$FF,$BF,$8E,$BF,$8E,$8E,$84,$FF
		DB $8E,$BF,$86,8,8,8,$9E,$9F,$8E,$CE,$FF,$FF,8,8,$60,$FF
		DB $9E,$BE,$8F,$9F,$84,$FF,8,$FF,$FF,8,$8E,2,$CE,$E6,$BC,$8E
		DB $8E,$8E,$FF,$8E,$8E,$9E,$60,4,$60,$71,$70,$FF,$FF,$8E,$84,$80
		DB $7B,$9F,4,$60,$FA,$10,$22,$33,$60,$82,8,8,8,$86,$80,$BC
		DB $84,$FF,$FF,$60,$8E,$40,$60,2,$86,$80,$8C,$AC,$60,$FB,$79,8
		DB 8,8,8,$60,$62,$8C,$A2,4,$60,$60,$82,$FF,$FF,$FF,$FA,$FF
		DB $8E,$82,$8C,$BB,$FF,$FF,$FF,$FF,$20,$FF,$FF,$FF,$FF,$FF,$AA

; --- ITEM_EFFECTS ---------------------------------------------
; @done
; One attribute byte per item id: the item's use/effect code (the spell
; or action triggered when the item is used or its passive effect).
; use_item / check_item_effect fetch it (then AND with a caller mask);
; check_equipped and find_special_weapon also read it. Same
; RLE-compressed, index-by-item-id layout as WEAPON_DAMAGE
; ($FC,count,value runs; leading DB 0 padding, base = LABEL+1).
; Referenced by: ADDR_TABLE index $67 (INX_ITEM_EFFECTS) -
;                use_item, check_item_effect, check_equipped, find_special_weapon
		debug "ITEM_EFFECTS: "
ITEM_EFFECTS:
		DB 0
		DB $B0,$B1,$FC,$18,0,$BC,0,5,$2B,$90,$FC,6,0,$B4,5,$FC
		DB 5,0,$90,$FC,9,0,$96,$97,$A4,$96,$9E,6,$B3,$FC,4,0
		DB $9F,0,2,0,8,0,0,$1A,$A5,$91,$93,$2D,$FC,4,0,$BE
		DB $BD,4,$A0,$A3,$12,0,$2D,0,0,$9C,$2C,$9D,7,$2F,$1A,$A5
		DB $94,$1B,$A7,$A2,0,$19,$9C,$95,$A5,$B2,$BA,1,1,$0E,9,0
		DB $98,0,$B5,$BB,$0A,$0F,$A6,$0B,$0C,$0D,$39,$B7,$28

		debug "  items end: "
