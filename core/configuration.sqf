#include "..\script_macros.hpp"
/*
    File: configuration.sqf
    Author:

    Description:
    Master Life Configuration File
    This file is to setup variables for the client; there are still other configuration files in the system

*****************************
****** Backend Variables *****
*****************************
*/
life_query_time = time;
life_action_delay = time;  // Zeitstempel für Aktionen
life_trunk_vehicle = objNull;  // Fahrzeug im Kofferraum (Initialisierung)
life_session_completed = false;  // Status der Spieler-Session
life_garage_store = false;  // Flag für Fahrzeug in der Garage
life_session_tries = 0;  // Versuche, eine Spielsession zu starten
life_siren_active = false;  // Status der Sirene
life_clothing_filter = 0;  // Kleidungsfilter (Initialisierung)
life_clothing_uniform = -1;
life_redgull_effect = time;  // Zeitstempel für RedGull-Effekt
life_is_processing = false;  // Status für Verarbeitungsvorgänge
life_bail_paid = false;  // Flag für gezahlte Kaution
life_impound_inuse = false;  // Flag für beschlagnahmtes Fahrzeug
life_action_inUse = false;  // Flag für aktive Aktion
life_spikestrip = objNull;  // Platzierter Spikestrip (Initialisierung)
life_skikesDeployed = [];  // Liste der platzierten Spikestrips
life_knockout = false;  // Spieler ist bewusstlos
life_interrupted = false;  // Flag für unterbrochene Aktionen
life_respawned = false;  // Flag für den Wiedereintritt des Spielers
life_removeWanted = false;  // Flag für Entfernen des Wanted-Status
life_action_gathering = false;  // Flag für sammelnde Aktion
life_god = false;  // Gottmodus aktiviert
life_frozen = false;  // Spieler ist eingefroren
life_save_gear = [];  // Gespeicherte Ausrüstung
life_container_activeObj = objNull;  // Aktives Container-Objekt (Initialisierung)
life_disable_getIn = false;  // Deaktiviere Einsteigen in Fahrzeuge
life_disable_getOut = false;  // Deaktiviere Aussteigen aus Fahrzeugen
life_admin_debug = false;  // Debug-Modus für Admins
life_preview_3D_vehicle_cam = objNull;
life_preview_3D_vehicle_object = objNull;
life_preview_light = objNull;
life_pos_exist = false;
life_pos_attach = [];
life_civ_position = [];  // Position des Zivilisten (Initialisierung)
life_markers = false;  // Marker aktiviert
life_markers_active = false;  // Aktive Marker
life_canpay_bail = true;  // Spieler kann Kaution zahlen
life_storagePlacing = scriptNull;  // Platzierungsobjekt für Lager
life_hideoutBuildings = [];  // Gebäude im Versteck (Initialisierung)
life_firstSpawn = true;  // Erster Spawndurchlauf

// Neue Variablen
life_canLockPick = true;  // Spieler kann Schlösser knacken
life_skikesDeployed = [];  // Liste der platzierten Spikestrips (Initialisierung)
gettingBought = 0;  // Flag für kaufenden Vorgang

//Perso
fvs_persoReady = false;
fvs_hakenregeln = false;
fvs_checking = false;
fvs_hakenrichtig = false;
fvs_namenInfo = false;
fvs_checking_a = false;
fvs_namen_a = false;
fvs_hakendaten = false;

//EMP
nn_last_vehicles = [];
nn_empInUse = false;

// Einstellungen
life_settings_enableNewsBroadcast = profileNamespace getVariable ["life_enableNewsBroadcast", true];  // Aktiviere News-Broadcast
life_settings_enableSidechannel = profileNamespace getVariable ["life_enableSidechannel", true];  // Aktiviere Sidechannel-Chat
life_settings_viewDistanceFoot = profileNamespace getVariable ["life_viewDistanceFoot", 1250];  // Sichtweite zu Fuß
life_settings_viewDistanceCar = profileNamespace getVariable ["life_viewDistanceCar", 1250];  // Sichtweite im Fahrzeug
life_settings_viewDistanceAir = profileNamespace getVariable ["life_viewDistanceAir", 1250];  // Sichtweite in der Luft
life_settings_tagson = profileNamespace getVariable ["life_settings_tagson",true];
life_settings_revealObjects = profileNamespace getVariable ["life_settings_revealObjects",true];


// Preise für Kleidung (Uniforme, Hut, Brille, Weste, Rucksack)
life_clothing_purchase = [-1, -1, -1, -1, -1];

/*
*****************************
****** Weight Variables *****
*****************************
*/
life_maxWeight = LIFE_SETTINGS(getNumber, "total_maxWeight");  // Maximales Gewicht
life_carryWeight = 0;  // Aktuelles Tragegewicht des Spielers (MUSS BEI 0 STARTEN).

/*
*****************************
****** Life Variables *******
*****************************
*/
life_net_dropped = false;  // Netz nicht geworfen
life_use_atm = true;  // Spieler kann Geldautomaten benutzen
life_is_arrested = false;  // Spieler ist nicht verhaftet
life_is_alive = false;  // Spieler ist nicht lebendig
life_delivery_in_progress = false;  // Lieferung in Bearbeitung
life_thirst = 100;  // Durstlevel
life_hunger = 100;  // Hungerlevel
CASH = 0;  // Spieler-Geldbetrag

life_istazed = false;  // Spieler ist nicht betäubt
life_isknocked = false;  // Spieler ist nicht bewusstlos
life_vehicles = [];  // Liste der Fahrzeuge des Spielers (Initialisierung)

life_smartphoneTarget = ObjNull;
life_unconscious = false;


/*
**************************************
****** Placeables Variables *****
**************************************
*/
life_definePlaceables = //Array aller Absperrungen (Cop + Medic)
[
 "RoadCone_F",
 "RoadCone_L_F",
 "RoadBarrier_F",
 "RoadBarrier_small_F",
 "PlasticBarrier_03_orange_F",
 "Land_CncBarrier_stripes_F",
 "Land_PortableLight_single_F",
 "Land_PortableLight_double_F"
];
life_bar_limit = 20; //Maximale Anzahl Absperrungen pro Person

// ACE-Einstellungen
{
  missionNamespace setVariable [_x,false];
} forEach ["ace_ballistics","ace_advanced_ballistics_allbullets","ace_advanced_ballistics_enabled","ace_interaction_enableteammanagement"];

// Master-Array von Gegenständen
// Initialisiere Variablen für virtuelle Gegenstände
{
    missionNamespace setVariable [ITEM_VARNAME(configName _x), 0];
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));

// Lizenzen initialisieren
{
    _varName = getText(_x >> "variable");
    _sideFlag = getText(_x >> "side");

    missionNamespace setVariable [LICENSE_VARNAME(_varName,_sideFlag), false];
} forEach ("true" configClasses (missionConfigFile >> "Licenses"));

// Versteckgebäude initialisieren
{
    _building = nearestBuilding getMarkerPos _x; 
    life_hideoutBuildings pushBack _building;
} forEach (LIFE_SETTINGS(getArray,"gang_area"));
