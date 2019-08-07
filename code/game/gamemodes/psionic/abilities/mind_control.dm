/datum/action/psionic/active/targeted/mind_control
	name = "Mind control"
	desc = "Control a target for a short duration. While mind controlled the victim won't perceive anything from his surrounding."
	button_icon_state = "psionic_mind_control"

	cooldown = 300 // 300 seconds
	channel = new /datum/psionic/channel/mind_control
	
	var/mob/living/captive_brain/victim_brain
	var/duration = 3 MINUTES

	var/datum/component/damage_callback/victim_damage_callback
	var/datum/component/damage_callback/user_damage_callback

/datum/action/psionic/active/targeted/mind_control/use_ability_on(atom/target, mob/living/user)
	var/mob/living/T = target
	if(!T)
		return FALSE
	. = channel.start_channeling(user, target, psionic_datum, upgraded)
	

/datum/action/psionic/active/targeted/mind_control/proc/start_mind_control(mob/living/target, mob/living/user)
	
	add_attack_logs(user, target, "mind controlled")
	victim_brain = mind_control(target, user)
	victim_brain.BecomeBlind() // It's all so dark
	victim_brain.BecomeDeaf() // And so quiet
	to_chat(victim_brain, "<span class='userdanger'>You suddenly lose all control over yourself!</span>")
	to_chat(target, "<span class='notice'>You have taken control over [target]. He will regain control in [duration/600] minutes.</span>") // Target here due to the target now being the psionic
	victim_damage_callback = new(target, 50, CALLBACK(src, .proc/stop_mind_control, target, user))
	user_damage_callback = new(user, 10, CALLBACK(src, .proc/stop_mind_control, target, user))
	// TODO: make life hell for the mindcontrolled person
	for(var/datum/action/psionic/P in user.actions)
		P.Grant(target)
	addtimer(CALLBACK(src, .proc/stop_mind_control, target, user), duration) // Remove the mind control after the duration

/datum/action/psionic/active/targeted/mind_control/proc/stop_mind_control(mob/living/target, mob/living/user)
	if(victim_brain)
		spawn(0)
			if(!victim_brain) // Just in case
				return
			release_mind_control(target, user, victim_brain)
			for(var/datum/action/psionic/P in target.actions)
				P.Grant(user) // Give them back to the psionic
			target.emote("faint") // Muh gud
			target.AdjustDrowsy(2)
			target.AdjustSleeping(2) // Sleep it off
			to_chat(target, "<span class='userdanger'>You can't seem to remember what happened to you the last [duration/600] minutes!</span>")

			if(victim_damage_callback.total_damage >= victim_damage_callback.damage_limit) // Broken by damage to victim
				to_chat(user, "<span class='danger'>The mindcontrol is broken due to our victim receiving to much damage!</span>")
				user.Weaken(4) // Backlash
			qdel(victim_damage_callback)
			qdel(user_damage_callback)
			add_attack_logs(user, target, "ended mind control over")
