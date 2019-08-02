/datum/psionic/channel_stage/break_mindshield_3
	duration = 5 SECONDS

/datum/psionic/channel_stage/break_mindshield_3/success(mob/living/carbon/psionic, target)
	var/mob/living/carbon/human/H = target
	if(!H || !ismindshielded(H))
		//Target is not human. or not mindshielded
		return FALSE 
	H.emote("faint")
	H.adjustBrainLoss(10)
	for(var/obj/item/implant/mindshield/L in H)
		if(L && L.implanted)
			qdel(L)
	to_chat(target, "<span class='warning'>You feel something crack in your head.</span>")
	return TRUE

/datum/psionic/channel_stage/break_mindshield_3/start_channeling(mob/living/carbon/psionic, target)
	if(ishuman(target))
		to_chat(target, "<span class='danger'>It just keeps going!.</span>")