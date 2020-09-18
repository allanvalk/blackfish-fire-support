// Script by [ Ares aka FunnyCookieEver ]
// Setup instruction are on GitHub page.
// You may modify and share this script as you want but please keep license and add original author as well as original repo.
// Support of this script in multiplayer or on a dedicated server is not tested.

if (!isServer) exitWith {};

_targetPoint = (_this select 0);
_supportTime = (_this select 1);
_supportCooldown = (_this select 2);
_spawnPoint = (_this select 3);
_flightHeight = (_this select 4);
_flightRadius = (_this select 5);
_side = (_this select 6);

sidePersistent = _side;
flightHeightPersistent = _flightHeight;
flightRadiusPersistent = _flightRadius;
spawnPointPersistent = _spawnPoint;
targetPersistent = "Land_HelipadEmpty_F" createVehicle position _targetPoint;

[ casOperator, 0 ] call BIS_fnc_holdActionRemove;

supportRTB = {
	supportPilotGroup addWaypoint [[0,0,0], 0];

	[ supportVehicle, 0 ] call BIS_fnc_holdActionRemove;
	removeAllActions casOperator;

	sleep 5;

	[selectRandom supportSoundListLeave] remoteExec ["playSound", 0, true];
	_nil = ["Dropkick","We are bingo fuel, heading back to base.",5] execVM "titles.sqf";

	sleep 60;

	{
		deleteVehicle _x;
	} forEach crew supportVehicle;

	deleteVehicle supportVehicle;
	deleteVehicle targetPersistent;

	{
		missionNamespace setVariable [str _x, nil];
	} forEach supportList;

	[
		casOperator,
		"Call CAS",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",
		"('ItemRadio' in assignedItems _this) and (currentWeapon _this in ['Laserdesignator']) and ((((getPos laserTarget casOperator) select 0) > 1) and (((getPos laserTarget casOperator) select 1) > 1))",
		"('ItemRadio' in assignedItems _caller) and (currentWeapon _caller in ['Laserdesignator']) and ((((getPos laserTarget casOperator) select 0) > 1) and (((getPos laserTarget casOperator) select 1) > 1))",
		{},
		{},
		{ [laserTarget casOperator, 120, 60, spawnPointPersistent, flightHeightPersistent, flightRadiusPersistent, sidePersistent] execVM "support.sqf"; },
		{},
		[],
		5,
		0,
		true,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, casOperator];
};

supportVehicle = createVehicle ["B_T_VTOL_01_armed_F", _spawnPoint, [], 0, "FLY"];
supportGroup = createVehicleCrew supportVehicle;
supportVehicle allowDamage false;

supportVehicle setVehicleLock "LOCKED";

supportPilot = driver supportVehicle;
supportActiveCommander = commander supportVehicle;
supportCommander = supportVehicle turretUnit [2];
supportGunner = gunner supportVehicle;

_supportSwitchSide = createGroup sidePersistent;

{
	[_x] joinSilent _supportSwitchSide;
} forEach units supportGroup;

[supportPilot] join grpNull;
supportPilotGroup = group supportPilot;
supportPilotGroup setBehaviour "CARELESS";
supportPilot disableAI "SUPPRESSION";
supportPilot disableAI "COVER";
supportPilot disableAI "AUTOCOMBAT";
supportPilot disableAI "COVER";
supportPilot disableAI "AUTOTARGET";
supportPilot disableAI "TARGET";

// Disable VCOM AI on crew

supportPilotGroup setVariable ["VCM_NOFLANK",true];
supportPilotGroup setVariable ["VCM_NORESCUE",true];
supportPilotGroup setVariable ["VCM_TOUGHSQUAD",true];
supportPilotGroup setVariable ["Vcm_Disable",true];
supportPilotGroup setVariable ["VCM_DisableForm",true];
supportPilotGroup setVariable ["VCM_Skilldisable",true];
_supportSwitchSide setVariable ["VCM_NOFLANK",true];
_supportSwitchSide setVariable ["VCM_NORESCUE",true];
_supportSwitchSide setVariable ["VCM_TOUGHSQUAD",true];
_supportSwitchSide setVariable ["Vcm_Disable",true];
_supportSwitchSide setVariable ["VCM_DisableForm",true];
_supportSwitchSide setVariable ["VCM_Skilldisable",true];

// End of VCOM AI part

_wp = supportPilotGroup addWaypoint [getPos targetPersistent, 0];
_wp setWaypointType "LOITER";
[supportPilotGroup, currentWaypoint supportPilotGroup] setWaypointLoiterType "CIRCLE_L";
[supportPilotGroup, currentWaypoint supportPilotGroup] setWaypointLoiterRadius flightRadiusPersistent;
supportVehicle flyInHeightASL [flightHeightPersistent, flightHeightPersistent, flightHeightPersistent];
supportVehicle flyInHeight flightHeightPersistent;

supportVehicle setEffectiveCommander supportActiveCommander;

supportList = [supportVehicle, supportGroup, supportPilot, supportCommander, supportGunner, supportPilotGroup];

_nil = [] spawn {
	waitUntil { supportVehicle distance targetPersistent < 1000};
		[
		casOperator,	
		"Control 40mm",				
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	
		"_this distance _target == 0",					
		"_caller distance _target == 0",				
		{},												
		{},											
		{ selectPlayer supportCommander; casOperator allowDamage false;},						
		{},												
		[],												
		2,										
		0,											
		false,										
		false										
	] remoteExec ["BIS_fnc_holdActionAdd", 0, casOperator];	
	[
		casOperator,										
		"Control 20mm / 105mm",									
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"_this distance _target == 0",					
		"_caller distance _target == 0",						
		{},													
		{},												
		{ selectPlayer supportGunner; casOperator allowDamage false;},						
		{},												
		[],													
		2,													
		0,												
		false,											
		false											
	] remoteExec ["BIS_fnc_holdActionAdd", 0, casOperator];
	[selectRandom supportSoundListArrive] remoteExec ["playSound", 0, true];
	_nil = ["Dropkick","Arriving in the AO, transfering fire control.",5] execVM "titles.sqf";
	_timer = 0;
	while {_timer < 120} do {
		_timer = _timer + 1;
		sleep 1;
	};
	[ supportVehicle, 0 ] call BIS_fnc_holdActionRemove;
	removeAllActions casOperator;
	selectPlayer casOperator;
	casOperator allowDamage true;
	removeSwitchableUnit supportCommander;
	removeSwitchableUnit supportGunner;
	deleteWaypoint [supportPilotGroup, currentWaypoint supportPilotGroup];
	call supportRTB;
};

{
	_x setSkill 1;
} forEach units supportGroup;

_nil = [] spawn {
	while {alive supportVehicle} do {
		[supportVehicle, selectRandom supportSoundChatter] remoteExec ["say3D", 0, true];
		sleep 15;
	};
};

[
	supportVehicle,
	"Drop Connection",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
	"_this in supportVehicle",
	"_caller in supportVehicle",
	{},
	{},
	{ selectPlayer casOperator; casOperator allowDamage true;},
	{},
	[],
	2,
	0,
	false,
	false
] remoteExec ["BIS_fnc_holdActionAdd", 0, supportVehicle];