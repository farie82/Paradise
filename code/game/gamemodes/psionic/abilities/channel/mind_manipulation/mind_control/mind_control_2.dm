/datum/psionic/channel_stage/mind_manipulation/mind_control_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/mind_manipulation/mind_control_2/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human
		return FALSE 

	if(istype(H, /mob/living/carbon/human/psionic))
		to_chat(user, "<span class='warning'>We can't implant an idea in a fellow psionic!</span>")
		return FALSE

	if(ismindshielded(H))
		to_chat(user, "<span class='warning'>This victim is mindshielded!</span>")
		return FALSE

	var/datum/action/psionic/active/targeted/mind_control/ability = psionic_datum.get_active_ability_by_type(/datum/action/psionic/active/targeted/mind_control)

	if(!ability)
		return FALSE
	
	if(ability.victim_brain)
		to_chat(user, "<span class='warning'>You can't do recursive mindcontrols! Do you want to break everything?!</span>")
		return FALSE

	spawn(0) // Do it after the other stuff is done. Reduces weirdness
		ability.start_mind_control(target, user)
	

	return TRUE

/datum/psionic/channel_stage/mind_manipulation/mind_control_2/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	if(ishuman(target))
		to_chat(target, "<span class='danger'>Life is starting to feel meaningless!</span>")