/datum/action/psionic/active/targeted/illusion
	name = "Illusion"
	desc = "Creates an illusion of choice at a location of choice. Keeping this illusion up takes focus."
	button_icon_state = "psionic_illusion"
	cooldown = 30
	focus_cost = 20

	channel = new /datum/psionic/channel/illusion
	var/list/types_to_pick = list("Wall" = /obj/structure/falsewall, "Grille" = /obj/structure/grille, "Airlock" = /obj/machinery/door/airlock, "Fake fire" = /obj/effect/hotspot/fake/faker)
	var/list/upgraded_to_pick = list("Fire" = /obj/effect/hotspot/fake)

	var/obj/illusion/active_illusion // Which illusion is currently active
	var/atom/selected_illusion

/datum/action/psionic/active/targeted/illusion/use_ability_on(atom/target, mob/living/user)
	if(target == user)
		//select illusion
		var/list/all = types_to_pick
		if(upgraded)
			all += upgraded_to_pick
		var/name = input("Choose an illusion.", "Illusion") as null|anything in all
		to_chat(user, "<span class='notice'>Selected [name].</span>")
		selected_illusion = all[name]
		return FALSE
	else
		if(!selected_illusion)
			to_chat(user, "<span class='warning'>You have to select an illusion first! Target yourself first!</span>")
			return FALSE
		. = channel.start_channeling(user, target, psionic_datum, upgraded)

/obj/illusion
	var/mob/living/carbon/caster
	var/upgraded
	var/atom/illusion_object
	obj_integrity = 50
	var/illusion_duration = 30 SECONDS

/obj/illusion/Initialize(mapload, type, caster, upgraded)
	. = ..()
	src.upgraded = upgraded
	src.caster = caster
	
	illusion_object = new type(loc) // Make it spawn yet make it invisible. Use this object to simulate the real effect. Since it's actually there!
	smooth_icon(illusion_object)
	icon = illusion_object.icon
	icon_state = illusion_object.icon_state
	overlays = illusion_object.overlays

	opacity = illusion_object.opacity
	name = illusion_object.name
	
	illusion_object.invisibility = INVISIBILITY_ABSTRACT
	illusion_object.density = upgraded ? illusion_object.density : FALSE // Real or not
	obj_integrity *= upgraded + 1 // * 1 or 2
	
	spawn(illusion_duration)
		QDEL_NULL(src)

/obj/illusion/examine(mob/user, distance, infix, suffix)
	return illusion_object.examine(user, distance, infix, suffix)

/obj/illusion/Destroy()
	visible_message("<span class='warning'>[src] suddenly vanishes!</span>")
	to_chat(caster, "<span class='notice'>You feel that the illusion has faded away.</span>")
	QDEL_NULL(illusion_object)
	. = ..()

/obj/illusion/attack_hand(mob/living/user)
	if(caster == user)
		qdel(src)
	else
		. = ..()