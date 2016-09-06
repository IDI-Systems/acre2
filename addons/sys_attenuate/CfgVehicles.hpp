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
class CfgVehicles {
#ifdef PLATFORM_A3
    class Air;
    class LandVehicle;
    class Car : LandVehicle {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = false;
            };
        };
    };
    
    class Car_F : Car {};
    
    class Wheeled_APC_F : Car_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment2  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment3  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment4  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };

    class Tank : LandVehicle {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment2  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment3  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment4  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };
    
    class Helicopter : Air {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };
    
    class Plane : Air {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };
    
    class MRAP_02_base_F: Car_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };
#endif
};