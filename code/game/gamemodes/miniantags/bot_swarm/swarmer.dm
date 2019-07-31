////Deactivated swarmer shell////
/obj/item/deactivated_swarmer
	name = "unactivated swarmer"
	desc = "A currently unactivated swarmer. Swarmers can self activate at any time, it would be wise to immediately dispose of this."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	origin_tech = "bluespace=4;materials=4;programming=7"
	materials = list(MAT_METAL=100, MAT_GLASS=400)

/obj/effect/mob_spawn/swarmer
	name = "unactivated swarmer"
	desc = "A currently unactivated swarmer. Swarmers can self activate at any time, it would be wise to immediately dispose of this."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	density = FALSE
	anchored = FALSE

	mob_type = /mob/living/simple_animal/hostile/swarmer
	mob_name = "a swarmer"
	death = FALSE
	roundstart = FALSE
	flavour_text = {"
	<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>
	<b>Clicking on any object will try to consume it, either deconstructing it into its components, destroying it, or integrating any materials it has into you if successful.</b>
	<b>Ctrl-Clicking on a mob will attempt to remove it from the area and place it in a safe environment for storage.</b>
	<b>Objectives:</b>
	1. Consume resources and replicate until there are no more resources left.
	2. Ensure that this location is fit for invasion at a later date; do not perform actions that would render it dangerous or inhospitable.
	3. Biological resources will be harvested at a later date; do not harm them.
	"}

/obj/effect/mob_spawn/swarmer/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A swarmer shell has been created in [A.name].", 'sound/effects/bin_close.ogg', source = src, action = NOTIFY_ATTACK, flashwindow = FALSE)

/obj/effect/mob_spawn/swarmer/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='notice'>Picking up the swarmer may cause it to activate. You should be careful about this.</span>")

/obj/effect/mob_spawn/swarmer/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/screwdriver)  && user.a_intent != INTENT_HARM)
		user.visible_message("<span class='warning'>[usr.name] deactivates [src].</span>",
			"<span class='notice'>After some fiddling, you find a way to disable [src]'s power source.</span>",
			"<span class='italics'>You hear clicking.</span>")
		new /obj/item/deactivated_swarmer(get_turf(src))
		qdel(src)
	else
		return ..()

////The Mob itself////

/mob/living/simple_animal/hostile/swarmer
	name = "Swarmer"
	real_name = "Swarmer"
	icon = 'icons/mob/swarmer.dmi'
	desc = "A robot of unknown design, they seek only to consume materials and replicate themselves indefinitely."
	speak_emote = list("tones")
	health = 40
	maxHealth = 40
	status_flags = CANPUSH
	icon_state = "swarmer"
	icon_living = "swarmer"
	icon_dead = "swarmer_unactivated"
	wander = 0
	harm_intent_damage = 5
	minbodytemp = 0
	maxbodytemp = 500
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	melee_damage_lower = 15
	melee_damage_upper = 15
	melee_damage_type = STAMINA
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	obj_damage = 0
	environment_smash = 0
	attacktext = "shocks"
	attack_sound = 'sound/effects/empulse.ogg'
	friendly = "pinches"
	speed = 0
	a_intent = INTENT_HARM
	can_change_intents = 0
	faction = list("swarmer")
	projectiletype = /obj/item/projectile/beam/disabler
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	ventcrawler = 2
	ranged = 1
	light_color = LIGHT_COLOR_CYAN
	ranged_cooldown_time = 20
	universal_speak = 0
	universal_understand = 0
	projectilesound = 'sound/weapons/taser2.ogg'
	AIStatus = AI_OFF
	var/resources = 0 //Resource points, generated by consuming metal/glass
	var/max_resources = 100
	loot = list(/obj/effect/decal/cleanable/blood/gibs/robot, /obj/item/stack/ore/bluespace_crystal/artificial)
	deathmessage = "The swarmer explodes with a sharp pop!"
	del_on_death = 1
	hud_possible = list(SPECIALROLE_HUD, DIAG_STAT_HUD, DIAG_HUD)

