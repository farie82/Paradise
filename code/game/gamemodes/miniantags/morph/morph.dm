#define MORPHED_SPEED 2
#define ITEM_EAT_COST 5
/mob/living/simple_animal/hostile/morph
	name = "morph"
	real_name = "morph"
	desc = "A revolting, pulsating pile of flesh."
	speak_emote = list("gurgles")
	emote_hear = list("gurgles")
	icon = 'icons/mob/animal.dmi'
	icon_state = "morph"
	icon_living = "morph"
	icon_dead = "morph_dead"
	speed = 1
	a_intent = INTENT_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	pass_flags = PASSTABLE
	ventcrawler = 2

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)

	minbodytemp = 0
	maxHealth = 150
	health = 150
	environment_smash = 1
	obj_damage = 50
	melee_damage_lower = 15
	melee_damage_upper = 15
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	vision_range = 1 // Only attack when target is close
	wander = 0
	attacktext = "glomps"
	attack_sound = 'sound/effects/blobattack.ogg'
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2)

	/// If the morph is disguised or not
	var/morphed = FALSE
	/// If the morph is ready to perform an ambush
	var/ambush_prepared = FALSE
	/// How much damage a successful ambush attack does
	var/ambush_damage = 25
	/// How much weaken a successful ambush attack applies
	var/ambush_weaken = 3
	/// The spell the morph uses to morph
	var/obj/effect/proc_holder/spell/targeted/click/mimic/morph/mimic_spell
	/// The ambush action used by the morph
	var/obj/effect/proc_holder/spell/morph/ambush/ambush_spell

	/// How much the morph has gathered in terms of food. Used to reproduce and such
	var/gathered_food = 20 // Start with a bit to use abilities

/mob/living/simple_animal/hostile/morph/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MAGIC_MIMIC_CHANGE_FORM, .proc/assume)
	RegisterSignal(src, COMSIG_MAGIC_MIMIC_RESTORE_FORM, .proc/restore)
	mimic_spell = new
	AddSpell(mimic_spell)
	ambush_spell = new
	AddSpell(ambush_spell)
	AddSpell(new /obj/effect/proc_holder/spell/morph/reproduce)
	AddSpell(new /obj/effect/proc_holder/spell/morph/open_vent)

/mob/living/simple_animal/hostile/morph/Stat(Name, Value)
	..()
	if(statpanel("Status"))
		stat(null, "Food Stored: [gathered_food]")
		return TRUE

/mob/living/simple_animal/hostile/morph/wizard
	name = "magical morph"
	real_name = "magical morph"
	desc = "A revolting, pulsating pile of flesh. This one looks somewhat.. magical."

/mob/living/simple_animal/hostile/morph/wizard/New()
	. = ..()
	AddSpell(new /obj/effect/proc_holder/spell/targeted/smoke)
	AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall)

