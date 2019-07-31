/datum/psionic/channel_stage
	var/duration = 0 // Duration of the stage in ticks
	var/able_to_move = TRUE // If the psionic is able to move during this stage
	var/interaction_breaks = FALSE // If the channel breaks if the psionic is interacted with
	var/interacted_with = FALSE
	
	
/datum/psionic/channel_stage/proc/channel(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	psionic.visible_message("<span class='warning'>[psionic] puts his fingers on his temples.</span>", "<span class='notice'>You start focusing. This will take [duration/10] seconds.</span>")
	var/datum/component/psionic_channel/no_move/no_move_component
	if(!able_to_move)
		psionic.canmove = FALSE
		no_move_component = psionic.AddComponent(/datum/component/psionic_channel/no_move, src)
	
	start_channeling(psionic, target, channel_ability)
	
	if(do_after(psionic, duration, target = psionic, extra_checks = (interaction_breaks ? CALLBACK(src, .proc/concentration_check, psionic) : null )))
		psionic.visible_message("<span class='warning'>You feel a sharp sting in your head!</span>", "<span class='notice'>You channel your focus into [target].</span>")
		. = success(psionic, target, channel_ability)
	else
		psionic.visible_message("<span class='warning'>You get a light headache.</span>", "<span class='warning'>Your focus was broken!</span>")
		. = failed(psionic, target, channel_ability)
	if(!able_to_move)
		no_move_component.RemoveComponent()
		psionic.canmove = TRUE

/datum/psionic/channel_stage/proc/concentration_check(mob/living/carbon/psionic)
	return TRUE
	//TODO: make a way to check if the person is interacted with. Component?

/datum/psionic/channel_stage/proc/start_channeling(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	return

/datum/psionic/channel_stage/proc/success(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	return TRUE

/datum/psionic/channel_stage/proc/failed(mob/living/carbon/psionic, target, datum/psionic/channel/channel_ability)
	return FALSE

/datum/component/psionic_channel
	var/datum/psionic/channel_stage/stage

/datum/component/psionic_channel/Initialize(var/datum/psionic/channel_stage/channel_stage)
	var/mob/living/M = parent
	if(!istype(M) || !channel_stage) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	stage = channel_stage
	
/datum/component/psionic_channel/no_move

/datum/component/psionic_channel/no_move/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_LIVING_UPDATE_CAN_MOVE, .proc/update_canmove)

/datum/component/psionic_channel/no_move/proc/update_canmove()
	var/mob/living/M = parent
	M.canmove = FALSE