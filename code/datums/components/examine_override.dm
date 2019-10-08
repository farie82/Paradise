/datum/component/examine_override
	var/list/examine_text
	var/datum/callback/after_callback

/datum/component/examine_override/Initialize(list/examine_text, datum/callback/after_callback)
	src.examine_text = examine_text
	src.after_callback = after_callback
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine)

/datum/component/examine_override/proc/examine(origin, mob/user, list/examine_list)
	examine_list.Cut()
	if(examine_text)
		examine_list += examine_text
	
	if(after_callback)
		var/res = after_callback.Invoke(user, examine_list)
		if(res)
			examine_list += res