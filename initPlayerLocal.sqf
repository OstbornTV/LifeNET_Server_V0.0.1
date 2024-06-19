#include "script_macros.hpp"

/*
    File: initPlayerLocal.sqf
    Author:

    Description:
    Starts the initialization of the player.
*/

TFAR_giveMicroDagrToSoldier = false; 
TFAR_giveLongRangeRadioToGroupLeaders = false; 
TFAR_givePersonalRadioToRegularSoldier = false;


#define CONST(var1,var2) var1 = compileFinal (if (var2 isEqualType "") then {var2} else {str(var2)})

#define LIFE_SETTINGS(TYPE,SETTING) TYPE(missionConfigFile >> "Life_Settings" >> SETTING)

CONST(BIS_fnc_endMission,BIS_fnc_endMission);

//if (!hasInterface && !isServer) exitWith {
//   [] call compile preprocessFileLineNumbers "\life_hc\initHC.sqf";
//};

[] spawn life_fnc_cba_setting;
[] spawn life_fnc_ace_self_setting;

[] execVM "core\init.sqf";
[] execVM "briefing.sqf";

//Sperrzonensystem initialisieren
"sperrzonensystem\" execVM "sperrzonensystem\main.sqf";

0 fadeRadio 0;