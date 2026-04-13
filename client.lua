local ESX = exports.es_extended:getSharedObject()
local spectating = false
local idSpectate = 0
local spectateAttached = false
local nomiTesta = false
local messagePopupActive = false
local messagePopupType = nil
local messagePopupTimeout = nil
local noclipEnabled = false
local noclipThread = false
local ghostSpectate = false
local currentSpectateTarget = 0
local lastCoords = nil
local lastHeading = nil


Citizen.CreateThread(function()
    while true do
        if messagePopupActive then
            Citizen.Wait(0)
            if IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201) or IsControlJustPressed(0, 202) then
                SendNUIMessage({
                    type = "CLOSE_POPUP_KEYPRESS"
                })
                messagePopupActive = false
                if messagePopupTimeout then
                    ClearTimeout(messagePopupTimeout)
                    messagePopupTimeout = nil
                end
            end
            if IsControlJustPressed(0, 322) then
                SendNUIMessage({
                    type = "CLOSE_POPUP_KEYPRESS"
                })
                messagePopupActive = false
                if messagePopupTimeout then
                    ClearTimeout(messagePopupTimeout)
                    messagePopupTimeout = nil
                end
            end
        else
            Citizen.Wait(100)
        end
    end
end)
SendDMMessage = function(text, sender)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    Citizen.Wait(0) 
    SendNUIMessage({
        type = "SHOW_DM_MESSAGE",
        text = text,
        sender = sender
    })
end
Announce = function(text)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    Citizen.Wait(0)
    SendNUIMessage({
        type = "SHOW_ANNOUNCE",
        text = text
    })
end
ShowWarnMessage = function(text, sender)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    Citizen.Wait(0)
    SendNUIMessage({
        type = "SHOW_WARN_MESSAGE",
        text = text,
        sender = sender
    })
end
RegisterNUICallback('popupClosed', function(data, cb)
    cb('ok')
end)
RegisterCommand(Config.CommandName, function(source, args, rawCommand)
    if SonoStaff() == false then return end
    OpenAdminMenu()
end)
if Config.Keybinds.adminmenu.enable then 
    RegisterKeyMapping(Config.CommandName, 'Admin Menu', 'keyboard', Config.Keybinds.adminmenu.key)
end
if Config.Keybinds.nomitesta.enable then 
    RegisterKeyMapping('-+nomitesta', 'Nomi Sopra la Testa', 'keyboard', Config.Keybinds.nomitesta.key)
    TriggerEvent('chat:removeSuggestion', '/-+nomitesta')
    RegisterCommand('-+nomitesta', function(source, args, rawCommand)
        if SonoStaff() == false then return end
        nomiTesta = not nomiTesta
        if nomiTesta then 
            ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_a"])
            fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["stato_nomitesta"],
                  value = Config.Lang[Config.Language]["attivo"],
                  inline = true
                },
              }
        else
            ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_b"])
            fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["stato_nomitesta"],
                  value = Config.Lang[Config.Language]["inattivo"],
                  inline = true
                },
              }
        end
        TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["nomitesta"], fields, "nomiplayer")
    end)
end
RegisterNUICallback('deletewarn', function(data)
    local id = data.id
    local index = data.index
    ESX.ShowNotification(Config.Lang[Config.Language]["delete_warn"])
    TriggerServerEvent('nxs:deletewarn', id, index)
end)
SonoStaff = function()
    local staff1 = nil
   ESX.TriggerServerCallback('nxs:sonoStaff', function(staff) 
        staff1 = staff
    end)
    while staff1 == nil do
        Citizen.Wait(0)
    end
    return staff1
end
postMessage = function(data)
    SendNUIMessage(data)
end
local menuOpen = false
CreateThread(function()
    while true do
        Wait(5000)
        if menuOpen and SonoStaff() then
            ESX.TriggerServerCallback('nxs:getPlayers', function(t)
                players = t
                postMessage({
                    type = "UPDATE_PLAYERS",
                    players = players
                })
            end)
        end
    end
end)
OpenAdminMenu = function()
    ESX.TriggerServerCallback('nxs:getPlayers', function(t)
        ESX.TriggerServerCallback('nxs:getData', function(data)
            if SonoStaff() == false then return end
            menuOpen = true
            SetNuiFocus(true, true)
            players = t
            postMessage({
                type = "SET_RADIUS",
                radius = Config.ClearAreaRadius
            })
            postMessage({
                type = "SET_ADMIN_ONLINE",
                admin = data.adminOnline
            })
            postMessage({
                type = "SET_KICKS",
                kicks = data.kicks
            })
            postMessage({
                type = "SET_CONFIG",
                config = Config
            })
            postMessage({
                type = "SET_BAN",
                ban = data.bans
            })
            postMessage({
                type = "SET_INFO_STAFF",
                info = data.infoStaff
            })
            postMessage({
                type = "SET_JOBS",
                jobs = data.jobs
            })
            postMessage({
                type = "SET_ADMIN_GROUPS",
                groups = Config.AdminGroup
            })
            postMessage({
                type = "SET_ORARIO",
                orario = data.orario
            })
            postMessage({
                type = "SET_AZIONI",
                azioni = Config.Azioni
            })
            postMessage({
                type = "SET_AZIONI_PERSONALE",
                azioni = Config.AzioniPersonale
            })
            postMessage({
                type = "OPEN",
                players = players
            })
            postMessage({
                type = "SET_SERVER_LOGO",
                logo = Config.LogoServer
            })
            TriggerServerEvent('nxs:getresources')
        end)
    end)
