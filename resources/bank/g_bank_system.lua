-- Nando 11/03/2023

--[[
Transaction Types:
	0: Withdraw Personal
	1: Deposit Personal
	2: Transfer from Personal
	3: Transfer from Business
	4: Withdraw Business
	5: Deposit Business
	6: Wage/State Benefits
	7: everything in payday except Wage/State Benefits
	8: faction budget
	9: fuel
	10: repair
	11: taxes
	12: bank interest
	13: Sales
	14: Insurance
	15: Supplies
	16: Impound
--]]

-- Exported
function getTransactionReason(type, reason)
	if type == 0 or type == 4 then
		return "Retrait: "..tostring(reason or "")
	elseif type == 1 or type == 5 then
		return "Dépôt: "..tostring(reason or "")
	elseif type == 6 then
		return tostring(reason or "")
	elseif type == 7 then
		return "Payday (Biz+Interest+Donator)"
	elseif type == 8 then
		return "Budget"
	elseif type == 9 then
		outputDebugString(tostring(reason) .. " " .. tostring(type))
		return tostring("Essence: "..math.ceil(tonumber(reason)).."L")
	elseif type == 10 then
		return "Réparation: "..tostring(reason or "")
	else
		return "Virement: " .. tostring(reason or "")
	end
end