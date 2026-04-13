local ESX = exports.es_extended:getSharedObject()
local client_var = {}
local avatarCache = {} 
local AVATAR_CACHE_TTL = 300 

local function getCachedAvatar(source)
    local now = os.time()
    if avatarCache[source] and (now - avatarCache[source].ts) < AVATAR_CACHE_TTL then
        return avatarCache[source].url
    end
    local url = GetPlayerAvatarSync(source)
    avatarCache[source] = { url = url, ts = now }
    return url
end
AddEventHandler('playerDropped', function()
    avatarCache[source] = nil
    client_var[source] = nil
end)

RegisterServerEvent('nxs:addvariable')
AddEventHandler('nxs:addvariable', function(type, value)
  if not client_var[source] then client_var[source] = {} end
  client_var[source][type] = value
end)

GetLicense = function(source, type)
    local steamid = false
    local license = false
    local discord = false
    local xbl = false
    local liveid = false
    local ip = false
  for k,v in pairs(GetPlayerIdentifiers(source)) do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = string.gsub(v, "steam:", "")
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = string.gsub(v, "license:", "")
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xbl = string.gsub(v, "xbl:", "")
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ip = string.gsub(v, "ip:", "")
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = string.gsub(v, "discord:", "")
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = string.gsub(v, "live:", "")
      end
  end
    if type == "steam" then return steamid
    elseif type == "license" then return license
    elseif type == "discord" then return discord
    elseif type == "xbl" then return xbl
    elseif type == "liveid" then return liveid
    elseif type == "ip" then return ip
    end
end

function DiscordRequest(method, endpoint, jsondata, reason)
  local data = nil
  PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
    data = {data=resultData, code=errorCode, headers=resultHeaders}
  end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..ConfigServer.Token, ['X-Audit-Log-Reason'] = reason})
  while data == nil do Citizen.Wait(0) end
  return data
end

GetPlayerAvatar = function(source, cb)
    local discordId = GetLicense(source, "discord")
    if not discordId or discordId == "N/A" then cb("") return end
    discordId = discordId:gsub("discord:", "")
    PerformHttpRequest("https://discord.com/api/v10/users/" .. discordId, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local userData = json.decode(resultData)
            if userData.avatar then
                local ext = string.sub(userData.avatar, 1, 2) == "a_" and "gif" or "png"
                cb("https://cdn.discordapp.com/avatars/" .. userData.id .. "/" .. userData.avatar .. "." .. ext)
            else
                local defaultAvatar = math.floor((tonumber(userData.id:sub(-4), 16) % 5))
                cb("https://cdn.discordapp.com/embed/avatars/" .. defaultAvatar .. ".png")
            end
        else
            cb("")
        end
    end, "GET", "", {["Authorization"] = "Bot " .. ConfigServer.Token, ["Content-Type"] = "application/json"})
end

GetPlayerAvatarSync = function(source)
    local url = ""
    local discordId = GetLicense(source, "discord")
    if not discordId or discordId == "N/A" then return "" end
    discordId = discordId:gsub("discord:", "")
    local promise = promise.new()
    PerformHttpRequest("https://discord.com/api/v10/users/" .. discordId, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local userData = json.decode(resultData)
            if userData.avatar then
                local ext = string.sub(userData.avatar, 1, 2) == "a_" and "gif" or "png"
                url = "https://cdn.discordapp.com/avatars/" .. userData.id .. "/" .. userData.avatar .. "." .. ext
            else
                local defaultAvatar = math.floor((tonumber(userData.id:sub(-4), 16) % 5))
                url = "https://cdn.discordapp.com/embed/avatars/" .. defaultAvatar .. ".png"
            end
        end
        promise:resolve(url)
    end, "GET", "", {["Authorization"] = "Bot " .. ConfigServer.Token, ["Content-Type"] = "application/json"})
    Citizen.Await(promise)
    return url
end

local function tsToDisplay(ts)
    local n = tonumber(ts)
    if not n or n == 0 then return "N/A" end
    return os.date("%d/%m/%Y %H:%M", n)
end

local function isPermanentDuration(timeValue)
    if not timeValue then return true end
    local n = tonumber(timeValue)
    if not n then
        return (timeValue == "0" or timeValue == "permanent" or timeValue == "")
    end
    return (n == 0 or n >= 999999999)
end

local function generateBanCode()
    math.randomseed(os.time() + math.random(1, 9999))
    for _ = 1, 200 do
        local code = math.random(10000, 99999)
        local exists = MySQL.Sync.fetchAll(
            "SELECT id FROM nxs_ban WHERE ban_code = @code LIMIT 1",
            { ['@code'] = code }
        )
        if not exists or #exists == 0 then
            return code
        end
    end
    return math.random(10000, 99999)
end

CheckSql = function(id)
  local xPlayer = ESX.GetPlayerFromId(id)
  if not xPlayer then return end
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return end
  MySQL.Sync.execute(
    "INSERT IGNORE INTO nxs_admin (identifier) VALUES (@identifier)",
    { ['@identifier'] = identifier }
  )
end

GetWarn = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(warn_date) AS warn_ts FROM nxs_warn WHERE identifier = @identifier ORDER BY warn_date ASC",
    { ['@identifier'] = identifier }
  )
  local warns = {}
  for _, row in ipairs(result or {}) do
    table.insert(warns, {
      id = row.id,
      reason = row.reason or "",
      name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.warn_ts)
    })
  end
  return warns
end

GetKick = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(kick_date) AS kick_ts FROM nxs_kick WHERE identifier = @identifier ORDER BY kick_date ASC",
    { ['@identifier'] = identifier }
  )
  local kicks = {}
  for _, row in ipairs(result or {}) do
    table.insert(kicks, {
      id = row.id,
      reason = row.reason or "",
      name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.kick_ts)
    })
  end
  return kicks
end

GetBan = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(ban_date) AS ban_ts, UNIX_TIMESTAMP(expire_date) AS expire_ts FROM nxs_ban WHERE ban_identifier = @identifier ORDER BY ban_date ASC",
    { ['@identifier'] = identifier }
  )
  local bans = {}
  local permanente = Config.Lang[Config.Language].permanente or "PERMANENTE"
  for _, row in ipairs(result or {}) do
    local isPerm = (row.expire_ts == nil or row.expire_ts == 0)
    local scLabel = isPerm and permanente or tsToDisplay(row.expire_ts)
    table.insert(bans, {
      id = row.ban_code or row.id,
      idBan = row.ban_code or row.id,
      reason = row.reason or "",
      name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.ban_ts),
      scadenzaLabel = scLabel,
      scadenza = isPerm and nil or row.expire_ts,
      permanente = isPerm,
      active = (row.active == 1)
    })
  end
  return bans
