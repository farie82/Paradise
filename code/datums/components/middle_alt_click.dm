/datum/component/middle_alt_click
	var/datum/callback/callback

// Listens to the middle click and alt button combo and calls the given callback when that one is pressed
/datum/component/middle_alt_click/Initialize(datum/callback/callback)
	var/mob/M = parent
	if(!istype(M)) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	src.callback = callback
	RegisterSignal(M, COMSIG_MIDDLE_CLICK_ALT, .proc/target)

/datum/component/middle_alt_click/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MIDDLE_CLICK_ALT)

/datum/component/middle_alt_click/proc/target(mob/user, atom/A)
	callback.Invoke(user, A)