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
	S.Grant(src)
	var/datum/action/psionic/teleport/T = new 
	T.Grant(src)

/mob/living/carbon/human/proc/give_psionic()
	if(mind)
		mind.psionic = new