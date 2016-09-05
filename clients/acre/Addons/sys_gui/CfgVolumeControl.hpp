#include "MyDialogDefines.hpp"

class RscSlider;
class RscXSliderH;
class RscText;

class RscTitles
{
	class GVAR(VolumeControlDialog) 
	{
		idd = 10568; 
		movingEnable = 1; 
		enableSimulation = 1;
		enableDisplay = 1; 
		
		onLoad = QUOTE(GVAR(VolumeControlDialog) = _this;); 
		onunLoad = QUOTE( GVAR(VolumeControlDialog) = _this; ); 
		
		duration = 9999;
		fadein = 0;
		fadeout = 0; 
		
		class controls
		{
			class RscSlider_1900: RscXSliderH
			{
				idc = 1900;
				x = 0.378232 * safezoneW + safezoneX;
				y = 0.706242 * safezoneH + safezoneY;
				w = 0.25695 * safezoneW;
				h = 0.03 * safezoneH;
			};
			/*class RscText_1000: RscText
			{
				idc = 1000;
				text = "Shout";
				x = 0.636093 * safezoneW + safezoneX;
				y = 0.692493 * safezoneH + safezoneY;
				w = 0.0458419 * safezoneW;
				h = 0.0549979 * safezoneH;
			};
			class RscText_1001: RscText
			{
				idc = 1001;
				text = "Whisper";
				x = 0.328093 * safezoneW + safezoneX;
				y = 0.692493 * safezoneH + safezoneY;
				w = 0.0458419 * safezoneW;
				h = 0.0549979 * safezoneH;
			};
			class RscText_1002: RscText
			{
				idc = 1002;
				text = "Normal";
				x = 0.478512 * safezoneW + safezoneX;
				y = 0.719992 * safezoneH + safezoneY;
				w = 0.0458419 * safezoneW;
				h = 0.0549979 * safezoneH;
			};*/
		};
	};
	
	class GVAR(VolumeControlDialog_Close) 
	{
		idd = 10569; 
		movingEnable = 1; 
		enableSimulation = 1;
		enableDisplay = 1; 
		
		onLoad = ""; 
		
		duration = 0;
		fadein = 0;
		fadeout = 0; 
	};
};