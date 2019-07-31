/datum/psionic
	var/harvested_thoughts_total	= 0 // How many thoughts he harvested
	var/harvested_thoughts_usable	= 0 // How many thoughts he has to spend
	var/datum/action/psionic/active/active_ability = null // Which ability is selected

/datum/psionic/proc/harvest_thought(mob/living/carbon/human/victim, mob/living/carbon/human/psionic)
	harvested_thoughts_total++
	harvested_thoughts_usable++
	to_chat(psionic, "<span class='notice'>You harvested another set of thoughts. You have a total of [harvested_thoughts_total] from which you can use [harvested_thoughts_usable].")