/datum/action/psionic/force_push
	name = "Force Push"
	desc = "Throw somebody away from you. Alt + middle mousebutton to use. Selects the closest target from where you target"
	needs_button = FALSE
	var/datum/component/listening_component
	cooldown = 30
	focus_cost = 10

/datum/action/psionic/force_push/on_purchase(mob/user)
	..()
	listening_component = user.AddComponent(/datum/component/force_push, src)
	to_chat(user, "<span class='info'>Press both alt and middle mouse button near a target to use the 'Force push' ability</span>")

/datum/action/psionic/force_push/proc/target(mob/living/carbon/user, atom/A)
	if(!IsAvailable())
		to_chat(user, "<span class='warning'>[src] is not available yet!</span>")
		return
	var/mob/living/target
	if(user != A && isliving(A)) // They selected a mob in special. So just use that
		target = A
	if(!target || target == user || !danger_mob_check(user, target))
		for(var/mob/living/L in range(2, A))
			if(L != user && danger_mob_check(user, L))
				target = L
				break

	if(target)
		var/fuck_you_dir = get_dir(user, target)
		var/turf/general_direction = get_edge_target_turf(target, fuck_you_dir)
		target.visible_message("<span class='warning'>[target] gets thrown out of nowhere!</span>'", "<span class='warning'>You suddenly start flying!</span>")
		playsound(target, 'sound/weapons/thudswoosh.ogg', 100, 1, -1)
		target.throw_at(general_direction, 4, 2, user)
		last_use = start_watch()
	else
		to_chat(user, "<span class='warning'>No suitable target found</span>")
