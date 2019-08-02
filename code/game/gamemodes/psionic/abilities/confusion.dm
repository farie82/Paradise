/datum/action/psionic/confusion
	name = "Confusion"
	desc = "Makes a the nearest target confused. They won't be able to walk straight and might start puking and fall down."
	var/target_max = 2 // 2 Targets get influenced at first
	cooldown = 20
	focus_cost = 15

/datum/action/psionic/confusion/activate(mob/living/carbon/user)
	. = ..()
	var/list/targets = list()
	for(var/mob/living/carbon/C in range(2, user.loc))
		if(user != C && danger_mob_check(user, C))
			targets += C

	if(LAZYLEN(targets) == 0)
		return FALSE

	if(LAZYLEN(targets) > target_max) // Randomise the targets
		targets = shuffle(targets)
	for(var/i = 1, i <= target_max, i++)
		var/mob/living/carbon/target = targets[i]
		target.adjustStaminaLoss(40)
		target.AdjustConfused(10, bound_lower = 0, bound_upper = 20)
		if(prob(60))
			target.vomit(20, 0, TRUE, 0, TRUE)