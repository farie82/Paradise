/datum/action/psionic/active/invisibility
	name = "Invisibility"
	desc = "Makes yourself invisible. Keeping this up costs a lot of focus. Casting an ability in this form will break concentration."
	maintain_focus_cost = 5
	button_icon_state = "psionic_invisibility"

	var/datum/psionic/channel/invisible/channel = new
	var/atom/movable/overlay/animation
	var/datum/effect_system/steam_spread/steam
	var/prior_invis

/datum/action/psionic/active/invisibility/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		. = channel.start_channeling(user, user) // Only one stage
		if(.)
			become_invisible(user) // Handled here due to the deactivation
			activated(user)

/datum/action/psionic/active/invisibility/deactivate(mob/living/carbon/user)
	. = ..()
	if(.)
		become_visible(user)

/datum/action/psionic/active/invisibility/proc/become_invisible(mob/living/carbon/user)
	var/originalloc = get_turf(user.loc)
	animation = new /atom/movable/overlay(originalloc)
	animation.density = 0
	animation.anchored = 1
	animation.icon = 'icons/mob/mob.dmi'
	animation.icon_state = "cloak"
	animation.layer = 5
	animation.master = user
	user.ExtinguishMob()
	if(user.buckled)
		user.buckled.unbuckle_mob()
	flick("cloak", animation)
	prior_invis = user.invisibility
	user.invisibility = INVISIBILITY_OBSERVER
	steam = new /datum/effect_system/steam_spread()
	steam.set_up(4, 0, originalloc)
	steam.start()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.dna.species.slowdown = 2

/datum/action/psionic/active/invisibility/proc/become_visible(mob/living/carbon/user)
	var/mobloc = get_turf(user.loc)
	animation.loc = mobloc
	steam.location = mobloc
	steam.start()
	user.canmove = 0
	sleep(20)
	flick("uncloak", animation)
	sleep(5)
	user.invisibility = prior_invis
	user.canmove = 1
	qdel(animation)
	qdel(steam)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.dna.species.slowdown = 0