/datum/component/psionic_active
	var/datum/action/psionic/active/active
	dupe_type = COMPONENT_DUPE_UNIQUE_PASSARGS // One for each active ability

/datum/component/psionic_active/Initialize(datum/action/psionic/active/ability)
	var/mob/living/carbon/C = parent
	if(!istype(C) || !ability) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	active = ability
