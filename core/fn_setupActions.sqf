#include "..\script_macros.hpp"
/*
    File: fn_setupActions.sqf
    Author:

    Description:
    Master addAction file handler for all client-based actions.
*/

// Array für alle Lebensaktionen
life_actions = [];

// Switch-Anweisung, um basierend auf der Seite des Spielers verschiedene Aktionen hinzuzufügen
switch (playerSide) do {

    // Zivilisten
    case civilian: {
        // Falle Fischernetz
        life_actions pushBack (player addAction [
            localize "STR_pAct_DropFishingNet",
            life_fnc_dropFishingNet,
            "",
            0,
            false,
            false,
            "",
            '(surfaceisWater (getPos vehicle player)) && (vehicle player isKindOf "Ship") && life_carryWeight < life_maxWeight && speed (vehicle player) < 2 && speed (vehicle player) > -1 && !life_net_dropped'
        ]);

        // Raube Person aus
        life_actions pushBack (player addAction [
            localize "STR_pAct_RobPerson",
            life_fnc_robAction,
            "",
            0,
            false,
            false,
            "",
            '!isNull cursorObject && player distance cursorObject < 3.5 && isPlayer cursorObject && animationState cursorObject == "Incapacitated" && !(cursorObject getVariable ["robbed", false])'
        ]);

        		//Passport
		life_actions = life_actions + [player addAction["Personalausweis ansehen",{[cursorTarget] remoteExecCall ["fvs_fnc_zeigePerso",player];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1) && !(player getVariable ["restrained",false]) && (cursorTarget getVariable ["restrained",false])']];
		life_actions = life_actions + [player addAction["Personalausweis zeigen",{[player] remoteExecCall ["fvs_fnc_zeigePerso",cursorTarget];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1)']];
    };
    
    // Polizisten
    case west: {
        // Waffen entfernen
        life_actions = life_actions + [player addAction [
            "Sachen entfernen",
            life_fnc_seizeWeapon,
            cursorTarget,
            0,
            false,
            false,
            "",
            'count(nearestObjects [player,["weaponholder"],3])>0'
        ]];
        
        // Pickup-Spikes
        life_actions pushBack (player addAction [
            localize "STR_ISTR_Spike_Pack",
            life_fnc_packupSpikes,
            "",
            0,
            false,
            false,
            "",
            '(nearestObjects[player,["Land_Razorwire_F"],8]) params [["_spikes",objNull]]; !isNull _spikes && {!isNil {(_spikes getVariable "item")}}'
        ]);

        //Passport
		life_actions = life_actions + [player addAction["Personalausweis ansehen",{[cursorTarget] remoteExecCall ["fvs_fnc_zeigePerso",player];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1) && !(player getVariable ["restrained",false]) && (cursorTarget getVariable ["restrained",false])']];
		life_actions = life_actions + [player addAction["Personalausweis zeigen",{[player] remoteExecCall ["fvs_fnc_zeigePerso",cursorTarget];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1)']];
		// nano EMP
		life_actions = life_actions + [player addAction["<t color='#FF0000'>EMP Operator Konsole öffnen</t>",life_fnc_openEmpMenu,[],8,false,false,"",'[_this] call life_fnc_isEmpOperator']];

	};
    
    // Rettungsdienst
    case independent: { };
        //Passport
		life_actions = life_actions + [player addAction["Personalausweis ansehen",{[cursorTarget] remoteExecCall ["fvs_fnc_zeigePerso",player];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1) && !(player getVariable ["restrained",false]) && (cursorTarget getVariable ["restrained",false])']];
		life_actions = life_actions + [player addAction["Personalausweis zeigen",{[player] remoteExecCall ["fvs_fnc_zeigePerso",cursorTarget];},"",0,false,false,"",'
		isPlayer cursorTarget && alive cursorTarget && (player distance cursorTarget < 3) && (speed player < 1 && speed cursorTarget < 1)']];
};
