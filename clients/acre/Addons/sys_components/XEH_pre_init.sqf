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

PREP(attachComplexComponent);
PREP(attachSimpleComponent);
PREP(attachComponentHandler);
PREP(initializeComponent);
PREP(findAntenna);
PREP(detachComponent);
PREP(detachComponentHandler);
PREP(sendComponentMessage);
PREP(handleComponentMessage);
PREP(getAllConnectedComponents);
PREP(getAllAvailableConnectors);
PREP(connectorConnected);
PREP(getComponentTree);

DFUNC(getAntennaDirMan) = {
    private ["_forwardV", "_upV"];
	params ["_obj"];
    //@TODO: This is a hack fix for vehicles having funky up vectors when people are inside...
    if(vehicle _obj == _obj) then {
        _spinePos = (_obj selectionPosition "Spine3");
        _upV = _spinePos vectorFromTo (_obj selectionPosition "Neck");
        
        _upP = _upV call cba_fnc_vect2polar;
        _upP set[2, (_upP select 2)-90];
        _forwardV = _upP call cba_fnc_polar2vect;
        
        _forwardV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _forwardV)));
        _upV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _upV)));
    } else {
        _forwardV = vectorDir (vehicle _obj);
        _upV = vectorUp (vehicle _obj);
    };
    [_forwardV, _upV];
};

ADDON = true;