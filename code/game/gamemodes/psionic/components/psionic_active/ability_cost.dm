/datum/component/psionic_active/ability_cost
	var/datum/antagonist/psionic/psionic

/datum/component/psionic_active/ability_cost/Initialize(datum/action/psionic/active/ability, datum/antagonist/psionic/psi)
	. = ..()
	if(. != COMPONENT_INCOMPATIBLE)
		if(!psi)
			return COMPONENT_INCOMPATIBLE
		psionic = psi
		RegisterSignal(parent, COMSIG_CARBON_LIFE, .proc/Life)

/datum/component/psionic_active/ability_cost/proc/Life(mob/living/carbon/C)
	if(C.stat != DEAD)
		psionic.use_focus(parent, active.maintain_focus_cost)

/datum/component/psionic_active/ability_cost/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CARBON_LIFE)