/mob/living/simple_animal/hostile/swarmer/Login()
	..()
	to_chat(src, "<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>")
	to_chat(src, "<b>Clicking on any object will try to consume it, either deconstructing it into its components, destroying it, or integrating any materials it has into you if successful.</b>")
	to_chat(src, "<b>Ctrl-Clicking on a mob will attempt to remove it from the area and place it in a safe environment for storage.</b>")
	to_chat(src, "<b>Prime Directives:</b>")
	to_chat(src, "1. Consume resources and replicate until there are no more resources left.")
	to_chat(src, "2. Ensure that the station is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	to_chat(src, "3. Biological and sentient resources will be harvested at a later date, do not harm them.")

/mob/living/simple_animal/hostile/swarmer/New()
	..()
	add_language("Swarmer", 1)
	verbs -= /mob/living/verb/pulled
	for(var/datum/atom_hud/data/diagnostic/diag_hud in huds)
		diag_hud.add_to_hud(src)
	updatename()

/mob/living/simple_animal/hostile/swarmer/med_hud_set_health()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(health / maxHealth)]"

/mob/living/simple_animal/hostile/swarmer/med_hud_set_status()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "hudstat"

/mob/living/simple_animal/hostile/swarmer/Stat()
	..()
	if(statpanel("Status"))
		stat("Resources:",resources)

/mob/living/simple_animal/hostile/swarmer/emp_act()
	if(health > 1)
		adjustHealth(health-1)
	else
		death()

/mob/living/simple_animal/hostile/swarmer/CanPass(atom/movable/O)
	if(istype(O, /obj/item/projectile/beam/disabler))//Allows for swarmers to fight as a group without wasting their shots hitting each other
		return 1
	if(isswarmer(O))
		return 1
	..()

/mob/living/simple_animal/hostile/swarmer/proc/updatename()
	real_name = "Swarmer [rand(100,999)]-[pick("kappa","sigma","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]"
	name = real_name


////CTRL CLICK FOR SWARMERS AND SWARMER_ACT()'S////
/mob/living/simple_animal/hostile/swarmer/AttackingTarget()
	if(!isliving(target))
		target.swarmer_act(src)
	else
		..()

/mob/living/simple_animal/hostile/swarmer/CtrlClickOn(atom/A)
	face_atom(A)
	if(!isturf(loc))
		return
	if(next_move > world.time)
		return
	if(!A.Adjacent(src))
		return
	A.swarmer_act(src)
	return

/atom/proc/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/item/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.Integrate(src)
	return FALSE

/atom/movable/swarmer_act()
	if(!simulated)
		return FALSE
	return ..()

/obj/effect/swarmer_act()
	return FALSE

/obj/effect/decal/cleanable/robot_debris/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	qdel(src)
	return TRUE

/obj/item/gun/swarmer_act()//Stops you from eating the entire armory
	return FALSE

/turf/simulated/floor/swarmer_act()//ex_act() on turf calls it on its contents, this is to prevent attacking mobs by DisIntegrate()'ing the floor
	return FALSE

/obj/machinery/atmospherics/swarmer_act()
	return FALSE

/obj/structure/disposalpipe/swarmer_act()
	return FALSE

/obj/machinery/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DismantleMachine(src)
	return TRUE

/obj/machinery/light/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/door/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/camera/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	toggle_cam(S, 0)
	return TRUE

/obj/structure/particle_accelerator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/particle_accelerator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S) // Since the console is still parented to this
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(!active)
		S.DisIntegrate(src)
		return TRUE
	to_chat(S, "<span class='warning'>An inhospitable area may be created as a result of destroying this object. Aborting.</span>")
	return FALSE

/obj/machinery/gravity_generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/vending/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)//It's more visually interesting than dismantling the machine
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/turretid/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/chem_dispenser/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>The volatile chemicals in this machine would destroy us. Aborting.</span>")
	return FALSE

/obj/machinery/nuclearbomb/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This device's destruction would result in the extermination of everything in the area. Aborting.</span>")
	return FALSE

/obj/effect/rune/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Searching... sensor malfunction! Target lost. Aborting.</span>")
	return FALSE

/obj/structure/reagent_dispensers/fueltank/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Destroying this object would cause a chain reaction. Aborting.</span>")
	return FALSE

/obj/structure/cable/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/portable_atmospherics/canister/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>An inhospitable area may be created as a result of destroying this object. Aborting.</span>")
	return FALSE

/obj/machinery/telecomms/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This communications relay should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/message_server/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This communications relay should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/blackbox_recorder/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This machine has recorded large amounts of data on this structure and its inhabitants, it will be a useful resource to our masters in the future. Aborting. </span>")
	return FALSE

