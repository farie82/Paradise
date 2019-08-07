/datum/psionic/channel_stage/illusion_1
	duration = 2 SECONDS

/datum/psionic/channel_stage/illusion_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum, upgraded)
	var/turf/T = get_turf(target)
	if(!T)
		return FALSE
	
	var/datum/action/psionic/active/targeted/illusion/ability = psionic_datum.get_active_ability_by_type(/datum/action/psionic/active/targeted/illusion)

	if(!ability || !ability.selected_illusion)
		return FALSE
	
	ability.active_illusion = new /obj/illusion(T, ability.selected_illusion, user, upgraded)
	return TRUE

/datum/psionic/channel_stage/illusion_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
