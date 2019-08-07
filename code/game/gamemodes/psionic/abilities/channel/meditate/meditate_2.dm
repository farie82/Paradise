/datum/psionic/channel_stage/meditate_2
	duration = 5.0 SECONDS
	able_to_move = FALSE
	cancellable = FALSE

/datum/psionic/channel_stage/meditate_2/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	user.SetEyeBlind(0)
	user.visible_message("<span class='notice'>[user] opens his eyes again.</span>", "<span class='notice'>You come out of your trance.</span>")
	psionic_datum.regen_focus(user, TRUE) // Maybe heal damage?
	return TRUE

/datum/psionic/channel_stage/meditate_2/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(user, "<span class='notice'>You start going into a trance.</span>")