/datum/psionic/channel_stage/sleep_3
	duration = 5 SECONDS

/datum/psionic/channel_stage/sleep_3/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human.
		return FALSE // TODO: Make AOE for upgrade
	
	H.AdjustSleeping(30)
	
	return TRUE