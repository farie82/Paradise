/datum/action/psionic/active/disguise_self
	name = "Disguise self"
	desc = "Disguises yourself as a selected crewmember, done by using the 'Select disguise' ability. Will cost focus to maintain but you can use abilities in this form."
	button_icon_state = "psionic_disguise_self"
	require_concentration = FALSE
	channel = new /datum/psionic/channel/disguise_self
	var/old_name
	var/datum/component/examine_override/comp

/datum/action/psionic/active/disguise_self/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		if(channel.start_channeling(user, user, psionic_datum, upgraded))
			if(disguise(user))
				activated(user)

/datum/action/psionic/active/disguise_self/deactivate(mob/living/carbon/user)
	. = ..()
	un_disguise(user)

/datum/action/psionic/active/disguise_self/proc/disguise(mob/living/carbon/user)
	var/mob/living/carbon/human/selected_disguise = psionic_datum.selected_disguise
	if(!selected_disguise)
		to_chat(user, "<span class='warning'>You have to select a suitable disguise first</span>")
		return FALSE
	//Todo: make animations
	
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		old_name = H.name_override
		H.name_override = selected_disguise.name
	else
		old_name = user.name
		user.name = selected_disguise.name
	user.icon = selected_disguise.icon
	user.icon_state = selected_disguise.icon_state
	user.overlays = selected_disguise.overlays
	user.update_inv_r_hand()
	user.update_inv_l_hand()
	comp = user.AddComponent(/datum/component/examine_override, selected_disguise.examine(selected_disguise), CALLBACK(src, .proc/examine_after))
	return TRUE

/datum/action/psionic/active/disguise_self/proc/examine_after(origin, mob/user, list/examine_list)
	if(!upgraded && get_dist(user, origin) <= 3) // Add upgraded version
		return "<span class='warning'>It doesn't look quite right...</span>"

/datum/action/psionic/active/disguise_self/proc/un_disguise(mob/living/carbon/user)
	//Todo: make animations
	user.overlays.Cut()
	user.regenerate_icons()
	QDEL_NULL(comp)
	
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.name_override = old_name
	else
		user.name = old_name
	old_name = null
