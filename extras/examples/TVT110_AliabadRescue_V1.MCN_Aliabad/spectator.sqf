//gdtmod_seagull.sqf
//by HeinBloed
//http://www.gdt-server.net/
//
//===========================
private["_keydown_Help", "_keydown_NightVision", "_keydown_camconstruct", "_keydown_switchCamera", "_mousez", "_playableUnits", "_z"];

sandi_spectating = true; 
 
gdtmod_seagull_nvg = false;
gdtmod_seagull_camera_on = true;
gdtmod_seagull_camera_help = false;

gdtmod_seagull_players = [];
{if (alive _x && _x distance specPen > 200 and _x != player) then {gdtmod_seagull_players = gdtmod_seagull_players + [_x]; }} foreach allUnits;
gdtmod_seagull_players_count = count gdtmod_seagull_players - 1;

gdtmod_seagull_target = specloc;
gdtmod_seagull_players_select = 0;

gdtspec_on = true;

setAperture -1;
sleep 1;
gdtmod_seagull_camera = "camconstruct" camcreate [getPos specloc select 0, (getPos specloc select 1), (getPos specloc select 2)];
gdtmod_seagull_camera setdir (getdir specloc);	
gdtmod_seagull_camera camConstuctionSetParams [getPos specloc, 20000, 10000];
gdtmod_seagull_camera cameraeffect ["internal","back"];
titleText ["", "BLACK IN", 0.2];

