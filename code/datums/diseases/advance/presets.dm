// Cold

/datum/disease/advance/cold/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Cold"
		symptoms = list(new/datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Flu"
		symptoms = list(new/datum/symptom/cough)
	..(process, D, copy)


// Voice Changing

/datum/disease/advance/voice_change/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Epiglottis Mutation"
		symptoms = list(new/datum/symptom/voice_change)
	..(process, D, copy)


// Toxin Filter

/datum/disease/advance/heal/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Liver Enhancer"
		symptoms = list(new/datum/symptom/heal)
	..(process, D, copy)


// Hullucigen

/datum/disease/advance/hullucigen/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Reality Impairment"
		symptoms = list(new/datum/symptom/hallucigen)
	..(process, D, copy)

// Sensory Restoration

/datum/disease/advance/sensory_restoration/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Reality Enhancer"
		symptoms = list(new/datum/symptom/sensory_restoration)
	..(process, D, copy)

// Neural Destruction

/datum/disease/advance/neural_destruction/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)
	if(!D)
		name = "Reality Destruction"
		symptoms = list(new/datum/symptom/neural_destruction)
	..(process, D, copy)