/mob/living/simple_animal/hostile/morph/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		visible_message("<span class='warning'>[src] swallows [A] whole!</span>")

		var/mob/living/carbon/human/H = A
		if(istype(H) && H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = H.w_uniform
			U.turn_sensors_off()

		A.extinguish_light()
		A.forceMove(src)
		add_food(calc_food_gained(A))
		add_attack_logs(src, A, "morph ate")
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/morph/proc/calc_food_gained(mob/living/L)
	if(!istype(L))
		return -ITEM_EAT_COST // Anything other than a tasty mob will make me sad ;(
	var/gained_food = max(5, 10 * L.mob_size) // Tiny things are worth less
	if(ishuman(L) && !ismonkeybasic(L))
		gained_food += 10 // Humans are extra tasty

	return gained_food

/mob/living/simple_animal/hostile/morph/proc/use_food(amount)
	if(amount > gathered_food)
		return FALSE
	add_food(-amount)
	return TRUE

/**
 * Adds the given amount of food to the gathered food and updates the actions.
 * Does not include a check to see if it goes below 0 or not
 */
/mob/living/simple_animal/hostile/morph/proc/add_food(amount)
	gathered_food += amount
	for(var/obj/effect/proc_holder/spell/morph/MS in mind.spell_list)
		MS.updateButtonIcon()

/mob/living/simple_animal/hostile/morph/proc/assume()
	morphed = TRUE

	//Morph is weaker initially when disguised
	melee_damage_lower = 5
	melee_damage_upper = 5
	speed = MORPHED_SPEED
	ambush_spell.updateButtonIcon()

/mob/living/simple_animal/hostile/morph/proc/restore()
	if(!morphed)
		return
	morphed = FALSE

	//Baseline stats
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	speed = initial(speed)
	if(ambush_prepared)
		to_chat(src, "<span class='warning'>The ambush potential has faded as you take your true form.</span>")
	failed_ambush()

/mob/living/simple_animal/hostile/morph/proc/prepare_ambush()
	ambush_prepared = TRUE
	to_chat(src, "<span class='sinister'>You are ready to ambush any unsuspected target. Your next attack will hurt a lot more and weaken the target! Moving will break your focus.</span>")

/mob/living/simple_animal/hostile/morph/Moved(atom/OldLoc, Dir, Forced)
	. = ..()
	if(ambush_prepared)
		failed_ambush()
		to_chat(src, "<span class='warning'>You moved out of your ambush spot!</span>")

/mob/living/simple_animal/hostile/morph/proc/failed_ambush()
	ambush_prepared = FALSE
	ambush_spell.updateButtonIcon()

/mob/living/simple_animal/hostile/morph/death(gibbed)
	. = ..()
	if(stat == DEAD && gibbed)
		for(var/atom/movable/AM in src)
			AM.forceMove(loc)
			if(prob(90))
				step(AM, pick(GLOB.alldirs))
	// Only execute the below if we successfully died
	if(!.)
		return FALSE

/mob/living/simple_animal/hostile/morph/attack_hand(mob/living/carbon/human/M)
	if(ambush_prepared)
		to_chat(M, "<span class='warning'>[src] feels a bit different from normal... it feels more.. </span><span class='userdanger'>SLIMEY?!</span>")
		ambush_attack(M, TRUE)
	else
		return ..()

#define MORPH_ATTACKED if((. = ..()) && morphed) mimic_spell.restore_form(src)

/mob/living/simple_animal/hostile/morph/attackby(obj/item/O, mob/living/user)
	if(user.a_intent == INTENT_HELP && ambush_prepared)
		to_chat(user, "<span class='warning'>You try to use [O] on [src]... it seems different than no-</span>")
		ambush_attack(user, TRUE)
		return TRUE
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_animal(mob/living/simple_animal/M)
	if(M.a_intent == INTENT_HELP && ambush_prepared)
		to_chat(M, "<span class='notice'>You nuzzle [src].</span><span class='danger'> And [src] nuzzles back!</span>")
		ambush_attack(M, TRUE)
		return TRUE
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_hulk(mob/living/carbon/human/user, does_attack_animation) // Me SMASH
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_larva(mob/living/carbon/alien/larva/L)
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_alien(mob/living/carbon/alien/humanoid/M)
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_tk(mob/user)
	MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/attack_slime(mob/living/simple_animal/slime/M)
	MORPH_ATTACKED

#undef MORPH_ATTACKED

/mob/living/simple_animal/hostile/morph/proc/ambush_attack(mob/living/L, touched)
	ambush_prepared = FALSE
	var/total_weaken = ambush_weaken
	var/total_damage = ambush_damage
	if(touched) // Touching a morph while he's ready to kill you is a bad idea
		total_weaken *= 2
		total_damage *= 2

	L.Weaken(total_weaken)
	L.apply_damage(total_damage, BRUTE)
	add_attack_logs(src, L, "morph ambush attacked")
	do_attack_animation(L, ATTACK_EFFECT_BITE)
	visible_message("<span class='danger'>[src] Suddenly leaps towards [L]!</span>", "<span class='warning'>You strike [L] when [L.p_they()] least expected it!</span>", "You hear a horrible crunch!")

	mimic_spell.restore_form(src)

/mob/living/simple_animal/hostile/morph/LoseAggro()
	vision_range = initial(vision_range)

/mob/living/simple_animal/hostile/morph/AIShouldSleep(var/list/possible_targets)
	. = ..()
	if(. && !morphed)
		var/list/things = list()
		for(var/atom/movable/A in view(src))
			if(mimic_spell.valid_target(A, src))
				things += A
		var/atom/movable/T = pick(things)
		mimic_spell.take_form(new /datum/mimic_form(T, src), src)
		prepare_ambush() // They cheat okay

/mob/living/simple_animal/hostile/morph/AttackingTarget()
	if(isliving(target)) // Eat Corpses to regen health
		var/mob/living/L = target
		if(L.stat == DEAD)
			if(do_after(src, 30, target = L))
				if(eat(L))
					adjustHealth(-50)
			return
		if(ambush_prepared)
			ambush_attack(L)
	else if(istype(target,/obj/item)) // Eat items just to be annoying
		var/obj/item/I = target
		if(!I.anchored)
			if(gathered_food < ITEM_EAT_COST)
				to_chat(src, "<span class='warning'>You can't force yourself to eat more disgusting items. Eat some living things first.</span>")
				return
			to_chat(src, "<span class='warning'>You start eating [I]... disgusting....</span>")
			if(do_after(src, 20, target = I))
				eat(I)
			return
	. = ..()
	if(. && morphed)
		mimic_spell.restore_form(src)


/mob/living/simple_animal/hostile/morph/proc/make_morph_antag(give_default_objectives = TRUE)
	mind.assigned_role = SPECIAL_ROLE_MORPH
	mind.special_role = SPECIAL_ROLE_MORPH
	SSticker.mode.traitors |= mind
	to_chat(src, "<b><font size=3 color='red'>You are a morph.</font><br></b>")
	to_chat(src, "<span class='sinister'>You hunger for living beings and desire to procreate. Achieve this goal by ambushing unsuspecting pray using your abilities.</span>")
	to_chat(src, "<span class='specialnotice'>As an abomination created primarily with changeling cells you may take the form of anything nearby by using your <span class='specialnoticebold'>Mimic ability</span>.</span>")
	to_chat(src, "<span class='specialnotice'>The transformation will not go unnoticed for bystanding observers.</span>")
	to_chat(src, "<span class='specialnoticebold'>While morphed</span><span class='specialnotice'>, you move slower and do less damage. In addition, anyone within three tiles will note an uncanny wrongness if examining you.</span>")
	to_chat(src, "<span class='specialnotice'>From this form you can however <span class='specialnoticebold'>Prepare an Ambush</span> using your ability.</span>")
	to_chat(src, "<span class='specialnotice'>This will allow you to deal a lot of damage the first hit. And if they touch you then even more.</span>")
	to_chat(src, "<span class='specialnotice'>Finally, you can attack any item or dead creature to consume it - creatures will restore 1/3 of your max health and will add to your stored food while eating items will reduce your stored food</span>.")
	if(give_default_objectives)
		var/datum/objective/eat = new /datum/objective
		eat.owner = mind
		eat.explanation_text = "Eat as many living beings as possible to still the hunger within you."
		eat.completed = TRUE
		mind.objectives += eat
		var/datum/objective/procreate = new /datum/objective
		procreate.owner = mind
		procreate.explanation_text = "Split yourself in as many other [src.name]'s as possible!"
		procreate.completed = TRUE
		mind.objectives += procreate
		mind.announce_objectives()
		playsound_local(get_turf(src), 'sound/magic/mutate.ogg', 100, FALSE, pressure_affected = FALSE)

#undef MORPHED_SPEED
#undef ITEM_EAT_COST
