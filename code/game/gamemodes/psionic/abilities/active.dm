/datum/action/psionic/active
	var/require_concentration = TRUE // Can only have one of these abilities max
	var/maintain_focus_cost = 0 // Focus it takes to keep up the ability

	var/datum/component/psionic_active/ability_cost/maintain_component // Component that makes the spell cost focus

/datum/action/psionic/active/activate(mob/living/carbon/user)
	if(src in user.mind.psionic.active_abilities) // Same ability. Disable
		src.deactivate(user)
		return FALSE
	
	if(require_concentration) // Break other concentration abilities
		for(var/datum/action/psionic/active/A in user.mind.psionic.active_abilities)
			if(A.require_concentration)
				A.deactivate(user)
	
	activation_message(user)
	
	return TRUE

/datum/action/psionic/active/activation_message(mob/living/carbon/user)
	return

// should be called when the ability is actually activated (after a channel etc)
/datum/action/psionic/active/proc/activated(mob/living/carbon/user)
	user.mind.psionic.active_abilities += src
	active = TRUE
	if(maintain_focus_cost > 0)
		maintain_component = new(user, src, user.mind.psionic)

/datum/action/psionic/active/proc/deactivation_message(mob/living/carbon/user)
	to_chat(user, "<span class='notice'>You break focus on '[src]'.</span>")

// Override this to implement functionality (Not called by Trigger. Will be called when deactivating an ability by selecting a new one for example)
/datum/action/psionic/active/proc/deactivate(mob/living/carbon/user)
	. = active // Only really deactivate when it was active to begin with
	if(active)
		deactivation_message(user)
		user.mind.psionic.active_abilities -= src
		active = FALSE
		if(maintain_component)
			qdel(maintain_component)

/datum/component/psionic_active
	var/datum/action/psionic/active/active
	dupe_type = COMPONENT_DUPE_UNIQUE_PASSARGS // One for each active ability

/datum/component/psionic_active/Initialize(datum/action/psionic/active/ability)
	var/mob/living/carbon/C = parent
	if(!istype(C) || !ability) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	active = ability

/datum/component/psionic_active/ability_cost
	var/datum/antagonist/psionic/psionic

/datum/component/psionic_active/ability_cost/Initialize(datum/action/psionic/active/ability, datum/antagonist/psionic/psi)
	. = ..()
	if(. != COMPONENT_INCOMPATIBLE)
		if(!psi)
			return COMPONENT_INCOMPATIBLE
		psionic = psi
		RegisterSignal(parent, COMSIG_LIVING_LIFE, .proc/Life)

/datum/component/psionic_active/ability_cost/proc/Life(mob/living/carbon/C)
	if(C.stat != DEAD)
		psionic.use_focus(parent, active.maintain_focus_cost)

/datum/component/psionic_active/ability_cost/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_LIFE)
