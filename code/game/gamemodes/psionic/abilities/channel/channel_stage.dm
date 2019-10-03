/datum/psionic/channel_stage
	var/duration = 0 // Duration of the stage in ticks
	var/able_to_move = TRUE // If the psionic is able to move during this stage
	var/interaction_breaks = FALSE // If the channel breaks if the psionic is interacted with
	var/interacted_with = FALSE
	var/requires_upgraded = FALSE // If this stage requires the upgraded version of the ability. Make sure only bonus stages are marked as this
	var/cancellable = TRUE // If you can cancel the channeling by stopping the ability or by selecting another.
	var/melee_range = FALSE // If the person needs to be adjacent to the caster
	
/datum/psionic/channel_stage/proc/channel(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, datum/psionic/channel/ability_channel, upgraded)
	if(requires_upgraded && !upgraded)
		return FALSE
	
	to_chat(user, "<span class='notice'>You start focusing. This will take [duration/10] seconds.</span>")
	var/datum/component/living_no_move/no_move_component
	if(!able_to_move)
		user.canmove = FALSE
		no_move_component = user.AddComponent(/datum/component/living_no_move, src)
	
	start_channeling(user, target, psionic_datum, upgraded)
	
	if(do_after(user, duration, target = user, extra_checks = CALLBACK(src, .proc/callback_checks, user, target, psionic_datum, src, ability_channel)))
		. = success(user, target, psionic_datum, upgraded)
	else
		. = failed(user, target, psionic_datum, upgraded)
	if(!able_to_move)
		qdel(no_move_component)
		user.canmove = TRUE

/datum/psionic/channel_stage/proc/callback_checks(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, datum/psionic/channel_stage/stage, datum/psionic/channel/ability_channel)
	return target && !ability_channel.stop_channeling_var && distance_check(user, target) && (!stage.interaction_breaks || concentration_check(user, target))

/datum/psionic/channel_stage/proc/distance_check(mob/living/carbon/user, target)
	if(target == user)
		return TRUE
	if(!melee_range)
		return (target in range(world.view, user)) // range not view due to xray being viable
	return user.Adjacent(target)

/datum/psionic/channel_stage/proc/concentration_check(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	return TRUE
	//TODO: make a way to check if the person is interacted with. Component?

/datum/psionic/channel_stage/proc/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	return

/datum/psionic/channel_stage/proc/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, upgraded)
	return TRUE

/datum/psionic/channel_stage/proc/failed(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, upgraded)
	return FALSE
