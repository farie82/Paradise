/datum/action/psionic/active/targeted/hallucinations
	name = "Hallucinations"
	desc = "Give a target hallucinations that seem real to him. They are that real that they will actually hurt him."
	button_icon_state = "psionic_hallucination"

/datum/action/psionic/active/targeted/hallucinations/use_ability_on(atom/target, mob/living/user)
	var/obj/effect/hallucination/fakeattacker/real/H = new(target.loc, target)