end
RegisterNetEvent('nxs:sendresources')
AddEventHandler('nxs:sendresources', function(resources)
    SendNUIMessage({
        type = "SET_RESOURCES",
        resources = resources
    })
end)
RegisterNUICallback('close', function(data, cb)
    menuOpen = false
    SetNuiFocus(false, false)
end)
RegisterNUICallback('skinmenu', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:skinmenu', id)
end)
RegisterNUICallback('spectate', function(data)
    local targetId = tonumber(data.id)
    if not targetId or targetId == GetPlayerServerId(PlayerId()) then
        ESX.ShowNotification("Non puoi spectare te stesso!")
        return
    end
    idSpectate = targetId
    currentSpectateTarget = targetId
    ghostSpectate = false
    spectateAttached = false
    SetNuiFocus(false, false)
    lastCoords = GetEntityCoords(PlayerPedId())
    lastHeading = GetEntityHeading(PlayerPedId())
    spectating = true
    ESX.ShowHelpNotification("Premi E per uscire dallo spectate")
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(GetPlayerFromServerId(targetId)), inline = true },
        { name = "Modalità", value = "Spectator Classico", inline = true },
    }
    TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["inizio_spectate"], fields, "spectate")
end)
RegisterNUICallback('spactate', function(data)
    local targetId = tonumber(data.id)
    if not targetId or targetId == GetPlayerServerId(PlayerId()) then
        ESX.ShowNotification("Non puoi spectare te stesso!")
        return
    end
    idSpectate = targetId
    currentSpectateTarget = targetId
    ghostSpectate = true
    spectateAttached = false
    SetNuiFocus(false, false)
    lastCoords = GetEntityCoords(PlayerPedId())
    lastHeading = GetEntityHeading(PlayerPedId())
    spectating = true
    ESX.ShowHelpNotification("Premi E per uscire dallo spactate")
    local fields = {
        { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
        { name = Config.Lang[Config.Language]["nome_player"], value = GetPlayerName(GetPlayerFromServerId(targetId)), inline = true },
        { name = "Modalità", value = "Spactate / Ghost", inline = true },
    }
    TriggerServerEvent('nxs:webhook', "Inizio Spactate", fields, "spectate")
end)
RegisterNetEvent('nxs:dm')
AddEventHandler('nxs:dm', function(text, sender)
    SendDMMessage(text, sender)
end)
RegisterNetEvent('nxs:announce')
AddEventHandler('nxs:announce', function(text)
    Announce(text)
end)
RegisterNetEvent('nxs:warnmessage')
AddEventHandler('nxs:warnmessage', function(text, sender)
    ShowWarnMessage(text, sender)
end)
RegisterNUICallback('repairvehicle', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)
        local fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["veicolo"],
              value = GetDisplayNameFromVehicleModel(GetEntityModel(veh)),
              inline = true
            },
          }
        TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["ripara_veicolo"], fields, "repairvehicle")
        ESX.ShowNotification(Config.Lang[Config.Language]["repair_vehicle2"])
    end
