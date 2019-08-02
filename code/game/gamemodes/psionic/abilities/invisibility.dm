/datum/action/psionic/active/invisibility
	name = "Invisibility"
	desc = "Makes yourself invisible. Keeping this up costs a lot of focus. Casting an ability in this form will break concentration."
	maintain_focus_cost = 5

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
	var/mob/living/U = user
	var/originalloc = get_turf(U.loc)
	animation = new /atom/movable/overlay(originalloc)
	animation.name = "water"
	animation.density = 0
	animation.anchored = 1
	animation.icon = 'icons/mob/mob.dmi'
	animation.icon_state = "liquify"
	animation.layer = 5
	animation.master = user
	U.ExtinguishMob()
	if(U.buckled)
		U.buckled.unbuckle_mob()
	flick("liquify", animation)
	prior_invis = U.invisibility
	U.invisibility = INVISIBILITY_OBSERVER
	steam = new /datum/effect_system/steam_spread()
	steam.set_up(4, 0, originalloc)
	steam.start()

/datum/action/psionic/active/invisibility/proc/become_visible(mob/living/carbon/user)
	var/mob/living/U = user
	var/mobloc = get_turf(U.loc)
	animation.loc = mobloc
	steam.location = mobloc
	steam.start()
	U.canmove = 0
	sleep(20)
	flick("reappear", animation)
	sleep(5)
	U.invisibility = prior_invis
	U.canmove = 1
	qdel(animation)
	qdel(steam)