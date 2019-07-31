/datum/action/psionic/active/targeted/sleep
	name = "Sleep"
	desc = "Puts a target to sleep. The channeling has 3 stages. A drowsy effect, a weakening effect and finally it'll put the target to sleep."
	cooldown = 3 SECONDS

/datum/action/psionic/active/targeted/sleep/target(atom/target, mob/living/user)
	var/datum/psionic/channel/sleep/S = new
	return S.start_channeling(user, target)