/datum/psionic/channel_stage/break_mindshield_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/break_mindshield_2/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H || !ismindshielded(H))
		//Target is not human. or not mindshielded
		return FALSE 
	H.emote("scream")
	H.adjustStaminaLoss(50)
	to_chat(target, "<span class='danger'>MAKE IT STOP!.</span>")
	return TRUE

/datum/psionic/channel_stage/break_mindshield_2/start_channeling(mob/living/carbon/psionic, target)
	if(ishuman(target))
		to_chat(target, "<span class='warning'>It feels like your head is on fire!.</span>")