end

GetStaffWarn = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(warn_date) AS warn_ts FROM nxs_warn WHERE staff_identifier = @identifier ORDER BY warn_date DESC",
    { ['@identifier'] = identifier }
  )
  local warns = {}
  for _, row in ipairs(result or {}) do
    table.insert(warns, {
      id = row.id, reason = row.reason or "", name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.warn_ts)
    })
  end
  return warns
end

GetStaffKick = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(kick_date) AS kick_ts FROM nxs_kick WHERE staff_identifier = @identifier ORDER BY kick_date DESC",
    { ['@identifier'] = identifier }
  )
  local kicks = {}
  for _, row in ipairs(result or {}) do
    table.insert(kicks, {
      id = row.id, reason = row.reason or "", name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.kick_ts)
    })
  end
  return kicks
end

GetStaffBan = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  if not identifier then return {} end
  local result = MySQL.Sync.fetchAll(
    "SELECT *, UNIX_TIMESTAMP(ban_date) AS ban_ts, UNIX_TIMESTAMP(expire_date) AS expire_ts FROM nxs_ban WHERE staff_identifier = @identifier ORDER BY ban_date DESC",
    { ['@identifier'] = identifier }
  )
  local bans = {}
  local permanente = Config.Lang[Config.Language].permanente or "PERMANENTE"
  for _, row in ipairs(result or {}) do
    local isPerm = (row.expire_ts == nil or row.expire_ts == 0)
    local scLabel = isPerm and permanente or tsToDisplay(row.expire_ts)
    table.insert(bans, {
      id = row.ban_code or row.id, idBan = row.ban_code or row.id,
      reason = row.reason or "", name = row.player_name or "",
      staff = { name = row.staff_name or "", identifier = row.staff_identifier or "" },
      date = tsToDisplay(row.ban_ts),
      scadenzaLabel = scLabel, scadenza = isPerm and nil or row.expire_ts,
      permanente = isPerm, active = (row.active == 1)
    })
  end
  return bans
end

SonoStaff = function(xPlayer)
  if not xPlayer then return false end
  local playerGroup = xPlayer.getGroup()
  for k, v in pairs(Config.AdminGroup) do
    if playerGroup == k then return true end
  end
  return false
end

getRank = function(source)
  local xp = ESX.GetPlayerFromId(source)
  if not xp then return 0 end
  local group = xp.getGroup()
  for k, v in pairs(Config.AdminGroup) do
    if group == k then return v.rank end
  end
  return 0
end

getPlayers = function()
    local xPlayers = ESX.GetExtendedPlayers()
    local players = {}
    if not xPlayers then return players end
    for k, xPlayer in pairs(xPlayers) do
      if xPlayer and xPlayer.source then
        local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
        if rankLabel == nil then
          rankLabel = Config.Lang[Config.Language]['utente']
        else
          rankLabel = rankLabel.label
        end
        local freezed = false
        if client_var[xPlayer.source] ~= nil then
          freezed = client_var[xPlayer.source].freeze
        end
        local avatar = getCachedAvatar(xPlayer.source)
        table.insert(players, {
            name = GetPlayerName(xPlayer.source),
            id = xPlayer.source,
            staff = SonoStaff(xPlayer),
            job = xPlayer.job,
            rankLabel = rankLabel,
            freezed = freezed,
            avatar = avatar,
            license = {
                discord = GetLicense(xPlayer.source, "discord") or "N/A",
                steam = GetLicense(xPlayer.source, "steam") or "N/A",
                license = GetLicense(xPlayer.source, "license") or "N/A",
            },
            warn = GetWarn(xPlayer),
            kick = GetKick(xPlayer),
            ban = GetBan(xPlayer),
        })
      end
    end
    return players
end

