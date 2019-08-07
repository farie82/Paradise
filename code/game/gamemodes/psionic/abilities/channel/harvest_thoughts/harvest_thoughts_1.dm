/datum/psionic/channel_stage/harvest_thoughts_1
	duration = 3 SECONDS
	melee_range = TRUE

/datum/psionic/channel_stage/harvest_thoughts_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		return FALSE
	
	H.AdjustSleeping(4)
	return TRUE

/datum/psionic/channel_stage/harvest_thoughts_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(target, "<span class='warning'>You feel as if something is rooting around in your brain!</span>")