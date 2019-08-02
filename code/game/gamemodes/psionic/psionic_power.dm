/datum/action/psionic
	name = "Base psionic ability"
	desc = "" // Fluff
	background_icon_state = "bg_default" //TODO: change this
	check_flags = AB_CHECK_CONSCIOUS
	var/helptext = "" // Details
	var/focus_cost = 0 // negative focus cost is for passive abilities (Invisible)
	var/thoughts_cost = -1 //cost of the ability in harvested thoughts. 0 = auto-purchase, -1 = cannot be purchased
	var/req_stat = CONSCIOUS // CONSCIOUS, UNCONSCIOUS or DEAD
	var/needs_button = TRUE // for passive abilities like hivemind that dont need a button
	var/active = FALSE // used by a few powers that toggle
	var/cooldown = 0 // Cooldown before the ability can be used again in seconds
	var/last_use = -INFINITY
	var/activation_messages = list("puts one hand on his temples", "looks like he's really focusing", "closes his eyes.")

/datum/action/psionic/proc/on_purchase(var/mob/user)
	if(needs_button)
		Grant(user)
	else
		owner = user // manually set it

/datum/action/psionic/Trigger()
	var/mob/living/carbon/user = owner
	if(!user || !user.mind || !user.mind.psionic)
		return

	if(activate(user))
		used(user)

// Override this to implement functionality
/datum/action/psionic/proc/activation_message(mob/living/carbon/human/user)
	user.visible_message("<span class='notice'>[user] [pick(activation_messages)].</span>", "<span class='notice'>You cast [src].</span>")

/datum/action/psionic/IsAvailable()
	return ..() && (stop_watch(last_use) >= cooldown) && owner.mind.psionic.focus_amount >= focus_cost

/datum/action/psionic/proc/used(mob/living/carbon/user)
	last_use = start_watch()
	user.mind.psionic.use_focus(focus_cost)

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
