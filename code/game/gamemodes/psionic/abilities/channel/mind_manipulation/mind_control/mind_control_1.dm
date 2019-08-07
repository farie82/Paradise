/datum/psionic/channel_stage/mind_manipulation/mind_control_1
	duration = 7 SECONDS
	able_to_move = FALSE
	cancellable = FALSE

/datum/psionic/channel_stage/mind_manipulation/mind_control_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	var/mob/living/carbon/human/H = target
	if(!H)
		//Target is not human
		return FALSE 

	if(istype(H, /mob/living/carbon/human/psionic))
		to_chat(user, "<span class='warning'>We can't enslave a fellow psionic! We can however harvest its brain for our own good!</span>")
		return FALSE

	if(ismindshielded(H))
		to_chat(user, "<span class='warning'>This victim is mindshielded!</span>")
		return FALSE
	
	if(prob(50))
		to_chat(target, "<span class='warning'>You start losing grip on your free will!</span>")
	return TRUE

/datum/psionic/channel_stage/mind_manipulation/mind_control_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	if(ishuman(target))
		to_chat(target, "<span class='warning'>You start thinking about what loyalty means... Wait that thing is rooting in your brains!</span>")