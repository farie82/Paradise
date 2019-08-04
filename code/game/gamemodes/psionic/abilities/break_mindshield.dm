/datum/action/psionic/active/targeted/break_mindshield
	name = "Break Mindshield"
	desc = "Breaks a mindshield of a target. The attack will be quite noticable for the victim"
	button_icon_state = "psionic_break_mindshield"

	cooldown = 45
	focus_cost = 40
	var/datum/psionic/channel/break_mindshield/B = new

/datum/action/psionic/active/targeted/break_mindshield/use_ability_on(atom/target, mob/living/user)
	..()
	if(ishuman(target))
		return B.start_channeling(user, target, upgraded)