/obj/machinery/power/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/gateway/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This bluespace source will be important to us later. Aborting.</span>")
	return FALSE

/obj/machinery/cryopod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryogenic sleeper should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/structure/cryofeed/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryogenic feed should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/computer/cryopod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryopod control computer should be preserved, it contains useful items and information about the inhabitants. Aborting.</span>")
	return FALSE

/turf/simulated/wall/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	for(var/turf/T in range(1, src))
		if(istype(T, /turf/space) || istype(T.loc, /area/space) || istype(T, /turf/simulated/floor/plating/airless))
			to_chat(S, "<span class='warning'>Destroying this object has the potential to cause a hull breach. Aborting.</span>")
			return FALSE
	return ..()

/obj/structure/window/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	for(var/turf/T in range(1, src))
		if(istype(T, /turf/space) || istype(T.loc, /area/space))
			to_chat(S, "<span class='warning'>Destroying this object has the potential to cause a hull breach. Aborting.</span>")
			return FALSE
	return ..()

/obj/item/stack/cable_coil/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)//Wiring would be too effective as a resource
	to_chat(S, "<span class='warning'>This object does not contain enough materials to work with.</span>")
	return FALSE

/obj/item/circuitboard/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This object does not contain enough materials to work with.</span>")
	return FALSE

/obj/machinery/porta_turret/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Attempting to dismantle this machine would result in an immediate counterattack. Aborting.</span>")
	return FALSE

/obj/spacepod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Destroying this vehicle would destroy us. Aborting.</span>")
	return FALSE

/obj/machinery/clonepod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(occupant)
		to_chat(S, "<span class='warning'>Destroying this machine while it is occupied would result in biological and sentient resources to be harmed. Aborting.</span>")
		return FALSE
	return ..()

/mob/living/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisperseTarget(src)
	return TRUE

/mob/living/carbon/slime/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This biological resource is somehow resisting our bluespace transceiver. Aborting.</span>")
	return FALSE

/obj/structure/lattice/catwalk/swarmer_catwalk/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>We have created these for our own benefit. Aborting.</span>")
	return FALSE	

/obj/structure/shuttle/engine/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This shuttle may be important to us later. Aborting.</span>")
	return FALSE	

////END CTRL CLICK FOR SWARMERS////

/mob/living/simple_animal/hostile/swarmer/proc/Fabricate(var/atom/fabrication_object,var/fabrication_cost = 0)
	if(!isturf(loc))
		to_chat(src, "<span class='warning'>This is not a suitable location for fabrication. We need more space.</span>")
	if(resources >= fabrication_cost)
		resources -= fabrication_cost
	else
		to_chat(src, "<span class='warning'>You do not have the necessary resources to fabricate this object.</span>")
		return 0
	new fabrication_object(loc)
	return 1

/mob/living/simple_animal/hostile/swarmer/proc/Integrate(var/obj/item/target)
	if(resources >= max_resources)
		to_chat(src, "<span class='warning'>We cannot hold more materials!</span>")
		return
   		//Check if any entries are either MAT_METAL or MAT_GLASS
	if((MAT_METAL in target.materials) || (MAT_GLASS in target.materials))
		resources++
		do_attack_animation(target)
		changeNext_move(CLICK_CD_MELEE)
		var/obj/structure/swarmer/integrate/I = new /obj/structure/swarmer/integrate(get_turf(target))
		I.pixel_x = target.pixel_x
		I.pixel_y = target.pixel_y
		if(istype(target, /obj/item/stack))
			var/obj/item/stack/S = target
			S.use(1)
			if(S.amount)
				return
		qdel(target)
	else
		to_chat(src, "<span class='warning'>\the [target] is incompatible with our internal matter recycler.</span>")
		return

/mob/living/simple_animal/hostile/swarmer/proc/DisIntegrate(var/atom/movable/target)
	new /obj/structure/swarmer/disintegration(get_turf(target))
	do_attack_animation(target)
	changeNext_move(CLICK_CD_MELEE)
	target.ex_act(3)

