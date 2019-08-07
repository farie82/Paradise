/datum/psionic/channel_stage/mind_manipulation/mind_slave_1
	duration = 7 SECONDS
	able_to_move = FALSE
	cancellable = FALSE
	melee_range = TRUE

/datum/psionic/channel_stage/mind_manipulation/mind_slave_1/success(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
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
	
	H.emote("scream") // MY GOD IT HURTS!

	if(H.mind.som && (H.mind in H.mind.som.serv)) // Unslave them
		var/datum/mindslaves/slaved = H.mind.som
		slaved.serv -= H.mind
		
		H.mind.som = null
		slaved.leave_serv_hud(H.mind)
		for(var/datum/objective/protect/mindslave/MS in H.mind.objectives)
			H.mind.objectives -= MS
			if(MS.prior_special_role)
				H.mind.special_role = MS.prior_special_role
		
		if(ismindslave(H))
			var/obj/item/implant/traitor/I = locate(/obj/item/implant/traitor) in target
			I.removed(target)
			qdel(I)
		to_chat(target, "<span class='danger'>You lose your loyalty to your previous owner!</span>")
	else 
		to_chat(target, "<span class='warning'>You start losing grip on your free will!</span>")
	return TRUE

/datum/psionic/channel_stage/mind_manipulation/mind_slave_1/start_channeling(mob/living/carbon/user, target, datum/antagonist/psionic/psionic_datum)
	if(ishuman(target))
		to_chat(target, "<span class='warning'>You start thinking about what loyalty means... Wait that thing is rooting in your brains!</span>")