/datum/action/psionic/active/targeted
	var/ranged = TRUE

/datum/action/psionic/active/targeted/activation_message(mob/living/carbon/user)
	to_chat(user, "<span class='notice'>You start preparing [src].</span>")

/datum/action/psionic/active/targeted/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		user.middleClickOverride = new /datum/middleClickOverride/psionic(src)
		activated(user)
		return FALSE // Don't go on cooldown

/datum/action/psionic/active/targeted/deactivate(mob/living/carbon/user)
	if(active)
		user.middleClickOverride = null
	. = ..()

/datum/action/psionic/active/targeted/deactivation_message(mob/living/carbon/user)
	to_chat(user, "<span class='notice'>You stop preparing [src].</span>")

/datum/action/psionic/active/targeted/proc/target(atom/target, mob/living/user)
	if(!IsAvailable())
		to_chat(user, "<span class='warning'>You can't use this ability now.</span>")
		return FALSE
	if(!ranged && !target.Adjacent(user))
		to_chat(user, "<span class='warning'>You have to be standing next to them to start this ability.</span>")
		return FALSE
	if(use_ability_on(target, user))
		return TRUE
	return FALSE

// Override this to do an effect. If it returns TRUE it'll remove the ability from the middle mouse button and unselect the ability
/datum/action/psionic/active/targeted/proc/use_ability_on(atom/target, mob/living/user)
	return TRUE

/datum/middleClickOverride/psionic
	var/datum/action/psionic/active/targeted/ability

/datum/middleClickOverride/psionic/New(datum/action/psionic/active/targeted/psionic_ability)
	. = ..()
	ability = psionic_ability

/datum/middleClickOverride/psionic/onClick(atom/A, mob/living/user)
	if(ability.target(A, user))
		ability.used(user)
		ability.deactivate(user)
		..()