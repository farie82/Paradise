/datum/component/no_move

/datum/component/no_move/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_LIVING_UPDATE_CAN_MOVE, .proc/update_canmove)

/datum/component/no_move/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_UPDATE_CAN_MOVE)

/datum/component/no_move/proc/update_canmove()
	var/mob/living/M = parent
	M.canmove = FALSE