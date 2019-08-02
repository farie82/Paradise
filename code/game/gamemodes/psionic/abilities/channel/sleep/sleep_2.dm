/datum/psionic/channel_stage/sleep_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/sleep_2/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human.
		return FALSE // TODO: Make AOE for upgrade
	
	H.Drowsy(2)
	H.adjustStaminaLoss(50)
	if(prob(30))
		H.emote("faint")
	
	return TRUE

/datum/psionic/channel_stage/sleep_2/start_channeling(mob/living/carbon/psionic, target)
	if(prob(70))
		to_chat(target, "<span class='warning'>You are almost falling asleep!</span>")