end)
RegisterNetEvent('nxs:cleararea')
AddEventHandler('nxs:cleararea', function(radius)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicles = ESX.Game.GetVehiclesInArea(pos, tonumber(radius))
    for k,v in pairs(vehicles) do 
        ESX.Game.DeleteVehicle(v)
    end
    ClearAreaOfVehicles(pos.x, pos.y, pos.z, radius, false, false, false, false, false)
    ClearAreaOfPeds(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfObjects(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfCops(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfProjectiles(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfEverything(pos.x, pos.y, pos.z, radius, 1)
    local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(PlayerId()),
          inline = true
        }
      }
    TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["clear_area"], fields, "cleararea")
    ESX.ShowNotification(Config.Lang[Config.Language]["clear_area2"])
end)
RegisterNUICallback('clearped', function(data)
    local id = data.id
    TriggerServerEvent('nxs:clearped', id)
end)
RegisterNetEvent('nxs:clearped')
AddEventHandler('nxs:clearped', function()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    ClearPedBloodDamage(ped)
    ESX.ShowNotification(Config.Lang[Config.Language]["clear_ped"])
end)
Citizen.CreateThread(function()
  while true do
    if spectating then 
        Wait(0)
        local targetPed = GetPlayerPed(GetPlayerFromServerId(currentSpectateTarget))
        if not DoesEntityExist(targetPed) then
            spectating = false
            ghostSpectate = false
            spectateAttached = false
            goto continue
        end
        local localPed = PlayerPedId()
        if ghostSpectate then
            if not spectateAttached then
                spectateAttached = true
                SetEntityVisible(localPed, false, false)
                SetEntityCollision(localPed, false, false)
                SetEntityInvincible(localPed, true)
                SetEveryoneIgnorePlayer(PlayerId(), true)
                SetPoliceIgnorePlayer(PlayerId(), true)
            end
            local targetCoords = GetEntityCoords(targetPed)
            local offset = vector3(0.0, 0.0, 2.2)
            SetEntityCoordsNoOffset(localPed, targetCoords + offset, true, true, true)
            SetEntityHeading(localPed, GetEntityHeading(targetPed))
        else
            if not spectateAttached then
                spectateAttached = true
                NetworkSetInSpectatorMode(true, targetPed)
                SetEntityVisible(localPed, false, false)
                AttachEntityToEntity(localPed, targetPed, 4103, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
            end
        end
        if IsControlJustPressed(0, 38) then
            spectating = false
            ghostSpectate = false
            spectateAttached = false
            currentSpectateTarget = 0
            NetworkSetInSpectatorMode(false, localPed)
            DetachEntity(localPed, true, true)
            SetEntityCollision(localPed, true, true)
            SetEntityInvincible(localPed, false)
            SetEntityVisible(localPed, true, false)
            SetEveryoneIgnorePlayer(PlayerId(), false)
            SetPoliceIgnorePlayer(PlayerId(), false)
            if lastCoords then
                SetEntityCoords(localPed, lastCoords)
                SetEntityHeading(localPed, lastHeading or 0.0)
            end
            local fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["nome_player"],
                  value = GetPlayerName(GetPlayerFromServerId(idSpectate)),
                  inline = true
                },
            }
            TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["fine_spectate"], fields, "spectate")
            postMessage({
                type = "RESUME"
            })
            SetNuiFocus(true, true)
        end
    else
        Wait(300)
    end
    ::continue::
   end
end)
function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))
	if len ~= 0 then
		coords = coords / len
	end
	return coords
end
local freecamSpeeds     = { 0.2, 0.5, 1.0, 1.5, 2.0 }
local freecamSpeedIndex = 2
local freecamCam        = nil
local fcYaw             = 0.0
local fcPitch           = 0.0
local fcUp              = false
local fcDown            = false

RegisterKeyMapping('+fcUp',   'FreeCam Su',  'keyboard', 'q')
RegisterKeyMapping('+fcDownE', 'FreeCam Giu', 'keyboard', 'e')
RegisterCommand('+fcUp',    function() fcUp   = true  end, false)
RegisterCommand('-fcUp',    function() fcUp   = false end, false)
RegisterCommand('+fcDownE', function() fcDown = true  end, false)
RegisterCommand('-fcDownE', function() fcDown = false end, false)

local function StartFreecam()
    local pos = GetEntityCoords(PlayerPedId())
    fcYaw   = GetEntityHeading(PlayerPedId())
    fcPitch = 0.0
    freecamCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(freecamCam, pos.x, pos.y, pos.z)
    SetCamRot(freecamCam, fcPitch, 0.0, fcYaw, 2)
    SetCamActive(freecamCam, true)
    RenderScriptCams(true, false, 0, true, true)
end

local function StopFreecam()
    if freecamCam then
        RenderScriptCams(false, false, 0, true, true)
        SetCamActive(freecamCam, false)
        DestroyCam(freecamCam, false)
        freecamCam = nil
    end
end
local fcScaleform      = nil
local fcLastSpeedIndex = -1

local function BuildScaleform(sf)
    local spd = math.floor(freecamSpeeds[freecamSpeedIndex] * 100) .. "%"

    PushScaleformMovieFunction(sf, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 21, true))
    PushScaleformMovieFunctionParameterString("Speed " .. spd)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 51, true))
    PushScaleformMovieFunctionParameterString("Down")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 44, true))
    PushScaleformMovieFunctionParameterString("Up")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 35, true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 34, true))
    PushScaleformMovieFunctionParameterString("Left/Right")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 33, true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 32, true))
    PushScaleformMovieFunctionParameterString("Forwards/Backwards")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