local function getInfoStaff(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return {} end
  local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
  if rankLabel == nil then
    rankLabel = Config.Lang[Config.Language]['utente']
  else
    rankLabel = rankLabel.label
  end
  local avatar = getCachedAvatar(source)
  return {
    name = GetPlayerName(xPlayer.source),
    id = xPlayer.source,
    staff = SonoStaff(xPlayer),
    job = xPlayer.getJob(),
    rank = getRank(xPlayer.source),
    rankLabel = rankLabel,
    avatar = avatar,
    ban = GetStaffBan(xPlayer),
    kick = GetStaffKick(xPlayer),
    warn = GetStaffWarn(xPlayer),
    license = {
      discord = GetLicense(xPlayer.source, "discord") or "N/A",
      steam = GetLicense(xPlayer.source, "steam") or "N/A",
      license = GetLicense(xPlayer.source, "license") or "N/A",
    },
  }
end

local function getJobs()
  local jobs = {}
  local esxJobs = ESX.GetJobs()
  if not esxJobs or type(esxJobs) ~= "table" then return {} end
  for k, v in pairs(esxJobs) do
    table.insert(jobs, { label = v.label, value = v.name })
  end
  return jobs
end

local function getBans()
    local result = MySQL.Sync.fetchAll(
        "SELECT *, UNIX_TIMESTAMP(ban_date) AS ban_ts, UNIX_TIMESTAMP(expire_date) AS expire_ts FROM nxs_ban ORDER BY ban_date DESC"
    )
    local bans = {}
    local permanente = Config.Lang[Config.Language].permanente or "PERMANENTE"
    local expiredIds = {}
    for i = 1, #result do
        local ban = result[i]
        local identifiers = {}
        if ban.all_identifiers then
            local ok, dec = pcall(json.decode, ban.all_identifiers)
            if ok then identifiers = dec end
        end
        local isPerm = (ban.expire_ts == nil or ban.expire_ts == 0)
        local isActive = (ban.active == 1)
        local expTs = isPerm and nil or tonumber(ban.expire_ts)
        local stato
        if not isActive then
            stato = Config.Lang[Config.Language].revocato or "REVOCATO"
        elseif isPerm then
            stato = permanente
        else
            local now = os.time()
            if expTs and expTs > now then
                local tl = expTs - now
                local days = math.floor(tl / 86400)
                local hours = math.floor((tl % 86400) / 3600)
                stato = string.format("%dd %dh", days, hours)
            else
                stato = Config.Lang[Config.Language].scaduto or "SCADUTO"
                table.insert(expiredIds, ban.id)
                isActive = false
            end
        end
        local formattedBanDate = tsToDisplay(ban.ban_ts)
        local formattedExpireDate = isPerm and permanente or tsToDisplay(expTs)
        table.insert(bans, {
            idBan = ban.ban_code or ban.id,
            name = ban.player_name,
            staff = { name = ban.staff_name or "Sconosciuto", identifier = ban.staff_identifier },
            reason = ban.reason,
            dataBan = formattedBanDate,
            labelScadenza = formattedExpireDate,
            scadenza = expTs,
            valido = isActive,
            permanente = isPerm,
            identifiers = identifiers,
            ban_token = ban.ban_token
        })
    end
    if #expiredIds > 0 then
        local placeholders = {}
        for i, id in ipairs(expiredIds) do
            placeholders[i] = id
        end
        MySQL.Async.execute(
            "UPDATE nxs_ban SET active = 0 WHERE id IN (" .. table.concat(placeholders, ",") .. ")",
            {}
        )
    end
    return bans
end

local function getAdminOnline()
  local xPlayers = ESX.GetExtendedPlayers()
  local adminOnline = 0
  for _, xPlayer in pairs(xPlayers) do
    for a, b in pairs(Config.AdminGroup) do
      if xPlayer.getGroup() == a then adminOnline = adminOnline + 1 end
    end
  end
  return adminOnline
end

local function getKicks()
  local result = MySQL.Sync.fetchAll("SELECT COUNT(*) as total FROM nxs_kick")
  return (result and result[1] and result[1].total) or 0
end

ESX.RegisterServerCallback('nxs:getPlayers', function(source, cb)
  cb(getPlayers())
end)

ESX.RegisterServerCallback('nxs:getData', function(source, cb)
  local data = {}
  data.jobs = getJobs()
  data.infoStaff = getInfoStaff(source)
  data.orario = os.date("%H:%M")
  data.bans = getBans()
  data.adminOnline = getAdminOnline()
  data.kicks = getKicks()
  cb(data)
end)

ESX.RegisterServerCallback('nxs:getInfoStaff', function(source, cb)
  cb(getInfoStaff(source))
end)

ESX.RegisterServerCallback('nxs:sonoStaff', function(source, cb)
  cb(SonoStaff(ESX.GetPlayerFromId(source)))
end)

ESX.RegisterServerCallback('nxs:getOrario', function(source, cb)
  cb(os.date("%H:%M"))
end)

ESX.RegisterServerCallback('nxs:getAllKicks', function(source, cb)
  cb(getKicks())
end)

ESX.RegisterServerCallback('nxs:getCoordsPlayer', function(source, cb, id)
  local xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer == nil then return end
  cb(xPlayer.getCoords(true), xPlayer.getCoords(false))
end)

local function getAllIdentifiers(source)
    local identifiers = {}
    local seen = {}
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if identifier and identifier ~= "" and not seen[identifier] then
            table.insert(identifiers, identifier)
            seen[identifier] = true
        end
    end
    local tokenIndex = 0
    while tokenIndex < 64 do
        local ok, token = pcall(GetPlayerToken, source, tokenIndex)
        if not ok or not token or token == "" then break end
        local prefixed = "token:" .. token
        if not seen[prefixed] then
            table.insert(identifiers, prefixed)
            seen[prefixed] = true
        end
        tokenIndex = tokenIndex + 1
    end
    return identifiers
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
            MySQL.Sync.execute([[
                INSERT INTO nxs_ban_history (ban_id, action, admin_identifier, admin_name, note, timestamp)
                VALUES (@ban_id, 'edit', @admin_identifier, @admin_name, @note, NOW())
            ]], {
                ['@ban_id'] = matchingBan.id,
                ['@admin_identifier'] = banData.staff_identifier,
                ['@admin_name'] = banData.staff_name,
                ['@note'] = "Identificativi aggiornati automaticamente per match con ban #" .. newBanId
            })
        end
    end
end

local function broadcastUpdateToStaff()
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        if SonoStaff(xPlayer) then
            TriggerClientEvent('nxs:updatePlayers', xPlayer.source)
        end
    end
end

RegisterServerEvent('nxs:action')
AddEventHandler('nxs:action', function(data)
  local staff = ESX.GetPlayerFromId(source)
  local target = ESX.GetPlayerFromId(data.id)
  local value1 = data.value1
  local value2 = data.value2

  if data.action == 'warn' then
    local reason = value1
    if target then
      MySQL.Sync.execute([[
        INSERT INTO nxs_warn (identifier, player_name, staff_identifier, staff_name, reason)
        VALUES (@identifier, @player_name, @staff_identifier, @staff_name, @reason)
      ]], {
        ['@identifier'] = GetLicense(target.source, "license"),
        ['@player_name'] = GetPlayerName(target.source),
        ['@staff_identifier'] = GetLicense(staff.source, "license"),
        ['@staff_name'] = GetPlayerName(staff.source),
        ['@reason'] = reason
      })
      TriggerClientEvent('nxs:warnmessage', target.source, reason, GetPlayerName(staff.source))
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = Config.Lang[Config.Language]["motivo"], value = reason, inline = true },
      }
      sendWebhook("WARN", fields, ConfigServer.Webhook.warn)
    end

  elseif data.action == 'kick' then
    local reason = value1
    if target then
      MySQL.Sync.execute([[
        INSERT INTO nxs_kick (identifier, player_name, staff_identifier, staff_name, reason)
        VALUES (@identifier, @player_name, @staff_identifier, @staff_name, @reason)
      ]], {
        ['@identifier'] = GetLicense(target.source, "license"),
        ['@player_name'] = GetPlayerName(target.source),
        ['@staff_identifier'] = GetLicense(staff.source, "license"),
        ['@staff_name'] = GetPlayerName(staff.source),
        ['@reason'] = reason
      })
      DropPlayer(target.source, reason)
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = Config.Lang[Config.Language]["motivo"], value = reason, inline = true },
      }
      sendWebhook("KICK", fields, ConfigServer.Webhook.kick)
    end

  elseif data.action == 'ban' then
    local timeValue = value1
    local reason = value2
    if not target then
      print("[NEXUS-BAN] Target non trovato per il ban")
      return
    end
    local isPermanent = isPermanentDuration(timeValue)
    local expireDate = nil
    local banDuration = nil
    if not isPermanent then
      local seconds = tonumber(timeValue)
      if seconds and seconds > 0 then
        expireDate = os.date("%Y-%m-%d %H:%M:%S", os.time() + seconds)
        banDuration = seconds
      else
        expireDate = os.date("%Y-%m-%d %H:%M:%S", os.time() + 86400)
        banDuration = 86400
      end
    end
    local allIdentifiers = getAllIdentifiers(target.source)
    local licenseIdentifier = GetLicense(target.source, "license") or target.identifier
    local permanentLabel = Config.Lang[Config.Language].permanente or "PERMANENTE"
    local banData = {
      ban_identifier = licenseIdentifier,
      all_identifiers = json.encode(allIdentifiers),
      player_name = GetPlayerName(target.source),
      staff_identifier = GetLicense(staff.source, "license") or staff.identifier,
      staff_name = GetPlayerName(staff.source),
      reason = reason,
      expire_date = expireDate,
      ban_token = nil
    }
    local banCode = generateBanCode()
    banData.ban_code = banCode
    local insertId = MySQL.Sync.insert([[
      INSERT INTO nxs_ban
      (ban_code, ban_identifier, all_identifiers, player_name, staff_identifier, staff_name, reason, ban_date, expire_date, active, ban_token)
      VALUES
      (@ban_code, @ban_identifier, @all_identifiers, @player_name, @staff_identifier, @staff_name, @reason, NOW(), @expire_date, 1, @ban_token)
    ]], banData)
    MySQL.Sync.execute([[
      INSERT INTO nxs_ban_history (ban_id, action, admin_identifier, admin_name, note, timestamp)
      VALUES (@ban_id, 'ban', @admin_identifier, @admin_name, @note, NOW())
    ]], {
      ['@ban_id'] = insertId,
      ['@admin_identifier'] = banData.staff_identifier,
      ['@admin_name'] = banData.staff_name,
      ['@note'] = reason
    })
    banAllMatchingIdentifiers(banData, insertId)
    local scadenzaText = isPermanent
        and permanentLabel
        or os.date('%d/%m/%Y %H:%M', os.time() + (banDuration or 0))
    local fields = {
      { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
      { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
      { name = Config.Lang[Config.Language]["motivo"], value = reason, inline = true },
      { name = "ID Ban", value = "#" .. banCode, inline = true },
      { name = "Scadenza", value = scadenzaText, inline = true },
      { name = "Tipo", value = isPermanent and "PERMANENTE" or "TEMPORANEO", inline = true },
    }
    sendWebhook("BAN", fields, ConfigServer.Webhook.ban)
    local kickMessage = "Sei stato bannato dal server\n"
                     .. "Motivo: " .. reason .. "\n"
                     .. "ID Ban: #" .. banCode .. "\n"
                     .. "Scadenza: " .. scadenzaText .. "\n"
                     .. "Staff: " .. GetPlayerName(staff.source)
    DropPlayer(target.source, kickMessage)

  elseif data.action == 'giveitem' then
    local item = value1
    local count = value2
    if target then
      target.addInventoryItem(item, count)
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = "Oggetto", value = item, inline = true },
        { name = "Quantità", value = count, inline = true },
      }
      sendWebhook("GIVE ITEM", fields, ConfigServer.Webhook.giveitem)
    end

  elseif data.action == 'givemoney' then
    local account = value1
    local count = value2
    if target then
      target.addAccountMoney(account, tonumber(count))
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = "Account", value = account, inline = true },
        { name = "Quantità", value = count, inline = true },
      }
      sendWebhook("GIVE MONEY", fields, ConfigServer.Webhook.givemoney)
    end

  elseif data.action == 'setjob' then
    local job = value1
    local grade = value2
    if target then
      target.setJob(job, grade)
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = "Lavoro", value = job, inline = true },
        { name = "Grado", value = grade, inline = true },
      }
      sendWebhook("SET JOB", fields, ConfigServer.Webhook.setjob)
    end

  elseif data.action == 'giveadmin' then
    local group = value1
    if target then
      target.setGroup(group)
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = "Gruppo", value = group, inline = true },
      }
      sendWebhook("GIVE ADMIN", fields, ConfigServer.Webhook.giveadmin)
    end

  elseif data.action == 'setped' then
    local ped = value1
    if target then
      TriggerClientEvent('nxs:setped', target.source, ped)
    end

  elseif data.action == 'dm' then
    local msg = value1
    if target then
      TriggerClientEvent('nxs:dm', target.source, msg, GetPlayerName(staff.source))
      local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
        { name = "Messaggio", value = msg, inline = true },
      }
      sendWebhook("MESSAGGIO PRIVATO", fields, ConfigServer.Webhook.sendmessage)
    end

  elseif data.action == 'annuncio' then
    TriggerClientEvent('nxs:announce', -1, value1)
    local fields = {
      { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
      { name = "Messaggio", value = value1, inline = true },
    }
    sendWebhook("ANNUNCIO", fields, ConfigServer.Webhook.annuncio)
    return

  elseif data.action == "givemoneyall" then
    local account = value1
    local count = value2
    local xPlayers = ESX.GetExtendedPlayers()
    for k, v in pairs(xPlayers) do
      v.addAccountMoney(account, tonumber(count))
    end
    local fields = {
      { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
      { name = "Account", value = account, inline = true },
      { name = "Quantità", value = count, inline = true },
    }
    sendWebhook("DAI SOLDI A TUTTI", fields, ConfigServer.Webhook.givemoneyall)
    return

  elseif data.action == "cleararea" then
    local radius = value1
    TriggerClientEvent('nxs:cleararea', -1, radius)
    local fields = {
      { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
      { name = "Raggio", value = radius, inline = true },
    }
    sendWebhook("CLEAR AREA", fields, ConfigServer.Webhook.cleararea)
    return
  end

  broadcastUpdateToStaff()
end)

CheckBanned = function(source)
    local playerIdentifiers = getAllIdentifiers(source)
    if #playerIdentifiers == 0 then return false, nil end
    local conditions = {}
    local params = {}
    for i, identifier in ipairs(playerIdentifiers) do
        table.insert(conditions, "all_identifiers LIKE @id" .. i)
        params["@id" .. i] = "%" .. identifier .. "%"
    end
    local query = "SELECT *, UNIX_TIMESTAMP(expire_date) AS expire_ts FROM nxs_ban WHERE active = 1 AND ("
                  .. table.concat(conditions, " OR ") .. ")"
    local bans = MySQL.Sync.fetchAll(query, params)
    for _, ban in ipairs(bans) do
        local expireTs = tonumber(ban.expire_ts)
        local isPerm = (expireTs == nil or expireTs == 0)
        if isPerm or (expireTs and expireTs > os.time()) then
            local existingIds = {}
            if ban.all_identifiers then
                local ok, dec = pcall(json.decode, ban.all_identifiers)
                if ok and type(dec) == "table" then existingIds = dec end
            end
            local merged = {}
            local seenMerge = {}
            for _, id in ipairs(existingIds) do
                if not seenMerge[id] then
                    table.insert(merged, id)
                    seenMerge[id] = true
                end
            end
            local newAdded = false
            for _, id in ipairs(playerIdentifiers) do
                if not seenMerge[id] then
                    table.insert(merged, id)
                    seenMerge[id] = true
                    newAdded = true
                end
            end
            if newAdded then
                MySQL.Sync.execute(
                    "UPDATE nxs_ban SET all_identifiers = @ids WHERE id = @id",
                    { ['@ids'] = json.encode(merged), ['@id'] = ban.id }
                )
                MySQL.Sync.execute([[
                    INSERT INTO nxs_ban_history
                        (ban_id, action, admin_identifier, admin_name, note, timestamp)
                    VALUES (@ban_id, 'auto_update', NULL, NULL, @note, NOW())
                ]], {
                    ['@ban_id'] = ban.id,
                    ['@note'] = "Nuovi identificativi/token aggiunti automaticamente al riconnettere"
                })
            end
            return true, ban
        else
            MySQL.Sync.execute(
                "UPDATE nxs_ban SET active = 0 WHERE id = @id",
                { ['@id'] = ban.id }
            )
            MySQL.Sync.execute([[
                INSERT INTO nxs_ban_history
                    (ban_id, action, admin_identifier, admin_name, note, timestamp)
                VALUES (@ban_id, 'expire', NULL, NULL, 'Ban scaduto automaticamente', NOW())
            ]], { ['@ban_id'] = ban.id })
        end
    end
    return false, nil
end

GetInfoBan = function(source)
    local isBanned, banInfo = CheckBanned(source)
    return banInfo
end

GetInfoBanFromId = function(banId)
    local result = MySQL.Sync.fetchAll(
        "SELECT *, UNIX_TIMESTAMP(ban_date) AS ban_ts, UNIX_TIMESTAMP(expire_date) AS expire_ts FROM nxs_ban WHERE ban_code = @id OR id = @id",
        { ['@id'] = banId }
    )
    if #result == 0 then return false end
    local ban = result[1]
    local identifiers = {}
    if ban.all_identifiers then
        local ok, dec = pcall(json.decode, ban.all_identifiers)
        if ok then identifiers = dec end
    end
    local expireTs = tonumber(ban.expire_ts)
    local isPerm = (expireTs == nil or expireTs == 0)
    return {
        id = ban.ban_code or ban.id,
        db_id = ban.id,
        player_name = ban.player_name,
        staff_name = ban.staff_name,
        reason = ban.reason,
        ban_date = tsToDisplay(ban.ban_ts),
        expire_date = isPerm and nil or tsToDisplay(expireTs),
        active = ban.active == 1,
        identifiers = identifiers,
        ban_token = ban.ban_token
    }
end

UnBan = function(banId, staffId, staffName)
    local result = MySQL.Sync.fetchAll("SELECT * FROM nxs_ban WHERE ban_code = @id OR id = @id", { ['@id'] = banId })
    if #result == 0 then return false, "Ban non trovato" end
    local dbId = result[1].id
    MySQL.Sync.execute("DELETE FROM nxs_ban WHERE id = @id", { ['@id'] = dbId })
    MySQL.Sync.execute([[
        INSERT INTO nxs_ban_history (ban_id, action, admin_identifier, admin_name, note, timestamp)
        VALUES (@ban_id, 'delete', @admin_identifier, @admin_name, @note, NOW())
    ]], {
        ['@ban_id'] = dbId,
        ['@admin_identifier'] = (type(staffId) == "number" and staffId > 0) and GetLicense(staffId, "license") or tostring(staffId),
        ['@admin_name'] = staffName or ((type(staffId) == "number" and staffId == 0) and "CONSOLE" or (type(staffId) == "number" and GetPlayerName(staffId) or tostring(staffId))),
        ['@note'] = "Ban eliminato completamente"
    })
    return true, "Ban eliminato con successo"
end

AddEventHandler('playerConnecting', function(name, skr, d)
    local src = source
    d.defer()
    Wait(50)
    d.update('🔍 Controllando il tuo stato nel server...')
    local isBanned, banInfo = CheckBanned(src)
    if not isBanned then
        d.done()
        return
    end
    Wait(150)
    local expireTs = tonumber(banInfo and banInfo.expire_ts)
    local isPermanent = (expireTs == nil or expireTs == 0)
    local banExpiry = "PERMANENTE"
    local banType = "❌ Ban Permanente"
    if not isPermanent then
        if expireTs > os.time() then
            banExpiry = os.date('%d/%m/%Y %H:%M', expireTs)
            banType = "⏳ Ban Temporaneo"
        else
            MySQL.Sync.execute("UPDATE nxs_ban SET active = 0 WHERE id = @id", { ['@id'] = banInfo.id })
            d.done()
            return
        end
    end
    local function safeStr(s)
        if not s then return "N/A" end
        local ok, r = pcall(json.encode, tostring(s))
        if ok then
            return r:gsub('^"', ''):gsub('"$', '')
        end
        return tostring(s)
    end
    local staffName = safeStr(banInfo and banInfo.staff_name)
    local banReason = safeStr(banInfo and banInfo.reason)
    local banId = tostring(banInfo and (banInfo.ban_code or banInfo.id) or "N/A")
    local serverName = safeStr(Config.NomeServer or "Server")
    local discordLink = safeStr(Config.DiscordServer or "#")
    local safeExpiry = safeStr(banExpiry)
    local cardJson = string.format([[
    {
        "type": "AdaptiveCard",
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "version": "1.5",
        "body": [
            {
                "type": "Container",
                "style": "default",
                "items": [
                    {
                        "type": "ColumnSet",
                        "columns": [
                            {
                                "type": "Column",
                                "width": "auto",
                                "items": [
                                    {
                                        "type": "Image",
                                        "url": "https://cdn-icons-png.flaticon.com/512/1828/1828843.png",
                                        "size": "small",
                                        "style": "person",
                                        "backgroundColor": "#FF4C4C"
                                    }
                                ],
                                "verticalContentAlignment": "Center"
                            },
                            {
                                "type": "Column",
                                "width": "stretch",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "%s",
                                        "weight": "bolder",
                                        "size": "extraLarge",
                                        "color": "light",
                                        "wrap": true,
                                        "horizontalAlignment": "Left"
                                    }
                                ],
                                "verticalContentAlignment": "Center"
                            }
                        ],
                        "horizontalAlignment": "Center",
                        "spacing": "medium"
                    },
                    {
                        "type": "Container",
                        "style": "emphasis",
                        "bleed": true,
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "🚫 ACCESSO NEGATO",
                                "size": "extraLarge",
                                "weight": "bolder",
                                "color": "light",
                                "wrap": true,
                                "horizontalAlignment": "Center"
                            },
                            {
                                "type": "TextBlock",
                                "text": "Il tuo account è stato sospeso da questo server",
                                "size": "medium",
                                "color": "light",
                                "wrap": true,
                                "horizontalAlignment": "Center",
                                "spacing": "small"
                            }
                        ],
                        "spacing": "medium",
                        "separator": true
                    },
                    {
                        "type": "Container",
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "📋 INFORMAZIONI DEL BAN",
                                "weight": "bolder",
                                "size": "medium",
                                "color": "light",
                                "horizontalAlignment": "Center",
                                "wrap": true,
                                "spacing": "medium"
                            },
                            {
                                "type": "ActionSet",
                                "actions": [
                                    {
                                        "type": "Action.Execute",
                                        "title": "🔑 ID Ban: #%s",
                                        "verb": "show_ban_id",
                                        "style": "default"
                                    }
                                ],
                                "horizontalAlignment": "Center",
                                "spacing": "small"
                            },
                            {
                                "type": "ActionSet",
                                "actions": [
                                    {
                                        "type": "Action.Execute",
                                        "title": "👮 Autore: %s",
                                        "verb": "show_staff",
                                        "style": "default"
                                    }
                                ],
                                "horizontalAlignment": "Center",
                                "spacing": "small"
                            },
                            {
                                "type": "ActionSet",
                                "actions": [
                                    {
                                        "type": "Action.Execute",
                                        "title": "📝 Motivo: %s",
                                        "verb": "show_reason",
                                        "style": "default"
                                    }
                                ],
                                "horizontalAlignment": "Center",
                                "spacing": "small"
                            },
                            {
                                "type": "ActionSet",
                                "actions": [
                                    {
                                        "type": "Action.Execute",
                                        "title": "📅 Scadenza: %s",
                                        "verb": "show_expiry",
                                        "style": "default"
                                    }
                                ],
                                "horizontalAlignment": "Center",
                                "spacing": "small"
                            }
                        ],
                        "spacing": "medium",
                        "separator": true
                    },
                    {
                        "type": "Container",
                        "style": "good",
                        "bleed": true,
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "Se ritieni che questo ban sia un errore, contatta il nostro team di supporto tramite il server Discord.",
                                "wrap": true,
                                "color": "light",
                                "horizontalAlignment": "Center",
                                "spacing": "small",
                                "size": "small"
                            }
                        ],
                        "spacing": "medium",
                        "separator": true
                    }
                ],
                "spacing": "medium",
                "separator": true
            }
        ],
        "actions": [
            {
                "type": "Action.OpenUrl",
                "title": "🎮 Unisciti al Discord",
                "url": "%s",
                "style": "positive"
            }
        ]
    }
    ]],
    serverName, banId, staffName, banReason, safeExpiry, discordLink
    )
    d.presentCard(cardJson)
