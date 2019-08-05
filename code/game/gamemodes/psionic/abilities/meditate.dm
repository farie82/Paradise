/datum/action/psionic/meditate
	name = "Meditate"
	desc = "Puts us in a trance. Once in the trance we can't get out of it till it's done so use it somewhere safe."
	cooldown = 10
	channel = new /datum/psionic/channel/meditate

/datum/action/psionic/meditate/activate(mob/living/carbon/user)
	..()
	return channel.start_channeling(user, user)