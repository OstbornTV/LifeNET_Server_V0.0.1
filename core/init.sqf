#include "..\script_macros.hpp"
/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Master client initialization file
*/

// Logging
diag_log "--------------------------------- Starting Altis Life Client Init ----------------------------------";
diag_log format ["------------------------------------------ Version %1 -------------------------------------------", (LIFE_SETTINGS(getText, "framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

private ["_handle","_timeStamp","_server_isReady","_extDB_notLoaded"];
life_firstSpawn = true;
life_session_completed = false;

// Display initialization message
0 cutText [localize "STR_Init_ClientSetup", "BLACK FADED", 99999999];

// Timestamp for performance measurement
_timeStamp = diag_tickTime;

// Wait for the main display to be created
waitUntil {!isNull (findDisplay 46)};

// Compile and execute clientValidator script
[] call compile preprocessFileLineNumbers "core\clientValidator.sqf";
enableSentences false;

// Initialize configuration variables
diag_log "[Life Client] Initialization Variables";
[] call compile preprocessFileLineNumbers "core\configuration.sqf";
diag_log "[Life Client] Variables initialized";

// Setup event handlers
diag_log "[Life Client] Setting up Eventhandlers";
[] call life_fnc_setupEVH;
diag_log "[Life Client] Eventhandlers completed";

// Setup user actions
diag_log "[Life Client] Setting up user actions";
[] call life_fnc_setupActions;
diag_log "[Life Client] User actions completed";

// Wait for the server to be ready
diag_log "[Life Client] Waiting for the server to be ready...";
waitUntil {!isNil "life_server_isReady" && {!isNil "life_server_extDB_notLoaded"}};

// Exit if extDB is not loaded
if (life_server_extDB_notLoaded) exitWith {
    0 cutText [localize "STR_Init_ExtdbFail", "BLACK FADED", 99999999];
};

diag_log "::Life Client:: Waiting for the server to be ready..";
waitUntil{!isNil "life_HC_isActive"};
if (life_HC_isActive) then {
    waitUntil{!isNil "life_HC_server_isReady" && !isNil "life_HC_server_extDB_notLoaded"};
    _server_isReady = life_HC_server_isReady;
    _extDB_notLoaded = life_HC_server_extDB_notLoaded;
} else {
    waitUntil{!isNil "life_server_isReady" && !isNil "life_server_extDB_notLoaded"};
    _server_isReady = life_server_isReady;
    _extDB_notLoaded = life_server_extDB_notLoaded;
};

// Wait for the server to finish loading
waitUntil {life_server_isReady};
diag_log "[Life Client] Server loading completed ";
0 cutText [localize "STR_Init_ServerReady", "BLACK FADED", 99999999];

// Perform data query to the server
[] call SOCK_fnc_dataQuery;
waitUntil {life_session_completed};
0 cutText [localize "STR_Init_ClientFinish", "BLACK FADED", 99999999];

// Initialize player based on side
switch (playerSide) do {
    case west: {
        [] call life_fnc_initCop;
    };
    case civilian: {
        [] call life_fnc_initCiv;
        (group player) deleteGroupWhenEmpty true;
    };
    case independent: {
        [] call life_fnc_initMedic;
    };
};

// Additional player settings
CONSTVAR(life_paycheck);

// Set initial player variables
player setVariable ["restrained", false, true];
player setVariable ["Escorting", false, true];
player setVariable ["transporting", false, true];
player setVariable ["playerSurrender", false, true];
player setVariable ["realname", profileName, true];

// Additional logging
diag_log "[Life Client] Past Settings Init";

// Key handling
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call life_fnc_keyHandler"];
[player, life_settings_enableSidechannel, playerSide] remoteExecCall ["TON_fnc_manageSC", RSERV];

// Spawn survival functions
[] spawn life_fnc_survival;

// Display message
0 cutText ["", "BLACK IN"];

// Enable player tags and reveal objects if configured
if (profileNamespace getVariable ["life_settings_revealObjects", true]) then {
    LIFE_ID_PlayerTags = addMissionEventHandler ["EachFrame", life_fnc_playerTags];
};
if (profileNamespace getVariable ["life_settings_revealObjects", true]) then {
    LIFE_ID_RevealObjects = addMissionEventHandler ["EachFrame", life_fnc_revealObjects];
};

// Disable fatigue if configured
if (LIFE_SETTINGS(getNumber, "enable_fatigue") isEqualTo 0) then {player enableFatigue false;};

// Setup pump service if configured
if (LIFE_SETTINGS(getNumber, "pump_service") isEqualTo 1) then {
    [] execVM "fn_setupStationService.sqf";
};

// Request client ID from the server
life_fnc_RequestClientId = player;
publicVariableServer "life_fnc_RequestClientId";

// Disable unnecessary channels (workaround)
{
    _x params [["_chan", -1, [0]], ["_noText", "false", [""]], ["_noVoice", "false", [""]]];

    _noText = [false, true] select ((["false", "true"] find toLower _noText) max 0);
    _noVoice = [false, true] select ((["false", "true"] find toLower _noVoice) max 0);

    _chan enableChannel [!_noText, !_noVoice];

} forEach getArray (missionConfigFile >> "disableChannels");

// Update wanted profile (remote execution)
if (life_HC_isActive) then {
    [getPlayerUID player, player getVariable ["realname", name player]] remoteExec ["HC_fnc_wantedProfUpdate", HC_Life];
} else {
    [getPlayerUID player, player getVariable ["realname", name player]] remoteExec ["life_fnc_wantedProfUpdate", RSERV];
};

// Update HUD and initialize permissions
[] call life_fnc_hudUpdate;
[] spawn cat_perm_fnc_initPerm;

// Final logging
diag_log "-------------------------------------------- End of Altis Life Client Init ---------------------------------------------";
diag_log format ["End of Altis Life Client Init :: Total Execution Time %1 seconds ", (diag_tickTime - _timeStamp)];
