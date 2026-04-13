const svgIcons = {
    dashboard:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/></svg>`,
    listaplayer:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
    menupersonale:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>`,
    listaban:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>`,
    gestionemeteo:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/></svg>`,
    risorse:        `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="8" rx="2"/><rect x="2" y="14" width="20" height="8" rx="2"/><line x1="6" y1="6" x2="6.01" y2="6"/><line x1="6" y1="18" x2="6.01" y2="18"/></svg>`,
    gestioneutenti: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="23" y2="12"/><line x1="23" y1="8" x2="19" y2="12"/></svg>`,
    esci:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>`,
    adminonline:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>`,
    playeronline:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
    totalban:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>`,
    totalkick:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>`,
    'stat-ban':     `<svg viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>`,
    'stat-warn':    `<svg viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`,
    'stat-kick':    `<svg viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>`,
    copy:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>`,
    refresh:        `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>`,
    ban:            `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>`,
    kick:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>`,
    warn:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`,
    skinmenu:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>`,
    spectate:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>`,
    spactate:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/><line x1="1" y1="1" x2="23" y2="23"/></svg>`,
    revive:         `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>`,
    heal:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/><line x1="12" y1="10" x2="12" y2="14"/><line x1="10" y1="12" x2="14" y2="12"/></svg>`,
    kill:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg>`,
    wipe:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>`,
    goto:           `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>`,
    bring:          `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><polyline points="23 11 17 11 19 9"/><polyline points="19 13 17 11"/></svg>`,
    giveitem:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-4 0v2M8 7V5a2 2 0 0 1 4 0v2"/><line x1="12" y1="12" x2="12" y2="17"/><line x1="9.5" y1="14.5" x2="14.5" y2="14.5"/></svg>`,
    givemoney:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg>`,
    setjob:         `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/><line x1="12" y1="12" x2="12" y2="16"/><line x1="10" y1="14" x2="14" y2="14"/></svg>`,
    clearinventory: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><line x1="10" y1="11" x2="14" y2="15"/><line x1="14" y1="11" x2="10" y2="15"/></svg>`,
    giveadmin:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg>`,
    clearped:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="17" y1="8" x2="23" y2="14"/><line x1="23" y1="8" x2="17" y2="14"/></svg>`,
    sendmessage:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>`,
    freeze:         `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="2" x2="12" y2="22"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M20 7l-8 5-8-5M20 17l-8-5-8 5"/></svg>`,
    sfreeze:        `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="2" x2="12" y2="22"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M20 7l-8 5-8-5M20 17l-8-5-8 5"/></svg>`,
    removeitem:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-4 0v2M8 7V5a2 2 0 0 1 4 0v2"/><line x1="9" y1="14" x2="15" y2="14"/></svg>`,
    viewinventory:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>`,
    noclip:         `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>`,
    invisibilita:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>`,
    godmode:        `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>`,
    nomiplayer:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>`,
    annuncio:       `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>`,
    reviveall:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
    givemoneyall:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>`,
    cleararea:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>`,
    copycoords:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>`,
    tpstaff:        `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3"/></svg>`,
    superspeed:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
    superjump:      `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="17 11 12 6 7 11"/><polyline points="17 17 12 12 7 17"/><line x1="12" y1="12" x2="12" y2="22"/></svg>`,
    superstrength:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8h1a4 4 0 0 1 0 8h-1"/><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>`,
    spawnvehicle:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="2"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>`,
    deletevehicle:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="2"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/><line x1="1" y1="1" x2="23" y2="23"/></svg>`,
    fixvehicle:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>`,
    repairvehicle:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/><line x1="3" y1="17" x2="9" y2="11"/></svg>`,
};

