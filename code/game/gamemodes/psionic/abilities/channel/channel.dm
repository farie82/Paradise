/datum/psionic/channel
	var/list/channel_stages = list()
	var/list/channel_stages_repeating = list() // Stages that will keep cycling till interupted
	var/fail_on_repeating_interupt = FALSE

// This returning TRUE means it started the first channeling step successfully
/datum/psionic/channel/proc/start_channeling(mob/living/carbon/psionic, target)
	var/first_stage_done = FALSE
	for(var/datum/psionic/channel_stage/stage in channel_stages)
		if(!stage.channel(psionic, target))
			return first_stage_done
		first_stage_done = TRUE
	var/interupted = LAZYLEN(channel_stages_repeating) == 0

	while(!interupted)
		for(var/datum/psionic/channel_stage/stage in channel_stages_repeating)
			if(!stage.channel(psionic, target))
				interupted = TRUE
				break
	
	return TRUE
	