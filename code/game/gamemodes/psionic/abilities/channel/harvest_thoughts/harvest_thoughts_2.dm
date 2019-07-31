/datum/psionic/channel_stage/harvest_thoughts_2
	duration = 5 SECONDS

/datum/psionic/channel_stage/harvest_thoughts_2/success(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	var/mob/living/carbon/human/H = target
	if(!H)
		return FALSE
	psionic.mind.psionic.harvest_thought(H, psionic)
	H.adjustBrainLoss(60) // Make permanent
	//Add random gene defect
	return TRUE

/datum/psionic/channel_stage/harvest_thoughts_2/start_channeling(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	to_chat(target, "<span class='danger'>Your brain hurts like hell! You can't think clearly anymore!</span>")