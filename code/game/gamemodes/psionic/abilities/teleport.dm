/datum/action/psionic/teleport
	name = "Teleport"
	desc = "Teleport to a place safe and out of sight. Has limited charges"
	var/charges = 2

/datum/action/psionic/teleport/activate(mob/living/carbon/user)
	var/turf/simulated/floor/F = find_safe_place_to_teleport(200, CALLBACK(src, .proc/nobody_nearby_check, user))
	if(F)
		playsound(user,'sound/effects/sparks4.ogg', 50, 1)
		do_teleport(user, F, 0)
	else
		to_chat(user, "<span class='danger'>Could not find a suitable location! Try again!</span>")
	
/datum/action/psionic/teleport/proc/nobody_nearby_check(mob/living/carbon/user, turf/simulated/floor/F)
	for(var/atom/thing in F.contents) // orange will exclude the center
		if(danger_mob_check(user, thing) || danger_camera_check(user, thing) || thing.density)
			return FALSE
	
	for(var/atom/thing in orange(world.view, F))
		if(danger_mob_check(user, thing) || danger_camera_check(user, thing))
			return FALSE
	
	return TRUE


/datum/action/psionic/teleport/proc/danger_camera_check(mob/living/carbon/user, thing)
	. = FALSE
	if(istype(thing, /obj/machinery/camera))
		var/obj/machinery/camera/C = thing
		return C.status // Active cams are bad