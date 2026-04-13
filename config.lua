Config = {}
Config.NomeServer = "Nexus Development"
Config.LogoServer = "https://i.postimg.cc/fRHq8t2x/Png.png"
Config.DiscordServer = "https://discord.gg/nxsdev"
Config.Language = "it"
Config.StaffAreaCoords = vector4(791.5623, 1277.6875, 360.2972, 340.5060)

Config.GroupUser = 'user'

Config.CommandName = 'adminneby'

Config.Trigger = {
    skin = 'nxs:openAppearance',
    revive = "esx_ambulancejob:revive",
    heal = "ambulancejob:healPlayer",
}

Config.Keybinds = {
    adminmenu = {
        enable = true,
        key = 'M'
    },
    noclip = {
        enable = true,
        key = 'HOME'
    },
    nomitesta = {
        enable = true,
        key = 'F9'
    },
}

Config.AdminGroup = {
    ['helper'] = {
        rank = 1,
        label = "Helper",
        id = "helper",
    },
    ['mod'] = {
        rank = 2,
        label = "Moderatore",
        id = "mod",
    },
    ['admin'] = {
        rank = 3,
        label = "Admin",
        id = "admin",
    },
    ['superadmin'] = {
        rank = 4,
        label = "Super Admin",
        id = "superadmin",
    },
    ['owner'] = {
        rank = 5,
        label = "Owner",
        id = "owner",
    }
}
Config.ClearAreaRadius = {
    {
        label = "100",
        value = 100
    },
    {
        label = "250",
        value = 250
    },
    {
        label = "500",
        value = 500
    }
}
Config.WipeSettings = { 
    ['identifier'] = {
        'users'
    }
}
Config.BanTime = {
    {
        label = "12 Ore",
        value = 43200
    },
    {
        label = "1 Giorno",
        value = 86400
    },
    {
        label = "2 Giorni",
        value = 172800
    },
    {
        label = "3 Giorni",
        value = 259200
    },
    {
        label = "1 Settimana",
        value = 604800
    },
    {
        label = "2 Settimane",
        value = 1209600
    },
    {
        label = "Permanente",
        value = 999999999 
    }
}
Config.Azioni = {
    {
        label = 'Ban',
        id = 'ban',
        icon = 'ban',
        rank = 1 
    },
    {
        label = 'Kick',
        id = 'kick',
        icon = 'kick',
        rank = 1
    },
    {
        label = 'Warn',
        id = 'warn',
        icon = 'warn',
        rank = 1
    },
    {
        label = 'Skin Menu',
        id = 'skinmenu',
        icon = 'skinmenu',
        rank = 1
    },
    {
        label = 'Spectate',
        id = 'spectate',
        icon = 'spectate',
        rank = 1
    },
    {
        label = 'Revive',
        id = 'revive',
        icon = 'revive',
        rank = 1
    },
    {
        label = 'Heal',
        id = 'heal',
        icon = 'heal',
        rank = 1
    },
    {
        label = 'Kill',
        id = 'kill',
        icon = 'kill',
        rank = 1
    },
    {
        label = 'Wipe',
        id = 'wipe',
        icon = 'wipe',
        rank = 1
    },
    {
        label = 'Go To',
        id = 'goto',
        icon = 'goto',
        rank = 1
    },
    {
        label = 'Bring',
        id = 'bring',
        icon = 'bring',
        rank = 1
    },
    {
        label = 'Give Item',
        id = 'giveitem',
        icon = 'giveitem',
        rank = 1
    },
    {
        label = 'Give Money',
        id = 'givemoney',
        icon = 'givemoney',
        rank = 1
    },
    {
        label = 'Set Job',
        id = 'setjob',
        icon = 'setjob',
        rank = 1
    },
    {
        label = 'Clear Inv.',
        id = 'clearinventory',
        icon = 'clearinventory',
        rank = 1
    },
    {
        label = 'Give Admin',
        id = 'giveadmin',
        icon = 'giveadmin',
        rank = 1
    },
    {
        label = 'Clear Ped',
        id = 'clearped',
        icon = 'clearped',
        rank = 1
    },
    {
        label = 'DM',
        id = 'sendmessage',
        icon = 'sendmessage',
        rank = 1
    },
    {
        label = 'Freeze',
        id = 'freeze',
        icon = 'freeze',
        rank = 1
    },
    {
        label = 'Rimuovi Oggetto',
        id = 'removeitem',
        icon = 'removeitem',
        rank = 1
    },
    {
        label = 'Vedi Inventario',
        id = 'viewinventory',
        icon = 'viewinventory',
        rank = 1
    }
}
Config.AzioniPersonale = {
    {
        label = 'Revive',
        id = 'revive',
        icon = 'revive',
        rank = 1
    },
    {
        label = "Revive All",
        id = "reviveall",
        image = "reviveall.png",
        rank = 1
    },
    {
        label = 'Heal',
        id = 'heal',
        icon = 'heal',
        rank = 1
    },
    {
        label = 'NoClip',
        id = 'noclip',
        icon = 'noclip',
        rank = 1
    },
    {
        label = "Invisibilità",
        id = 'invisibilita',
        icon = 'invisibilita',
        rank = 1
    },
    {
        label = "God Mode",
        id = 'godmode',
        icon = 'godmode',
        rank = 1
    },
    {
        label = "Nomi Player",
        id = 'nomiplayer',
        icon = 'nomiplayer',
        rank = 1
    },
    {
        label = "Annuncio",
        id = "annuncio",
        icon = 'nomiplayer',
        rank = 1
    },
    {
        label = 'Give Item',
        id = 'giveitem',
        icon = 'giveitem',
        rank = 1
    },
    {
        label = "Dai Soldi a Tutti",
        id = "givemoneyall",
        image = "givemoney.png",
        rank = 1
    },
    {
        label = "Clear Area",
        id = "cleararea",
        image = "cleararea.png",
        rank = 1
    },
    {
        label = "Clear Inv.",
        id = "clearinventory",
        image = "clearinventory.png",
        rank = 1
    },
    {
        label = "Clear Ped",
        id = "clearped",
        image = "clearped.png",
        rank = 1
    },
    {
        label = "Skin Menu",
        id = "skinmenu",
        image = "skinmenu.png",
        rank = 1
    },
    {
        label = "Copia Coordinate",
        id = "copycoords",
        image = "goto.png",
        rank = 1
    },
    {
        label = "TP Area Staff",
        id = "tpstaff",
        image = "goto.png",
        rank = 1
    },
    {
        label = "Super Velocità",
        id = "superspeed",
        image = "invincible.png",
        rank = 1
    },
    {
        label = "Super Salto",
        id = "superjump",
        image = "invincible.png",
        rank = 1
    },
    {
        label = "Super Forza",
        id = "superstrength",
        image = "invincible.png",
        rank = 1
    },
    {
        label = "Spawna Veicolo",
        id = "spawnvehicle",
        image = "repairveh.png",
        rank = 1
    },
    {
        label = "Elimina Veicolo",
        id = "deletevehicle",
        image = "repairveh.png",
        rank = 1
    },
    {
        label = "Ripara Veicolo",
        id = "fixvehicle",
        image = "repairveh.png",
        rank = 1
    }
}
Config.Lang = {
    ['it'] = {
        ['dashboard'] = "Dashboard",
        ['lista_player'] = "Lista Player",
        ['menu_personale'] = "Menu Personale",
        ['lista_ban'] = "Lista Ban",
        ['esci'] = "Esci",
        ['benvenuto'] = "Benvenuto,",
        ['search_name'] = "Cerca dal Nome",
        ['search_id'] = "Cerca dall'ID",
        ['lista_kick'] = "Lista Kick",
        ['lista_warn'] = "Lista Warn",
        ['nome_staff'] = "Nome Staff",
        ['nome_player'] = "Nome Utente",
        ['motivo'] = "Motivo",
        ['data'] = "Data",
        ['azioni'] = "Azioni",
        ['scadenza'] = "Scadenza",
        ['tipo'] = "Tipo",
        ['permanente'] = "PERMANENTE",
        ['temporaneo'] = "Temporaneo",
        ['revocato'] = "Revocato",
        ['scaduto'] = "Scaduto",
        ['stato'] = "Stato",
        ['id_ban'] = "ID Ban",
        ['seleziona_opzione'] = "Seleziona un Opzione",
        ['confirm'] = "Conferma",
        ['cancel'] = "Cancella",
        ['utente'] = "Utente",
        ['revoca'] = "Elimina",
        ['no_azione'] = "Nessuna azione",
        ['confirm_revoca'] = "Sei sicuro di voler ELIMINARE COMPLETAMENTE questo ban?\nQuesta azione non può essere annullata.",
        ['discord'] = "Discord ID: ",
        ['steam'] = "Steam ID: ",
        ['license'] = "License ID: ",
        ['elimina'] = "Elimina",
        ['ban_totali'] = "Ban Totali",
        ['kick_totali'] = "Kick Totali",
        ['staff_online'] = "Admin Online",
        ['player_online'] = "Player Online",
        ['unfreeze'] = "Unfreeze",
        ['job_grade'] = "Grado Lavoro",
        ['ban'] = "BAN",
        ['kick'] = "KICK",
        ['warn'] = "WARN",
        ['giveitem'] = "GIVE ITEM",
        ['givemoney'] = "GIVE MONEY",
        ['setjob'] = "SET JOB",
        ['sendmessage'] = "MANDA MESSAGGIO IN DM",
        ['giveadmin'] = "DAI PERMESSI",
        ['setped'] = "SET PED",
        ['item_name'] = "Nome Item",
        ['item_count'] = "Quantità Item",
        ['cash'] = "Contanti",
        ['bank'] = "Banca",
        ['black_money'] = "Soldi Sporchi",
        ['count'] = "Quantità",
        ['text'] = "Messaggio",
        ['ped_name'] = "Nome Ped",
        ['annuncio'] = "ANNUNCIO",
        ['dmmessage'] = "MESSAGGIO PRIVATO",
        ['give_money_all'] = "DAI SOLDI A TUTTI",
        ['stato_nomitesta'] = "Stato Nomi Testa",
        ['stato_noclip'] = "Stato NoClip",
        ['stato_invisible'] = "Stato Invisibilità",
        ['stato_godmode'] = "Stato Godmode",
        ['godmode'] = "Godmode",
        ['noclip'] = "NoClip",
        ['invisibilita'] = "Invisibilità",
        ['nomitesta'] = "Nomi Testa",
        ['attivo'] = "Attivo",
        ['inattivo'] = "Inattivo",
        ['esci_spectate'] = "Premi ~INPUT_PICKUP~ per uscire dalla modalità spettatore",
        ['inizio_spectate'] = "Inizio Spectate",
        ['fine_spectate'] = "Fine Spectate",
        ['veicolo'] = "Veicolo",
        ['ripara_veicolo'] = "Ripara Veicolo",
        ['clear_area'] = "Clear Area",
        ['exit_noclip'] = "Premi ~INPUT_23B4087C~ per uscire dal noclip",
        ['noclip_attivato'] = "NoClip Attivato",
        ['noclip_disattivato'] = "NoClip Disattivato",
        ['revive'] = "Hai rianimato con successo!",
        ['heal'] = "Hai curato con successo!",
        ['clear_ped'] = "Il tuo ped è stato pulito con successo",
        ['clear_ped2'] = "Hai pulito il ped con successo",
        ['clear_area2'] = "Hai pulito la zona con successo",
        ['repair_vehicle2'] = "Hai riparato il veicolo con successo",
        ['delete_warn'] = "Hai eliminato il warn",
        ['nomitesta_a'] = "Hai attivato i nomi sulla testa",
        ['nomitesta_b'] = "Hai disattivato i nomi sulla testa",     
        ['revoca_ban'] = "Hai revocato il ban",
        ['revoca_ban_success'] = "Ban eliminato con successo",
        ['kill'] = "Hai ucciso il player",
        ['wipe'] = "Hai wipato il player",
        ['clear_inv2'] = "Hai pulito l'inventario del player",
        ['invisibilita_a'] = "Hai attivato l'invisibilità",
        ['invisibilita_b'] = "Hai disattivato l'invisibilità",
        ['godmode_a'] = "Hai attivato la godmode",
        ['godmode_b'] = "Hai disattivato la godmode",
        ['revive_all'] = "Hai curato tutti",
        ['copycoords'] = "Coordinate copiate negli appunti!",
        ['tpstaff'] = "Teletrasportato nell'area staff",
        ['superspeed_a'] = "Super velocità attivata",
        ['superspeed_b'] = "Super velocità disattivata",
        ['superjump_a'] = "Super salto attivato",
        ['superjump_b'] = "Super salto disattivato",
        ['superstrength_a'] = "Super forza attivata",
        ['superstrength_b'] = "Super forza disattivata",
        ['risorse'] = "Risorse",
        ['success_warn']            = "Warn inviato con successo",
        ['success_kick']            = "Kick eseguito con successo",
        ['success_ban']             = "Ban eseguito con successo",
        ['success_giveitem']        = "Oggetto consegnato con successo",
        ['success_givemoney']       = "Soldi consegnati con successo",
        ['success_setjob']          = "Lavoro impostato con successo",
        ['success_giveadmin']       = "Permessi assegnati con successo",
        ['success_setped']          = "Ped impostato con successo",
        ['success_dm']              = "Messaggio privato inviato con successo",
        ['success_annuncio']        = "Annuncio inviato con successo",
        ['success_givemoneyall']    = "Soldi dati a tutti con successo",
        ['success_goto']            = "Teletrasportato dal player",
        ['success_bring']           = "Player portato da te",
        ['success_freeze']          = "Player freezato con successo",
        ['success_sfreeze']         = "Player sfrezzato con successo",
        ['success_skinmenu']        = "Skin menu aperto con successo",
        ['success_startresource']   = "Risorsa avviata con successo",
        ['success_stopresource']    = "Risorsa fermata con successo",
        ['success_restartresource'] = "Risorsa riavviata con successo",
        ['success_executecommand']  = "Comando eseguito con successo",
        ['success_settime']         = "Ora impostata con successo",
        ['success_setweather']      = "Meteo impostato con successo",
        ['success_viewinventory']   = "Inventario visualizzato",
        ['success_clearped_staff']  = "Ped del player pulito con successo",
        ['success_removeitem']      = "Oggetto rimosso con successo",
        ['success_heal_staff']      = "Player curato con successo",
        ['success_revive_staff']    = "Player rianimato con successo",
        ['success_kill_staff']      = "Player eliminato con successo",
        ['success_wipe_staff']      = "Player wipato con successo",
        ['success_clearinv_staff']  = "Inventario del player svuotato con successo",
        ['success_reviveall']       = "Tutti i player rianimati con successo",
        ['error_player_not_found']          = "Errore: giocatore non trovato",
        ['error_resource_not_started']      = "Errore: la risorsa non è avviata",
        ['error_resource_already_started']  = "Errore: la risorsa è già avviata",
        ['error_no_vehicle_nearby']         = "Errore: nessun veicolo trovato nelle vicinanze",
        ['error_not_in_vehicle']            = "Errore: non sei in un veicolo",
        ['error_item_not_found']            = "Errore: oggetto non trovato o quantità insufficiente",
        ['error_invalid_model']             = "Errore: modello veicolo non valido",
        ['error_no_action']                 = "Errore: azione non riconosciuta",
        ['error_cannot_self']               = "Errore: non puoi eseguire questa azione su te stesso",
        ['error_no_permission']             = "Errore: non hai i permessi necessari",
    },
    ['en'] = {
        ['dashboard'] = "Dashboard",
        ['lista_player'] = "Player List",
        ['menu_personale'] = "Personal Menu",
        ['lista_ban'] = "Ban List",
        ['esci'] = "Exit",
        ['benvenuto'] = "Welcome,",
        ['search_name'] = "Search by Name",
        ['search_id'] = "Search by ID",
        ['lista_kick'] = "Kick List",
        ['lista_warn'] = "List Warn",
        ['nome_staff'] = "Staff Name",
        ['nome_player'] = "User",
        ['motivo'] = "reason",
        ['data'] = "Date",
        ['azioni'] = "Actions",
        ['scadenza'] = "Expire",
        ['tipo'] = "Type",
        ['permanente'] = "PERMANENT",
        ['temporaneo'] = "Temporary",
        ['revocato'] = "Revoked",
        ['scaduto'] = "Expired",
        ['stato'] = "Status",
        ['id_ban'] = "ID Ban",
        ['seleziona_opzione'] = "Select an Option",
        ['confirm'] = "Confirm",
        ['cancel'] = "Cancel",
        ['utente'] = "User",
        ['revoca'] = "Delete",
        ['no_azione'] = "No Action",
        ['confirm_revoca'] = "Are you sure you want to COMPLETELY DELETE this ban?\nThis action cannot be undone.",
        ['discord'] = "Discord ID: ",
        ['steam'] = "Steam ID: ",
        ['license'] = "License ID: ",
        ['elimina'] = "Delete",
        ['ban_totali'] = "Total Bans",
        ['kick_totali'] = "Total Kicks",
        ['staff_online'] = "Admin Online",
        ['player_online'] = "Player Online",
        ['unfreeze'] = "Unfreeze",
        ['job_grade'] = "Job Grade",
        ['ban'] = "BAN",
        ['kick'] = "KICK",
        ['warn'] = "WARN",
        ['giveitem'] = "GIVE ITEM",
        ['givemoney'] = "GIVE MONEY",
        ['setjob'] = "SET JOB",
        ['sendmessage'] = "DM MESSAGE",
        ['giveadmin'] = "GIVE PERMISSIONS",
        ['setped'] = "SET PED",
        ['item_name'] = "Item Name",
        ['item_count'] = "Item Quantity",
        ['cash'] = "Cash",
        ['bank'] = "Bank",
        ['black_money'] = "Dirty Money",
        ['count'] = "Amount",
        ['text'] = "Message",
        ['ped_name'] = "Ped Name",
        ['annuncio'] = "ANNOUNCE",
        ['dmmessage'] = "DM MESSAGE",
        ['give_money_all'] = "GIVE MONEY TO ALL",
        ['stato_nomitesta'] = "Head Names Status",
        ['stato_noclip'] = "NoClip state",
        ['stato_invisible'] = "Invisibility Status",
        ['stato_godmode'] = "Godmode state",
        ['godmode'] = "Godmode",
        ['noclip'] = "NoClip",
        ['invisibilita'] = "Invisibility",
        ['nomitesta'] = "Head Names",
        ['attivo'] = "Active",
        ['inattivo'] = "Inactive",
        ['esci_spectate'] = "Press ~INPUT_PICKUP~ to exit spectator mode",
        ['inizio_spectate'] = "Start Spectate",
        ['fine_spectate'] = "End Spectate",
        ['veicolo'] = "Vehicle",
        ['ripara_veicolo'] = "Repair Vehicle",
        ['clear_area'] = "Clear Area",
        ['exit_noclip'] = "Press ~INPUT_23B4087C~ to exit noclip",
        ['noclip_attivato'] = "NoClip Activated",
        ['noclip_disattivato'] = "NoClip Disabled",
        ['revive'] = "You have successfully revived!",
        ['heal'] = "You have successfully healed!",
        ['clear_ped'] = "Your ped has been cleared successfully",
        ['clear_ped2'] = "You have cleared the ped successfully",
        ['clear_area2'] = "You have cleared the area successfully",
        ['repair_vehicle2'] = "You have successfully repaired the vehicle",
        ['delete_warn'] = "You have deleted the warn",
        ['nomitesta_a'] = "You have activated headnames",
        ['nomitesta_b'] = "You have deactivated the names on the head",
        ['revoca_ban'] = "You have revoked the ban",
        ['revoca_ban_success'] = "Ban deleted successfully",
        ['kill'] = "You have killed the player",
        ['wipe'] = "You have wiped the player",
        ['clear_inv2'] = "You have cleared the player's inventory",
        ['invisibilita_a'] = "You have invisibility activated",
        ['invisibilita_b'] = "You have disabled invisibility",
        ['godmode_a'] = "You have activated godmode",
        ['godmode_b'] = "You have disabled godmode",
        ['revive_all'] = "You have cured all",
        ['copycoords'] = "Coordinates copied to clipboard!",
        ['tpstaff'] = "Teleported to staff area",
        ['superspeed_a'] = "Super speed activated",
        ['superspeed_b'] = "Super speed disabled",
        ['superjump_a'] = "Super jump activated",
        ['superjump_b'] = "Super jump disabled",
        ['superstrength_a'] = "Super strength activated",
        ['superstrength_b'] = "Super strength disabled",
        ['risorse'] = "Resources",
        ['success_warn']            = "Warn sent successfully",
        ['success_kick']            = "Kick executed successfully",
        ['success_ban']             = "Ban executed successfully",
        ['success_giveitem']        = "Item given successfully",
        ['success_givemoney']       = "Money given successfully",
        ['success_setjob']          = "Job set successfully",
        ['success_giveadmin']       = "Permissions assigned successfully",
        ['success_setped']          = "Ped set successfully",
        ['success_dm']              = "Private message sent successfully",
        ['success_annuncio']        = "Announcement sent successfully",
        ['success_givemoneyall']    = "Money given to all successfully",
        ['success_goto']            = "Teleported to player",
        ['success_bring']           = "Player brought to you",
        ['success_freeze']          = "Player frozen successfully",
        ['success_sfreeze']         = "Player unfrozen successfully",
        ['success_skinmenu']        = "Skin menu opened successfully",
        ['success_startresource']   = "Resource started successfully",
        ['success_stopresource']    = "Resource stopped successfully",
        ['success_restartresource'] = "Resource restarted successfully",
        ['success_executecommand']  = "Command executed successfully",
        ['success_settime']         = "Time set successfully",
        ['success_setweather']      = "Weather set successfully",
        ['success_viewinventory']   = "Inventory viewed",
        ['success_clearped_staff']  = "Player ped cleared successfully",
        ['success_removeitem']      = "Item removed successfully",
        ['success_heal_staff']      = "Player healed successfully",
        ['success_revive_staff']    = "Player revived successfully",
        ['success_kill_staff']      = "Player eliminated successfully",
        ['success_wipe_staff']      = "Player wiped successfully",
        ['success_clearinv_staff']  = "Player inventory cleared successfully",
        ['success_reviveall']       = "All players revived successfully",
        ['error_player_not_found']          = "Error: player not found",
        ['error_resource_not_started']      = "Error: resource is not started",
        ['error_resource_already_started']  = "Error: resource is already started",
        ['error_no_vehicle_nearby']         = "Error: no vehicle found nearby",
        ['error_not_in_vehicle']            = "Error: you are not in a vehicle",
        ['error_item_not_found']            = "Error: item not found or insufficient quantity",
        ['error_invalid_model']             = "Error: invalid vehicle model",
        ['error_no_action']                 = "Error: unrecognized action",
        ['error_cannot_self']               = "Error: you cannot perform this action on yourself",
        ['error_no_permission']             = "Error: you do not have the required permissions",
    }
}
SonoStaff = function(xPlayer)
    local group = xPlayer.getGroup()
    for k, v in pairs(Config.AdminGroup) do
        if group == k then
            return true
        end
    end
    return false
end
SendDMMessage = function(text)
    postMessage({
        type = "SHOW_DM_MESSAGE",
        text = text
    })
end
Announce = function(text)
    postMessage({
        type = "SHOW_ANNOUNCE",
        text = text
    })
end