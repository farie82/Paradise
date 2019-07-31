/datum/action/psionic/active/targeted/sleep
	name = "Sleep"
	desc = "Puts a target to sleep. The channeling has 3 stages. A drowsy effect, a weakening effect and finally it'll put the target to sleep."
	cooldown = 30
	var/datum/psionic/channel/sleep/S = new

/datum/action/psionic/active/targeted/sleep/use_ability_on(atom/target, mob/living/user)
	..()
	return S.start_channeling(user, target)