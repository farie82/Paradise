/datum/component/human_damage_callback
	dupe_type = COMPONENT_DUPE_ALLOWED
	var/datum/callback/callback
	var/list/allowed_damage_types
	var/damage_limit
	var/total_damage = 0

// Takes a limit and a callback as manditory arguments. Will not unregister itself after the callback is called
// Optionally takes the allowed damage types as argument in the form of (BRUTE, BURN) for example
/datum/component/human_damage_callback/Initialize(_damage_limit, _callback, damage_types = null)
	var/mob/living/carbon/human/H = parent
	if(!istype(H) || _damage_limit <= 0 || !_callback) //Something went wrong
		return COMPONENT_INCOMPATIBLE
	damage_limit = _damage_limit
	callback = _callback
	allowed_damage_types = damage_types
	RegisterSignal(H, COMSIG_HUMAN_APPLY_DAMAGE, .proc/register_damage)

/datum/component/human_damage_callback/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_APPLY_DAMAGE)

/datum/component/human_damage_callback/proc/register_damage(mob/living/carbon/human/H, damage, damagetype, def_zone, blocked, sharp, obj/used_weapon)
	if(damage > 0 && (!allowed_damage_types || damagetype in allowed_damage_types)) // Only count damage. Not healing
		total_damage += damage
		if(total_damage >= damage_limit)
			callback.Invoke()