//with uiNamespace {

	_keydown_help = (finddisplay 46) displayaddeventhandler ["keydown", "
		if ((_this select 1) in (actionkeys 'Help')) then {
			if (not gdtmod_seagull_camera_help) then {
				cutText ['Mousewheel:                     Camera jumps to player positions\nLeft mouse button:                                     Freelock\nRight mouse button:                     Camera locked on Player\nMovement keys and mouse:                          Move camera\n\nQ:                                              Move camera up\nY or Z:                                      Move camera down\nSHIFT Left:                                      Slow movement\n\nNightvision key:                              Nightvision On/Off\n\nWhile the camera is locked on a player you can change between\n1st/3rd person, optics and group view.\nPress the help button to exit the help screen.', 'BLACK OUT'];
				gdtmod_seagull_camera_help = true;
			}
			else {
				cutText ['Mousewheel:                     Camera jumps to player positions\nLeft mouse button:                                     Freelock\nRight mouse button:                     Camera locked on Player\nMovement keys and mouse:                          Move camera\n\nQ:                                              Move camera up\nY or Z:                                      Move camera down\nSHIFT Left:                                      Slow movement\n\nNightvision key:                              Nightvision On/Off\n\nWhile the camera is locked on a player you can change between\n1st/3rd person, optics and group view.\nPress the help button to exit the help screen.', 'BLACK IN'];
				gdtmod_seagull_camera_help = false;
			};
		};
	"];
	_keydown_nightVision = (finddisplay 46) displayaddeventhandler ["keydown", "
		if ((_this select 1) in (actionkeys 'NightVision')) then {
			if (gdtmod_seagull_nvg) then {
			  camUseNVG false;
				gdtmod_seagull_nvg = false;
			}	else {
			  camUseNVG true;
				gdtmod_seagull_nvg = true;
			};
	  };
	"];
	_keydown_camConstruct = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
		if (((_this select 1) == 0) and (not gdtmod_seagull_camera_on)) then {
			gdtmod_seagull_camera cameraeffect ['internal', 'back'];
			gdtmod_seagull_camera setpos [((position gdtmod_seagull_target) select 0) + ((sin (getdir gdtmod_seagull_target)) * ( - 10)), ((position gdtmod_seagull_target) select 1) + ((cos (getdir gdtmod_seagull_target)) * (- 10)), ((position gdtmod_seagull_target) select 2) + 2];
			gdtmod_seagull_camera setdir getdir gdtmod_seagull_target;		
			gdtmod_seagull_camera_on = true;
	  };
	"];
	_keydown_switchCamera = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
		if (((_this select 1) == 1) and gdtmod_seagull_camera_on) then {
			if (not (alive (gdtmod_seagull_players select gdtmod_seagull_players_select)) || (gdtmod_seagull_players select gdtmod_seagull_players_select) distance specPen < 200) then {
				while {not (alive (gdtmod_seagull_players select gdtmod_seagull_players_select)) || (gdtmod_seagull_players select gdtmod_seagull_players_select) distance specPen < 200} do {
					gdtmod_seagull_players_select = gdtmod_seagull_players_select + 1;
					if (gdtmod_seagull_players_select > gdtmod_seagull_players_count) then {gdtmod_seagull_players_select = 0};
				};
				gdtmod_seagull_target = vehicle (gdtmod_seagull_players select gdtmod_seagull_players_select);
			};
			gdtmod_seagull_camera cameraeffect ['Terminate', 'back'];
			cutText [format['                   %1', name gdtmod_seagull_target],'PLAIN DOWN'];
			gdtmod_seagull_target switchCamera 'EXTERNAL';
			gdtmod_seagull_camera_on = false;
			gdtmod_seagull_camera_help = false;
	  };
	"];
	_keydown_mouseZ = (findDisplay 46) displayAddEventHandler ["mousezchanged", "
		if (count gdtmod_seagull_players > 0) then {
			_z = _this select 1;
			if (_z  < 0) then {
				gdtmod_seagull_players_select = gdtmod_seagull_players_select - 1;
				if (gdtmod_seagull_players_select < 0) then {gdtmod_seagull_players_select = gdtmod_seagull_players_count};
				while {not (alive (gdtmod_seagull_players select gdtmod_seagull_players_select)) || (gdtmod_seagull_players select gdtmod_seagull_players_select) distance specPen < 200} do {
					gdtmod_seagull_players_select = gdtmod_seagull_players_select - 1;
					if (gdtmod_seagull_players_select < 0) then {gdtmod_seagull_players_select = gdtmod_seagull_players_count};
				};
				gdtmod_seagull_target = vehicle (gdtmod_seagull_players select gdtmod_seagull_players_select);		
			}
			else {
				gdtmod_seagull_players_select = gdtmod_seagull_players_select + 1;
				if (gdtmod_seagull_players_select > gdtmod_seagull_players_count) then {gdtmod_seagull_players_select = 0};
				while {not (alive (gdtmod_seagull_players select gdtmod_seagull_players_select)) || (gdtmod_seagull_players select gdtmod_seagull_players_select) distance specPen < 200} do {
					gdtmod_seagull_players_select = gdtmod_seagull_players_select + 1;
					if (gdtmod_seagull_players_select > gdtmod_seagull_players_count) then {gdtmod_seagull_players_select = 0};
				};
				gdtmod_seagull_target = vehicle (gdtmod_seagull_players select gdtmod_seagull_players_select);
			};
			cutText [format['                   %1', name gdtmod_seagull_target], 'PLAIN DOWN'];
			if (gdtmod_seagull_camera_on) then {
			  gdtmod_seagull_camera setpos [((position gdtmod_seagull_target) select 0) + ((sin (getdir gdtmod_seagull_target)) * ( - 10)), ((position gdtmod_seagull_target) select 1) + ((cos (getdir gdtmod_seagull_target)) * (- 10)), ((position gdtmod_seagull_target) select 2) + 2];
			  gdtmod_seagull_camera setdir getdir gdtmod_seagull_target;
			}	else {
			  gdtmod_seagull_target switchCamera 'EXTERNAL';
			};
			gdtmod_seagull_camera_help = false;
		};
	"];
//};

//while {player distance specPen < 100} do {
while {true} do {

	gdtmod_seagull_players = [];
	{if ((alive _x) && (_x distance specPen > 200) && (_x != player) && (isPlayer _x) && (vehiclevarname _x != "camman")) then {gdtmod_seagull_players = gdtmod_seagull_players + [_x]; }} foreach allUnits;
	gdtmod_seagull_players_count = count gdtmod_seagull_players - 1;

  sleep 0.25;
};
