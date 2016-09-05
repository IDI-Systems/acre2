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

NO_DEDICATED;

ADDON = false;

// Volume control
PREP(openVolumeControl);
PREP(closeVolumeControl);
PREP(onVolumeControlAdjust);
PREP(onVolumeControlKeyPress);
PREP(onVolumeControlKeyPressUp);
PREP(onVolumeControlSliderChanged);
PREP(setVolumeSliderColor);

PREP(enableZeusOverlay);
PREP(setZeusOverlayDetail);
PREP(disableZeusOverlay);

PREP(openInventory);
PREP(closeInventory);

PREP(onInventoryRadioSelected);
PREP(onInventoryRadioDoubleClick);

ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
DFUNC(inventoryListMouseDown) = {
	if((_this select 1) == 1) then {
		ACRE_HOLD_OFF_ITEMRADIO_CHECK = true;
		acre_player unassignItem "ItemRadioAcreFlagged";
		acre_player removeItem "ItemRadioAcreFlagged";
	};
};

DFUNC(inventoryListMouseUp) = {
	if((_this select 1) == 1) then {
		ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
	};
};

//[] call FUNC(initializeVolumeControl);

DVAR(ACRE_CustomVolumeControl) = nil;
GVAR(VolumeControl_Level) = 0; // range of -2 to +2
GVAR(keyBlock) = false;

ADDON = true;
