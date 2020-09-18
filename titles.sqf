// _nil = ["Speaker","Line",5] execVM "titles.sqf";
// Script by Ares / FunnyCookieEver

private ["_name", "_text","_ulength"];

_name = _this select 0;
_text = _this select 1;
_ulength = _this select 2;

_length = _ulength / 10;

_temparray = [];
_separate = "<t color='#FFD500'size=2>: <t/>";

_uname = format ["%1%2%3","<t color='#FFD500' size=2>", _name, "</t>"];
_utext = format ["%1%2%3","<t color='#FFFFFF' size=2>", _text, "</t>"];
_temparray = [_uname,_utext];
_alpha = _temparray joinString _separate;

cutText [_alpha, "PLAIN DOWN", _length, true, true];