end


Citizen.CreateThread(function()
    while true do
        if noclipEnabled then
            Wait(0)
            if not fcScaleform then
                fcScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
                fcLastSpeedIndex = -1
            end
            if HasScaleformMovieLoaded(fcScaleform) then
                if fcLastSpeedIndex ~= freecamSpeedIndex then
                    fcLastSpeedIndex = freecamSpeedIndex
                    BuildScaleform(fcScaleform)
                end
                DrawScaleformMovieFullscreen(fcScaleform, 255, 255, 255, 255, 0)
            end
            DisableControlAction(0, 21, true)
            if IsDisabledControlJustPressed(0, 21) then
                freecamSpeedIndex = freecamSpeedIndex % #freecamSpeeds + 1
            end
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            local mX = GetDisabledControlNormal(0, 1) * 5.0
            local mY = GetDisabledControlNormal(0, 2) * 5.0
            fcYaw   = fcYaw - mX
            fcPitch = math.max(-89.0, math.min(89.0, fcPitch - mY))
            if freecamCam then
                SetCamRot(freecamCam, fcPitch, 0.0, fcYaw, 2)
            end
            local spd = freecamSpeeds[freecamSpeedIndex]
            local rad = math.rad(fcYaw)
            local fwd   = vector3(-math.sin(rad), math.cos(rad), 0.0)
            local right = vector3( math.cos(rad), math.sin(rad), 0.0)

            local pos = GetEntityCoords(PlayerPedId(), false)
            local moved = false

            if IsControlPressed(0, 32) then
                pos = pos + fwd * spd; moved = true
            end
            if IsControlPressed(0, 33) then
                pos = pos - fwd * spd; moved = true
            end
            if IsControlPressed(0, 34) then
                pos = pos - right * spd; moved = true
            end
            if IsControlPressed(0, 35) then
                pos = pos + right * spd; moved = true
            end
            if fcUp then
                pos = vector3(pos.x, pos.y, pos.z + spd); moved = true
            end
            if fcDown then
                pos = vector3(pos.x, pos.y, pos.z - spd); moved = true
            end

            SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
            if moved then
                SetEntityCoordsNoOffset(PlayerPedId(), pos, true, true, true)
                if freecamCam then
                    SetCamCoord(freecamCam, pos.x, pos.y, pos.z)
                end
            end
        else
            if fcScaleform then
                SetScaleformMovieAsNoLongerNeeded(fcScaleform)
                fcScaleform = nil
            end
            Wait(500)
        end
    end
end)
RegisterNUICallback('heal', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:heal', id)
end)
RegisterNUICallback('revive', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:revive', id)
end)
RegisterCommand('noclip', function()
    if SonoStaff() == false then return end
    ToggleNoclip()
end)
if Config.Keybinds.noclip.enable then
    RegisterKeyMapping('noclip', 'Noclip', 'keyboard', Config.Keybinds.noclip.key)
end
function ToggleNoclip()
    noclipEnabled = not noclipEnabled
    local ped = PlayerPedId()
    if noclipEnabled then
        ESX.ShowNotification(Config.Lang[Config.Language]['noclip_attivato'])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)
        SetEveryoneIgnorePlayer(PlayerId(), true)
        SetPoliceIgnorePlayer(PlayerId(), true)
        StartFreecam()
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
            { name = Config.Lang[Config.Language]["stato_noclip"], value = Config.Lang[Config.Language]["attivo"], inline = true },
        }
        TriggerServerEvent('nxs:webhook', 'NoClip', fields, "noclip")
    else
        StopFreecam()
        freecamSpeedIndex = 2
        fcUp   = false
        fcDown = false
        ESX.ShowNotification(Config.Lang[Config.Language]['noclip_disattivato'])
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), false)
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
            { name = Config.Lang[Config.Language]["stato_noclip"], value = Config.Lang[Config.Language]["inattivo"], inline = true },
        }
        TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["noclip"], fields, "noclip")
    end
