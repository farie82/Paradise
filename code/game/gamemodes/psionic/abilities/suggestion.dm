/datum/action/psionic/active/targeted/suggestion
	name = "Suggestion"
	desc = "Implants an idea into your targets brain. You get to pick from a selection of preset ideas which will usually lead to isolation of targets or distractions."

	channel = new /datum/psionic/channel/suggestion
	var/list/datum/objective/suggestion/suggestions = list( \
		"Lure other" = new /datum/objective/suggestion("You have a surprise for a coworker. Lure one into this room. Make sure he's alone since the suprise is only for that person!"), \
		"Clear room" = new /datum/objective/suggestion("This room is to crowded. Make the other people leave to let you focus again."), \
		"Get security" = new /datum/objective/suggestion("You have something to show security. Ensure they come to this room right now!"), \
		"Lure security away" = new /datum/objective/suggestion("You have something you don't want security to find. Make sure they will be on the other side of the station!"), \
		"Block security" = new /datum/objective/suggestion("You are done with the system! Make sure no security member enters this room, ensure you do this without harm since you are protesting peacefully."), \
		"Seek sollitude" = new /datum/objective/suggestion("You need some time alone. The nearest maintenance looks like a fitting place to take a small break. You need some time alone so don't bring others."))
	var/datum/objective/suggestion/selected_suggestion

/datum/action/psionic/active/targeted/suggestion/use_ability_on(atom/target, mob/living/user)
	if(target == user)
		//Select Suggestion
		var/name = input("Choose an suggestion.", "Suggestion") as null|anything in suggestions
		to_chat(user, "<span class='notice'>Selected [name].</span>")
		selected_suggestion = suggestions[name]
		return FALSE
	else
		if(!selected_suggestion)
			to_chat(user, "<span class='warning'>You have to select an suggestion first! Target yourself first!</span>")
			return FALSE
		. = channel.start_channeling(user, target, psionic_datum, upgraded)

/datum/objective/suggestion
	completed = TRUE // Muh GREENTEXT
	var/duration = 5 MINUTES
	var/start_moment = 0
	var/prior_special_role

/datum/objective/suggestion/proc/check_removal()
	var/dif = stop_watch(start_moment) * 10 - duration
	if(dif >= 0)
		remove_suggestion()
	else
		addtimer(CALLBACK(src, .proc/check_removal), dif) // Check if the suggestion should be over later. Needed when increasing the duration by extra channeling

/datum/objective/suggestion/proc/remove_suggestion()
	if(src in owner.objectives)
		owner.objectives -= src
		owner.special_role = prior_special_role
		if(owner.current)
			owner.current.emote("faint") // Gain control of yourself again. Also makes him notice chat a bit more I hope
			to_chat(owner.current, "<span class='userdanger'>You suddenly lose interest in what you were doing before. Hell you don't even remember anything for the last 10 minutes.</span>")
	qdel(src)