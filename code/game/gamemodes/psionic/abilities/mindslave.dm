/datum/action/psionic/active/targeted/mindslave
	name = "Mind slave"
	desc = "Mind slave somebody. You will have to be close to the target. It consists of two steps. The first one you can't move and takes a long time. The second one you can move and takes a bit shorter."
	ranged = FALSE
	channel = new /datum/psionic/channel/mind_slave

/datum/action/psionic/active/targeted/mindslave/use_ability_on(atom/target, mob/living/user)
	var/mob/living/carbon/human/H = target
	if(!H || !H.mind)
		to_chat(user, "<span class='warning'>We can't mindslave ones without brain activity!</span>")
		return FALSE

	if(user == target)
		to_chat(user, "<span class='warning'>You're... going to mindslave yourself?</span>")
		return FALSE

	if(ismindshielded(H))
		to_chat(user, "<span class='warning'>This one has a mindshield. We cannot mindslave him with it inside of him!</span>")
		return FALSE

	if(H in user.mind.som.serv)
		to_chat(user, "<span class='warning'>We already have this one as our slave.</span>")
		return FALSE
	
	return channel.start_channeling(user, target, upgraded)