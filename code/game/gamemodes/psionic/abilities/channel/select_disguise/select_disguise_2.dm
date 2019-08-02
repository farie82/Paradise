/datum/psionic/channel_stage/select_disguise_2
	duration = 3 SECONDS
	able_to_move = FALSE

/datum/psionic/channel_stage/select_disguise_2/success(mob/living/carbon/psionic, target)
	if(!target || !ishuman(target))
		return FALSE
	psionic.mind.psionic.selected_disguise = target
	to_chat(psionic, "<span class='notice'>You memorised [target]'s appearance for further use.</span>'")
	return TRUE

/datum/psionic/channel_stage/select_disguise_2/start_channeling(mob/living/carbon/psionic, target)
	to_chat(psionic, "<span class='notice'>You start to rehearsing [target]'s behaviour.</span>'")