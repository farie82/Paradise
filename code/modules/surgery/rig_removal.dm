//Procedures in this file: Unsealing a Rig.
//Bay12 removal
/datum/surgery_step/rigsuit
	name="Cut Seals"
	allowed_surgery_behaviour = SURGERY_CUT_SEALS
	surgery_start_stage = SURGERY_STAGE_START
	next_surgery_stage = SURGERY_STAGE_START
	possible_locs = list("chest")
	pain = FALSE
	can_infect = 0
	blood_level = 0

	time = 50

/datum/surgery_step/rigsuit/can_use(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!istype(target))
		return 0
	if(tool.tool_behaviour == TOOL_WELDER)
		if(!tool.tool_use_check(user, 0))
			return
		if(!tool.use(1))
			return
	return (target_zone == "chest") && istype(target.back, /obj/item/rig) && (target.back.flags&NODROP)

/datum/surgery_step/rigsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." , \
	"You start cutting through the support systems of [target]'s [target.back] with \the [tool].")
	..()

/datum/surgery_step/rigsuit/end_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message("<span class='notice'>[user] has cut through the support systems of [target]'s [rig] with \the [tool].</span>", \
		"<span class='notice'>You have cut through the support systems of [target]'s [rig] with \the [tool].</span>")
	return TRUE

/datum/surgery_step/rigsuit/fail_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='danger'>[user]'s [tool] can't quite seem to get through the metal...</span>", \
	"<span class='danger'>Your [tool] can't quite seem to get through the metal. It's weakening, though - try again.</span>")
	return FALSE
