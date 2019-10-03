/datum/psionic/channel
	var/list/channel_stages = list()
	var/list/channel_stages_repeating = list() // Stages that will keep cycling till interupted
	var/fail_on_repeating_interupt = FALSE
	var/stop_channeling_var = FALSE // Used to stop channeling if you try to channel again. Or if you try to channel another channeling ability
	var/cancellable = TRUE // If you can cancel this channeling by stopping the ability or by selecting another. Will be set by stages
	var/cancel_damage_amount = 0 // If more than 0 then the channeling will stop when the caster is damaged for the given amount in total

	var/datum/component/human_damage_callback/damage_component // The component that will cancel the ability when enough damage is done to the caster

// This returning TRUE means it started the first channeling step successfully
/datum/psionic/channel/proc/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, upgraded)
	if(!user || !psionic_datum)
		return FALSE
	
	if(psionic_datum.channeling) // Another is being channeled
		psionic_datum.channeling.stop_channeling_var = TRUE //Ensure that one stops
		if(psionic_datum.channeling == src)
			return FALSE
	
	stop_channeling_var = FALSE // Reset it to FALSE
	psionic_datum.channeling = src // Make sure to let the psionic know we're channeling this ability
	user.visible_message("<span class='notice'>[user] puts his fingers on his temples.</span>", "<span class='notice'>You start focusing on channeling.</span> ")
	var/first_stage_done = FALSE
	if(cancel_damage_amount > 0)
		damage_component = new(user, cancel_damage_amount, CALLBACK(src, .proc/stop_channeling, psionic_datum))
	
	for(var/datum/psionic/channel_stage/stage in channel_stages)
		cancellable = stage.cancellable
		if(!stage.channel(user, target, psionic_datum, src, upgraded))
			user.visible_message("<span class='warning'>You get a light headache.</span>", "<span class='warning'>Your focus was broken!</span>")
			stop_channeling(psionic_datum)
			return first_stage_done
		first_stage_done = TRUE // First stage done means it sets the ability on cooldown and it costs focus
	
	var/interupted = LAZYLEN(channel_stages_repeating) == 0 // Don't do a while if nothing is there to do
	if(!interupted)
		to_chat(user, "<span class='info'>You can safely stop channeling the ability now to cast it. Extra channeling will give extra effects.</span>")
		while(!interupted)
			for(var/datum/psionic/channel_stage/stage in channel_stages_repeating) // Keep doing the bonus channels
				cancellable = stage.cancellable
				if(!stage.channel(user, target, psionic_datum, src, upgraded))
					interupted = TRUE
					break
	
	user.visible_message("<span class='warning'>You feel a sharp sting in your head!</span>", "<span class='notice'>You channel your focus into [target].</span>")

	stop_channeling(psionic_datum)
	return TRUE
	
/datum/psionic/channel/proc/stop_channeling(datum/antagonist/psionic/psionic_datum)
	if(psionic_datum.channeling == src)
		psionic_datum.channeling = null
	stop_channeling_var = TRUE
	if(damage_component)
		qdel(damage_component)