/datum/action/psionic/active
	var/require_concentration = TRUE // Can only have one of these abilities max
	var/maintain_focus_cost = 0 // Focus it takes to keep up the ability

	var/datum/component/psionic_active/ability_cost/maintain_component // Component that makes the spell cost focus

/datum/action/psionic/active/activate(mob/living/carbon/user)
	if(src in psionic_datum.active_abilities) // Same ability. Disable
		src.deactivate(user)
		return FALSE
	
	if(require_concentration) // Break other concentration abilities
		for(var/datum/action/psionic/active/A in psionic_datum.active_abilities)
			if(A.require_concentration)
				A.deactivate(user)
	
	activation_message(user)
	
	return TRUE

/datum/action/psionic/active/activation_message(mob/living/carbon/user)
	return

// should be called when the ability is actually activated (after a channel etc)
/datum/action/psionic/active/proc/activated(mob/living/carbon/user)
	psionic_datum.active_abilities += src
	active = TRUE
	if(maintain_focus_cost > 0)
		maintain_component = new(user, src, psionic_datum)

/datum/action/psionic/active/proc/deactivation_message(mob/living/carbon/user)
	to_chat(user, "<span class='notice'>You break focus on '[src]'.</span>")

// Override this to implement functionality (Not called by Trigger. Will be called when deactivating an ability by selecting a new one for example)
/datum/action/psionic/active/proc/deactivate(mob/living/carbon/user)
	. = active // Only really deactivate when it was active to begin with
	if(active)
		if(channel)
			channel.stop_channeling(psionic_datum)
		deactivation_message(user)
		psionic_datum.active_abilities -= src
		active = FALSE
		if(maintain_component)
			qdel(maintain_component)
