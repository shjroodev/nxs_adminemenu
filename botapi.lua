local BOT_API_SECRET = ConfigServer.BotApiSecret

local function jsonResponse(response, code, data)
    response.writeHead(code, { ['Content-Type'] = 'application/json' })
    response.send(json.encode(data))
end

local function getTargetPlayer(idStr)
    local id = tonumber(idStr)
    if not id then return nil, "ID non valido" end
    local target = ESX.GetPlayerFromId(id)
    if not target then return nil, "Giocatore con ID " .. id .. " non trovato (offline?)" end
    return target, nil
end

local function banAllMatchingIdentifiers(banData, newBanId)
    local allIdentifiers = {}
    if banData.all_identifiers then
        local ok, dec = pcall(json.decode, banData.all_identifiers)
        if ok then allIdentifiers = dec end
    end
    if #allIdentifiers == 0 then return end
    local query = "SELECT * FROM nxs_ban WHERE active = 1 AND ("
    local params = {}
    local conditions = {}
    for i, identifier in ipairs(allIdentifiers) do
        table.insert(conditions, "all_identifiers LIKE @identifier" .. i)
        params["@identifier" .. i] = "%" .. identifier .. "%"
    end
    query = query .. table.concat(conditions, " OR ") .. ")"
    local matchingBans = MySQL.Sync.fetchAll(query, params)
    for _, matchingBan in ipairs(matchingBans) do
        if matchingBan.id ~= newBanId then
            local existingIdentifiers = {}
            if matchingBan.all_identifiers then
                local ok, dec = pcall(json.decode, matchingBan.all_identifiers)
                if ok then existingIdentifiers = dec end
            end
            local mergedIdentifiers = {}
            local seen = {}
            for _, id in ipairs(existingIdentifiers) do
                if not seen[id] then table.insert(mergedIdentifiers, id) ; seen[id] = true end
            end
            for _, id in ipairs(allIdentifiers) do
                if not seen[id] then table.insert(mergedIdentifiers, id) ; seen[id] = true end
            end
            MySQL.Sync.execute("UPDATE nxs_ban SET all_identifiers = @identifiers WHERE id = @id", {
                ['@identifiers'] = json.encode(mergedIdentifiers),
                ['@id'] = matchingBan.id
            })
        end
    end
end

local function doBanFromBot(targetId, durationSeconds, reason, botStaffName)
    local target = ESX.GetPlayerFromId(targetId)
    if not target then return false, "Giocatore non trovato" end

    local isPermanent = (not durationSeconds or durationSeconds == 0 or durationSeconds >= 999999999)
    local expireDate = nil
    local banDuration = durationSeconds

    if not isPermanent then
        expireDate = os.date("%Y-%m-%d %H:%M:%S", os.time() + durationSeconds)
    end

    local allIds = {}
    local seen   = {}
    for _, v in pairs(GetPlayerIdentifiers(target.source)) do
        if v and v ~= "" and not seen[v] then
            table.insert(allIds, v)
            seen[v] = true
        end
    end
    local tokenIndex = 0
    while tokenIndex < 64 do
        local ok, token = pcall(GetPlayerToken, target.source, tokenIndex)
        if not ok or not token or token == "" then break end
        local prefixed = "token:" .. token
        if not seen[prefixed] then
            table.insert(allIds, prefixed)
            seen[prefixed] = true
        end
        tokenIndex = tokenIndex + 1
    end

    local licenseId = GetLicense(target.source, "license") or target.identifier
    local playerName = GetPlayerName(target.source)

    local banCode = math.random(10000, 99999)
    local banData = {
        ban_code         = banCode,
        ban_identifier   = licenseId,
        all_identifiers  = json.encode(allIds),
        player_name      = playerName,
        staff_identifier = "discord:bot",
        staff_name       = botStaffName or "Discord Bot",
        reason           = reason or "Nessun motivo",
        expire_date      = expireDate,
        ban_token        = nil,
    }

    local insertId = MySQL.Sync.insert([[
        INSERT INTO nxs_ban
        (ban_code, ban_identifier, all_identifiers, player_name, staff_identifier, staff_name, reason, ban_date, expire_date, active, ban_token)
        VALUES
        (@ban_code, @ban_identifier, @all_identifiers, @player_name, @staff_identifier, @staff_name, @reason, NOW(), @expire_date, 1, @ban_token)
    ]], banData)

    MySQL.Sync.execute([[
        INSERT INTO nxs_ban_history (ban_id, action, admin_identifier, admin_name, note, timestamp)
        VALUES (@ban_id, 'ban', 'discord:bot', @admin_name, @note, NOW())
    ]], {
        ['@ban_id']     = insertId,
        ['@admin_name'] = botStaffName or "Discord Bot",
        ['@note']       = reason,
    })

    banAllMatchingIdentifiers(banData, insertId)

    local scadenzaText = isPermanent
        and "PERMANENTE"
        or os.date('%d/%m/%Y %H:%M', os.time() + (banDuration or 0))

    local kickMsg = "Sei stato bannato dal server\n"
                 .. "Motivo: " .. (reason or "N/A") .. "\n"
                 .. "ID Ban: #" .. banCode .. "\n"
                 .. "Scadenza: " .. scadenzaText .. "\n"
                 .. "Staff: " .. (botStaffName or "Discord Bot")

    DropPlayer(target.source, kickMsg)
    local fields = {
        { name = "Staff",    value = botStaffName or "Discord Bot", inline = true },
        { name = "Player",   value = playerName,                    inline = true },
        { name = "Motivo",   value = reason or "N/A",               inline = true },
        { name = "ID Ban",   value = "#" .. banCode,                inline = true },
        { name = "Scadenza", value = scadenzaText,                  inline = true },
        { name = "Tipo",     value = isPermanent and "PERMANENTE" or "TEMPORANEO", inline = true },
    }
    sendWebhook("BAN [BOT]", fields, ConfigServer.Webhook.ban)

    return true, banCode, playerName, scadenzaText
