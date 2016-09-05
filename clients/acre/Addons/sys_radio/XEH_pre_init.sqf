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

ADDON = false;

PREP(monitorRadios);

PREP(setActiveRadio);

PREP(openRadio);
PREP(listRadios);
PREP(onDialogClose);

PREP(initDefaultRadio);
PREP(onReturnRadioId);

PREP(getRadioVolume);
PREP(setRadioVolume);


PREP(setRadioSpatial);
PREP(getRadioSpatial);

PREP(getRadioPos);
PREP(getRadioObject);
PREP(getRadioSubObject);
PREP(radioObjectsSame);
PREP(radioExists);
PREP(nearRadios);
PREP(playRadioSound);
PREP(handleRadioSpatialKeyPressed);

PREP(onPlayerKilled);



NO_DEDICATED;

DGVAR(workingRadioList) = [];
DGVAR(currentRadioList) = [];

// Addition for compat: Compat features / remote features can add a radio here.
// TODO: not managed by monitorRadios yet
DGVAR(auxRadioList) = [];
DGVAR(pendingClaim) = 0;
DGVAR(replacementRadioIdList) = [];

// handler callbacks
DGVAR(radioListHandlers) = [];
DGVAR(lostRadioHandlers) = [];
DGVAR(gotRadioHandlers) = [];

DGVAR(currentRadioDialog) = "";

DVAR(ACRE_ACTIVE_RADIO) = "";
DVAR(ACRE_SPECTATOR_RADIOS) = [];

// this isn't used anymore i do not think?
// acre_player setVariable [QUOTE(GVAR(currentRadioList)), []];

if(isNil QUOTE(GVAR(defaultItemRadioType))) then {
	GVAR(defaultItemRadioType) = "ACRE_PRC343";
};

DGVAR(pendingClaim)  = 0;

ADDON = true;
