/datum/action/psionic/active/become_ethereal
	name = "Become ethereal"
	desc = "Transform into your ethereal form. This allows you to move through solid object. Using another ability in this form will break concentration and transform you back."
	maintain_focus_cost = 3

	var/datum/psionic/channel/become_ethereal/channel = new
	var/atom/movable/overlay/animation
	var/obj/effect/dummy/spell_jaunt/holder

/datum/action/psionic/active/become_ethereal/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		. = channel.start_channeling(user, user) // Only one stage
		if(.)
			become_ethereal(user) // Handled here due to the deactivation
			activated(user)

/datum/action/psionic/active/become_ethereal/deactivate(mob/living/carbon/user)
	. = ..()
	if(.)
		become_normal(user)

/datum/action/psionic/active/become_ethereal/proc/become_ethereal(mob/living/carbon/user)
	var/originalloc = get_turf(user.loc)
	holder = new /obj/effect/dummy/spell_jaunt(originalloc)
	holder.invisibility = 0
	user.canmove = FALSE
	animation = new /atom/movable/overlay(originalloc)
	animation.icon = 'icons/mob/mob.dmi'
	animation.icon_state = "psionic_ethereal_ani"
	animation.density = 0
	animation.anchored = 1
	animation.layer = MOB_LAYER
	animation.master = holder
	user.ExtinguishMob()
	if(user.buckled)
		user.buckled.unbuckle_mob()
	flick("psionic_ethereal_ani", animation)
	user.forceMove(holder)
	user.client.eye = holder
	sleep(4)
	animation.icon = "nothing"
	holder.canmove = TRUE
	holder.icon = 'icons/mob/mob.dmi'
	holder.icon_state = "psionic_ethereal"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.dna.species.slowdown = 2

/datum/action/psionic/active/become_ethereal/proc/become_normal(mob/living/carbon/user)
	var/mobloc = get_turf(user.loc)
	animation.loc = mobloc
	user.canmove = 0
	animation.icon = "reappear"
	flick("reappear", animation)
	sleep(5)
	if(!user.Move(mobloc))
		user.adjustBruteLoss(20) // Don't stand in walls!
		for(var/direction in list(1,2,4,8,5,6,9,10))
			var/turf/T = get_step(mobloc, direction)
			if(T)
				if(user.Move(T))
					break
	user.canmove = 1
	user.client.eye = user
	qdel(animation)
	qdel(holder)