local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("gamemode:server:ItemHandler", function(item, amounth)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amounth)  
end)

RegisterNetEvent("gamemode:server:getMoney", function(Payment)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Payment) 
end)

QBCore.Functions.CreateUseableItem("illegalphone", function(source, item)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("gamemode:client:UseIllegalphone", src)
	end
end)