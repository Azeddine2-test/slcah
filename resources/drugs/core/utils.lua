--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Drug System
    Date:		27/06/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.DrugScript = SL.DrugScript or {};
SL.DrugScript.Config = SL.DrugScript.Config or {};


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: getCompleteRecipe
--@ Description: Get the recipe (complete_recipe) from the table
--@ Return: table
function getCompleteRecipe(table)
    --> Variable(s)
    local complete_recipe = {};

    --> Loop: Add all the components to the complete_recipe table
    for k, v in pairs(table) do
        complete_recipe[#complete_recipe + 1] = k;
    end;

    --> Return
    return complete_recipe;
end;

--@ Function: getRecipeName
--@ Description: Get the recipe name
--@ Return: string
function getRecipeName(table)
    --> Variable(s)
    local recipes = SL.DrugScript.Config['recipes'];
    local alt_table = table['infos'].alt_tbl;
    local isRecipe, complete_recipe = isRecipe(alt_table, true);
    local concerned_recipe = getConcernedRecipe(alt_table);
    local name = '';

    --> Check: Recipe (check if the returned boolean is false)
    if not isRecipe then return 'drugs:not_recipe'; end;

    --> Loop: Get the name
    for _, k in pairs(recipes) do
        --> Set: Name
        name = recipes[concerned_recipe][7];
        break;
    end;
 
    --> Return(s)
    return name;
end;

--@ Function: getRecipeFormula
--@ Description: Get the recipe formulas
--@ Return: table
function getRecipeFormula(table)
    local components = SL.DrugScript.Config['components'];
    local isRecipe, complete_recipe = isRecipe(table, true);
    local formulas = {};

    --> Loop: Get the formulas
    for k, v in pairs(components) do
        if table[k] then
            formulas[#formulas + 1] = components[k][2];
        end;
    end;

    --> Return(s)
    return formulas;
end;

--@ Function: isRecipe
--@ Description: Check if the recipe is valid
--@ Return: boolean
function isRecipe(table, bool)
    --> Variable(s)
    local recipes = SL.DrugScript.Config['recipes'];
    local complete_recipe = getCompleteRecipe(table);
    local choosed_1, choosed_2, choosed_3 = tonumber(table[1][1]) or 1, tonumber(table[2][1]) or 1, tonumber(table[3][1]) or 1;
    local isRecipe = false;

    --> Loop: Check if the recipe is valid
    for _, v in pairs(recipes) do
        --> Check: If the recipe is valid
        if tonumber(v[1]) == choosed_1 and tonumber(v[2]) == choosed_2 and tonumber(v[3]) == choosed_3 then
            isRecipe = true;
            break;
        end;
    end;

    --> Return(s)
    if bool then --> If the player wants to know the recipe
        return isRecipe, complete_recipe;
    else
        return isRecipe; 
    end;
end;

--@ Function: getConcernedRecipe
--@ Description: Get the concerned recipe (index)
--@ Return: integer
function getConcernedRecipe(table)
    --> Variable(s)
    local recipes = SL.DrugScript.Config['recipes'];
    local complete_recipe = getCompleteRecipe(table);
    local choosed_1, choosed_2, choosed_3 = tonumber(table[1][1]), tonumber(table[2][1]), tonumber(table[3][1]);
    local index = 0;

    --> Loop: Check if the recipe is valid
    for k, v in pairs(recipes) do
        --> Check: If the recipe is valid
        if tonumber(v[1]) == choosed_1 and tonumber(v[2]) == choosed_2 and tonumber(v[3]) == choosed_3 then
            index = k;
            break;
        end;
    end;

    --> Return(s)
    return index;
end;

--@ Function: getRecipeGrams
--@ Description: Get the recipe grams
--@ Return: table
function getRecipeGrams(table)
    --> Variable(s)
    local recipes = SL.DrugScript.Config['recipes'];
    local isRecipe = isRecipe(table);
    local concerned_recipe = tonumber(getConcernedRecipe(table));
    local grams = {};

    --> Check: Recipe (check if the returned boolean is false)
    if not isRecipe then return false; end;

    --> Loop: Get the grams
    for _, k in pairs(recipes) do
        --> Set: Grams
        grams = {recipes[concerned_recipe][4], recipes[concerned_recipe][5], recipes[concerned_recipe][6]};
        break;
    end;

    --> Return(s)
    return grams;
end;

--@ Function: getRecipeEnteredGrams
--@ Description: Get the recipe entered grams (by the player)
--@ Return: table
function getRecipeEnteredGrams(table)
    --> Variable(s)
    local grams = {};

    --> Check: Table
    if not table then return; end;

    --> Loop: Get the grams
    for k, v in pairs(table) do
        --> Set: Grams
        grams[#grams + 1] = v[2];
    end;

    --> Return(s)
    return grams;
end;

--@ Function: getRecipePurity
--@ Description: Get the recipe purity (0-100)
--@ Description: The purity should be lower if we're getting away from the recipe grams
--@ Return: integer
function getRecipePurity(table)
    --> Variable(s)
    local isRecipe, complete_recipe = isRecipe(table, true);

    --> Check: Recipe (check if the returned boolean is false) & Grams
    if not isRecipe then return math.random(1, 15); end;

    --> Variable(s)
    local grams = getRecipeGrams(table);
    local entered_grams = getRecipeEnteredGrams(table);
    local purity, grams_diff = 100, 0;

    --> Loop: Get the purity
    for i = 1, 3 do grams_diff = grams_diff + math.abs(grams[i] - entered_grams[i]); end;

    --> Set: Purity
    purity = purity - (grams_diff * 2.5);

    --> Check: Purity
    if purity < 0 then purity = 0; end;

    --> Return(s)
    return purity;
end;

--@ Function: getPurityFromWeight
--@ Description: Get the purity from the weight (0.1g = 0%, 7g = 100%)
--@ Return: integer
function getPurityFromWeight(weight)
    --> Variable(s)
    local purity = 0;
    local grams_diff = weight - 0.1; -- Comparaison avec le poids de référence (0.1g)

    --> Set: Purity
    if grams_diff >= 0 then
        purity = (grams_diff / 6.9) * 100; -- 6.9 est la différence entre le poids maximum (7g) et le poids de référence (0.1g)
    else
        purity = (grams_diff / 0.1) * 100; -- Si le poids est inférieur à 0.1g, on utilise 0.1g comme référence
    end

    --> Check: Purity
    if purity > 100 then
        purity = 100;
    elseif purity < 0 then
        purity = 0;
    end

    --> Return(s)
    return purity;
end


--@ Function: getDesiredTemp
--@ Description: Get the desired temperature
--@ Return: integer
function getDesiredTemp(table)
    --> Variable(s)
    local components = SL.DrugScript.Config['components'];
    local isRecipe, complete_recipe = isRecipe(table, true);
    local temp = 0;

    --> Loop: Get the temperature
    for k, v in pairs(components) do
        if table[k] then
            temp = temp + components[k][4];
        end;
    end;

    --> Return(s)
    return temp;
end;

--@ Function: getApproxWeight
--@ Description: Get the approximate weight (based on the entered ones and the purity)
--@ Return: integer
function getApproxWeight(table)
    --> Variable(s)
    local grams = getRecipeEnteredGrams(table);
    local purity = getRecipePurity(table);
    local weight = 0;

    --> Loop: Get the weight
    for k, v in pairs(grams) do
        weight = weight + v;
    end;

    --> Set: Weight
    weight = weight * (purity / 100);

    --> Return(s)
    return math.round(weight * 2.5, 1);
end;

--@ Function: getClosestObject
--@ Description: Get the closest object (based on the object ID)
--@ Return: element
function getClosestObject(player, id, distance)
    --> Check: Player & ID
    if not player or not id then return; end;
    if not isElement(player) then return; end;

    --> Variable(s)
    local components = SL.DrugScript.Config.components;
    local x, y, z = getElementPosition(player);
    local max_distance = distance or 5;
    local closest_object = nil;
    local closest_distance = nil;

    --> Loop: Get the closest object
    for _, object in ipairs(getElementsWithinRange(x, y, z, max_distance, 'object')) do
        --> Check: Object
        if not isElement(object) then return; end;

        --> Check: Object ID
        if getElementData(object, 'itemID') == id then
            --> Variable(s)
            local object_x, object_y, object_z = getElementPosition(object);
            local distance = getDistanceBetweenPoints3D(x, y, z, object_x, object_y, object_z);

            --> Check: Distance
            if not closest_object or distance < closest_distance then
                closest_object = object;
                closest_distance = distance;
            end;
        end;
    end;

    --> Return
    return closest_object;
end;

--@ Function: giveDrug
--@ Description: Give the drug to the player based on the table
--@ Return: boolean
function giveDrug(player, table, element)
    --> Check: Player & Table
    if not player or not table or not element then return; end;
    if not isElement(player) or not isElement(element) then return; end;

    --> Variable(s)
    local components = SL.DrugScript.Config.components;
    local alt_table = table['infos'].alt_tbl;
    local grams = getRecipeGrams(alt_table);
    --local purity = getRecipePurity(alt_table);
    --local weight = math.round(getApproxWeight(alt_table), 1) / 10;
    local purity = getElementData(element, 'drugs:reactor:purity');
    local weight = math.round(getElementData(element, 'drugs:reactor:approx_weight'), 1); --/ 100;
    local drug = SL.DrugScript.Config['recipes'][getConcernedRecipe(alt_table)] or {}; -- Get the drug
    local itemID = getElementData(element, 'drugs:reactor:drug_id') or 395;
    
    --local itemID = tonumber(drug[9]) or 395;
    local name = drug[8] or 'Drogue inconnue';

    --> Check: If enough space and give the drug
    if not exports['item-system']:hasSpaceForItem(player, itemID, weight) then return outputChatBox(SL.DrugScript.Config['base'].PREFIX .. 'Vous n\'avez pas assez de place dans votre inventaire.', player, 255, 0, 0); end; 
    exports.global:giveItem(player, itemID, weight, {['purity'] = purity});

    --> Reset: Reactor's elements
    resetElementDatas(element);

    --> Send: Ame & Message
    local ame_message = "prend la drogue du réacteur et la met dans son inventaire.";
    triggerEvent('sendAme', player, ame_message);
    --outputChatBox(SL.DrugScript.Config['base'].PREFIX .. 'Vous avez pris ' .. weight .. 'g de ' .. name .. ' (' .. purity .. '% de pureté).', player, 0, 255, 0);
end;

--@ Function: math.round
--@ Description: Round a number to the nearest selected decimal
--@ Return: float
function math.round(number, decimals)
    --> Check: Number
    if not number then return; end;

    --> Variable(s)
    local decimals = decimals or 0;
    local factor = 10 ^ decimals;

    --> Return(s)
    return math.floor(number * factor + 0.5) / factor;
end;

--@ Function: math.clamp
--@ Description: Clamp a number between two values
--@ Return: float
function math.clamp(number, min, max)
    --> Check: Number
    if not number then return; end;

    --> Return(s)
    return math.min(math.max(number, min), max);
end;

--@ Function: switch
--@ Description: Create a switch statement
--@ Return: function
function switch(case, cases)
    --> Check: Case & Cases
    if not case or not cases then return; end;

    --> Variable(s)
    local case_function = cases[case] or cases.default;

    --> Check: Case function
    if case_function then
        if type(case_function) == 'function' then
            return case_function();
        else
            return error('[DRUG ERR!]: The case function is not a function.');
        end;
    end;
end;