end

SetHttpHandler(function(request, response)
    if request.path ~= '/bot' then
        jsonResponse(response, 404, { success = false, error = "Endpoint non trovato" })
        return
    end

    if request.method ~= 'POST' then
        jsonResponse(response, 405, { success = false, error = "Metodo non consentito" })
        return
    end

    request.setDataHandler(function(body)
        local headers = request.headers or {}
        local authValue = ""
        for k, v in pairs(headers) do
            if string.lower(tostring(k)) == "x-bot-secret" then
                authValue = tostring(v):match("^%s*(.-)%s*$")
            end
        end
        local secret = tostring(BOT_API_SECRET):match("^%s*(.-)%s*$")
        if authValue ~= secret then
            jsonResponse(response, 401, { success = false, error = "Non autorizzato" })
            return
        end

        if not body or body == '' then
            jsonResponse(response, 400, { success = false, error = "Body vuoto" })
            return
        end
        local ok, data = pcall(json.decode, body)
        if not ok or type(data) ~= 'table' then
            jsonResponse(response, 400, { success = false, error = "JSON non valido" })
            return
        end

        local action    = data.action
        local staffName = data.staffName or "Discord Bot"


        if action == 'ban' then
            local id     = tonumber(data.id)
            local giorni = tonumber(data.giorni) or 0
            local motivo = data.motivo or "Nessun motivo"
            if not id then jsonResponse(response, 400, { success = false, error = "ID mancante" }) return end
            local durataSecondi = (giorni == 0) and 999999999 or (giorni * 86400)
            local success, banCode, playerName, scadenza = doBanFromBot(id, durataSecondi, motivo, staffName)
            if success then
                jsonResponse(response, 200, { success = true, banCode = banCode, playerName = playerName, scadenza = scadenza })
            else
                jsonResponse(response, 400, { success = false, error = banCode })
            end
        elseif action == 'kick' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local motivo     = data.motivo or "Kicked dal Discord Bot"
            local playerName = GetPlayerName(target.source)
            MySQL.Sync.execute([[
                INSERT INTO nxs_kick (identifier, player_name, staff_identifier, staff_name, reason)
                VALUES (@identifier, @player_name, 'discord:bot', @staff_name, @reason)
            ]], {
                ['@identifier']  = GetLicense(target.source, "license"),
                ['@player_name'] = playerName,
                ['@staff_name']  = staffName,
                ['@reason']      = motivo,
            })
            DropPlayer(target.source, "Sei stato kickato\nMotivo: " .. motivo)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
                { name = "Motivo", value = motivo,     inline = true },
            }
            sendWebhook("KICK [BOT]", fields, ConfigServer.Webhook.kick)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'unban' then
            local banId = tonumber(data.banId)
            if not banId then jsonResponse(response, 400, { success = false, error = "ID Ban mancante" }) return end
            local banInfo = GetInfoBanFromId(banId)
            if not banInfo then
                jsonResponse(response, 404, { success = false, error = "Ban #" .. banId .. " non trovato" })
                return
            end
            local success, message = UnBan(banId, "discord:bot", staffName)
            if success then
                local fields = {
                    { name = "Staff",      value = staffName,               inline = true },
                    { name = "Player",     value = banInfo.player_name,     inline = true },
                    { name = "ID Ban",     value = "#" .. banId,            inline = true },
                    { name = "Motivo Ban", value = banInfo.reason or "N/A", inline = true },
                }
                sendWebhook("REVOCA BAN [BOT]", fields, ConfigServer.Webhook.ban)
                jsonResponse(response, 200, { success = true, playerName = banInfo.player_name })
            else
                jsonResponse(response, 500, { success = false, error = message })
            end
        elseif action == 'warn' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local motivo     = data.motivo or "Nessun motivo"
            local playerName = GetPlayerName(target.source)
            MySQL.Sync.execute([[
                INSERT INTO nxs_warn (identifier, player_name, staff_identifier, staff_name, reason)
                VALUES (@identifier, @player_name, 'discord:bot', @staff_name, @reason)
            ]], {
                ['@identifier']  = GetLicense(target.source, "license"),
                ['@player_name'] = playerName,
                ['@staff_name']  = staffName,
                ['@reason']      = motivo,
            })
            TriggerClientEvent('nxs:warnmessage', target.source, motivo, staffName)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
                { name = "Motivo", value = motivo,     inline = true },
            }
            sendWebhook("WARN [BOT]", fields, ConfigServer.Webhook.warn)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'giveitem' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local item  = data.item
            local count = tonumber(data.count) or 1
            if not item then jsonResponse(response, 400, { success = false, error = "Nome oggetto mancante" }) return end
            local playerName = GetPlayerName(target.source)
            target.addInventoryItem(item, count)
            local fields = {
                { name = "Staff",    value = staffName,       inline = true },
                { name = "Player",   value = playerName,      inline = true },
                { name = "Oggetto",  value = item,            inline = true },
                { name = "Quantita", value = tostring(count), inline = true },
            }
            sendWebhook("GIVE ITEM [BOT]", fields, ConfigServer.Webhook.giveitem)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'revive' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent("esx_ambulancejob:revive", target.source)
            TriggerClientEvent("nxs-ambulance:revive:ossa", target.source)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("REVIVE [BOT]", fields, ConfigServer.Webhook.revive)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'reviveall' then
            local players      = ESX.GetPlayers()
            local revivedCount = 0
            local names        = {}
            for _, playerId in ipairs(players) do
                local p = ESX.GetPlayerFromId(playerId)
                if p then
                    TriggerClientEvent("esx_ambulancejob:revive", p.source)
                    revivedCount = revivedCount + 1
                    table.insert(names, GetPlayerName(playerId))
                end
            end
            local fields = {
                { name = "Staff",            value = staffName,                        inline = true },
                { name = "Player Rianimati", value = tostring(revivedCount),           inline = true },
                { name = "Lista Player",     value = table.concat(names, ', ') or "-", inline = false },
            }
            sendWebhook("REVIVE ALL [BOT]", fields, ConfigServer.Webhook.revive)
            jsonResponse(response, 200, { success = true, count = revivedCount })
        elseif action == 'givemoney' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local account    = data.account or "money"
            local amount     = tonumber(data.amount) or 0
            local playerName = GetPlayerName(target.source)
            target.addAccountMoney(account, amount)
            local fields = {
                { name = "Staff",    value = staffName,        inline = true },
                { name = "Player",   value = playerName,       inline = true },
                { name = "Account",  value = account,          inline = true },
                { name = "Quantita", value = tostring(amount), inline = true },
            }
            sendWebhook("GIVE MONEY [BOT]", fields, ConfigServer.Webhook.givemoney)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'givemoneyall' then
            local account  = data.account or "money"
            local amount   = tonumber(data.amount) or 0
            local xPlayers = ESX.GetExtendedPlayers()
            local count    = 0
            for _, p in pairs(xPlayers) do
                p.addAccountMoney(account, amount)
                count = count + 1
            end
            local fields = {
                { name = "Staff",    value = staffName,        inline = true },
                { name = "Account",  value = account,          inline = true },
                { name = "Quantita", value = tostring(amount), inline = true },
                { name = "Player",   value = tostring(count),  inline = true },
            }
            sendWebhook("DAI SOLDI A TUTTI [BOT]", fields, ConfigServer.Webhook.givemoneyall)
            jsonResponse(response, 200, { success = true, count = count })
        elseif action == 'clearinv' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            local items = target.getInventory()
            for _, v in pairs(items) do
                target.removeInventoryItem(v.name, v.count)
            end
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("CLEAR INV [BOT]", fields, ConfigServer.Webhook.clearinventory)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'skinmenu' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent(Config.Trigger.skin, target.source)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("SKIN MENU [BOT]", fields, ConfigServer.Webhook.skinmenu)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'dm' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local msg        = data.msg or ""
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent('nxs:dm', target.source, msg, staffName)
            local fields = {
                { name = "Staff",    value = staffName,  inline = true },
                { name = "Player",   value = playerName, inline = true },
                { name = "Messaggio",value = msg,        inline = false },
            }
            sendWebhook("DM [BOT]", fields, ConfigServer.Webhook.sendmessage)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'annuncio' then
            local msg = data.msg or ""
            TriggerClientEvent('nxs:announce', -1, msg)
            local fields = {
                { name = "Staff",    value = staffName, inline = true },
                { name = "Messaggio",value = msg,       inline = false },
            }
            sendWebhook("ANNUNCIO [BOT]", fields, ConfigServer.Webhook.annuncio)
            jsonResponse(response, 200, { success = true })
        elseif action == 'kill' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent('nxs:kill', target.source)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("KILL [BOT]", fields, ConfigServer.Webhook.kill)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'wipe' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            for k, v in pairs(Config.WipeSettings) do
                for _, tableName in pairs(v) do
                    MySQL.Sync.execute('DELETE FROM ' .. tableName .. ' WHERE ' .. k .. ' = @identifier', {
                        ['@identifier'] = target.identifier,
                    })
                end
            end
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("WIPE [BOT]", fields, ConfigServer.Webhook.wipe)
            DropPlayer(target.source, 'Sei stato wipato dal server')
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'freeze' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent('nxs:freeze', target.source)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("FREEZE [BOT]", fields, ConfigServer.Webhook.freeze)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'unfreeze' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            TriggerClientEvent('nxs:sfreeze', target.source)
            local fields = {
                { name = "Staff",  value = staffName,  inline = true },
                { name = "Player", value = playerName, inline = true },
            }
            sendWebhook("UNFREEZE [BOT]", fields, ConfigServer.Webhook.freeze)
            jsonResponse(response, 200, { success = true, playerName = playerName })
        elseif action == 'viewinventory' then
            local target, err = getTargetPlayer(data.id)
            if not target then jsonResponse(response, 400, { success = false, error = err }) return end
            local playerName = GetPlayerName(target.source)
            local inventory  = target.getInventory()
            local items      = {}
            for _, v in pairs(inventory) do
                if v.count and v.count > 0 then
                    table.insert(items, {
                        name  = v.name,
                        label = v.label or v.name,
                        count = v.count,
                    })
                end
            end
            table.sort(items, function(a, b) return a.name < b.name end)
            local fields = {
                { name = "Staff",           value = staffName,        inline = true },
                { name = "Player",          value = playerName,       inline = true },
                { name = "Oggetti Trovati", value = tostring(#items), inline = true },
            }
            sendWebhook("VIEW INVENTORY [BOT]", fields, ConfigServer.Webhook.viewinventory or "")
            jsonResponse(response, 200, { success = true, playerName = playerName, items = items })
        elseif action == 'players' then
            local xPlayers = ESX.GetExtendedPlayers()
            local list     = {}
            for _, p in pairs(xPlayers) do
                table.insert(list, {
                    id   = p.source,
                    name = GetPlayerName(p.source),
                    job  = p.job and p.job.name or "N/A",
                })
            end
            jsonResponse(response, 200, { success = true, players = list, count = #list })

        else
            jsonResponse(response, 400, { success = false, error = "Azione non riconosciuta: " .. tostring(action) })
        end
    end)
end)
