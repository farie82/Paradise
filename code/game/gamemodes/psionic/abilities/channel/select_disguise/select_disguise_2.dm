/datum/psionic/channel_stage/select_disguise_2
	duration = 3 SECONDS
	able_to_move = FALSE
	cancellable = FALSE

/datum/psionic/channel_stage/select_disguise_2/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	if(!target || !ishuman(target))
		return FALSE
	psionic_datum.selected_disguise = target
	to_chat(user, "<span class='notice'>You memorised [target]'s appearance for further use.</span>'")
	return TRUE

/datum/psionic/channel_stage/select_disguise_2/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(user, "<span class='notice'>You start to rehearsing [target]'s behaviour.</span>'")