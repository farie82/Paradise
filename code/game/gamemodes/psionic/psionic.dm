/datum/antag/psionic
	var/harvested_thoughts_total	= 0 // How many thoughts he harvested
	var/harvested_thoughts_usable	= 0 // How many thoughts he has to spend

	var/focus_max = 150
	var/focus_amount = 75
	var/focus_recharge_rate_passive = 0.5
	var/focus_recharge_rate_meditate = 20

	var/datum/action/psionic/active/active_ability = null // Which ability is selected
	var/datum/component/psionic_focus_regen/psionic_focus_regen_comp

/datum/antag/psionic/New(mob/living/carbon/C)
	. = ..()
	psionic_focus_regen_comp = C.AddComponent(/datum/component/psionic_focus_regen, src)

/datum/antag/psionic/proc/harvest_thought(mob/living/carbon/human/victim, mob/living/carbon/psionic)
	harvested_thoughts_total++
	harvested_thoughts_usable++
	to_chat(psionic, "<span class='notice'>You harvested another set of thoughts. You have a total of [harvested_thoughts_total] from which you can use [harvested_thoughts_usable].")

/datum/antag/psionic/proc/use_focus(mob/living/carbon/psionic, amount)
	if(amount > focus_amount)
		focus_amount = 0
		to_chat(psionic, "<span class='danger'>You are fully drained of focus!</span>")
		psionic.AdjustWeaken(3)
	else
		focus_amount -= amount

/datum/antag/psionic/proc/regen_focus(mob/living/carbon/psionic, meditating = FALSE)
	if(!meditating)
		focus_amount = min(focus_max * 0.5, focus_amount + focus_recharge_rate_passive) // Max is halved and slower regen.
	else
		focus_amount = min(focus_max, focus_amount + focus_recharge_rate_meditate)

/datum/component/psionic_focus_regen
	var/datum/antag/psionic/psionic

/datum/component/psionic_focus_regen/Initialize(datum/antag/psionic/psi)
	var/mob/living/carbon/C = parent
	if(!istype(C) || !psi) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	psionic = psi
	RegisterSignal(C, COMSIG_LIVING_LIFE, .proc/Life)

/datum/component/psionic_focus_regen/proc/Life(mob/living/carbon/C)
	if(C.stat != DEAD)
		psionic.regen_focus(parent)