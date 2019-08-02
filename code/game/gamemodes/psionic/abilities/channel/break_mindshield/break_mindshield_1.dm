/datum/psionic/channel_stage/break_mindshield_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/break_mindshield_1/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human
		return FALSE 
	if(!ismindshielded(H))
		to_chat(psionic, "<span class='warning'>This victim has no mindshield.</span>")
		return FALSE
	H.emote("scream")
	to_chat(target, "<span class='warning'>Your head hurts!</span>")
	return TRUE

/datum/psionic/channel_stage/break_mindshield_1/start_channeling(mob/living/carbon/psionic, target)
	if(ishuman(target))
		to_chat(target, "<span class='warning'>Your head begins to ache.</span>")