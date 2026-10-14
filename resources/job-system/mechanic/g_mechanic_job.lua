-- Nando 08/03/2023
-- Global variables for mechanic job

--[[
    Mechanics can be:
    - Independent mechanic (job 5)
    - Mechanic of a faction (faction type 8)
]]

MECH_JOB_ID = 5
MECH_FACTION_TYPE = 8

function isInMechanicFaction(player)
    local isMechFac, fID = exports["factions"]:isInFactionType(player, MECH_FACTION_TYPE)
    if isMechFac then
        local dutyFactionID = exports["factions"]:getCurrentFactionDuty(player)
        if dutyFactionID and exports["factions"]:getFactionType(dutyFactionID)==MECH_FACTION_TYPE then
            return dutyFactionID
        end
    end
    return false
end

function isMechanic(player)
    return (getElementData(player, "job") or 0)==MECH_JOB_ID
end

-- Exported
function canMechanicJob(player)
    if isMechanic(player) then
        return true
    end
    if isInMechanicFaction(player) then
        return true
    end
    if exports.integration:isPlayerLeadAdmin(player) or exports.integration:isPlayerLeadScripter(player) then
        return true
    end
    return false
end

local MECH_ACTIONS = {
    ["REPAIR_BODYWORK"] = {250, "Carrosserie"},
    ["REPAIR_ENGINE"] = {800, "Moteur"},
    ["POLISH_PAINT"] = {1000, "Polissage carrosserie"},
    ["TOGGLE_TINT"] = {2500, "Teinture vitres"},
    ["CHANGE_TYRE"] = {500, "Changement pneu"},
    ["REPAINT"] = {1000, "Peinture carosserie"},
    ["HEADLIGHTS_COLOR"] = {5000, "Changement phares"},
    ["CHANGE_LOCK"] = {500, "Changement serrure"},
    ["DUPLICATE_KEY"] = {100, "Duplication de clé"},
}

function getActionCost(action)
    local info = MECH_ACTIONS[tostring(action)]
    if info then
        return info[1]
    end
    return false
end
function getActionName(action)
    local info = MECH_ACTIONS[tostring(action)]
    if info then
        return info[2]
    end
    return false
end