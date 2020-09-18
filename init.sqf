// blackfish-fire-support script
supportSoundListArrive = ['Sound_supportArrive_0', 'Sound_supportArrive_1', 'Sound_supportArrive_2'];
supportSoundListLeave = ['Sound_supportLeave_0', 'Sound_supportLeave_1', 'Sound_supportLeave_2'];
supportSoundChatter = ['Sound_supportChatter_0', 'Sound_supportChatter_1', 'Sound_supportChatter_2', 'Sound_supportChatter_3', 'Sound_supportChatter_4', 'Sound_supportChatter_5', 'Sound_supportChatter_6', 'Sound_supportChatter_7', 'Sound_supportChatter_8'];

_nil = [] spawn {
	[
		casOperator,
		"Call CAS",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
		"('ItemRadio' in assignedItems _this) and (currentWeapon _this in ['Laserdesignator']) and (laserTarget casOperator != objNull)",
		"('ItemRadio' in assignedItems _caller) and (currentWeapon _caller in ['Laserdesignator']) and (laserTarget casOperator != objNull)",
		{},
		{},
		{ [laserTarget casOperator, 120, 60] execVM "support.sqf"; },
		{},
		[],
		5,
		0,
		false,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, casOperator];
};
// end of blackfish-fire-support script