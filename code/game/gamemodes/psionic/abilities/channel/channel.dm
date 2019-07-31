/datum/psionic/channel
	var/list/channel_stages = list()
	var/list/channel_stages_repeating = list() // Stages that will keep cycling till interupted
	var/fail_on_repeating_interupt = FALSE

/datum/psionic/channel/proc/start_channeling(mob/living/carbon/psionic, target)
	for(var/datum/psionic/channel_stage/stage in channel_stages)
		if(!stage.channel(psionic, target))
			return FALSE
	var/interupted = LAZYLEN(channel_stages_repeating) == 0

	while(!interupted)
		for(var/datum/psionic/channel_stage/stage in channel_stages_repeating)
			if(!stage.channel(psionic, target))
				interupted = TRUE
				break
	
	return TRUE
	