end)


RegisterServerEvent('nxs:kill')
AddEventHandler('nxs:kill', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("KILL", fields, ConfigServer.Webhook.kill)
  TriggerClientEvent('nxs:kill', id)
end)

RegisterServerEvent('nxs:goto')
AddEventHandler('nxs:goto', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("GOTO", fields, ConfigServer.Webhook.goto1)
  staff.setCoords(target.getCoords(true))
end)

RegisterServerEvent('nxs:bring')
AddEventHandler('nxs:bring', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("BRING", fields, ConfigServer.Webhook.bring)
  target.setCoords(staff.getCoords(true))
end)

RegisterServerEvent('nxs:clearInv')
AddEventHandler('nxs:clearInv', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  local itemsTarget = target.getInventory()
  for k, v in pairs(itemsTarget) do
    target.removeInventoryItem(v.name, v.count)
  end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("CLEAR INV.", fields, ConfigServer.Webhook.clearinventory)
end)

RegisterServerEvent('nxs:wipe')
AddEventHandler('nxs:wipe', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  for k, v in pairs(Config.WipeSettings) do
    for a, b in pairs(v) do
      MySQL.Sync.execute('DELETE FROM ' .. b .. ' WHERE ' .. k .. ' = @identifier', {
        ['@identifier'] = target.identifier,
      })
    end
  end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("WIPE", fields, ConfigServer.Webhook.wipe)
  DropPlayer(target.source, 'Sei stato wipato dal server')
end)

