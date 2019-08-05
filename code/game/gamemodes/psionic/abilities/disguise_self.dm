/datum/action/psionic/active/disguise_self
	name = "Disguise self"
	desc = "Disguises yourself as a selected crewmember, done by using the 'Select disguise' ability. Will cost focus to maintain but you can use abilities in this form."
	require_concentration = FALSE
	channel = new /datum/psionic/channel/disguise_self
	var/old_name

/datum/action/psionic/active/disguise_self/activate(mob/living/carbon/user)
	. = ..()
	if(.)
		if(channel.start_channeling(user, user))
			disguise(user)
			activated(user)

/datum/action/psionic/active/disguise_self/deactivate(mob/living/carbon/user)
	. = ..()
	un_disguise(user)

/datum/action/psionic/active/disguise_self/proc/disguise(mob/living/carbon/user)
	var/mob/living/carbon/human/selected_disguise = user.mind.psionic.selected_disguise
	old_name = user.name
	//Todo: make animations
	user.appearance = selected_disguise.appearance
	user.name = selected_disguise.name
	user.transform = initial(user.transform)
	user.pixel_y = initial(user.pixel_y)
	user.pixel_x = initial(user.pixel_x)

/datum/action/psionic/active/disguise_self/proc/un_disguise(mob/living/carbon/user)
	//Todo: make animations
	user.regenerate_icons()
	user.name = old_name
