/datum/psionic/channel_stage/mind_slave/mind_slave_2
	duration = 4 SECONDS

/datum/psionic/channel_stage/mind_slave/mind_slave_2/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human
		return FALSE 

	if(istype(H, /mob/living/carbon/human/psionic))
		to_chat(psionic, "<span class='warning'>We can't implant an idea in a fellow psionic!</span>")
		return FALSE

	if(ismindshielded(H))
		to_chat(psionic, "<span class='warning'>This victim is mindshielded!</span>")
		return FALSE

	H.emote("faint") // Suddenly realising your life is a lie is rough man

	// TODO: make icons for this
	// SSticker.mode.update_vampire_icons_added(H.mind)
	// SSticker.mode.update_vampire_icons_added(user.mind)
	
	var/datum/mindslaves/slaved = psionic.mind.som
	H.mind.som = slaved
	slaved.serv += H.mind
	
	// TODO: icons
	slaved.add_serv_hud(psionic.mind, "vampire")//handles master servent icons
	slaved.add_serv_hud(H.mind, "vampthrall")

	
	var/datum/objective/protect/mindslave/MS = new
	MS.prior_special_role = H.mind.special_role
	MS.owner = H.mind
	MS.target = psionic.mind
	MS.explanation_text = "Obey every order from and protect [psionic.real_name], the [psionic.mind.assigned_role == psionic.mind.special_role ? (psionic.mind.special_role) : (psionic.mind.assigned_role)]."
	H.mind.objectives += MS
	
	H.mind.special_role = SPECIAL_ROLE_PSIONIC_THRALL
	
	add_attack_logs(psionic, H, "Psionic-mindslaved")
	
	to_chat(target, "<span class='userdanger'>You are now loyal to [psionic]([psionic.real_name]). Follow his commands to the best you can!</span>")
	to_chat(psionic, "<span class='warning'>You have successfully enslaved [H]. <i>If [H.p_they()] refuse[H.p_s()] to do as you say just adminhelp.</i></span>")
	return TRUE

/datum/psionic/channel_stage/mind_slave/mind_slave_2/start_channeling(mob/living/carbon/psionic, target)
	if(ishuman(target))
		to_chat(target, "<span class='danger'>Life is starting to feel meaningless!</span>")