RegisterServerEvent('nxs:deletewarn')
AddEventHandler('nxs:deletewarn', function(id, index)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  if index == 0 then index = 1 end
  local identifier = GetLicense(target.source, "license")
  local warns = MySQL.Sync.fetchAll(
    "SELECT id FROM nxs_warn WHERE identifier = @identifier ORDER BY warn_date ASC",
    { ['@identifier'] = identifier }
  )
  if warns and warns[index] then
    MySQL.Sync.execute("DELETE FROM nxs_warn WHERE id = @id", { ['@id'] = warns[index].id })
  end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("WARN ELIMINATO", fields, ConfigServer.Webhook.warn)
  broadcastUpdateToStaff()
end)

RegisterServerEvent('nxs:revocaban')
AddEventHandler('nxs:revocaban', function(staffId, id)
    local staff = ESX.GetPlayerFromId(staffId)
    local staffName = staff and GetPlayerName(staff.source) or "Sconosciuto"
    local success, message = UnBan(id, staffId, staffName)
    if success then
        if staff then
            TriggerClientEvent('esx:showNotification', staffId, Config.Lang[Config.Language]['revoca_ban'] or "Ban revocato con successo")
        end
        local banInfo = GetInfoBanFromId(id)
        if banInfo then
            local fields = {
                { name = Config.Lang[Config.Language]['nome_staff'] or "Staff", value = staffName, inline = true },
                { name = Config.Lang[Config.Language]["nome_player"] or "Player", value = banInfo.player_name, inline = true },
                { name = "ID Ban", value = "#" .. id, inline = true },
                { name = "Motivo Ban", value = banInfo.reason, inline = true },
            }
            sendWebhook("REVOCA BAN", fields, ConfigServer.Webhook.ban or ConfigServer.Webhook.default)
        end
        broadcastUpdateToStaff()
        if staff then
            TriggerClientEvent('nxs:setBan', staffId, getBans())
        end
    else
        if staff then
            TriggerClientEvent('esx:showNotification', staffId, "Errore: " .. (message or "Sconosciuto"), "error")
        end
    end
end)

