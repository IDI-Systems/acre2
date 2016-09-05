/*
	Copyright © 2010,International Development & Integration Systems, LLC
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
class CfgPatches {
	class acre_game {
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.01;
		requiredAddons[] = { "A3_Weapons_F", "Extended_EventHandlers", "CBA_MAIN"  };
		author = "ACRE2 Team";
	};
};


#include "CfgWeapons.hpp"
#include "CfgEventhandlers.hpp"

class CfgLocationTypes {
    class AcreHashType {
        color[] = {0,0,0,0};
        drawStyle = "acre";
        font = "PuristaMedium";
        importance = 0;
        name = "acre";
        shadow = 0;
        size = 0;
        textSize = 0.0;
        texture = "";
    };
};
