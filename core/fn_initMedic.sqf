#include "..\script_macros.hpp"

/*
    File: fn_initMedic.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initializes the medic.
*/

// Warte, bis das HUD geladen ist (auskommentiert, da es nicht benötigt wird)
// waitUntil { !(isNull (findDisplay 46)) };

// Schreibe in die Server-Logdatei, dass das Skript gestartet wurde
diag_log "fn_initMedic.sqf";

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

// Überprüfe, ob der Spieler entweder kein Medic-Level hat oder kein Admin-Level ist
if ((FETCH_CONST(life_medicLevel)) < 1 && (FETCH_CONST(life_adminlevel) isEqualTo 0)) exitWith {
    ["Notwhitelisted", false, true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!", "BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!";
    sleep 35;
};

// Holen Sie sich das Medic-Rang und die Paychecks-Einstellungen
private _rank = FETCH_CONST(life_medicLevel);
private _paychecks = LIFE_SETTINGS(getArray, "paycheck_med");

// Setze das Paycheck basierend auf dem Medic-Rang
if (count _paychecks isEqualTo 1) then {
    life_paycheck = _paychecks select 0;
} else {
    life_paycheck = _paychecks select _rank;
};

// Setze die Variable "rank" für den Spieler
player setVariable ["rank", _rank, true];

// Rufe Funktionen auf, um bestimmte Dinge zu initialisieren
// [] call life_fnc_placeablesInit; // Funktion auskommentiert, da sie nicht benötigt wird
[] call cat_spawn_fnc_spawnMenu;

// Warte, bis das Spawn-Auswahlmenü geöffnet ist
waitUntil { !isNull (findDisplay 38500) };

// Warte, bis das Spawn-Auswahlmenü geschlossen ist
waitUntil { isNull (findDisplay 38500) };

// Holen Sie sich den Standort des Spielers und protokollieren Sie ihn
private _standort = (text nearestLocation [ getPosATL player, "nameCity"]);
[name player, (getPlayerUID player), format["joint als MEDIC nahe %1", _standort], 8] remoteExec ["TON_fnc_logIt", 2];

[] spawn life_fnc_medicPlaceablesInit;