RegisterCommand('unban', function(source, args, rawCommand)
  if source == 0 or SonoStaff(ESX.GetPlayerFromId(source)) then
    local idBan = tonumber(args[1])
    if not GetInfoBanFromId(idBan) then
      if source == 0 then
        print("[NEXUS-BAN] ID Ban non valido: " .. tostring(idBan))
      else
        ESX.GetPlayerFromId(source).showNotification("ID Ban non valido", "error")
      end
      return
    end
    local staffName = source == 0 and "CONSOLE" or GetPlayerName(source)
    local success, message = UnBan(idBan, source, staffName)
    if success then
      if source == 0 then
        print("[NEXUS-BAN] Ban #" .. idBan .. " revocato con successo")
      else
        ESX.GetPlayerFromId(source).showNotification("Unban effettuato con successo", "success")
      end
    else
      if source == 0 then
        print("[NEXUS-BAN] Errore revoca ban: " .. message)
      else
        ESX.GetPlayerFromId(source).showNotification("Errore: " .. message, "error")
      end
    end
  end
end)

RegisterServerEvent('nxs:freeze')
AddEventHandler('nxs:freeze', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  TriggerClientEvent('nxs:freeze', target.source)
  if client_var[target.source] then
    client_var[target.source].freeze = (client_var[target.source].freeze == 1) and false or 1
  end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("FREEZE", fields, ConfigServer.Webhook.freeze)
  broadcastUpdateToStaff()
end)