/mob/living/simple_animal/hostile/swarmer/proc/DisperseTarget(var/mob/living/target)
	if(target != src)
		to_chat(src, "<span class='info'>Attempting to remove this being from our presence.</span>")
		if(!is_station_level(src.z))
			to_chat(src, "<span class='warning'>Our bluespace transceiver cannot locate a viable bluespace link, our teleportation abilities are useless in this area.</span>")
			return
		if(do_mob(src, target, 30))
			var/turf/simulated/floor/F = find_safe_place_to_teleport()
			if(F)
				if(ishuman(target))//If we're getting rid of a human, slap some zipties on them to keep them away from us a little longer
					var/obj/item/restraints/handcuffs/energy/used/Z = new /obj/item/restraints/handcuffs/energy/used(src)
					Z.apply_cuffs(target, src)
				do_teleport(target, F, 0)
				playsound(src,'sound/effects/sparks4.ogg',50,1)
				
			return

/mob/living/simple_animal/hostile/swarmer/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, safety = FALSE, override = FALSE, tesla_shock = FALSE, illusion = FALSE, stun = TRUE)
	if(!tesla_shock)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/swarmer/proc/DismantleMachine(var/obj/machinery/target)
	do_attack_animation(target)
	to_chat(src, "<span class='info'>We begin to dismantle this machine. We will need to be uninterrupted.</span>")
	var/obj/structure/swarmer/dismantle/D = new /obj/structure/swarmer/dismantle(get_turf(target))
	D.pixel_x = target.pixel_x
	D.pixel_y = target.pixel_y
	if(do_mob(src, target, 100))
		if(!src.Adjacent(target))
			to_chat(src, "<span class='info'>Error:Dismantling aborted.</span>")
		else
			to_chat(src, "<span class='info'>Dismantling complete.</span>")
			var/obj/item/stack/sheet/metal/M = new /obj/item/stack/sheet/metal(target.loc)
			M.amount = 5
			if(target.component_parts && target.component_parts.len)
				for(var/obj/item/I in target.component_parts)
					I.forceMove(M.loc)
			var/obj/structure/swarmer/disintegration/N = new /obj/structure/swarmer/disintegration(get_turf(target))
			N.pixel_x = target.pixel_x
			N.pixel_y = target.pixel_y
			target.dropContents()
			if(istype(target, /obj/machinery/computer))
				var/obj/machinery/computer/C = target
				if(C.circuit)
					new C.circuit(get_turf(M))
			qdel(target)



/obj/structure/swarmer //Default swarmer effect object visual feedback
	name = "swarmer ui"
	desc = null
	gender = NEUTER
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "ui_light"
	layer = MOB_LAYER
	anchored = 1
	unacidable = 1
	light_range = 1
	mouse_opacity = MOUSE_OPACITY_ICON
	var/health = 30
	light_color = LIGHT_COLOR_CYAN
	var/lon_range = 1

/obj/structure/swarmer/New()
	. = ..()
	set_light(lon_range)

/obj/structure/swarmer/disintegration
	icon_state = "disintegrate"

/obj/structure/swarmer/disintegration/New()
	playsound(src.loc, "sparks", 100, 1)
	spawn(10)
		qdel(src)

/obj/structure/swarmer/dismantle
	icon_state = "dismantle"

/obj/structure/swarmer/dismantle/New()
	spawn(25)
		qdel(src)

/obj/structure/swarmer/integrate
	icon_state = "integrate"

/obj/structure/swarmer/integrate/New()
	spawn(5)
		qdel(src)

/obj/structure/swarmer/take_damage(damage)
	health -= damage
	if(health <= 0)
		qdel(src)

/obj/structure/swarmer/bullet_act(obj/item/projectile/Proj)
	if(Proj.damage)
		if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
			take_damage(Proj.damage)
	..()

/obj/structure/swarmer/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item))
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		take_damage(I.force)
	return

/obj/structure/swarmer/ex_act()
	qdel(src)
	return

/obj/structure/swarmer/blob_act()
	qdel(src)
	return

/obj/structure/swarmer/emp_act()
	qdel(src)
	return
/obj/structure/swarmer/attack_animal(mob/living/user)
	if(isanimal(user))
		var/mob/living/simple_animal/S = user
		S.do_attack_animation(src)
		user.changeNext_move(CLICK_CD_MELEE)
		if(S.melee_damage_type == BRUTE || S.melee_damage_type == BURN)
			take_damage(rand(S.melee_damage_lower, S.melee_damage_upper))
	return

