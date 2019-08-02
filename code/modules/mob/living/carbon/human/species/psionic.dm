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
	for(var/obj/item/I in H.contents - (H.bodyparts | H.internal_organs)) //drops all items except organs
		H.unEquip(I)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/shadowling/psionic(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling/psionic(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling/psionic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/shadowling/psionic(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling/psionic(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling/psionic(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/shadowling/psionic(H), slot_glasses)

/mob/living/carbon/human/psionic/Initialize(mapload)
	..(mapload, /datum/species/psionic)

/mob/living/carbon/human/psionic/examine(mob/user)
	if(mind && mind.psionic)
		var/found = FALSE
		for(var/datum/action/psionic/active/disguise_self/D in mind.psionic.active_abilities)
			found = TRUE
			break // Should not be needed but hey
		if(found)
			. = mind.psionic.selected_disguise.examine(user)
			if(get_dist(user,src) <= 3) // Add upgraded version
				to_chat(user, "<span class='warning'>It doesn't look quite right...</span>")
			return .
	
	. = ..() // Not disguised

/mob/living/carbon/human/proc/make_psionic()
	if(mind)
		for(var/obj/item/I in contents - (bodyparts | internal_organs)) //drops all items except organs
			unEquip(I)
		var/mob/living/carbon/human/psionic/psi = new(loc)
		var/datum/mind/oldmind = mind
		psi.ckey = ckey
		oldmind.transfer_to(psi)
		oldmind.psionic = new(psi)
		for(var/path in typesof(/datum/action/psionic))
			var/datum/action/psionic/P = new path
			if(!P.name || P.name == "Base psionic ability")
				continue
			P.on_purchase(psi)
		
		spawn(0)
			qdel(src)