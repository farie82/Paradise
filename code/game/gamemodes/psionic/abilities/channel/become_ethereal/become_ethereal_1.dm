/datum/psionic/channel_stage/become_ethereal_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/become_ethereal_1/success(mob/living/carbon/psionic, target)
	return TRUE

/datum/psionic/channel_stage/become_ethereal_1/start_channeling(mob/living/carbon/psionic, target)
	psionic.visible_message("<span 'warning'>[psionic] starts to become translucent.</span>")