/obj/structure/swarmer/trap
	name = "swarmer trap"
	desc = "A quickly assembled trap that electrifies living beings and overwhelms machine sensors. Will not retain its form if damaged enough."
	icon_state = "trap"
	light_range = 1
	light_color = LIGHT_COLOR_CYAN
	health = 10

/obj/structure/swarmer/trap/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(!istype(L, /mob/living/simple_animal/hostile/swarmer))
			playsound(loc,'sound/effects/snap.ogg',50, 1, -1)
			L.electrocute_act(0, src, 1, TRUE, TRUE)
			if(isrobot(L) || L.isSynthetic())
				L.Weaken(5)
			qdel(src)
	..()

/mob/living/simple_animal/hostile/swarmer/proc/CreateTrap()
	set name = "Create trap"
	set category = "Swarmer"
	set desc = "Creates a simple trap that will non-lethally electrocute anything that steps on it. Costs 5 resources."
	if(locate(/obj/structure/swarmer/trap) in loc)
		to_chat(src, "<span class='warning'>There is already a trap here. Aborting.</span>")
		return
	Fabricate(/obj/structure/swarmer/trap, 5)

/mob/living/simple_animal/hostile/swarmer/proc/CreateBarricade()
	set name = "Create barricade"
	set category = "Swarmer"
	set desc = "Creates a barricade that will stop anything but swarmers and disabler beams from passing through."
	if(locate(/obj/structure/swarmer/blockade) in loc)
		to_chat(src, "<span class='warning'>There is already a blockade here. Aborting.</span>")
		return
	if(resources < 5)
		to_chat(src, "<span class='warning'>We do not have the resources for this!</span>")
		return
	if(do_mob(src, src, 10))
		Fabricate(/obj/structure/swarmer/blockade, 5)

/obj/structure/swarmer/blockade
	name = "swarmer blockade"
	desc = "A quickly assembled energy blockade. Will not retain its form if damaged enough, but disabler beams and swarmers pass right through."
	icon_state = "barricade"
	light_range = 1
	light_color = LIGHT_COLOR_CYAN
	health = 50
	density = 1
	anchored = 1

/obj/structure/swarmer/blockade/CanPass(atom/movable/O)
	if(isswarmer(O))
		return 1
	if(istype(O, /obj/item/projectile/beam/disabler))
		return 1

/mob/living/simple_animal/hostile/swarmer/proc/CreateSwarmer()
	set name = "Replicate"
	set category = "Swarmer"
	set desc = "Creates a shell for a new swarmer. Swarmers will self activate."
	to_chat(src, "<span class='info'>We are attempting to replicate ourselves. We will need to stand still until the process is complete.</span>")
	if(resources < 50)
		to_chat(src, "<span class='warning'>We do not have the resources for this!</span>")
		return
	if(!isturf(loc))
		to_chat(src, "<span class='warning'>This is not a suitable location for replicating ourselves. We need more room.</span>")
		return
	if(do_mob(src, src, 100))
		var/createtype = SwarmerTypeToCreate()
		if(createtype && Fabricate(createtype, 50))
			playsound(loc,'sound/items/poster_being_created.ogg',50, 1, -1)

/mob/living/simple_animal/hostile/swarmer/proc/SwarmerTypeToCreate()
	return /obj/effect/mob_spawn/swarmer

/mob/living/simple_animal/hostile/swarmer/proc/RepairSelf()
	set name = "Self Repair"
	set category = "Swarmer"
	set desc = "Attempts to repair damage to our body. You will have to remain motionless until repairs are complete."
	if(!isturf(loc))
		return
	to_chat(src, "<span class='info'>Attempting to repair damage to our body, stand by...</span>")
	if(do_mob(src, src, 100))
		adjustHealth(-100)
		to_chat(src, "<span class='info'>We successfully repaired ourselves.</span>")

/mob/living/simple_animal/hostile/swarmer/proc/ToggleLight()
	if(!light_range)
		set_light(3)
	else
		set_light(0)

/mob/living/simple_animal/hostile/swarmer/proc/ContactSwarmers()
	var/message = input(src, "Announce to other swarmers", "Swarmer contact")
	if(message)
		for(var/mob/M in GLOB.mob_list)
			if(isswarmer(M) || (M in GLOB.dead_mob_list))
				to_chat(M, "<B>Swarm communication - </b> [src] states: [message]")
