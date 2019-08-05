/datum/psionic/channel_stage/meditate_2
	duration = 5.0 SECONDS
	able_to_move = FALSE
	cancellable = FALSE

/datum/psionic/channel_stage/meditate_2/success(mob/living/carbon/psionic, target)
	psionic.SetEyeBlind(0)
	psionic.visible_message("<span class='notice'>[psionic] opens his eyes again.</span>", "<span class='notice'>You come out of your trance.</span>")
	psionic.mind.psionic.regen_focus(psionic, TRUE) // Maybe heal damage?
	return TRUE

/datum/psionic/channel_stage/meditate_2/start_channeling(mob/living/carbon/psionic, target)
	to_chat(psionic, "<span class='notice'>You start going into a trance.</span>")