/datum/psionic/channel_stage/mind_slave/suggestion_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/mind_slave/suggestion_2/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H)
		return FALSE 
	if(istype(H, /mob/living/carbon/human/psionic))
		to_chat(psionic, "<span class='warning'>We can't implant an idea in a fellow psionic!</span>")
		return FALSE
	if(ismindshielded(H))
		to_chat(psionic, "<span class='warning'>This victim is mindshielded!</span>")
		return FALSE
	
	var/datum/action/psionic/active/targeted/suggestion/ability = psionic.mind.psionic.get_active_ability_by_type(/datum/action/psionic/active/targeted/suggestion)

	if(!ability.selected_suggestion)
		return FALSE
	
	H.emote("gasp") // Oh darn I want to do this!
	
	var/datum/objective/suggestion/S = new(ability.selected_suggestion.explanation_text)
	S.owner = H.mind
	S.target = psionic.mind
	S.prior_special_role = H.mind.special_role
	H.mind.objectives += S
	
	H.mind.special_role = SPECIAL_ROLE_PSIONIC_SUGGESTION
	
	addtimer(CALLBACK(S, /datum/objective/suggestion/proc/check_removal), S.duration) // Check if the suggestion should be over later. Needed when increasing the duration by extra channeling
	add_attack_logs(psionic, H, "Psionic-suggested")
	
	to_chat(target, "<span class='userdanger'>You suddenly have the extreme urge to do something special! Be sure you try to achieve this the best you can.</span>")
	to_chat(target, "<span class='bnotice'>Objective #1</span><span class='notice'>: [S.explanation_text]</span>")
	to_chat(psionic, "<span class='warning'>You have successfully implanted the suggestion in [H]'s mind. <i>If [H.p_they()] refuse[H.p_s()] to do as you say just adminhelp.</i></span>")

	return TRUE
