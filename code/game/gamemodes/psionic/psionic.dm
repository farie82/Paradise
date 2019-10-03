/datum/antagonist/psionic
	var/harvested_thoughts_total	= 0 // How many thoughts he harvested
	var/harvested_thoughts_usable	= 0 // How many thoughts he has to spend

	var/focus_max = 150
	var/focus_amount = 75
	var/focus_recharge_rate_passive = 0.5
	var/focus_recharge_rate_meditate = 20

	var/list/active_abilities = list() // Which ability is selected/active. Can have multiple "active" such as sleep on the ready and invisibility on
	var/datum/psionic/channel/channeling // Which ability is currently channeling

	var/datum/mind/mind

	var/list/datum/mind/mind_slaves = list() // Who are enslaved to this psionic?
	
	var/datum/component/carbon_on_life/psionic_focus_regen_comp
	var/mob/living/carbon/human/selected_disguise

/datum/antagonist/psionic/New(mob/living/carbon/C)
	. = ..()
	mind = C.mind
	C.mind.som = new()
	C.mind.som.masters += C.mind
	psionic_focus_regen_comp = C.AddComponent(/datum/component/carbon_on_life, CALLBACK(src, .proc/use_focus))

/datum/antagonist/psionic/proc/harvest_thought(mob/living/carbon/human/victim, mob/living/carbon/psionic)
	harvested_thoughts_total++
	harvested_thoughts_usable++
	to_chat(psionic, "<span class='notice'>You harvested another set of thoughts. You have a total of [harvested_thoughts_total] from which you can use [harvested_thoughts_usable].")

/datum/antagonist/psionic/proc/use_focus(mob/living/carbon/psionic, amount)
	if(amount > focus_amount) // Can happen if you maintain an ability such as disguise self and cast a channel. Not gonna restrict this in code
		focus_amount = 0
		to_chat(psionic, "<span class='danger'>You are fully drained of focus!</span>")
		psionic.emote("scream") // You fucked up man
		psionic.AdjustWeakened(3)
		for(var/datum/action/psionic/active/ability in active_abilities)
			ability.deactivate(psionic)
	else
		focus_amount -= amount
		if(focus_amount <= amount)
			to_chat(psionic, "<span class='userdanger'>You're almost out of focus!</span>")
	for(var/datum/action/psionic/P in psionic.abilities)
		if(!P.IsAvailable())
			START_PROCESSING(SSfastprocess, P)

/datum/antagonist/psionic/proc/regen_focus(mob/living/carbon/psionic, meditating = FALSE)
	if(!meditating && focus_amount < focus_max * 0.5)
		focus_amount = min(focus_max * 0.5, focus_amount + focus_recharge_rate_passive) // Max is halved and slower regen.
	else
		focus_amount = min(focus_max, focus_amount + focus_recharge_rate_meditate)

/datum/antagonist/psionic/proc/get_active_ability_by_type(type)
	for(var/datum/action/psionic/active/A in active_abilities)
		if(istype(A, type))
			return A
	return null
