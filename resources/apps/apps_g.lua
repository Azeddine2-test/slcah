-- Nando (WIP)

SERVERNAME = "Southland Roleplay"

NUM_QUESTIONS_PART_1 = 6
NUM_QUESTIONS_PART_2 = 4

MIN_CHARS_APP = 45

function canHandleApplications(thePlayer)
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer))
end

function canManageQuestions(thePlayer)
	return (exports.integration:isPlayerSeniorAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer))
--	return false
end