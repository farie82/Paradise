/datum/component/psionic_focus_regen
	var/datum/antagonist/psionic/psionic

/datum/component/psionic_focus_regen/Initialize(datum/antagonist/psionic/psi)
	var/mob/living/carbon/C = parent
	if(!istype(C) || !psi) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	psionic = psi
	RegisterSignal(C, COMSIG_CARBON_LIFE, .proc/Life)

/datum/component/psionic_focus_regen/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CARBON_LIFE)

/datum/component/psionic_focus_regen/proc/Life(mob/living/carbon/C)
	if(C.stat != DEAD)
		psionic.regen_focus(parent)