RegisterServerEvent('nxs:sfreeze')
AddEventHandler('nxs:sfreeze', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  TriggerClientEvent('nxs:sfreeze', target.source)
  if client_var[target.source] then
    client_var[target.source].freeze = (client_var[target.source].freeze == 1) and false or 1
  end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("SFREEZE", fields, ConfigServer.Webhook.freeze)
  broadcastUpdateToStaff()
end)



RegisterServerEvent('nxs:clearped')
AddEventHandler('nxs:clearped', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then return end
  local fields = {
    { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(staff.source), inline = true },
    { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(target.source), inline = true },
  }
  sendWebhook("CLEAR PED", fields, ConfigServer.Webhook.clearped)
  TriggerClientEvent('nxs:clearped', target.source)
end)

GenerateRandomColor = function()
  return math.random(0, 255), math.random(0, 255), math.random(0, 255)
end

RegisterServerEvent('nxs:webhook')
AddEventHandler('nxs:webhook', function(title, fields, webhook)
  if type(webhook) == "string" then
    webhook = ConfigServer.Webhook[webhook]
  end
  sendWebhook(title, fields, webhook)
end)

sendWebhook = function(title, fields, webhook)
  local r, g, b = GenerateRandomColor()
  local embed = {
    {
      ["title"] = title,
      ["type"] = "rich",
      ["color"] = r * 65536 + g * 256 + b,
      ["fields"] = fields,
      ["footer"] = { ["text"] = os.date("%d/%m/%Y %H:%M") },
      ['thumbnail'] = { ['url'] = Config.LogoServer },
    }
  }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST',
    json.encode({ username = Config.NomeServer, avatar_url = Config.LogoServer, embeds = embed }),
    { ['Content-Type'] = 'application/json' })
end

local function sendResourcesToClient(src)
    local resources = {}
    local resourceCount = GetNumResources()
    for i = 0, resourceCount - 1 do
        local resourceName = GetResourceByFindIndex(i)
        if resourceName and resourceName ~= '_cfx_internal' then
            table.insert(resources, {
                name = resourceName,
                state = GetResourceState(resourceName)
            })
        end
    end
    table.sort(resources, function(a, b) return a.name < b.name end)
    TriggerClientEvent('nxs:sendresources', src, resources)
end

RegisterServerEvent('nxs:getresources')
AddEventHandler('nxs:getresources', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    sendResourcesToClient(source)
end)

RegisterServerEvent('nxs:startresource')
AddEventHandler('nxs:startresource', function(resourceName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    if GetResourceState(resourceName) ~= 'started' then
        StartResource(resourceName)
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
            { name = "Risorsa", value = resourceName, inline = true },
            { name = "Azione", value = "START", inline = true },
        }
        sendWebhook("Gestione Risorse", fields, ConfigServer.Webhook.default or "")
    end
    Citizen.Wait(1000)
    sendResourcesToClient(source)
end)

RegisterServerEvent('nxs:restartresource')
AddEventHandler('nxs:restartresource', function(resourceName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    if GetResourceState(resourceName) == 'started' then
        StopResource(resourceName)
        Citizen.Wait(100)
        StartResource(resourceName)
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
            { name = "Risorsa", value = resourceName, inline = true },
            { name = "Azione", value = "RESTART", inline = true },
        }
        sendWebhook("Gestione Risorse", fields, ConfigServer.Webhook.default or "")
    end
    Citizen.Wait(2000)
    sendResourcesToClient(source)
end)

RegisterServerEvent('nxs:stopresource')
AddEventHandler('nxs:stopresource', function(resourceName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    if GetResourceState(resourceName) == 'started' then
        StopResource(resourceName)
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
            { name = "Risorsa", value = resourceName, inline = true },
            { name = "Azione", value = "STOP", inline = true },
        }
        sendWebhook("Gestione Risorse", fields, ConfigServer.Webhook.default or "")
    end
    Citizen.Wait(1000)
    sendResourcesToClient(source)
end)

RegisterServerEvent('nxs:executecommand')
AddEventHandler('nxs:executecommand', function(command)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    local players = ESX.GetExtendedPlayers()
    for _, player in pairs(players) do
        if SonoStaff(player) then
            TriggerClientEvent('nxs:consoleLog', player.source, GetPlayerName(source), command)
        end
    end
    ExecuteCommand(command)
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
        { name = "Comando", value = command, inline = false },
    }
    sendWebhook("Console Command", fields, ConfigServer.Webhook.default or "")
end)

local currentWeather = 'CLEAR'
local currentTime = 12
local timeFreezed = false

