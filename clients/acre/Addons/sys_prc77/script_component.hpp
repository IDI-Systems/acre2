/*
	Copyright © 2016, International Development & Integration Systems, LLC
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
#define COMPONENT sys_prc77

#include "\idi\clients\acre\Addons\main\script_mod.hpp"

//#define DEBUG_ENABLED_SYS_PRC77
#ifdef DEBUG_ENABLED_SYS_PRC77
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_PRC77
	#define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_PRC77
#endif


#include "\idi\clients\acre\Addons\main\script_macros.hpp"

#define GET_VAR(var1) acre_player getVariable QUOTE(GVAR(var1))
#define SET_VAR(var1,var2) acre_player setVariable [QUOTE(GVAR(var1)), var2]

#define GET_STATE(id)			([GVAR(currentRadioId), "getState", #id] call acre_sys_data_fnc_dataEvent)
#define SET_STATE(id, val)		([GVAR(currentRadioId), "setState", [#id, val]] call acre_sys_data_fnc_dataEvent)
#define SET_STATE_CRIT(id, val)	([GVAR(currentRadioId), "setStateCritical", [#id, val]] call acre_sys_data_fnc_dataEvent)

#define MAIN_DISPLAY	(findDisplay 31337)

#include "\idi\clients\acre\Addons\sys_components\script_acre_component_defines.hpp"