/datum/component/damage_callback
	var/datum/callback/callback
	var/damage_limit
	var/total_damage = 0

/datum/component/damage_callback/Initialize(damage_limit, callback)
	var/mob/living/carbon/human/H = parent
	if(!istype(H) || damage_limit <= 0 || !callback) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	src.damage_limit = damage_limit
	src.callback = callback
	RegisterSignal(H, COMSIG_HUMAN_APPLY_DAMAGE, .proc/apply_damage)

/datum/component/damage_callback/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_APPLY_DAMAGE)

/datum/component/damage_callback/proc/apply_damage(mob/living/carbon/human/H, damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, sharp = 0, obj/used_weapon = null)
	if(H.stat != DEAD)
		if(damage > 0) // Only count damage. Not healing
			total_damage += damage
			if(total_damage >= damage_limit)
				callback.Invoke()