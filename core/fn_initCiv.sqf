#include "..\script_macros.hpp"

/*
    File: fn_initCiv.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initializes the civilian.
*/

// Erstelle ein Array für Gebäude, die in WL_Rosche liegen
private "_spawnPos";
private _wl_roscheArray = [];
private _spawnBuildings = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

// Finde die nächstgelegenen Gebäude zu den Spawnpunkten
civ_spawn_1 = nearestObjects[getMarkerPos "civ_spawn_rosch", _spawnBuildings, 350];
civ_spawn_2 = nearestObjects[getMarkerPos "civ_spawn_stock", _spawnBuildings, 350];

// Warte, bis das HUD geladen ist
waitUntil { !(isNull (findDisplay 46)) };

// Einstellungen für das Gehalt
life_paycheck = LIFE_SETTINGS(getNumber, "paycheck_civ");

diag_log "::Life Client:: Creating AGB Dialog";
// AGB
rulesok = false;
if(!createDialog "agb") exitWith {};
waitUntil{!isNull (findDisplay 32154)}; //Wait for the spawn selection to be open.
waitUntil{isNull (findDisplay 32154)}; //Wait for the spawn selection to be done.
if(!rulesok)then {        
        player enableSimulation false;
        ["agb",false,true] call BIS_fnc_endMission;
        sleep 35;
};
rulesok = nil;


// Überprüfe, ob der Spieler lebendig ist und nicht verhaftet wurde
if (life_is_alive && !life_is_arrested) then {
    /* Spawn an unserer letzten Position */
    player setVehiclePosition [life_civ_position, [], 0, "CAN_COLLIDE"];
} else {
    // Überprüfe, ob der Spieler nicht lebendig und nicht verhaftet ist
    if (!life_is_alive && !life_is_arrested) then {
        // Wenn "save_civilian_positionStrict" auf 1 gesetzt ist
        if (LIFE_SETTINGS(getNumber, "save_civilian_positionStrict") isEqualTo 1) then {
            [] call life_fnc_startLoadout;
            CASH = 0;
            [0] call SOCK_fnc_updatePartial;
        };

        // Öffne das Spawn-Menü für den Zivilisten
        [] call cat_spawn_fnc_spawnMenu;

        // Warte, bis das Spawn-Auswahlmenü geöffnet ist
        waitUntil { !isNull (findDisplay 38500) };

        // Warte, bis das Spawn-Auswahlmenü geschlossen ist
        waitUntil { isNull (findDisplay 38500) };
    } else {
        // Wenn der Spieler verhaftet wurde
        if (life_is_arrested) then {
            life_is_arrested = false;
            [player, true] spawn life_fnc_jail;
        };
    };
};

// Setze den Status des Spielers auf "lebendig"
life_is_alive = true;
