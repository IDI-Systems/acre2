class ACRE_OmnibusWizardMain : ACRE_OmnibusWizardBase {
	idd = 80085;
	
	class controls 
	{
		class TitleText : ACRE_OmnibusWizard_BaseHeaderText 
		{
			text = "ACRE Omnibus Status Wizard";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.6;
			h = 0.05;
			w = 0.6 * 3 / 4;
			sizeEx = 0.05;
		};
		class StatusText : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc = 999;
			text = "Performing system check...";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.55;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class ProgressBar 
		{
			idc = 1000;
			x = (safeZoneX + safeZoneW - 0.6 * 3 / 4) + 0.01; 
			y = safeZoneY + safeZoneH - 0.52;
			h = 0.05;
			w = (0.6 * 3 / 4) - 0.02;
			type = 8;
			style = 0;
			colorFrame[] = {0.3,0.3,0.3,1};
			colorBar[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1 };
			texture = "#(argb,8,8,3)color(1,1,1,1)";
			tooltip = "ST_HORIZONTAL";
		};
		
		class DisplayLine1 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1001;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.47;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine2 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1002;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.44;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine3 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1003;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.41;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine4 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1004;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.38;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine5 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1005;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.35;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine6 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1006;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.32;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine7 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1007;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.29;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine8 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1008;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.26;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine9 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1009;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.23;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine10 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1010;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.20;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine11 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1011;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.17;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine12 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1012;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.14;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine13 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1013;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.11;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine14 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1014;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.08;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
		class DisplayLine15 : ACRE_OmnibusWizard_BaseHeaderText 
		{
			idc=1015;
			text = "";
			x = safeZoneX + safeZoneW - 0.6 * 3 / 4; 
			y = safeZoneY + safeZoneH - 0.05;
			h = 0.03;
			w = 0.6 * 3 / 4;
		};
	};	
};