const app = new Vue({
    el: '#app',

    data: {
        nomeRisorsa: GetParentResourceName(),
        findbyname: '',
        findbyidban: '',
        questionInfo: {},
        kickTotali: 0,
        radius: [],
        viewTwoQuestionInput: false,
        viewOneQuestionInput: false,
        listaBan: [],
        labelFreeze: false,
        orario: "",
        config: [],
        viewList: false,
        listType: false,
        adminOnline: 0,
        infoStaff: [],
        azioni: [],
        jobs: [],
        adminGroups: [],
        azioniPersonale: [],
        infoDashboard: [
            { label: '', id: 'adminonline',  value: 0 },
            { label: '', id: 'playeronline', value: 3 },
            { label: '', id: 'totalban',     value: 3 },
            { label: '', id: 'totalkick',    value: 3 },
        ],
        listaPlayer: [],
        optionSelected: 'dashboard',
        playerSelected: false,
        test: false,
        resources: [],
        risorse_search: '',
        consoleLogs: [],
        consoleCommand: '',

        serverTime: 12,
        timeFreezed: false,
        currentWeather: 'CLEAR',
        weatherIntensity: 0.5,
        weatherTransition: true,
        dynamicWeather: false,
        weatherTypes: [
            { id: 'CLEAR',      name: 'Sereno',          icon: '☀️' },
            { id: 'EXTRASUNNY', name: 'Extra Soleggiato', icon: '🌞' },
            { id: 'CLOUDS',     name: 'Nuvoloso',         icon: '☁️' },
            { id: 'OVERCAST',   name: 'Coperto',          icon: '🌥️' },
            { id: 'RAIN',       name: 'Pioggia',          icon: '🌧️' },
            { id: 'CLEARING',   name: 'Schiarite',        icon: '⛅' },
            { id: 'THUNDER',    name: 'Temporale',        icon: '⛈️' },
            { id: 'SMOG',       name: 'Nebbia',           icon: '🌫️' },
            { id: 'FOGGY',      name: 'Nebbioso',         icon: '🌫️' },
            { id: 'XMAS',       name: 'Neve',             icon: '❄️' },
            { id: 'SNOWLIGHT',  name: 'Neve Leggera',     icon: '🌨️' },
            { id: 'BLIZZARD',   name: 'Tormenta',         icon: '🌨️' }
        ],

        allUsers: [],
        users_search: '',

        showInventoryModal: false,
        inventoryData: [],
        inventoryPlayerName: ''
    },

    methods: {
        postMessage(name, table) {
            $.post(`https://${this.nomeRisorsa}/${name}`, JSON.stringify(table));
        },

        updateSelectedOption(option) {
            this.optionSelected = option;

            var elements = document.getElementsByClassName("opzione");
            for (var i = 0; i < elements.length; i++) {
                elements[i].style.background = "none";
            }

            var element = document.getElementById("opzione" + option);
            if (element) element.style.backgroundColor = "#4B4B4B";

            this.viewList = false;
            this.listType = false;

            if (option === 'gestioneutenti') {
                this.refreshUsers();
            }
        },

        updateOptionSelected(option) {
            this.optionSelected = option;
        },

        getSvgIcon(id) {
            return svgIcons[id] || '';
        },
        setBgFromInfo(img) {
            return { backgroundImage: 'url("img/' + img + '")' };
        },

        setLogoServer() {
            return { backgroundImage: 'url(' + this.config.LogoServer + ')' };
        },

        setPlayerBg(player) {
            if (player.staff) {
                return {
                    background: "linear-gradient(90deg, rgba(37, 37, 37, 0.4) 0%, rgba(0, 0, 0, 0.00) 100%), rgba(216, 216, 216, 0.05)"
                };
            } else {
                return {
                    background: 'linear-gradient(90deg, rgba(236, 236, 236, 0.40) 0%, rgba(0, 0, 0, 0.00) 100%), rgba(216, 216, 216, 0.05)'
                };
            }
        },

        filterByName() {
            if (this.findbyname !== '') {
                return this.listaPlayer.filter(player => {
                    return (
                        player.name.toLowerCase().includes(this.findbyname.toLowerCase()) ||
                        player.id.toString().includes(this.findbyname.toLowerCase()) ||
                        player.job.name.toLowerCase().includes(this.findbyname.toLowerCase()) ||
                        player.job.label.toLowerCase().includes(this.findbyname.toLowerCase())
                    );
                });
            }
            return this.listaPlayer;
        },

        filterByIdBan() {
            if (this.findbyidban !== '') {
                return this.listaBan.filter(ban => {
                    return (
                        (ban.idBan && ban.idBan.toString().includes(this.findbyidban)) ||
                        (ban.name && ban.name.toLowerCase().includes(this.findbyidban.toLowerCase())) ||
                        (ban.staff && ban.staff.name && ban.staff.name.toLowerCase().includes(this.findbyidban.toLowerCase()))
                    );
                });
            }
            return this.listaBan;
        },

        infoUser(id) {
            this.viewList = false;
            this.updateOptionSelected('infopersona');

            for (const [k, v] of Object.entries(this.listaPlayer)) {
                if (v.id == id) {
                    this.playerSelected = v;
                    break;
                }
            }

            for (const [k, v] of Object.entries(this.azioni)) {
                if (v.id === 'freeze' && this.playerSelected.freezed) {
                    v.label = this.config.lang.unfreeze;
                    v.id = 'sfreeze';
                } else if (v.id === 'sfreeze' && !this.playerSelected.freezed) {
                    v.label = this.labelFreeze;
                    v.id = 'freeze';
                }
            }
        },

        revocaBan(idban) {
            this.postMessage('revocaban', { id: idban });
        },

        setImageLogo(bool) {
            const link = bool ? this.infoStaff.avatar : this.playerSelected.avatar;

            if (!link || link === "" || link === "N/A" || link === null) {
                return {
                    backgroundImage: 'url("./img/default_avatar.png")',
                    backgroundSize: 'cover',
                    backgroundPosition: 'center',
                };
            }

            return {
                backgroundImage: 'url("' + link + '")',
                backgroundSize: 'cover',
                backgroundPosition: 'center',
            };
        },

        copy(type, bool) {
            let string = '';
            if (type === 'discord') {
                string = bool ? this.infoStaff.license.discord : this.playerSelected.license.discord;
            } else if (type === 'steam') {
                string = bool ? this.infoStaff.license.steam : this.playerSelected.license.steam;
            } else if (type === 'license') {
                string = bool ? this.infoStaff.license.license : this.playerSelected.license.license;
            }

            const $temp = $("<input>");
            $("body").append($temp);
            $temp.val(string).select();
            document.execCommand("copy");
            $temp.remove();
        },

        viewDoubleInput(bool) {
            this.viewTwoQuestionInput = bool;
        },

        viewOneInput(bool) {
            this.viewOneQuestionInput = bool;
        },

        setQuestionInformation() {
            return {
                background: `linear-gradient(to right, ${this.questionInfo.color} 0%, #131313 100%)`
            };
        },

        closeQuestion() {
            if (this.viewTwoQuestionInput) this.viewTwoQuestionInput = false;
            if (this.viewOneQuestionInput) this.viewOneQuestionInput = false;
        },

        azione(id) {
            if (!this.playerSelected || !this.playerSelected.id) {
                this.playerSelected = { id: this.infoStaff.id };
            }

            const actions = {
                ban: {
                    title: this.config.lang.ban,
                    color: '#242424',
                    action: 'ban',
                    input1: { type: 'select', options: this.config.BanTime },
                    input2: { placeholder: this.config.lang.motivo, type: 'text' },
                    double: true
                },
                kick: {
                    title: this.config.lang.kick,
                    color: '#242424',
                    action: 'kick',
                    input1: { placeholder: this.config.lang.motivo, type: 'text' }
                },
                warn: {
                    title: this.config.lang.warn,
                    color: '#242424',
                    action: 'warn',
                    input1: { placeholder: this.config.lang.motivo, type: 'text' }
                },
                giveitem: {
                    title: this.config.lang.giveitem,
                    color: '#242424',
                    action: 'giveitem',
                    input1: { placeholder: this.config.lang.item_name, type: 'text' },
                    input2: { placeholder: this.config.lang.item_count, type: 'number' },
                    double: true
                },
                givemoney: {
                    title: this.config.lang.givemoney,
                    color: '#1d1d1d',
                    action: 'givemoney',
                    input1: {
                        type: 'select',
                        options: [
                            { label: this.config.lang.cash, value: 'money' },
                            { label: this.config.lang.bank, value: 'bank' },
                            { label: this.config.lang.black_money, value: 'black_money' }
                        ]
                    },
                    input2: { placeholder: this.config.lang.count, type: 'number' },
                    double: true
                },
                setjob: {
                    title: this.config.lang.setjob,
                    color: '#1f1f1f',
                    action: 'setjob',
                    input1: { options: this.jobs, type: 'select' },
                    input2: { placeholder: this.config.lang.job_grade, type: 'number' },
                    double: true
                },
                sendmessage: {
                    title: this.config.lang.sendmessage,
                    color: '#242424',
                    action: 'dm',
                    input1: { placeholder: this.config.lang.text, type: 'text' }
                },
                skinmenu: () => {
                    this.postMessage('skinmenu', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                revive: () => {
                    this.postMessage('revive', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                heal: () => {
                    this.postMessage('heal', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                kill: () => {
                    this.postMessage('kill', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                goto: () => {
                    this.postMessage('goto', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                bring: () => {
                    this.postMessage('bring', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                clearinventory: () => {
                    this.postMessage('clearinv', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                wipe: () => {
                    this.postMessage('wipe', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                giveadmin: {
                    title: this.config.lang.giveadmin,
                    color: '#242424',
                    action: 'giveadmin',
                    input1: { options: this.adminGroups, type: 'select' }
                },
                spectate: () => {
                    if (this.playerSelected.id === this.infoStaff.id) return;
                    this.closeMenu();
                    this.postMessage('spectate', { id: this.playerSelected.id });
                },
                spactate: () => {
                    if (this.playerSelected.id === this.infoStaff.id) return;
                    this.closeMenu();
                    this.postMessage('spactate', { id: this.playerSelected.id });
                },
                setped: {
                    title: this.config.lang.setped,
                    color: '#242424',
                    action: 'setped',
                    input1: { placeholder: this.config.lang.ped_name, type: 'text' }
                },
                freeze: () => {
                    this.postMessage('freeze', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                sfreeze: () => {
                    this.postMessage('sfreeze', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                removeitem: {
                    title: 'Rimuovi Oggetto',
                    color: '#242424',
                    action: 'removeitem',
                    input1: { placeholder: 'Nome oggetto (es. bread)', type: 'text' },
                    input2: { placeholder: 'Quantità', type: 'number' },
                    double: true
                },
                viewinventory: () => {
                    this.postMessage('viewinventory', { id: this.playerSelected.id });
                },
                noclip: () => {
                    this.playerSelected = false;
                    this.closeMenu(2);
                    this.postMessage('noclip');
                },
                invisibilita: () => {
                    this.playerSelected = false;
                    this.closeMenu();
                    this.postMessage('invisibilita');
                },
                godmode: () => {
                    this.playerSelected = false;
                    this.closeMenu();
                    this.postMessage('godmode');
                },
                reviveall: () => {
                    this.playerSelected = false;
                    this.closeMenu();
                    this.postMessage('reviveall');
                },
                annuncio: {
                    title: this.config.lang.annuncio,
                    color: '#242424',
                    action: 'annuncio',
                    input1: { placeholder: this.config.lang.text, type: 'text' }
                },
                givemoneyall: {
                    title: this.config.lang.give_money_all,
                    color: '#0f0f0f',
                    action: 'givemoneyall',
                    input1: {
                        type: 'select',
                        options: [
                            { label: this.config.lang.cash, value: 'money' },
                            { label: this.config.lang.bank, value: 'bank' },
                            { label: this.config.lang.black_money, value: 'black_money' }
                        ]
                    },
                    input2: { placeholder: this.config.lang.count, type: 'text' },
                    double: true
                },
                repairvehicle: () => {
                    this.postMessage('repairvehicle');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                clearped: () => {
                    this.postMessage('clearped', { id: this.playerSelected.id });
                    this.playerSelected = false;
                    this.closeMenu();
                },
                nomiplayer: () => {
                    this.closeMenu();
                    this.postMessage("nomiplayer");
                },
                cleararea: {
                    title: this.config.lang.clear_area,
                    color: '#242424',
                    action: 'cleararea',
                    input1: { type: 'select', options: this.radius }
                },
                copycoords: () => {
                    this.postMessage('copycoords');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                tpstaff: () => {
                    this.postMessage('tpstaff');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                superspeed: () => {
                    this.postMessage('superspeed');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                superjump: () => {
                    this.postMessage('superjump');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                superstrength: () => {
                    this.postMessage('superstrength');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                spawnvehicle: {
                    title: 'Spawna Veicolo',
                    color: '#1a1a1a',
                    action: 'spawnvehicle',
                    input1: { placeholder: 'Modello veicolo (es. adder)', type: 'text' }
                },
                deletevehicle: () => {
                    this.postMessage('deletevehicle');
                    this.playerSelected = false;
                    this.closeMenu();
                },
                fixvehicle: () => {
                    this.postMessage('fixvehicle');
                    this.playerSelected = false;
                    this.closeMenu();
                }
            };

            const act = actions[id];
            if (typeof act === 'function') {
                act();
            } else if (act) {
                this.questionInfo = act;
                if (act.double) {
                    this.viewDoubleInput(true);
                } else {
                    this.viewOneInput(true);
                }
            }
        },

        confirmAction() {
            const action = this.questionInfo.action;
            const value1 = $(".value1").val();
            const value2 = $(".value2").val() || "";

            if (action === 'spawnvehicle') {
                this.postMessage('spawnvehicle', { model: value1 });
                this.closeQuestion();
                this.playerSelected = false;
                this.closeMenu();
                return;
            }

            if (action === 'removeitem') {
                this.postMessage('removeitem', {
                    id: this.playerSelected.id,
                    item: value1,
                    count: parseInt(value2) || 1
                });
                this.closeQuestion();
                this.playerSelected = false;
                this.closeMenu();
                return;
            }

            this.postMessage('action', {
                action: action,
                value1: value1,
                value2: value2,
                id: this.playerSelected.id
            });

            this.closeQuestion();
            this.playerSelected = false;
            this.closeMenu();
        },

        updatePlayers(players) {
            this.listaPlayer = players;
            if (this.playerSelected) {
                for (const player of players) {
                    if (player.id === this.playerSelected.id) {
                        this.playerSelected = player;
                        break;
                    }
                }
            }

            for (const action of this.azioni) {
                if (action.id === 'freeze' && this.playerSelected?.freezed) {
                    action.label = this.config.lang.unfreeze;
                    action.id = 'sfreeze';
                } else if (action.id === 'sfreeze' && !this.playerSelected?.freezed) {
                    action.label = this.labelFreeze;
                    action.id = 'freeze';
                }
            }
        },

        viewList1(id) {
            this.listType = id;
            this.viewList = true;
        },

        deleteWarn(index) {
            this.postMessage('deletewarn', {
                id: this.playerSelected.id,
                index: index
            });
        },

        setConfig(config) {
            this.config = config;
            this.config.lang = config.Lang[config.Language];

            for (const item of this.infoDashboard) {
                if (item.id === 'adminonline')  item.label = this.config.lang['staff_online'];
                if (item.id === 'playeronline') item.label = this.config.lang['player_online'];
                if (item.id === 'totalban')     item.label = this.config.lang['ban_totali'];
                if (item.id === 'totalkick')    item.label = this.config.lang['kick_totali'];
            }
        },

        setAzioni(azioni) {
            this.azioni = azioni;

            for (const action of this.azioni) {
                if (action.id === 'freeze') this.labelFreeze = action.label;
            }
        },

        setAzioniPersonale(azioni) {
            this.azioniPersonale = azioni;
        },

        close() {
            const sectionToSave = (this.optionSelected === 'infopersona') ? 'listaplayer' : this.optionSelected;
            window._lastAdminSection = sectionToSave;
            $("#app").fadeOut(500);
            this.postMessage('close');
        },

        closeMenu(fadeTime) {
            const sectionToSave = (this.optionSelected === 'infopersona') ? 'listaplayer' : this.optionSelected;
            window._lastAdminSection = sectionToSave;
            $("#app").fadeOut(fadeTime !== undefined ? fadeTime : 500);
            this.postMessage('close');
        },

        redirectPage(url) {
            window.invokeNative('openUrl', url);
        },

        getValue(id) {
            if (id === 'totalban')    return this.listaBan.length;
            if (id === 'adminonline') return this.adminOnline;
            if (id === 'playeronline') return this.listaPlayer.length;
            if (id === 'totalkick')   return this.kickTotali;
        },

        refreshResources() {
            this.postMessage('refreshresources');
        },

        startResource(resourceName) {
            this.postMessage('startresource', { resource: resourceName });
            this.addConsoleLog(`start ${resourceName}`);
            const resource = this.resources.find(r => r.name === resourceName);
            if (resource) resource.state = 'starting';
        },

        restartResource(resourceName) {
            this.postMessage('restartresource', { resource: resourceName });
            this.addConsoleLog(`restart ${resourceName}`);
            const resource = this.resources.find(r => r.name === resourceName);
            if (resource) resource.state = 'restarting';
        },

        stopResource(resourceName) {
            this.postMessage('stopresource', { resource: resourceName });
            this.addConsoleLog(`stop ${resourceName}`);
            const resource = this.resources.find(r => r.name === resourceName);
            if (resource) resource.state = 'stopping';
        },

        executeCommand() {
            if (!this.consoleCommand.trim()) return;
            this.postMessage('executecommand', { command: this.consoleCommand });
            this.addConsoleLog(this.consoleCommand);
            this.consoleCommand = '';
        },

        addConsoleLog(command) {
            this.consoleLogs.push({
                name: this.infoStaff.name || 'Console',
                command: command
            });

            this.$nextTick(() => {
                const el = document.getElementById('consoleContent');
                if (el) el.scrollTop = el.scrollHeight;
            });

            if (this.consoleLogs.length > 100) this.consoleLogs.shift();
        },

        filteredResources() {
            if (!this.risorse_search) return this.resources;
            const q = this.risorse_search.toLowerCase();
            return this.resources.filter(r => r.name.toLowerCase().includes(q));
        },

        setResources(resources) {
            this.resources.splice(0, this.resources.length, ...resources);
        },

        formatServerTime(time) {
            const hours = Math.floor(time);
            const minutes = Math.floor((time - hours) * 60);
            return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
        },

        getTimePeriod(time) {
            if (time >= 5 && time < 12) return '🌅 Mattina';
            if (time >= 12 && time < 17) return '☀️ Pomeriggio';
            if (time >= 17 && time < 21) return '🌆 Sera';
            return '🌙 Notte';
        },

        getTimeOfDay(time) {
            if (time >= 5 && time < 12) return 'Mattina';
            if (time >= 12 && time < 17) return 'Pomeriggio';
            if (time >= 17 && time < 21) return 'Sera';
            return 'Notte';
        },

        updateServerTime() {
            this.postMessage('setServerTime', { time: parseFloat(this.serverTime) });
        },

        setTime(hour) {
            this.serverTime = hour;
            this.updateServerTime();
        },

        freezeTime() {
            this.timeFreezed = !this.timeFreezed;
            this.postMessage('freezeTime', { freeze: this.timeFreezed });
        },

        syncRealTime() {
            const now = new Date();
            this.serverTime = now.getHours();
            this.postMessage('setServerTime', { time: now.getHours() });
        },

        setWeather(weatherId) {
            this.currentWeather = weatherId;
            this.postMessage('setWeather', {
                weather: weatherId,
                intensity: parseFloat(this.weatherIntensity),
                transition: this.weatherTransition
            });
        },

        updateWeatherIntensity() {
            this.postMessage('setWeatherIntensity', {
                intensity: parseFloat(this.weatherIntensity),
                weather: this.currentWeather
            });
        },

        toggleWeatherTransition() {
            this.postMessage('toggleWeatherTransition', { transition: this.weatherTransition });
        },

        toggleDynamicWeather() {
            this.postMessage('toggleDynamicWeather', { dynamic: this.dynamicWeather });
        },

        getCurrentWeatherName() {
            const w = this.weatherTypes.find(w => w.id === this.currentWeather);
            return w ? w.name : 'Sconosciuto';
        },

        updateTimeSlider() {
            this.postMessage('setServerTime', { time: parseInt(this.serverTime) });
        },

        getTimeLabel(hour) {
            hour = parseInt(hour);
            if (hour >= 6 && hour < 12) return 'Mattina';
            if (hour >= 12 && hour < 18) return 'Pomeriggio';
            if (hour >= 18 && hour < 21) return 'Sera';
            return 'Notte';
        },

        selectWeather(weatherId) {
            this.currentWeather = weatherId;
            this.postMessage('setWeather', {
                weather: weatherId,
                transition: true
            });
        },

        toggleTimeFreeze() {
            this.timeFreezed = !this.timeFreezed;
            this.postMessage('freezeTime', { freeze: this.timeFreezed });
        },

        formatTime(hour) {
            return String(hour).padStart(2, '0') + ':00';
        },

        filteredUsers() {
            if (this.users_search !== '') {
                return this.allUsers.filter(user => {
                    return user.name.toLowerCase().includes(this.users_search.toLowerCase());
                });
            }
            return this.allUsers;
        },

        refreshUsers() {
            this.postMessage('getAllUsers', {});
        },

        getGroupLabel(groupValue) {
            const group = this.adminGroups.find(g => g.value === groupValue);
            return group ? group.label : groupValue || 'Utente';
        },

        changeUserGroup(identifier, newGroup) {
            const user = this.allUsers.find(u => u.identifier === identifier);
            if (!user) return;

            user.group = newGroup;
            user.selectedGroup = newGroup;

            this.postMessage('changeUserGroup', {
                identifier: identifier,
                group: newGroup
            });
        },

        setAllUsers(users) {
            this.allUsers = users.map(user => ({
                ...user,
                selectedGroup: user.group || 'user'
            }));
        },

        openInventory(inventory, playerName) {
            this.inventoryData = inventory || [];
            this.inventoryPlayerName = playerName || 'Giocatore';
            this.showInventoryModal = true;
        },

        closeInventory() {
            this.showInventoryModal = false;
            this.inventoryData = [];
            this.inventoryPlayerName = '';
        }
    }
});


window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.type === "OPEN") {
        const section = window._lastAdminSection || 'dashboard';
        app.updateSelectedOption(section);
        app.updatePlayers(data.players);
        $("#app").fadeIn(500);
    }
    else if (data.type === "UPDATE_PLAYERS") {
        app.updatePlayers(data.players);
    }
    else if (data.type === "SET_CONFIG") {
        app.setConfig(data.config);
    }
    else if (data.type === "SET_AZIONI") {
        app.setAzioni(data.azioni);
    }
    else if (data.type === "SET_AZIONI_PERSONALE") {
        app.setAzioniPersonale(data.azioni);
    }
    else if (data.type === "SET_INFO_STAFF") {
        app.infoStaff = data.info;
    }
    else if (data.type === "SET_JOBS") {
        app.jobs = data.jobs;
    }
    else if (data.type === "SET_ORARIO") {
        const updateOrario = () => {
            const now = new Date();
            const h = String(now.getHours()).padStart(2, '0');
            const m = String(now.getMinutes()).padStart(2, '0');
            app.orario = `${h}:${m}`;
        };
        updateOrario();
        if (window._orarioInterval) clearInterval(window._orarioInterval);
        window._orarioInterval = setInterval(updateOrario, 60000);
    }
    else if (data.type === "SET_ADMIN_GROUPS") {
        app.adminGroups = [{
            label: app.config.lang?.['utente'] || 'Utente',
            value: app.config.GroupUser || 'user'
        }];

        for (const group of Object.values(data.groups || {})) {
            group.value = group.id;
            if (group.rank <= (app.infoStaff.rank || 0)) {
                app.adminGroups.push(group);
            }
        }
    }
    else if (data.type === "RESUME") {
        $("#app").fadeIn(500);
    }
    else if (data.type === "SET_BAN") {
        app.listaBan = data.ban || [];
    }
    else if (data.type === "SET_ADMIN_ONLINE") {
        app.adminOnline = data.admin || 0;
    }
    else if (data.type === "SHOW_ANNOUNCE") {
        showMessageBox('annuncio', data.text, app.config.NomeServer || 'Server');
    }
    else if (data.type === "SHOW_DM_MESSAGE") {
        showMessageBox('dm', data.text, data.sender || app.config.NomeServer);
    }
    else if (data.type === "SHOW_WARN_MESSAGE") {
        showMessageBox('warn', data.text, data.sender || app.config.NomeServer);
    }
    else if (data.type === "SET_KICKS") {
        app.kickTotali = data.kicks || 0;
    }
    else if (data.type === "SET_SERVER_LOGO") {
        const logo = document.querySelector(".serverLogo");
        if (logo) logo.style.backgroundImage = `url("${data.logo}")`;
    }
    else if (data.type === "SET_RADIUS") {
        app.radius = data.radius || [];
    }
    else if (data.type === "copyToClipboard") {
        const textarea = document.createElement('textarea');
        textarea.value = data.text;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
    }
    else if (data.type === "SET_RESOURCES") {
        app.setResources(data.resources || []);
    }
    else if (data.type === "ADD_CONSOLE_LOG") {
        app.addConsoleLog(data.command);
    }
    else if (data.type === "UPDATE_SERVER_TIME") {
        let hours = parseInt(data.hours);
        app.serverTime = (hours >= 0 && hours <= 23) ? hours : 12;
        app.timeFreezed = !!data.frozen;
    }
    else if (data.type === "UPDATE_WEATHER") {
        app.currentWeather = data.weather || 'CLEAR';
    }
    else if (data.type === "UPDATE_WEATHER_INTENSITY") {
        let intensity = parseFloat(data.intensity);
        app.weatherIntensity = (intensity >= 0 && intensity <= 1) ? intensity : 0.5;
    }
    else if (data.type === "SET_ALL_USERS") {
        app.setAllUsers(data.users || []);
    }
    else if (data.type === "SHOW_INVENTORY") {
        app.openInventory(data.inventory || [], data.playerName || 'Giocatore');
    }
});
function showMessageBox(type, text, sender) {
    $('#messageContainer').remove();

    const typeMap = {
        annuncio: { svg: svgIcons.annuncio,    color: '#f59e0b' },
        dm:       { svg: svgIcons.sendmessage, color: '#3b82f6' },
        warn:     { svg: svgIcons.warn,        color: '#ef4444' }
    };
    const meta = typeMap[type] || { svg: svgIcons.annuncio, color: '#777' };

    const title =
        type === 'annuncio' ? (app.config?.lang?.annuncio   || 'ANNUNCIO')        :
        type === 'dm'       ? (app.config?.lang?.dmmessage  || 'MESSAGGIO PRIVATO') :
        type === 'warn'     ? (app.config?.lang?.warn       || 'AVVISO')           :
                              'NOTIFICA';

    $('body').append(`
        <div id="messageContainer" class="message-backdrop">
            <div class="message-wrapper">
                <div class="messageBox" style="border-left-color: ${meta.color};">
                    <div class="message-header">
                        <div class="messageIcon" style="color: ${meta.color}; width:32px; height:32px; display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                            ${meta.svg}
                        </div>
                        <div class="message-title-info">
                            <div class="messageTitle"></div>
                            <div class="messageSender">Da: <span class="senderName"></span></div>
                        </div>
                    </div>
                    <div class="messageContent"></div>
                    <div class="message-actions">
                        <div class="countdown">Chiusura tra <span class="seconds">5</span> secondi</div>
                    </div>
                </div>
            </div>
        </div>
    `);

    $('#messageContainer .messageTitle').text(title);
    $('#messageContainer .senderName').text(sender || app.config?.NomeServer || 'Sistema');
    $('#messageContainer .messageContent').text(text);

    const $container = $('#messageContainer');
    const $countdown = $('#messageContainer .seconds');

    $container.fadeIn(220);

    let secondsLeft = 5;
    const countdownInterval = setInterval(() => {
        secondsLeft--;
        $countdown.text(secondsLeft);
        if (secondsLeft <= 3) $countdown.parent().addClass('warning');
        if (secondsLeft <= 0) {
            clearInterval(countdownInterval);
            $container.fadeOut(220, () => $container.remove());
        }
    }, 1000);

    function closePopup() {
        clearInterval(countdownInterval);
        $container.fadeOut(220, () => $container.remove());
    }

    $(document).on('keydown.messageClose', e => {
        if (e.key === 'Enter' || e.key === 'Escape' || e.key === ' ') {
            e.preventDefault();
            closePopup();
        }
    });

    $container.on('click', e => {
        if (e.target === $container[0]) closePopup();
    });
}

function setupFiveMKeyHandlers() {
    document.addEventListener('keydown', e => {
        const popup = document.getElementById('messageContainer');
        if (popup && popup.style.display !== 'none') {
            if (e.key === 'Enter' || e.key === 'Escape' || e.key === ' ') {
                e.preventDefault();
                e.stopPropagation();
                $('#messageContainer').fadeOut(220, function() { $(this).remove(); });
            }
        }
    }, true);
}

$(document).ready(setupFiveMKeyHandlers);

document.onkeyup = function (data) {
    if (data.key === 'Escape') {
        if (app.showInventoryModal) {
            app.closeInventory();
            return;
        }
        if (app.optionSelected === 'infopersona' && !app.viewList) {
            app.updateSelectedOption('listaplayer');
            app.playerSelected = false;
        } else if (app.viewList) {
            app.viewList = false;
        } else {
            window._lastAdminSection = app.optionSelected;
            app.close();
        }
    }
};
function showInventoryModal(inventory, playerName) {
    $("#inventoryModal").remove();

    let rows = "";
    if (inventory.length === 0) {
        rows = '<tr><td colspan="3" style="text-align:center;padding:18px;color:#888;">Inventario vuoto</td></tr>';
    } else {
        inventory.forEach(function(item) {
            rows += '<tr>' +
                '<td style="padding:7px 12px;color:#e0e0e0;">' + (item.label || item.name) + '</td>' +
                '<td style="padding:7px 12px;color:#aaa;font-family:monospace;">' + item.name + '</td>' +
                '<td style="padding:7px 12px;color:#7faaff;text-align:right;font-weight:bold;">x' + item.count + '</td>' +
            '</tr>';
        });
    }

    var total = inventory.reduce(function(s, i) { return s + (i.count || 0); }, 0);

    var html = '<div id="inventoryModal" style="position:fixed;inset:0;z-index:99999;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,0.72);backdrop-filter:blur(4px);">' +
        '<div style="background:#161616;border:1px solid #2a2a2a;border-radius:10px;min-width:440px;max-width:600px;width:100%;max-height:75vh;display:flex;flex-direction:column;box-shadow:0 8px 40px #000a;">' +
            '<div style="padding:16px 20px;border-bottom:1px solid #232323;display:flex;align-items:center;justify-content:space-between;">' +
                '<div>' +
                    '<div style="color:#fff;font-size:15px;font-weight:700;display:flex;align-items:center;gap:8px;">' +
                        'Inventario di <span style="color:#7faaff;margin-left:4px;">' + playerName + '</span>' +
                    '</div>' +
                    '<div style="color:#666;font-size:12px;margin-top:3px;">' + inventory.length + ' tipi &middot; ' + total + ' oggetti totali</div>' +
                '</div>' +
                '<button id="invModalClose" style="background:#2a2a2a;border:none;color:#aaa;cursor:pointer;border-radius:6px;padding:6px 14px;font-size:13px;display:flex;align-items:center;gap:6px;">' +
                    '&#x2715; Chiudi' +
                '</button>' +
            '</div>' +
            '<div style="overflow-y:auto;flex:1;">' +
                '<table style="width:100%;border-collapse:collapse;">' +
                    '<thead>' +
                        '<tr style="background:#1e1e1e;position:sticky;top:0;">' +
                            '<th style="padding:8px 12px;color:#888;font-weight:600;text-align:left;font-size:12px;">LABEL</th>' +
                            '<th style="padding:8px 12px;color:#888;font-weight:600;text-align:left;font-size:12px;">NOME</th>' +
                            '<th style="padding:8px 12px;color:#888;font-weight:600;text-align:right;font-size:12px;">QT&Agrave;</th>' +
                        '</tr>' +
                    '</thead>' +
                    '<tbody>' + rows + '</tbody>' +
                '</table>' +
            '</div>' +
        '</div>' +
    '</div>';

    $("body").append(html);

    $("#invModalClose").on("click", function() { $("#inventoryModal").remove(); });

    $(document).off("keydown.invModal").on("keydown.invModal", function(e) {
        if (e.key === "Escape") { $("#inventoryModal").remove(); $(document).off("keydown.invModal"); }
    });
}