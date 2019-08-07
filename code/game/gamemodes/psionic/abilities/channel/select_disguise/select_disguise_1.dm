/datum/psionic/channel_stage/select_disguise_1
	duration = 5 SECONDS

/datum/psionic/channel_stage/select_disguise_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(target, "<span class='notice'>It feels like something is watching you...</span>")
	return TRUE

/datum/psionic/channel_stage/select_disguise_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	to_chat(user, "<span class='notice'>You start to observe [target]'s behaviour</span>'")