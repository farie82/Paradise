/datum/component/force_push
	var/datum/action/psionic/force_push/ability

/datum/component/force_push/Initialize(datum/action/psionic/force_push/psionic_ability)
	var/mob/living/M = parent
	if(!istype(M) || !psionic_ability) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	ability = psionic_ability
	RegisterSignal(M, COMSIG_MIDDLE_CLICK_ALT, .proc/target)

/datum/component/force_push/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MIDDLE_CLICK_ALT)

/datum/component/force_push/proc/target(mob/living/user, atom/A)
	ability.target(user, A)