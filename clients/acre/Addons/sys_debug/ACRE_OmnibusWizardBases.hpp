class RscText;

class ACRE_OmnibusWizard_BaseHeaderText {
	idc = -1;              // set to -1, unneeded
	moving = 1;            // left click (and hold) this control to move the dialog
						   // (requires "movingEnabled" to be 1, see above)
	type = CT_STATIC;      // constant
	style = ST_LEFT;       // constant
	font = FontM;
	sizeEx = 0.03;
	
	colorText[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1 };
	colorBackground[] = {0,0,0,0};
};

class ACRE_OmnibusWizardBase {
	idd = -1;
	onLoad = "";
	onUnload = "";
	movingEnable = false; 
	enableSimulation = true;
		
	controls[] = {};
	objects[] = {};
	controlsBackground[] = {"ACRE_OmnibusWizardBase_Background"};
	
	class ACRE_OmnibusWizardBase_Background
	{
		type = CT_STATIC;
        idc = -1;
        style = ST_BACKGROUND;
        font = FontM;
        sizeEx = 0.04;
		text = "";
		
		x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
		y = safeZoneY + safeZoneH - 0.6;
		h = 0.6;
		w = 0.6 * 3 / 4;
		
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.3,0.3,0.3,0.8};
	};
};