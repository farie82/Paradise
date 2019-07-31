/datum/species/psionic
	name = "Psionic"
	icobase = 'icons/mob/human_races/r_shadowling.dmi'
	deform = 'icons/mob/human_races/r_shadowling.dmi'
	blacklisted = TRUE

	blood_color = "#555555"
	flesh_color = "#222222"

	species_traits = list(NO_BLOOD, NO_BREATHE, RADIMMUNE, NOGUNS, NO_EXAMINE)

	silent_steps = TRUE

/datum/species/psionic/on_species_gain(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	H.equip_to_slot_or_del(new /obj/item/clothing/under/shadowling/psionic(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling/psionic(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling/psionic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/shadowling/psionic(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling/psionic(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling/psionic(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/shadowling/psionic(H), slot_glasses)

//TODO: TEMP REMOVE LATER
/mob/living/carbon/human/psionic/Initialize(mapload)
	..(mapload, /datum/species/psionic)
	var/datum/action/psionic/active/targeted/sleep/S = new 
	S.on_purchase(src)
	var/datum/action/psionic/teleport/T = new 
	T.on_purchase(src)
	var/datum/action/psionic/force_push/F = new 
	F.on_purchase(src)
	var/datum/action/psionic/active/targeted/harvest_thoughts/H = new 
	H.on_purchase(src)
	var/datum/action/psionic/meditate/M = new 
	M.on_purchase(src)
	var/datum/action/psionic/active/targeted/break_mindshield/B = new 
	B.on_purchase(src)

/mob/living/carbon/human/proc/give_psionic()
	if(mind)
		mind.psionic = new(src)