end
RegisterNUICallback('noclip', function(data, cb)
    SetNuiFocus(false, false)
    ExecuteCommand('noclip')
end)
RegisterNUICallback('revocaban', function(data)
    local id = data.id
    TriggerServerEvent('nxs:revocaban', GetPlayerServerId(PlayerId()), id)
    ESX.ShowNotification(Config.Lang[Config.Language]['revoca_ban'])
end)
RegisterNUICallback('kill', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:kill', id)
end)
RegisterNUICallback('goto', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:goto', id)
end)
RegisterNUICallback('bring', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:bring', id)
end)
RegisterNUICallback('wipe', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:wipe', id)
end)
RegisterNUICallback('clearinv', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:clearInv', id)
end)
RegisterNetEvent('nxs:kill')
AddEventHandler('nxs:kill', function()
  local ped = PlayerPedId()
  SetEntityHealth(ped, 0)
end)
RegisterNUICallback('action', function(data, cb)
    TriggerServerEvent('nxs:action', data)
end)
RegisterNetEvent('nxs:updatePlayers')
AddEventHandler('nxs:updatePlayers', function()
    if not menuOpen then return end
    ESX.TriggerServerCallback('nxs:getPlayers', function(p)
        postMessage({
            type = "UPDATE_PLAYERS",
            players = p
        })
    end)
end)
RegisterNetEvent('nxs:setped')
AddEventHandler('nxs:setped', function(model)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end
end)
RegisterNetEvent('nxs:resetped')
AddEventHandler('nxs:resetped', function()
    local maschio = 'mp_m_freemode_01'
    local femmina = 'mp_f_freemode_01'
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then 
        RequestModel(maschio)
        while not HasModelLoaded(maschio) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), maschio)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
          end)
      else
        RequestModel(femmina)
        while not HasModelLoaded(femmina) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), femmina)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
          end)
      end
    end)
end)
RegisterNUICallback('freeze', function(data)
    local id = tonumber(data.id)
    TriggerServerEvent('nxs:freeze', id)
end)
RegisterNUICallback('sfreeze', function(data)
    local id = tonumber(data.id)
    TriggerServerEvent('nxs:sfreeze', id)
end)
RegisterNetEvent('nxs:freeze')
AddEventHandler('nxs:freeze', function()
    FreezeEntityPosition(PlayerPedId(), true)
end)
RegisterNetEvent('nxs:sfreeze')
AddEventHandler('nxs:sfreeze', function()
    FreezeEntityPosition(PlayerPedId(), false)
end)
local invisible = false
RegisterNUICallback('invisibilita', function()
    invisible = not invisible
    SetNuiFocus(false, false)
    if not invisible then
        ESX.ShowNotification(Config.Lang[Config.Language]['invisibilita_b'])
        SetEntityVisible(PlayerPedId(), true, 0)
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_invisible"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['invisibilita_a'])
        SetEntityVisible(PlayerPedId(), false, 0)
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_invisible"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    end
    TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["invisibilita"], fields, "invisibilita")
end)
local godmode = false
RegisterNUICallback('godmode', function()
    godmode = not godmode
    if godmode then 
        ESX.ShowNotification(Config.Lang[Config.Language]['godmode_a'])
         fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_godmode"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['godmode_b'])
         fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_godmode"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    end
    TriggerServerEvent('nxs:webhook', "Godmode", fields, "godmode")
    SetNuiFocus(false, false)
end)
RegisterNUICallback('reviveall', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('nxs:reviveall')
end)
Citizen.CreateThread(function()
    local wasGodmode = false
    while true do
      if godmode then
          Wait(0)
          SetEntityInvincible(PlayerPedId(), true)
          wasGodmode = true
      else
          if wasGodmode then
              SetEntityInvincible(PlayerPedId(), false)
              wasGodmode = false
          end
          Wait(1000)
      end
     end
  end)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if SonoStaff() then
        TriggerServerEvent('nxs:addvariable', 'freeze', IsEntityPositionFrozen(PlayerPedId()))
        if menuOpen then
            ESX.TriggerServerCallback('nxs:getOrario', function(orario)
                postMessage({
                    type = "SET_ORARIO",
                    orario = orario
                })
            end)
        end
    end
   end
end)
DrawText3D = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
RegisterNUICallback('nomiplayer', function()
    nomiTesta = not nomiTesta
    if nomiTesta then 
        ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_a"])
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_nomitesta"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_b"])
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_nomitesta"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    end
    TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]["nomitesta"], fields, "nomiplayer")
end)
Citizen.CreateThread(function()
  while true do
    if nomiTesta then 
        Wait(0)
        for k,v in pairs(GetActivePlayers()) do 
            if NetworkIsPlayerActive(v) then
                local ped = GetPlayerPed(v)
                local coords = GetEntityCoords(ped)
                if IsPedInAnyVehicle(ped, false) then
                    DrawText3D(coords.x, coords.y, coords.z + 1.5, GetPlayerName(v).." | Vita: "..GetEntityHealth(ped).." | ID: "..GetPlayerServerId(v))
                else
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, GetPlayerName(v).." | Vita: "..GetEntityHealth(ped).." | ID: "..GetPlayerServerId(v))
                end
            end
         end
    else
        Wait(1000)
    end
   end
