/datum/component/carbon_on_life
	var/datum/callback/callback

/datum/component/carbon_on_life/Initialize(datum/callback/callback)
	var/mob/living/carbon/C = parent
	if(!istype(C) || !callback) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	src.callback = callback
	RegisterSignal(C, COMSIG_CARBON_LIFE, .proc/Life)

/datum/component/carbon_on_life/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CARBON_LIFE)

/datum/component/carbon_on_life/proc/Life(mob/living/carbon/C)
	if(C.stat != DEAD)
		callback.Invoke(C)