RegisterServerEvent('nxs:setServerTime')
AddEventHandler('nxs:setServerTime', function(time)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    currentTime = tonumber(time) or 12
    TriggerClientEvent('nxs:updateServerTime', -1, currentTime)
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
        { name = "Ora Impostata", value = currentTime .. ":00", inline = true },
    }
    sendWebhook("Cambio Ora Server", fields, ConfigServer.Webhook.default or "")
end)

RegisterServerEvent('nxs:freezeTime')
AddEventHandler('nxs:freezeTime', function(freeze)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    timeFreezed = freeze
    TriggerClientEvent('nxs:updateTimeFreeze', -1, timeFreezed)
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
        { name = "Stato Tempo", value = freeze and "Bloccato" or "Sbloccato", inline = true },
    }
    sendWebhook("Cambio Stato Tempo", fields, ConfigServer.Webhook.default or "")
end)

RegisterServerEvent('nxs:setWeather')
AddEventHandler('nxs:setWeather', function(weather, transition)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    currentWeather = weather or 'CLEAR'
    TriggerClientEvent('nxs:updateWeather', -1, currentWeather, transition)
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
        { name = "Meteo Impostato", value = currentWeather, inline = true },
    }
    sendWebhook("Cambio Meteo Server", fields, ConfigServer.Webhook.default or "")
end)

RegisterServerEvent('nxs:setWeatherIntensity')
AddEventHandler('nxs:setWeatherIntensity', function(intensity, weather)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not SonoStaff(xPlayer) then return end
    local intensityPercent = math.floor(intensity * 100)
    TriggerClientEvent('nxs:updateWeatherIntensity', -1, intensity, weather)
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(source), inline = true },
        { name = "Intensità Meteo", value = intensityPercent .. "%", inline = true },
        { name = "Condizione", value = weather, inline = true },
    }
    sendWebhook("Cambio Intensità Meteo", fields, ConfigServer.Webhook.default or "")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        if not timeFreezed then
            currentTime = currentTime + 1
            if currentTime >= 24 then currentTime = 0 end
            TriggerClientEvent('nxs:updateServerTime', -1, currentTime)
        end
    end
end)

RegisterServerEvent('nxs:getAllUsers')
AddEventHandler('nxs:getAllUsers', function()
    local src = source
    local staff = ESX.GetPlayerFromId(src)
    if not staff then return end
    local staffGroup = staff.getGroup()
    if not staffGroup or staffGroup == (ConfigServer.GroupUser or 'user') then return end
    MySQL.Async.fetchAll('SELECT identifier, CONCAT(firstname, " ", lastname) as name, `group` FROM users ORDER BY firstname ASC', {}, function(result)
        local users = {}
        if result then
            for _, user in ipairs(result) do
                table.insert(users, {
                    identifier = user.identifier,
                    name = user.name or "Sconosciuto",
                    group = user.group or ConfigServer.GroupUser or 'user'
                })
            end
        end
        TriggerClientEvent('nxs:setAllUsers', src, users)
    end)
end)

RegisterServerEvent('nxs:changeUserGroup')
AddEventHandler('nxs:changeUserGroup', function(data)    local src = source
    local staff = ESX.GetPlayerFromId(src)
    if not staff then return end
    local staffGroup = staff.getGroup()
    if not staffGroup or staffGroup == (ConfigServer.GroupUser or 'user') then return end
    MySQL.Async.execute('UPDATE users SET `group` = @group WHERE identifier = @identifier', {
        ['@group'] = data.group,
        ['@identifier'] = data.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            local targetPlayer = nil
            for _, player in pairs(ESX.GetExtendedPlayers()) do
                if player.identifier == data.identifier then
                    targetPlayer = player
                    break
                end
            end
            if targetPlayer then
                targetPlayer.setGroup(data.group)
                TriggerClientEvent('esx:showNotification', targetPlayer.source, 'Il tuo grado è stato aggiornato a: ' .. data.group)
            end
            TriggerClientEvent('esx:showNotification', src, 'Gruppo aggiornato con successo!')
            local targetName = targetPlayer and GetPlayerName(targetPlayer.source) or "Utente Offline"
            local fields = {
                { name = "Staff", value = GetPlayerName(src), inline = true },
                { name = "Utente", value = targetName, inline = true },
                { name = "Nuovo Gruppo", value = data.group, inline = true },
            }
            sendWebhook("Cambio Gruppo Utente", fields, ConfigServer.Webhook.default or "")
        end
    end)
end)


RegisterServerEvent('nxs:removeitem')
AddEventHandler('nxs:removeitem', function(id, item, count)
    local src    = source
    local staff  = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)
    if not target then return end

    local inventory = target.getInventory()
    local hasItem = false
    for _, v in pairs(inventory) do
        if v.name == item and v.count >= count then
            hasItem = true
            break
        end
    end

    if not hasItem then
        TriggerClientEvent('esx:showNotification', src, '~r~Oggetto non trovato o quantità insufficiente')
        return
    end

    target.removeInventoryItem(item, count)

    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'],  value = GetPlayerName(staff.source),  inline = true },
        { name = Config.Lang[Config.Language]['nome_player'], value = GetPlayerName(target.source), inline = true },
        { name = 'Oggetto',    value = item,           inline = true },
        { name = 'Quantità',   value = tostring(count), inline = true },
    }
    sendWebhook('REMOVE ITEM', fields, ConfigServer.Webhook.removeitem or '')
    broadcastUpdateToStaff()
end)


RegisterServerEvent('nxs:viewinventory')
AddEventHandler('nxs:viewinventory', function(id)
    local src    = source
    local staff  = ESX.GetPlayerFromId(src)
    if not staff or not SonoStaff(staff) then return end

    local target = ESX.GetPlayerFromId(id)
    if not target then
        TriggerClientEvent('esx:showNotification', src, '~r~Giocatore non trovato')
        return
    end

    local inventory = target.getInventory()
    local items = {}
    for _, v in pairs(inventory) do
        if v.count and v.count > 0 then
            table.insert(items, {
                name  = v.name,
                label = v.label or v.name,
                count = v.count,
                weight = v.weight or 0,
            })
        end
    end


    table.sort(items, function(a, b) return a.name < b.name end)

    TriggerClientEvent('nxs:sendInventory', src, items, GetPlayerName(target.source))

    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'],  value = GetPlayerName(staff.source),  inline = true },
        { name = Config.Lang[Config.Language]['nome_player'], value = GetPlayerName(target.source), inline = true },
        { name = 'Oggetti Trovati', value = tostring(#items), inline = true },
    }
    sendWebhook('VIEW INVENTORY', fields, ConfigServer.Webhook.viewinventory or '')
end)