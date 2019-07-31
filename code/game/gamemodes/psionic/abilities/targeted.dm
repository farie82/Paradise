/datum/action/psionic/active/targeted

/datum/action/psionic/active/targeted/activation_message(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You start preparing [src].</span>")

/datum/action/psionic/active/targeted/activate(mob/living/carbon/human/user)
	..()
	user.middleClickOverride = new /datum/middleClickOverride/psionic(src)

/datum/action/psionic/active/targeted/deactivation_message(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You stop preparing [src].</span>")

// Override this to do an effect. If it returns TRUE it'll remove the ability from the middle mouse button and unselect the ability
/datum/action/psionic/active/targeted/proc/target(atom/target, mob/living/user)
	return TRUE

/datum/middleClickOverride/psionic
	var/datum/action/psionic/active/targeted/ability

/datum/middleClickOverride/psionic/New(datum/action/psionic/active/targeted/psionic_ability)
	. = ..()
	ability = psionic_ability

/datum/middleClickOverride/psionic/onClick(atom/A, mob/living/user)
	if(ability.target(A, user))
		// Will unset itself from the middle mouse button once used successfully
		ability.deactivate()
		..()