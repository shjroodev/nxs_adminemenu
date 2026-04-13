ESX = exports.es_extended:getSharedObject()
ConfigServer = {}

ConfigServer.Token = ""
ConfigServer.BotApiSecret = ""


ConfigServer.Webhook = {
    ban = "", 
    kick = "",
    warn = "",
    skinmenu = "",
    spectate = "",
    revive = "",
    heal = "",
    kill = "",
    wipe = "",
    goto1 = "",
    bring = "",
    giveitem = "",
    givemoney = "",
    setjob = "",
    clearinventory = "",
    giveadmin = "",
    clearped = "",
    sendmessage = "",
    freeze = "",
    noclip = "",
    invisibilita = "",
    godmode = "",
    nomiplayer = "",
    annuncio = "",
    reviveall = "",
    givemoneyall = "",
    repairvehicle = "",
    cleararea = "",
    spawnvehicle = "",
    deletevehicle = "",
    removeitem = "",
    viewinventory = "",
}
RegisterServerEvent('nxs:skinmenu')
AddEventHandler('nxs:skinmenu', function(id)
    local src = source
    local staff = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)
    if not staff or not target then
        TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['error_player_not_found'])
        return
    end
    TriggerClientEvent("nxs:openAppearance", target.source)
    TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['success_skinmenu'])
    local fields = {
        { name = 'Nome Staff',  value = GetPlayerName(staff.source),   inline = true },
        { name = 'Nome Player', value = GetPlayerName(target.source),  inline = true },
    }
    sendWebhook("SKIN MENU", fields, ConfigServer.Webhook.skinmenu)
end)
RegisterServerEvent('nxs:heal')
AddEventHandler('nxs:heal', function(id)
    local src = source
    local staff = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)
    if not staff or not target then
        TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['error_player_not_found'])
        return
    end

    TriggerClientEvent("nxs:healPlayer", target.source)

    TriggerClientEvent('esx_status:set', target.source, 'hunger', 1000000)
    TriggerClientEvent('esx_status:set', target.source, 'thirst', 1000000)

    TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['success_heal_staff'])
    local fields = {
        { name = 'Nome Staff',  value = GetPlayerName(staff.source), inline = true },
        { name = 'Nome Player', value = GetPlayerName(target.source), inline = true },
    }
    sendWebhook("HEAL", fields, ConfigServer.Webhook.heal)
end)

RegisterServerEvent('nxs:revive')
AddEventHandler('nxs:revive', function(id)
    local src = source
    local staff = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)

    if not staff or not target then
        TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['error_player_not_found'])
        return
    end
    TriggerClientEvent("ambulancejob:healPlayer", target.source, { revive = true })

    TriggerClientEvent('esx:showNotification', src, Config.Lang[Config.Language]['success_revive_staff'])

    local fields = {
        { name = 'Nome Staff',  value = GetPlayerName(staff.source),  inline = true },
        { name = 'Nome Player', value = GetPlayerName(target.source), inline = true },
    }

    sendWebhook("REVIVE", fields, ConfigServer.Webhook.revive)
end)


RegisterServerEvent('nxs:reviveall')
AddEventHandler('nxs:reviveall', function()
    local src = source
    local staff = ESX.GetPlayerFromId(src)
    if not staff then return end

    local players = ESX.GetPlayers()
    local revivedCount = 0
    local playerNames = {}

    for _, playerId in ipairs(players) do
        local target = ESX.GetPlayerFromId(playerId)
        if target then
            revivedCount = revivedCount + 1
            table.insert(playerNames, GetPlayerName(playerId))
            TriggerClientEvent("ambulancejob:healPlayer", target.source, { revive = true })
        end
    end

    local fields = {
        { name = 'Nome Staff', value = GetPlayerName(staff.source), inline = true },
        { name = 'Player Rianimati', value = revivedCount, inline = true },
        { name = 'Lista Player', value = table.concat(playerNames, ', '), inline = false },
    }

    sendWebhook("REVIVE ALL", fields, ConfigServer.Webhook.revive)

    TriggerClientEvent('esx:showNotification', staff.source, Config.Lang[Config.Language]['success_reviveall'])
end)