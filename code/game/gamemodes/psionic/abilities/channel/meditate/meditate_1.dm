/datum/psionic/channel_stage/meditate_1
	duration = 1.0 SECONDS

/datum/psionic/channel_stage/meditate_1/success(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	psionic.SetEyeBlind(4)
	return TRUE

/datum/psionic/channel_stage/meditate_1/start_channeling(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	psionic.visible_message("<span class='notice'>[psionic] starts to close his eyes.</span>", "<span class='notice'>You close your eyes.</span>")