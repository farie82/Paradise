/datum/psionic/channel_stage/sleep_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/sleep_2/success(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human.
		return FALSE // TODO: Make AOE for upgrade
	H.emote("faint")
	
	H.Drowsy(20)
	H.Weaken(10)
	return TRUE

/datum/psionic/channel_stage/sleep_2/start_channeling(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	if(prob(70))
		to_chat(target, "<span class='warning'>You are almost falling asleep!</span>")