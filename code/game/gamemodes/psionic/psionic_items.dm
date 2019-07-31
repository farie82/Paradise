/obj/item/clothing/under/shadowling/psionic
	name = "blackened flesh"
	desc = "Black, chitinous skin."


/obj/item/clothing/suit/space/shadowling/psionic
	name = "chitin shell"
	desc = "Dark, semi-transparent shell. Protects against vacuum, but not against the light of the stars." //Still takes damage from spacewalking but is immune to space itself
	icon_state = "golem"
	item_state = "golem"
	body_parts_covered = 0
	cold_protection = 0
	min_cold_protection_temperature = null
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 25, bio = 100, rad = 100)
	flags = ABSTRACT | NODROP | THICKMATERIAL


/obj/item/clothing/shoes/shadowling/psionic
	name = "chitin feet"
	desc = "Charred-looking feet. They have minature hooks that latch onto flooring."

/obj/item/clothing/mask/gas/shadowling/psionic
	name = "chitin mask"
	desc = "A mask-like formation with slots for facial features. A red film covers the eyes."
	icon_state = "golem"
	item_state = "golem"


/obj/item/clothing/gloves/shadowling/psionic
	name = "chitin hands"
	desc = "An electricity-resistant covering of the hands."
	icon_state = "golem"


/obj/item/clothing/head/shadowling/psionic
	name = "chitin helm"
	desc = "A helmet-like enclosure of the head."
	cold_protection = 0
	min_cold_protection_temperature = null
	heat_protection = 0
	max_heat_protection_temperature = null
	flags = ABSTRACT | NODROP

/obj/item/clothing/glasses/shadowling/psionic
	name = "crimson eyes"
	desc = "A shadowling's eyes. Very light-sensitive and can detect body heat through walls."
	flash_protect = 0