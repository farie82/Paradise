/datum/species/psionic
	name = "Psionic"
	icobase = 'icons/mob/human_races/r_shadowling.dmi'
	deform = 'icons/mob/human_races/r_shadowling.dmi'
	blacklisted = TRUE

	blood_color = "#555555"
	flesh_color = "#222222"

	species_traits = list(NO_BLOOD, NO_BREATHE, RADIMMUNE, NOGUNS, NO_EXAMINE)

	silent_steps = TRUE


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

/mob/living/carbon/human/proc/give_psionic()
	if(mind)
		mind.psionic = new(src)