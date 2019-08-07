/datum/psionic/channel_stage/sleep_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/sleep_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human.
		return FALSE // TODO: Make AOE for upgrade
	H.emote("yawn")
	H.AdjustEyeBlurry(2)
	return TRUE

/datum/psionic/channel_stage/sleep_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	if(prob(50))
		to_chat(target, "<span class='notice'>You start to feel a bit [pick("tired","sleepy")]</span>")