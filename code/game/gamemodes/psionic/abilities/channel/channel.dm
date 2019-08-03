/datum/psionic/channel
	var/list/channel_stages = list()
	var/list/channel_stages_repeating = list() // Stages that will keep cycling till interupted
	var/fail_on_repeating_interupt = FALSE
	var/stop_channeling_var = FALSE // Used to stop channeling if you try to channel again. Or if you try to channel another channeling ability

// This returning TRUE means it started the first channeling step successfully
/datum/psionic/channel/proc/start_channeling(mob/living/carbon/psionic, target, upgraded)
	if(!psionic || !psionic.mind || !psionic.mind.psionic)
		return FALSE
	
	if(psionic.mind.psionic.channeling) // Another is being channeled
		psionic.mind.psionic.channeling.stop_channeling_var = TRUE //Ensure that one stops
		if(psionic.mind.psionic.channeling == src)
			return FALSE
	stop_channeling_var = FALSE // Reset it to FALSE
	psionic.mind.psionic.channeling = src // Make sure to let the psionic know we're channeling this ability

	var/first_stage_done = FALSE
	for(var/datum/psionic/channel_stage/stage in channel_stages)
		if(!stage.channel(psionic, target, src, upgraded))
			stop_channeling(psionic)
			return first_stage_done
		first_stage_done = TRUE // First stage done means it sets the ability on cooldown and it costs focus
	
	var/interupted = LAZYLEN(channel_stages_repeating) == 0 // Don't do a while if nothing is there to do

	while(!interupted)
		for(var/datum/psionic/channel_stage/stage in channel_stages_repeating) // Keep doing the bonus channels
			if(!stage.channel(psionic, target, src, upgraded))
				interupted = TRUE
				break
	
	stop_channeling(psionic)
	return TRUE
	
/datum/psionic/channel/proc/stop_channeling(mob/living/carbon/psionic)
	if(psionic.mind.psionic.channeling == src)
		psionic.mind.psionic.channeling = null
	stop_channeling_var = TRUE