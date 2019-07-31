/datum/psionic/channel_stage/sleep_3
	duration = 5 SECONDS

/datum/psionic/channel_stage/sleep_3/success(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human.
		return FALSE // TODO: Make AOE for upgrade
		
	H.Drowsy(60)
	H.Paralyse(50)
	
	return TRUE