end)
RegisterNUICallback('copycoords', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local coordsString = string.format("vector3(%.4f, %.4f, %.4f)", coords.x, coords.y, coords.z)
    SendNUIMessage({
        type = "copyToClipboard",
        text = coordsString
    })
    ESX.ShowNotification(Config.Lang[Config.Language]['copycoords'])
    local fields = {
        {
            name = Config.Lang[Config.Language]['nome_staff'],
            value = GetPlayerName(PlayerId()),
            inline = true
        },
        {
            name = "Coordinate",
            value = coordsString,
            inline = false
        }
    }
    TriggerServerEvent('nxs:webhook', "Copia Coordinate", fields, "copycoords")
    cb('ok')
end)
RegisterNUICallback('tpstaff', function(data, cb)
    local ped = PlayerPedId()
    SetEntityCoords(ped, Config.StaffAreaCoords.x, Config.StaffAreaCoords.y, Config.StaffAreaCoords.z, false, false, false, true)
    SetEntityHeading(ped, Config.StaffAreaCoords.w)
    ESX.ShowNotification(Config.Lang[Config.Language]['tpstaff'])
    local fields = {
        {
            name = Config.Lang[Config.Language]['nome_staff'],
            value = GetPlayerName(PlayerId()),
            inline = true
        },
        {
            name = "Destinazione",
            value = "Area Staff",
            inline = true
        }
    }
    TriggerServerEvent('nxs:webhook', "TP Area Staff", fields, "tpstaff")
    cb('ok')
end)
local superSpeed = false
local normalSpeed = 1.0
local superSpeedMultiplier = 2.5
RegisterNUICallback('superspeed', function(data, cb)
    superSpeed = not superSpeed
    if superSpeed then
        ESX.ShowNotification(Config.Lang[Config.Language]['superspeed_a'])
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['superspeed_b'])
    end
    local fields = {
        {
            name = Config.Lang[Config.Language]['nome_staff'],
            value = GetPlayerName(PlayerId()),
            inline = true
        },
        {
            name = "Stato Super Velocità",
            value = superSpeed and Config.Lang[Config.Language]['attivo'] or Config.Lang[Config.Language]['inattivo'],
            inline = true
        }
    }
    TriggerServerEvent('nxs:webhook', "Super Velocità", fields, "superspeed")
    cb('ok')
end)
Citizen.CreateThread(function()
    while true do
        if superSpeed then
            Wait(0)
            local ped = PlayerPedId()
            SetPedMoveRateOverride(ped, superSpeedMultiplier)
            SetRunSprintMultiplierForPlayer(PlayerId(), superSpeedMultiplier)
            SetSwimMultiplierForPlayer(PlayerId(), superSpeedMultiplier)
        else
            Wait(500)
        end
    end
end)
local superJump = false
RegisterNUICallback('superjump', function(data, cb)
    superJump = not superJump
    if superJump then
        ESX.ShowNotification(Config.Lang[Config.Language]['superjump_a'])
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['superjump_b'])
    end
    local fields = {
        {
            name = Config.Lang[Config.Language]['nome_staff'],
            value = GetPlayerName(PlayerId()),
            inline = true
        },
        {
            name = "Stato Super Salto",
            value = superJump and Config.Lang[Config.Language]['attivo'] or Config.Lang[Config.Language]['inattivo'],
            inline = true
        }
    }
    TriggerServerEvent('nxs:webhook', "Super Salto", fields, "superjump")
    cb('ok')
end)
Citizen.CreateThread(function()
    while true do
        if superJump then
            Wait(0)
            SetSuperJumpThisFrame(PlayerId())
        else
            Wait(500)
        end
    end
end)
local superStrength = false
RegisterNUICallback('superstrength', function(data, cb)
    superStrength = not superStrength
    if superStrength then
        ESX.ShowNotification(Config.Lang[Config.Language]['superstrength_a'])
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['superstrength_b'])
    end
    local fields = {
        {
            name = Config.Lang[Config.Language]['nome_staff'],
            value = GetPlayerName(PlayerId()),
            inline = true
        },
        {
            name = "Stato Super Forza",
            value = superStrength and Config.Lang[Config.Language]['attivo'] or Config.Lang[Config.Language]['inattivo'],
            inline = true
        }
    }
    TriggerServerEvent('nxs:webhook', "Super Forza", fields, "superstrength")
    cb('ok')
