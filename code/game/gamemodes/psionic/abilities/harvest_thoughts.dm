/datum/action/psionic/active/targeted/harvest_thoughts
	name = "Harvest thoughts"
	desc = "Harvest the thoughts of a sleeping humanoid. Won't work on humanoids that already harvested. Have to stand in melee range of the victim"
	button_icon_state = "psionic_harvest_thoughts"

	channel = new /datum/psionic/channel/harvest_thoughts
	cooldown = 10
	ranged = FALSE

/datum/action/psionic/active/targeted/harvest_thoughts/use_ability_on(atom/target, mob/living/user)
	if(target == user)
		to_chat(user, "<span class='warning'>Are you mad? We need a humanoid to harvest!</span>")
		return FALSE
	if(!ishuman(target))
		to_chat(user, "<span class='warning'>We can only use this on humanoids.</span>")
		return FALSE
	var/mob/living/carbon/human/H = target
	if(H.stat != UNCONSCIOUS)
		to_chat(user, "<span class='warning'>The victim needs to be asleep for us to harvest his thoughts.</span>")
		return FALSE
	
	return channel.start_channeling(user, H)
