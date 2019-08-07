/datum/action/psionic/increase_concentration
	name = "Increased concentration"
	desc = "Increases your focus pool."
	needs_button = FALSE // Passive

/datum/action/psionic/increase_concentration/on_purchase(mob/user)
	. = ..()
	psionic_datum.focus_max *= 2 // TODO: Balance it later