end)
Citizen.CreateThread(function()
    local wasStrength = false
    while true do
        if superStrength then
            Wait(0)
            wasStrength = true
            local ped = PlayerPedId()
            SetPlayerMeleeWeaponDamageModifier(PlayerId(), 10.0)
            SetPlayerWeaponDamageModifier(PlayerId(), 2.0)
            if IsPedInMeleeCombat(ped) then
                local coords = GetEntityCoords(ped)
                local forwardVector = GetEntityForwardVector(ped)
                local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                if DoesEntityExist(vehicle) and vehicle ~= 0 then
                    local vehCoords = GetEntityCoords(vehicle)
                    local distance = #(coords - vehCoords)
                    if distance < 3.0 then
                        local forceMultiplier = 800.0
                        ApplyForceToEntity(
                            vehicle, 
                            1,
                            forwardVector.x * forceMultiplier, 
                            forwardVector.y * forceMultiplier, 
                            0.0,
                            0.0, 0.0, 0.0, 
                            0,
                            false,
                            true,
                            true,
                            false,
                            true
                        )
                        Wait(500)
                    end
                end
            end
        else
            if wasStrength then
                SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)
                SetPlayerWeaponDamageModifier(PlayerId(), 1.0)
                wasStrength = false
            end
            Wait(500)
        end
    end
end)
RegisterNUICallback('refreshresources', function(data, cb)
    TriggerServerEvent('nxs:getresources')
    cb('ok')
end)
RegisterNUICallback('startresource', function(data, cb)
    TriggerServerEvent('nxs:startresource', data.resource)
    cb('ok')
end)
RegisterNUICallback('restartresource', function(data, cb)
    TriggerServerEvent('nxs:restartresource', data.resource)
    cb('ok')
end)
RegisterNUICallback('stopresource', function(data, cb)
    TriggerServerEvent('nxs:stopresource', data.resource)
    cb('ok')
end)
RegisterNUICallback('executecommand', function(data, cb)
    TriggerServerEvent('nxs:executecommand', data.command)
    cb('ok')
end)
RegisterNetEvent('nxs:consoleLog')
AddEventHandler('nxs:consoleLog', function(name, command)
    SendNUIMessage({
        type = "ADD_CONSOLE_LOG",
        name = name,
        command = command
    })
end)
RegisterNUICallback('spawnvehicle', function(data, cb)
    local model = data.model
    if not model or model == '' then cb('ok') return end
    SetNuiFocus(false, false)
    cb('ok')
    Citizen.SetTimeout(100, function()
        local modelHash = GetHashKey(model)
        if not IsModelInCdimage(modelHash) or not IsModelValid(modelHash) then
            ESX.ShowNotification(Config.Lang[Config.Language]['error_invalid_model'])
            return
        end
        RequestModel(modelHash)
        local timeout = 0
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(100)
            timeout = timeout + 100
            if timeout > 10000 then
                ESX.ShowNotification(Config.Lang[Config.Language]['error_invalid_model'])
                return
            end
        end
        local ped    = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local fwd    = GetEntityForwardVector(ped)
        local heading = GetEntityHeading(ped)
        local veh = CreateVehicle(modelHash,
            coords.x + fwd.x * 5.0,
            coords.y + fwd.y * 5.0,
            coords.z,
            heading, true, false)
        SetVehicleOnGroundProperly(veh)
        SetEntityAsMissionEntity(veh, true, true)
        SetModelAsNoLongerNeeded(modelHash)
        ESX.ShowNotification(Config.Lang[Config.Language]['success_startresource'] and 
            ('Veicolo ' .. model .. ' spawnato!') or ('Veicolo ' .. model .. ' spawnato!'))
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
            { name = 'Modello', value = model, inline = true },
        }
        TriggerServerEvent('nxs:webhook', 'Spawna Veicolo', fields, 'spawnvehicle')
    end)
end)
RegisterNUICallback('deletevehicle', function(data, cb)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then
        local coords = GetEntityCoords(ped)
        veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    if veh and veh ~= 0 and DoesEntityExist(veh) then
        local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
        ESX.Game.DeleteVehicle(veh)
        ESX.ShowNotification(Config.Lang[Config.Language]['deletevehicle'] or 'Veicolo eliminato')
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
            { name = 'Veicolo', value = modelName, inline = true },
        }
        TriggerServerEvent('nxs:webhook', 'Elimina Veicolo', fields, 'deletevehicle')
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['error_no_vehicle_nearby'])
    end
    cb('ok')
end)
RegisterNUICallback('fixvehicle', function(data, cb)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        local fields = {
            { name = Config.Lang[Config.Language]['nome_staff'], value = GetPlayerName(PlayerId()), inline = true },
            { name = Config.Lang[Config.Language]['veicolo'], value = GetDisplayNameFromVehicleModel(GetEntityModel(veh)), inline = true },
        }
        TriggerServerEvent('nxs:webhook', Config.Lang[Config.Language]['ripara_veicolo'] or 'Ripara Veicolo', fields, 'repairvehicle')
        ESX.ShowNotification(Config.Lang[Config.Language]['repair_vehicle2'] or 'Veicolo riparato')
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['error_not_in_vehicle'])
    end
    cb('ok')
