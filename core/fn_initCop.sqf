#include "..\script_macros.hpp"

/*
    File: fn_initCop.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Cop Initialization file.
*/

// Warte, bis das HUD geladen ist
// waitUntil { !(isNull (findDisplay 46)) }; // Auskommentiert, da es nicht benötigt wird

// Schreibe in die Server-Logdatei, dass das Skript gestartet wurde
diag_log "fn_initCop.sqf";

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

// Überprüfe, ob der Spieler auf der Blacklist steht
if (life_blacklisted) exitWith {
    ["Blacklisted", false, true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!", "BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!";
    sleep 30;
};

// Überprüfe, ob der Spieler entweder kein Cop-Level hat oder kein Admin-Level ist
if ((FETCH_CONST(life_coplevel) < 1) && (FETCH_CONST(life_adminlevel) isEqualTo 0)) then {
    ["NotWhitelisted", false, true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!", "BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!";
    sleep 35;
};

// Holen Sie sich den Cop-Rang und die Paychecks-Einstellungen
private _rank = FETCH_CONST(life_coplevel);
private _paychecks = LIFE_SETTINGS(getArray, "paycheck_cop");

// Setze das Paycheck basierend auf dem Cop-Rang
if (count _paychecks isEqualTo 1) then {
    life_paycheck = _paychecks select 0;
} else {
    life_paycheck = _paychecks select _rank;
};

// Setze die Variable "rank" für den Spieler
player setVariable ["rank", _rank, true];

// Warte, bis das Spawn-Auswahlmenü geöffnet ist
waitUntil { !isNull (findDisplay 38500) };
// Warte, bis das Spawn-Auswahlmenü geöffnet ist
waitUntil { !isNull (findDisplay 38500) };

// Holen Sie sich den Standort des Spielers und protokollieren Sie ihn
private _standort = (text nearestLocation [ getPosATL player, "nameCity"]);
[name player, (getPlayerUID player), format["Joint als COP nahe %1", _standort], 8] remoteExec ["TON_fnc_logIt", 2];

// Rufe Funktionen auf, um bestimmte Dinge zu initialisieren
// [] call life_fnc_placeablesInit; // Funktion auskommentiert, da sie nicht benötigt wird
[] call stig_sz_hideGUI;
[] call cat_spawn_fnc_spawnMenu;
[] spawn life_fnc_placeablesInit;