/datum/action/psionic
	name = "Base psionic ability"
	desc = "" // Fluff
	background_icon_state = "bg_default" //TODO: change this
	var/helptext = "" // Details
	var/focus_cost = 0 // negative focus cost is for passive abilities (Invisible)
	var/thoughts_cost = -1 //cost of the ability in harvested thoughts. 0 = auto-purchase, -1 = cannot be purchased
	var/req_stat = CONSCIOUS // CONSCIOUS, UNCONSCIOUS or DEAD
	var/needs_button = TRUE // for passive abilities like hivemind that dont need a button
	var/active = FALSE // used by a few powers that toggle
	var/cooldown = 0 // Cooldown before the ability can be used again

/datum/action/psionic/proc/on_purchase(var/mob/user)
	if(needs_button)
		Grant(user)

/datum/action/psionic/Trigger()
	var/mob/living/carbon/human/user = owner
	if(!user || !user.mind) //|| !user.mind.changeling)
		return

	activation_message(user)
	activate(user)

// Override this to implement functionality
/datum/action/psionic/proc/activation_message(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You cast [src].</span>")


// Override this to implement functionality
/datum/action/psionic/proc/activate(mob/living/carbon/human/user)
	return
