/*
	Copyright © 2016,International Development & Integration Systems, LLC
	All rights reserved.
	http://www.idi-systems.com/

	For personal use only. Military or commercial use is STRICTLY
	prohibited. Redistribution or modification of source code is 
	STRICTLY prohibited.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	POSSIBILITY OF SUCH DAMAGE.
*/
#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		units[] = {"ACRE_TestLoader"};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = { "acre_main", "acre_sys_sync", "acre_sys_rpc", "acre_sys_data" };
		AUTHOR;
		version = VERSION;
	};
};
#include "cfgEventhandlers.hpp"
#include "cfgSounds.hpp"
#include "cfgVehicles.hpp"
#include "dialogs.hpp"

class CfgAcreWorlds {
	
};


// class CfgFunctions
// {
	// class ACRE
	// {
		// class steam
		// {
			// class boot_copy
			// {
				// preStart = 1;//"call compile preprocessFileLineNumbers  ""idi\clients\acre\addons\sys_core\steam_boot.sqf""; 1"; // 1 to call the function upon game start, before title screen, but after all addons are loaded.
                // file = "idi\clients\acre\addons\sys_core\steam_ghost.sqf";
                // headerType = "call compile preprocessFileLineNumbers  ""idi\clients\acre\addons\sys_core\steam_boot.sqf""; -1"
			// };
		// };
	// };
// };


// THIS IS A MASSIVE ANNOYING HACK BUT ITS THE ONLY RELIABLE WAY TO DO THIS 
// AND NOT GET GRAPHICAL GLITCHES WITH FULLSCREEN IF THERE IS AN ERROR!
tooltipDelay = "call compile preprocessFileLineNumbers  ""idi\clients\acre\addons\sys_core\steam_boot.sqf""; 0;";
