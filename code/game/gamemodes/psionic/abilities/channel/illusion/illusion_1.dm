/datum/psionic/channel_stage/illusion_1
	duration = 2 SECONDS

/datum/psionic/channel_stage/illusion_1/success(mob/living/carbon/psionic, target, upgraded)
	var/turf/T = get_turf(target)
	if(!T)
		return FALSE
	if(!psionic.mind.psionic.selected_illusion)
		return FALSE
	psionic.mind.psionic.active_illusion = new /obj/illusion(T, psionic.mind.psionic.selected_illusion, psionic, upgraded)
	return TRUE

/datum/psionic/channel_stage/illusion_1/start_channeling(mob/living/carbon/psionic, target)
