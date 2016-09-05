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

class Vodnik : Tank {
	class gunner {
		hasCrewIntercom = 1;

		class inside { // open turret
			class other      { attenuationValue = 0.2; };
			class driver     { attenuationValue = 0.0; };
			class commander  { attenuationValue = 0.0; };
			class cargo      { attenuationValue = 0.2; };
			attenuateOutside = 0.2;
		};
		class turnedout { // open turret
			class other      { attenuationValue = 0.2; };
			class driver     { attenuationValue = 0.0; };
			class commander  { attenuationValue = 0.0; };
			class cargo      { attenuationValue = 0.2; };
			attenuateOutside = 0.2;
		};
	};
}; 

class M113 : DefaultAttenuation {
	positions[] = { gunner, driver, cargo, other };
	class gunner {
		hasCrewIntercom = 1;

		class inside { // open turret
			class other      { attenuationValue = 0.2; };
			class driver     { attenuationValue = 0.0; };
			class cargo      { attenuationValue = 0.2; };
			attenuateOutside = 0.2;
		};
		class turnedout { // open turret
			class other      { attenuationValue = 0.2; };
			class driver     { attenuationValue = 0.0; };
			class cargo      { attenuationValue = 0.2; };
			attenuateOutside = 0.2;
		};
	};
	class driver {
		hasCrewIntercom = 1;

		class inside {
			class gunner     { attenuationValue = 0.0; };
			attenuateOutside = 0.4;
		};
		class turnedout {
			class other      { attenuationValue = 0.2; };
			class gunner     { attenuationValue = 0.0; };
			class cargo      { attenuationValue = 0.2; };
			attenuateOutside = 0.2;
		};
	};
	class cargo {
		class inside {
			class gunner     { attenuationValue = 0.2; };
			attenuateOutside = 0.9;
		};
	};
	class other {
		class inside {
			class gunner     { attenuationValue = 0.2; };
			attenuateOutside = 0.9;
		};
	};
};

class BTR : DefaultAttenuation {
	positions[] = { gunner, commander, driver, cargo, other };
	class gunner {
		class inside {
			attenuateOutside = 1;
			class driver { attenuationValue = 0.0; };
			class commander { attenuationValue = 0.0; };
		};
		class outside {
			attenuateOutside = 0;
			class driver { attenuationValue = 0.0; };
			class commander { attenuationValue = 0.0; };
		};
	};
	class commander {
		class inside {
			attenuateOutside = 1;
			class driver { attenuationValue = 0.0; };
			class gunner { attenuationValue = 0.0; };
		};
		class outside {
			attenuateOutside = 0;
			class driver { attenuationValue = 0.0; };
			class gunner { attenuationValue = 0.0; };
		};
	};
	class driver {
		class inside {
			attenuateOutside = 1;
			class gunner { attenuationValue = 0.0; };
			class commander { attenuationValue = 0.0; };
		};
		class outside {
			attenuateOutside = 0;
			class gunner { attenuationValue = 0.0; };
			class commander { attenuationValue = 0.0; };
		};
	};
	class cargo {
		class inside {
			attenuateOutside = 1;
		};
	};
	class other {
		class inside {
			attenuateOutside = 1;
		};
	};
};

class Bradley : DefaultAttenuation {
	positions[] = { gunner, commander, driver, cargo};
	
	class gunner {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class commander {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class driver {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class cargo {
		class inside {
			attenuateOutside = 1;
			class driver      { attenuationValue = 0.2; };
			class gunner      { attenuationValue = 0.2; };
			class commander      { attenuationValue = 0.2; };
		};
	};
};

class Stryker : DefaultAttenuation {
	positions[] = { gunner, commander, driver, cargo};
	
	class gunner {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class commander {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class driver {
		class inside {
			attenuateOutside = 1;
			class cargo      { attenuationValue = 0.4; };
		};
	};
	class cargo {
		class inside {
			attenuateOutside = 1;
			class driver      { attenuationValue = 0.2; };
			class gunner      { attenuationValue = 0.2; };
			class commander      { attenuationValue = 0.2; };
		};
	};
};

class ATV : DefaultAttenuation {
	positions[] = { other };
	
	class other {
		class inside {
			class other {
				attenuationValue = 0;
			};
			attenuateOutside	= 0;
		};
		class turnedout {
			attenuateOutside	= 0;
		};
	};
};
	