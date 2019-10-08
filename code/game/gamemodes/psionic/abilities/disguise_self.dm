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
	old_name = user.name
	//Todo: make animations
	user.appearance = selected_disguise.appearance
	user.name = selected_disguise.name
	user.transform = initial(user.transform)
	user.pixel_y = initial(user.pixel_y)
	user.pixel_x = initial(user.pixel_x)
	comp = user.AddComponent(/datum/component/examine_override, selected_disguise.examine(selected_disguise))
	return TRUE

/datum/action/psionic/active/disguise_self/proc/examine_after(origin, mob/user, list/examine_list)
	if(!upgraded && get_dist(user, origin) <= 3) // Add upgraded version
		return "<span class='warning'>It doesn't look quite right...</span>"

/datum/action/psionic/active/disguise_self/proc/un_disguise(mob/living/carbon/user)
	//Todo: make animations
	user.regenerate_icons()
	QDEL_NULL(comp)
	user.name = old_name
