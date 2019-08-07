/datum/action/psionic/active/targeted/mind_control
	name = "Mind control"
	desc = "Control a target for a short duration. While mind controlled the victim won't perceive anything from his surrounding."
	button_icon_state = "psionic_mind_control"

	cooldown = 1 MINUTES
	channel = new /datum/psionic/channel/mind_control
	
	var/mob/living/captive_brain/victim_brain
	var/duration = 3 MINUTES

/datum/action/psionic/active/targeted/mind_control/use_ability_on(atom/target, mob/living/user)
	var/mob/living/T = target
	if(!T)
		return FALSE
	. = channel.start_channeling(user, target, psionic_datum, upgraded)
	

/datum/action/psionic/active/targeted/mind_control/proc/start_mind_control(mob/living/target, mob/living/user)
	spawn(0)
		victim_brain = mind_control(target, user)
		for(var/datum/action/psionic/P in user.actions)
			P.Grant(target)
		addtimer(CALLBACK(src, .proc/release_mind_control, target, user), duration) // Remove the mind control after the duration

/datum/action/psionic/active/targeted/mind_control/proc/release_mind_control(mob/living/target, mob/living/user)
	release_mind_control(target, user, victim_brain)
	for(var/datum/action/psionic/P in target.actions)
		P.Remove(target)
