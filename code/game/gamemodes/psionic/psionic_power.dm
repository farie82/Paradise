/datum/action/psionic
	name = "Base psionic ability"
	desc = "" // Fluff
	background_icon_state = "bg_psionic"
	check_flags = AB_CHECK_CONSCIOUS
	
	var/datum/antagonist/psionic/psionic_datum // The psionic using these abilities.
	var/helptext = "" // Details
	var/focus_cost = 0 // negative focus cost is for passive abilities (Invisible)
	var/thoughts_cost = -1 //cost of the ability in harvested thoughts. 0 = auto-purchase, -1 = cannot be purchased
	var/req_stat = CONSCIOUS // CONSCIOUS, UNCONSCIOUS or DEAD
	var/needs_button = TRUE // for passive abilities like hivemind that dont need a button
	var/active = FALSE // used by a few powers that toggle
	var/cooldown = 0 // Cooldown before the ability can be used again in seconds
	var/last_use = -INFINITY
	var/activation_messages = list("puts one hand on his temples", "looks like he's really focusing", "closes his eyes.")
	var/upgraded = FALSE
	
	var/datum/psionic/channel/channel // Channel if the ability requires it

/datum/action/psionic/proc/on_purchase(var/mob/user)
	psionic_datum = user.mind.psionic
	if(needs_button)
		Grant(user)
	else
		owner = user // manually set it

/datum/action/psionic/Trigger()
	var/mob/living/carbon/user = usr // "user" can be a mindcontrolled victim
	if(!user)
		return
	if(!IsAvailable())
		to_chat(user, "<span class='warning'>You can't use this ability yet.</span>")
		return
	
	if(channel && psionic_datum.channeling)
		if(!psionic_datum.channeling.cancellable)
			to_chat(user, "<span class='warning'>You are channeling something you cannot stop.</span>")
			return
		psionic_datum.channeling.stop_channeling(psionic_datum)
	
	if(activate(user))
		used(user)

// Override this to implement functionality
/datum/action/psionic/proc/activation_message(mob/living/carbon/human/user)
	user.visible_message("<span class='notice'>[user] [pick(activation_messages)].</span>", "<span class='notice'>You cast [src].</span>")

/datum/action/psionic/IsAvailable()
	return ..() && (stop_watch(last_use) >= cooldown) && psionic_datum.focus_amount >= focus_cost

/datum/action/psionic/proc/used(mob/living/carbon/user)
	last_use = start_watch()
	psionic_datum.use_focus(user, focus_cost)
	START_PROCESSING(SSfastprocess, src) // Update the button

/datum/action/psionic/process()
	UpdateButtonIcon()
	if(IsAvailable())
		return PROCESS_KILL // We're done here

/datum/action/psionic/UpdateButtonIcon()
	if(button && !..() && cooldown > 0) // It's not yet available
		if(psionic_datum.focus_amount >= focus_cost) // Only do the slow fade in when you have enough focus
			var/progress = stop_watch(last_use) / cooldown
			var/half = progress * 72 // Make it noticeable when the ability is ready or still charging but almost done
			var/full = progress * 200
			button.color = rgb(128 + half, full, full, 128 + half) // Make it slowly get back to form

// Override this to implement functionality. If it returns true it'll set the cooldown
/datum/action/psionic/proc/activate(mob/living/carbon/user)
	activation_message(user)
	return TRUE

/datum/action/psionic/proc/danger_mob_check(mob/living/carbon/user, thing)
	. = FALSE
	if(isliving(thing))
		var/mob/living/L = thing
		if(L.stat != DEAD) // Dead things can't hurt you
			if(L.mind) // TODO: Check if mindslaved
				return TRUE
			if(isanimal(L))
				var/mob/living/simple_animal/hostile/S = L
				if(!("neutral" in S.faction)) // Hostile check
					return TRUE
				if(istype(S, /mob/living/simple_animal/hostile/retaliate))
					var/mob/living/simple_animal/hostile/retaliate/R = S
					if(user in R.enemies)
						return TRUE
