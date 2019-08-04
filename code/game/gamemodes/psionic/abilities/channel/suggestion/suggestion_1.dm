/datum/psionic/channel_stage/mind_slave/suggestion_1
	duration = 3 SECONDS

/datum/psionic/channel_stage/mind_slave/suggestion_1/success(mob/living/carbon/psionic, target)
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
	
	if(prob(50))
		to_chat(target, "<span class='notice'>You start to get the feeling you want to do something special... yet not sure what yet</span>")
	
	return TRUE
