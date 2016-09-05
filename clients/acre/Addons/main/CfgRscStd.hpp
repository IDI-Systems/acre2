#include "script_dialog_defines.hpp"

class RscStandardDisplay;
class RscText;
class RscActiveText;
class RscStructuredText;
class RscEdit;
class RscButton_small;

class RscDisplayMain: RscStandardDisplay {
	class controlsBackground {
		class ACRE_VERSION_TXT: RscText {
			idc = -1;
			style = ST_LEFT + ST_SHADOW;
			__SX(0.021);
			__SY(0.85);
			__SW(0.3);
			__SH(0.05);
			//colorText[] = { 1, 1, 1, 1 };
			sizeEx = 0.02674;
			#include "version.hpp"
		};
	};
};

