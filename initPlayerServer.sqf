/*
    File: initPlayerServer.sqf
    Author:

    Description:
    Executed only on server when a player joins mission.
*/

#define LIFE_SETTINGS(TYPE,SETTING) TYPE(missionConfigFile >> "Life_Settings" >> SETTING)

diag_log "initPlayerServer.sqf";
[getPlayerUid player,profilename,profileNameSteam,"start game","initPlayerServer.sqf"] remoteExec ["TON_fnc_diag_log_player",2];

//[] execVM "KRON_Strings.sqf";

if (LIFE_SETTINGS(getNumber,"player_deathLog") isEqualTo 0) exitWith {};

_this select 0 addMPEventHandler ["MPKilled", {_this call fn_whoDoneIt}];
