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
class Extended_PreInit_EventHandlers {
	class ADDON	{
		init = QUOTE(call COMPILE_FILE(XEH_pre_init));
	};
};
class Extended_PostInit_EventHandlers {
	class ADDON	{
		init = QUOTE(call COMPILE_FILE(XEH_post_init));
	};
};
class Extended_GetIn_EventHandlers {
	class Car {
		GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
	};
	class Tank {
		GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
	};
	class Static {
		GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
	};
	class Air {
		GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
	};
};
class Extended_GetOut_EventHandlers {
	class Car {
		GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
	};
	class Tank {
		GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
	};
	class Static {
		GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
	};
	class Air {
		GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
	};
};
class Extended_Killed_EventHandlers {
    class Man {
        ADDON = QUOTE(_this call FUNC(onPlayerKilled));
    };
};