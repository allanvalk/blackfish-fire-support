// Script by [ Ares aka FunnyCookieEver ]
// Setup instruction are on GitHub page.
// You may modify and share this script as you want but please keep license and add original author as well as original repo.
// Support of this script in multiplayer or on a dedicated server is not tested.

if (!isServer) exitWith {};

_targetPoint = (_this select 0);
_supportTime = (_this select 1);
_supportCooldown = (_this select 2);
_spawnPoint = (_this select 3);

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
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
		"('ItemRadio' in assignedItems _this) and (currentWeapon _this in ['Laserdesignator']) and (laserTarget casOperator != objNull)",
		"('ItemRadio' in assignedItems _caller) and (currentWeapon _caller in ['Laserdesignator']) and (laserTarget casOperator != objNull)",
		{},
		{},
		{ [laserTarget casOperator, 120, 60, spawnPointPersistent] execVM "support.sqf"; },
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

supportPilot = driver supportVehicle;
supportActiveCommander = commander supportVehicle;
supportCommander = supportVehicle turretUnit [2];
supportGunner = gunner supportVehicle;

[supportPilot] join grpNull;
supportPilotGroup = group supportPilot;
supportPilotGroup setBehaviour "CARELESS";
supportPilot disableAI "SUPPRESSION";
supportPilot disableAI "COVER";
supportPilot disableAI "AUTOCOMBAT";
supportPilot disableAI "COVER";

_wp = supportPilotGroup addWaypoint [getPos targetPersistent, 0];
_wp setWaypointType "LOITER";
[supportPilotGroup, currentWaypoint supportPilotGroup] setWaypointLoiterType "CIRCLE_L";
[supportPilotGroup, currentWaypoint supportPilotGroup] setWaypointLoiterRadius 350;
supportVehicle flyInHeightASL [450, 450, 450];
supportVehicle flyInHeight 450;

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
		{ selectPlayer supportCommander; },						
		{},												
		[],												
		2,										
		0,											
		false,										
		false										
	] remoteExec ["BIS_fnc_holdActionAdd", 0, casOperator];	
	[
		casOperator,										
		"Control 25mm / 105mm",									
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"_this distance _target == 0",					
		"_caller distance _target == 0",						
		{},													
		{},												
		{ selectPlayer supportGunner; },						
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
	{ selectPlayer casOperator; },
	{},
	[],
	2,
	0,
	false,
	false
] remoteExec ["BIS_fnc_holdActionAdd", 0, supportVehicle];