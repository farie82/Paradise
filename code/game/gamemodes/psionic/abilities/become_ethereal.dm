/datum/action/psionic/active/become_ethereal
	name = "Become ethereal"
	desc = "Transform into your ethereal form. This allows you to move through solid object. Using another ability in this form will break concentration and transform you back."
	button_icon_state = "psionic_ethereal"
	
	maintain_focus_cost = 3

	channel = new /datum/psionic/channel/become_ethereal
	var/atom/movable/overlay/animation
	var/obj/effect/dummy/spell_jaunt/holder

/datum/action/psionic/active/become_ethereal/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		. = channel.start_channeling(user, user, psionic_datum, upgraded) // Only one stage
		if(.)
			become_ethereal(user) // Handled here due to the deactivation
			activated(user)

/datum/action/psionic/active/become_ethereal/deactivate(mob/living/carbon/user)
	. = ..()
	if(.)
		become_normal(user)

/datum/action/psionic/active/become_ethereal/proc/become_ethereal(mob/living/carbon/user)
	var/originalloc = get_turf(user.loc)

	user.ExtinguishMob()
	if(user.buckled)
		user.buckled.unbuckle_mob()

	holder = new /obj/effect/dummy/spell_jaunt(originalloc)
	holder.invisibility = 0
	user.canmove = FALSE
	holder.canmove = FALSE

	animation = new /atom/movable/overlay(originalloc)
	animation.icon = 'icons/mob/mob.dmi'
	animation.icon_state = "psionic_become_ethereal"
	animation.density = FALSE
	animation.anchored = TRUE
	animation.layer = MOB_LAYER
	animation.master = holder
	flick("psionic_become_ethereal", animation)
	user.forceMove(holder)
	user.client.eye = holder
	
	sleep(12) // 12 ticks animation
	
	holder.canmove = TRUE
	animation.icon_state = "nothing"

	if(ishuman(user)) // Find a better way please
		var/mob/living/carbon/human/H = user
		H.dna.species.slowdown = 2

/datum/action/psionic/active/become_ethereal/proc/become_normal(mob/living/carbon/user)
	var/mobloc = get_turf(user.loc)
	animation.loc = mobloc
	user.canmove = 0
	animation.icon_state = "psionic_become_ethereal_revert"
	flick("psionic_become_ethereal_revert", animation)

	sleep(12)
	
	if(!user.Move(mobloc))
		user.adjustBruteLoss(20) // Don't stand in walls!
		for(var/direction in shuffle(list(1,2,4,8,5,6,9,10))) // Random direction
			var/turf/T = get_step(mobloc, direction)
			if(T)
				if(user.Move(T))
					break
	
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.dna.species.slowdown = 0
	user.canmove = 1
	user.client.eye = user
	qdel(animation)
	qdel(holder)