/datum/psionic/channel_stage
	var/duration = 0 // Duration of the stage in ticks
	var/able_to_move = TRUE // If the psionic is able to move during this stage
	var/interaction_breaks = FALSE // If the channel breaks if the psionic is interacted with
	
	
/datum/psionic/channel_stage/proc/channel(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	psionic.visible_message("<span class='warning'>[psionic] puts his fingers on his temples.</span>", "<span class='notice'>You start focusing. This will take [duration/10] seconds.</span>")
	if(!able_to_move)
		//TODO: Component that listens to update_canmove?
	
	start_channeling(psionic, target, channel_ability)
	
	if(do_after(psionic, duration, target = psionic, extra_checks = (interaction_breaks ? CALLBACK(src, .proc/concentration_check, psionic) : null )))
		psionic.visible_message("<span class='warning'>You feel a sharp sting in your head!</span>", "<span class='notice'>You channel your focus into [target].</span>")
		return success(psionic, target, channel_ability)
	else
		psionic.visible_message("<span class='warning'>You get a light headache.</span>", "<span class='warning'>Your focus was broken!</span>")
		return failed(psionic, target, channel_ability)

/datum/psionic/channel_stage/proc/concentration_check(mob/living/carbon/human/psionic)
	return TRUE
	//TODO: make a way to check if the person is interacted with. Component?

/datum/psionic/channel_stage/proc/start_channeling(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	return

/datum/psionic/channel_stage/proc/success(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	return TRUE

/datum/psionic/channel_stage/proc/failed(mob/living/carbon/human/psionic, target, datum/psionic/channel/channel_ability)
	return FALSE