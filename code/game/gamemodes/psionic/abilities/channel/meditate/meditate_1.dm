/datum/psionic/channel_stage/meditate_1
	duration = 1.5 SECONDS

/datum/psionic/channel_stage/meditate_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	user.SetEyeBlind(4)
	return TRUE

/datum/psionic/channel_stage/meditate_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	user.visible_message("<span class='notice'>[user] starts to close his eyes.</span>", "<span class='notice'>You close your eyes.</span>")