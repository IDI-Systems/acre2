// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUT_BUTTON  16 // Arma 2 - textured button

#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_List_N_Box       102 // Arma 2 - N columns list box


// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

#define FontM             "TahomaB"
#define DEFAULTFONT       FontM

#define true              1
#define false             0
class RscMapControl;
class ACRE_Dummy_Map: RscMapControl {
	idc = -1;

	type=100;
	style=48;

	x = 0;
	y = 0;
	w = 1;
	h = 1;

	colorBackground[] = {1.00, 1.00, 1.00, 0};
	colorText[] = {0.00, 0.00, 0.00, 0};
	colorSea[] = {0.56, 0.80, 0.98, 0};
	colorForest[] = {0.60, 0.80, 0.20, 0};
	colorRocks[] = {0.50, 0.50, 0.50, 0};
	colorCountlines[] = {0.65, 0.45, 0.27, 0};
	colorMainCountlines[] = {0.65, 0.45, 0.27, 0};
	colorCountlinesWater[] = {0.00, 0.53, 1.00, 0};
	colorMainCountlinesWater[] = {0.00, 0.53, 1.00, 0};
	colorForestBorder[] = {0.40, 0.80, 0.00, 0};
	colorRocksBorder[] = {0.50, 0.50, 0.50, 0};
	colorPowerLines[] = {0.00, 0.00, 0.00, 0};
	colorNames[] = {0.00, 0.00, 0.00, 0};
	colorInactive[] = {1.00, 1.00, 1.00, 0};
	colorLevels[] = {0.00, 0.00, 0.00, 0};
	colorRailWay[] = {0.00, 0.00, 0.00, 0};
	colorOutside[] = {0.56, 0.80, 0.98, 0};

	font = "TahomaB";
	sizeEx = 0.00;

	stickX[] = {0.0, {"Gamma", 1.00, 1.50} };
	stickY[] = {0.0, {"Gamma", 1.00, 1.50} };
	ptsPerSquareSea = 0;
	ptsPerSquareTxt = 0;
	ptsPerSquareCLn = 0;
	ptsPerSquareExp = 0;
	ptsPerSquareCost = 0;
	ptsPerSquareFor = "0f";
	ptsPerSquareForEdge = "0f";
	ptsPerSquareRoad = 0;
	ptsPerSquareObj = 0;

	fontLabel = "TahomaB";
	sizeExLabel = 0.0;
	fontGrid = "TahomaB";
	sizeExGrid = 0.0;
	fontUnits = "TahomaB";
	sizeExUnits = 0.0;
	fontNames = "TahomaB";
	sizeExNames = 0.0;
	fontInfo = "TahomaB";
	sizeExInfo = 0.0;
	fontLevel = "TahomaB";
	sizeExLevel = 0.0;
    scaleMax = 1;
    scaleMin = 0.125;
	text = "";
	
	maxSatelliteAlpha = 0;	 // Alpha to 0 by default
	alphaFadeStartScale = 1.0; 
	alphaFadeEndScale = 1.1;   // Prevent div/0

	showCountourInterval=1;
	scaleDefault = 2;
};


class RscTitles
{
	class ACRE_FrameHandlerTitle {
		idd = 50902;
		movingEnable = 1;
        enableSimulation = 1;
        enableDisplay = 1;

        onLoad = QUOTE(_this call FUNC(perFrameEngine););

        duration = 99999999999999999;
        fadein  = 0;
        fadeout = 0;
		name = "ACRE_FrameHandlerTitle";
		class controlsBackground { 
			class dummy_map : ACRE_Dummy_Map {
				idc = 50909;
				x = 0; 
				y = 0;
				w = 0;  
				h = 0;
			};
		};
		class objects { 
			
		};
		class controls {
			
		};
	};
};