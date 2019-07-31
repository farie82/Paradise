/datum/psionic/channel_stage/harvest_thoughts_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/harvest_thoughts_1/success(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	var/mob/living/carbon/human/H = target
	if(!H)
		return FALSE
	
	H.Drowsy(10)
	H.Paralyse(10)
	return TRUE

/datum/psionic/channel_stage/harvest_thoughts_1/start_channeling(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	to_chat(target, "<span class='warning'>You feel as if something is rooting around in your brain!</span>")