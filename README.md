# Blackfish Fire Support
Script that adds and ability to call V-44X Blackfish as close air support to any location in the **Arma 3** game. 
You may modify and share this script as you want but please keep license and add original author as well as a link to original repo. 
## Setup
* Download all files and place them in to the mission folder.
* Merge files if they already exist in the mission folder.
* In the [init.sqf](init.sqf) file change script config as you wish:
  * `[laserTarget casOperator, 120, 60, [15000,15000,0], 450, 350] execVM "support.sqf";`
  * **laserTarget casOperator** - center of loiter, target marked by laser designator.
  * **120** - time while support will be in the air since arrival near target.
  * **60** - cooldown time untill next support will be available.
  * **[15000,15000,0]** - location on map where CAS will be spawned.
  * **450** - height of flight.
  * **350** - radius of orbit.
* Place unit that should be able to call CAS and set its variable name to `casOperator`.
* Make sure unit has **radio** and **laser designator** equipped.

## Known Bugs
* ~~`laserTarget casOperator != objNull` condition doesn't care if laser off, because for some reason laser target constantly exits at unknown coordinates.~~ - Fixed
* Make sure unit has designator batteries and laser designator is **on**.
* Support of this script in **multiplayer** or on a **dedicated server** is not tested.
