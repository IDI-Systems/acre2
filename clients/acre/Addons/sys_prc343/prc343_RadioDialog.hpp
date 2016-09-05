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
#include "script_component.hpp"

#define CODE_SPACING	0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name : parent { idc = idval;
#define END_CONTROL		};

#define NEW_SCALE 0.85
#define SCALE (NEW_SCALE/0.8)


class PRC343_RadioDialog {
	idd = 31337;
	MovingEnable = 0;
	onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
	onLoad = QUOTE(_this call FUNC(render));
	controlsBackground[] = {PRC343Background};
	objects[] = {};
	class PRC343Background
	{
		type = CT_STATIC;
		idc = 99999;
		style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {1, 1, 1, 1};
		font = FontM;
		sizeEx = 0.04;
		/*x = SafeZoneY;
		y = ((0.5-((0.8*SafeZoneH)/2)));
		w = 1*SafeZoneH;
		h = 0.8*SafeZoneH;*/

		x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
		y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
		w = NEW_SCALE*safeZoneH;
		h = NEW_SCALE*safeZoneH;

		text = QUOTE(PATHTOF(Data\static\prc343_ui_backplate.paa));
	};
	class controls {
		BEGIN_CONTROL(ChannelKnob, Prc343_RscPicture, 106)
			x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
			y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
			w = NEW_SCALE*safeZoneH;
			h = NEW_SCALE*safeZoneH;
			text = QUOTE(PATHTOF(Data\knobs\channel\prc343_ui_pre_1.paa));
		END_CONTROL

		BEGIN_CONTROL(ChannelKnobButton, Prc343_RscButton, 201)
			x = (((((0.416+0.085)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			y = ((((0.28-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			w = SCALE*0.072*SafeZoneH;
			h = SCALE*0.1*SafeZoneH;
			colorBackground[] = {1, 0, 0, 0};
			text = "";
			onMouseButtonUp = "[_this,0] call acre_sys_prc343_fnc_onChannelKnobPress";
			toolTip = QUOTE(Change channel);
		END_CONTROL

		BEGIN_CONTROL(VolumeKnob, Prc343_RscPicture, 107)
			x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
			y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
			w = NEW_SCALE*safeZoneH;
			h = NEW_SCALE*safeZoneH;
			text = QUOTE(PATHTOF(Data\knobs\volume\prc343_ui_vol_5.paa));
		END_CONTROL

		BEGIN_CONTROL(VolumeKnobButton, Prc343_RscButton, 202)
			x = ((((0.416-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			y = ((((0.28-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			w = SCALE*0.072*SafeZoneH;
			h = SCALE*0.1*SafeZoneH;
			colorBackground[] = {0, 1, 0, 0};
			text = "";
			onMouseButtonUp = QUOTE(_this call FUNC(onVolumeKnobPress));
			toolTip = QUOTE(Change volume);
		END_CONTROL

		BEGIN_CONTROL(PTTHandleButton, Prc343_RscButton, 203)
			x = ((((0.255-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			y = ((((0.377-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			w = SCALE*0.07*SafeZoneH;
			h = SCALE*0.4*SafeZoneH;
			//colorBackground[] = {0, 0, 1, 0.2};
			text = "";
			onMouseButtonUp = QUOTE(_this call FUNC(onPTTHandlePress));
			toolTip = QUOTE(Detach Handle);
		END_CONTROL

		BEGIN_CONTROL(ChannelBlockButton, Prc343_RscButton, 204)
			x = ((((0.515-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			y = ((((0.6-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
			w = SCALE*0.03*SafeZoneH;
			h = SCALE*0.05*SafeZoneH;
			//colorBackground[] = {1, 1, 1, 0.2};
			text = "";
			onMouseButtonUp = "[_this,1] call acre_sys_prc343_fnc_onChannelKnobPress";
			toolTip = QUOTE(Current channel block: 1);
		END_CONTROL
	};
};
