/datum/psionic/channel_stage/harvest_thoughts_2
	duration = 5 SECONDS
	melee_range = TRUE

/datum/psionic/channel_stage/harvest_thoughts_2/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		return FALSE
	psionic_datum.harvest_thought(H, user)
	H.adjustBrainLoss(60) // Make permanent
	//Add random gene defect
	return TRUE

/datum/psionic/channel_stage/harvest_thoughts_2/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(target, "<span class='danger'>Your brain hurts like hell! You can't think clearly anymore!</span>")