/datum/action/psionic/active

/datum/action/psionic/active/activate(mob/living/carbon/human/user)
	if(user.mind.psionic.active_ability)
		user.mind.psionic.active_ability.deactivation_message(user)
		user.mind.psionic.active_ability.deactivate()
	active = TRUE
	user.mind.psionic.active_ability = src
	return TRUE

/datum/action/psionic/active/activation_message(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You start focusing on keeping '[src]' up.</span>")

/datum/action/psionic/active/proc/deactivation_message(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You stop focusing on keeping '[src]' up.</span>")

// Override this to implement functionality (Not called by Trigger. Will be called when deactivating an ability by selecting a new one for example)
/datum/action/psionic/active/proc/deactivate()
	return