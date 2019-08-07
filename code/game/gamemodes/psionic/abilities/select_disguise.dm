/datum/action/psionic/active/targeted/select_disguise
	name = "Select disguise"
	desc = "Select a disguise. Target a humanoid to remember their appearance for the 'Disguises self' ability."
	channel = new /datum/psionic/channel/select_disguise

/datum/action/psionic/active/targeted/select_disguise/use_ability_on(atom/target, mob/living/user)
	if(!ishuman(target))
		to_chat(user, "<span class='warning'>You cannot disguise yourself as something non human.</span>")
		return FALSE
	return channel.start_channeling(user, target, psionic_datum, upgraded)