end)
RegisterNUICallback('removeitem', function(data, cb)
    local id   = data.id
    local item  = data.item
    local count = tonumber(data.count) or 1
    TriggerServerEvent('nxs:removeitem', id, item, count)
    cb('ok')
end)
RegisterNUICallback('viewinventory', function(data, cb)
    local id = data.id
    TriggerServerEvent('nxs:viewinventory', id)
    cb('ok')
end)
RegisterNetEvent('nxs:sendInventory')
AddEventHandler('nxs:sendInventory', function(inventory, playerName)
    SendNUIMessage({
        type = 'SHOW_INVENTORY',
        inventory = inventory,
        playerName = playerName
    })
end)
RegisterNUICallback('setServerTime', function(data, cb)
    local time = tonumber(data.time)
    if time == nil then
        time = 12
    end
    NetworkOverrideClockTime(time, 0, 0)
    TriggerServerEvent('nxs:setServerTime', time)
    if cb then cb('ok') end
end)
RegisterNUICallback('freezeTime', function(data, cb)
    local freeze = data.freeze or false
    TriggerServerEvent('nxs:freezeTime', freeze)
    if freeze then
        ESX.ShowNotification(Config.Lang[Config.Language]['success_settime'] or "Tempo bloccato")
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['success_settime'] or "Tempo sbloccato")
    end
    if cb then cb('ok') end
end)
RegisterNUICallback('setWeather', function(data, cb)
    local weather = data.weather or 'CLEAR'
    local transition = data.transition or true
    if transition then
        SetWeatherTypeOvertimePersist(weather, 15.0)
    else
        SetWeatherTypeNowPersist(weather)
    end
    TriggerServerEvent('nxs:setWeather', weather, transition)
    if cb then cb('ok') end
end)
RegisterNUICallback('setWeatherIntensity', function(data, cb)
    local intensity = tonumber(data.intensity) or 0.5
    local weather = data.weather or 'CLEAR'
    SetWindSpeed(intensity * 12.0)
    SetWindDirection(math.random(0, 360))
    TriggerServerEvent('nxs:setWeatherIntensity', intensity, weather)
    if cb then cb('ok') end
end)
RegisterNetEvent('nxs:updateWeather')
AddEventHandler('nxs:updateWeather', function(weather, transition)
    if transition then
        SetWeatherTypeOvertimePersist(weather, 15.0)
    else
        SetWeatherTypeNowPersist(weather)
    end
    SendNUIMessage({
        type = "UPDATE_WEATHER",
        weather = weather
    })
end)
RegisterNetEvent('nxs:updateServerTime')
AddEventHandler('nxs:updateServerTime', function(hour)
    NetworkOverrideClockTime(hour, 0, 0)
    SendNUIMessage({
        type = "UPDATE_SERVER_TIME",
        hours = hour
    })
end)
RegisterNetEvent('nxs:updateTimeFreeze')
AddEventHandler('nxs:updateTimeFreeze', function(frozen)
    SendNUIMessage({
        type = "UPDATE_SERVER_TIME",
        hours = GetClockHours(),
        frozen = frozen
    })
end)
RegisterNetEvent('nxs:updateWeatherIntensity')
AddEventHandler('nxs:updateWeatherIntensity', function(intensity, weather)
    SetWindSpeed(intensity * 12.0)
    SetWindDirection(math.random(0, 360))
    SendNUIMessage({
        type = "UPDATE_WEATHER_INTENSITY",
        intensity = intensity
    })
end)
RegisterNUICallback("getAllUsers", function(data, cb)
    TriggerServerEvent("nxs:getAllUsers")
    cb("ok")
end)
RegisterNUICallback("changeUserGroup", function(data, cb)
    TriggerServerEvent("nxs:changeUserGroup", data)
    cb("ok")
end)
RegisterNetEvent("nxs:setAllUsers")
AddEventHandler("nxs:setAllUsers", function(users)
    SendNUIMessage({
        type = "SET_ALL_USERS",
        users = users
    })
end)

RegisterNetEvent('nxs:openAppearance')
AddEventHandler('nxs:openAppearance', function()
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent('fivem-appearance:save', appearance)
        end
    end)
end)

RegisterNetEvent('nxs:healPlayer')
AddEventHandler('nxs:healPlayer', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 100)  
    ClearPedBloodDamage(ped)
    ClearPedWetness(ped)
end)