/datum/psionic/channel_stage/become_ethereal_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/become_ethereal_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	return TRUE

/datum/psionic/channel_stage/become_ethereal_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	user.visible_message("<span 'warning'>[user] starts to become translucent.</span>")