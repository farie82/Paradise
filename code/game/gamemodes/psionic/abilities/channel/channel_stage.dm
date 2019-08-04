/datum/psionic/channel_stage
	var/duration = 0 // Duration of the stage in ticks
	var/able_to_move = TRUE // If the psionic is able to move during this stage
	var/interaction_breaks = FALSE // If the channel breaks if the psionic is interacted with
	var/interacted_with = FALSE
	var/requires_upgraded = FALSE // If this stage requires the upgraded version of the ability. Make sure only bonus stages are marked as this
	
	
/datum/psionic/channel_stage/proc/channel(mob/living/carbon/psionic, target, datum/psionic/channel/ability_channel, upgraded)
	if(requires_upgraded && !upgraded)
		return FALSE
	
	to_chat(psionic, "<span class='notice'>You start focusing. This will take [duration/10] seconds.</span>")
	var/datum/component/psionic_channel/no_move/no_move_component
	if(!able_to_move)
		psionic.canmove = FALSE
		no_move_component = psionic.AddComponent(/datum/component/psionic_channel/no_move, src)
	
	start_channeling(psionic, target)
	
	if(do_after(psionic, duration, target = psionic, extra_checks = CALLBACK(src, .proc/callback_checks, psionic, target, src, ability_channel)))
		. = success(psionic, target, upgraded)
	else
		. = failed(psionic, target, upgraded)
	if(!able_to_move)
		qdel(no_move_component)
		psionic.canmove = TRUE

/datum/psionic/channel_stage/proc/callback_checks(mob/living/carbon/psionic, target, datum/psionic/channel_stage/stage, datum/psionic/channel/ability_channel)
	return !ability_channel.stop_channeling_var && distance_check(psionic, target) && (!stage.interaction_breaks || concentration_check(psionic, target))

/datum/psionic/channel_stage/proc/distance_check(mob/living/carbon/psionic, target)
	if(target == psionic)
		return TRUE
	return (target in range(world.view, psionic)) // range not view due to xray being viable

/datum/psionic/channel_stage/proc/concentration_check(mob/living/carbon/psionic, target)
	return TRUE
	//TODO: make a way to check if the person is interacted with. Component?

/datum/psionic/channel_stage/proc/start_channeling(mob/living/carbon/psionic, target)
	return

/datum/psionic/channel_stage/proc/success(mob/living/carbon/psionic, target, upgraded)
	return TRUE

/datum/psionic/channel_stage/proc/failed(mob/living/carbon/psionic, target, upgraded)
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

/datum/component/psionic_channel/no_move/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_UPDATE_CAN_MOVE)

/datum/component/psionic_channel/no_move/proc/update_canmove()
	var/mob/living/M = parent
	M.canmove = FALSE