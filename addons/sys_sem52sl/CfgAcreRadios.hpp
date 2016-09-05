/*
    Copyright © 2010, International Development & Integration Systems, LLC
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

class CfgAcreComponents 
{    
    class ACRE_BaseRadio;
    
    class ACRE_SEM52SL_base : ACRE_BaseRadio {
        class Interfaces;
        isAcre = 1; 
    };
    
    class ACRE_SEM52SL : ACRE_SEM52SL_base {
        name = "SEM 52 SL";
        sinadRating = -117; 
        sensitivityMin = -117;
        sensitivityMax = -50;
        isPackRadio = 0;        
        isDeployable = 0;

        connectors[] =     {
                            {"Antenna", ACRE_CONNECTOR_BNC},
                            {"Audio/Data", ACRE_CONNECTOR_U_283}
                        };
        defaultComponents[] = {
                                {0, "ACRE_120CM_VHF_BNC"} /*TODO Not use this */
                            };
        
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRadioInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };
        
        class Interfaces: Interfaces {
            class CfgAcreDataInterface {
                getListInfo                    =    QUOTE(DFUNC(getListInfo));
                
                setVolume                    =    QUOTE(DFUNC(setVolume));                // [0-1]
                getVolume                    =     QUOTE(DFUNC(getVolume));                // [] = 0-1
                
                setSpatial                    =    QUOTE(DFUNC(setSpatial));            
                getSpatial                    =    QUOTE(DFUNC(getSpatial));
                
                setChannelData                 =    QUOTE(DFUNC(setChannelData));            // [channelNumber, [channelData] ]
                getChannelData                =    QUOTE(DFUNC(getChannelData));            // [channelNumber] = channelData
                getCurrentChannelData        =    QUOTE(DFUNC(getCurrentChannelData));        // channelData (of current channel)
                
                
                getCurrentChannel            =    QUOTE(DFUNC(getCurrentChannel));        // [] = channelNumber
                setCurrentChannel            =    QUOTE(DFUNC(setCurrentChannel));        // [channelNumber]
                
                getStates                    =    QUOTE(DFUNC(getStates));                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState                    =    QUOTE(DFUNC(getState));                // [stateName] = stateData
                setState                    =     QUOTE(DFUNC(setState));                // [stateName, stateData] = sets state
                
                getOnOffState                =     QUOTE(DFUNC(getOnOffState));            // [] = 0/1
                setOnOffState                =     QUOTE(DFUNC(setOnOffState));            // [ZeroOrOne]
                
                initializeComponent            =     QUOTE(DFUNC(initializeRadio));
                
                getChannelDescription        =     QUOTE(DFUNC(getChannelDescription));
                
                isExternalAudio                =    QUOTE(DFUNC(isExternalAudio));
            };
            
            class CfgAcrePhysicalInterface {
                getExternalAudioPosition    =     QUOTE(DFUNC(getExternalAudioPosition));
            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission        =     QUOTE(DFUNC(handleBeginTransmission));
                handleEndTransmission        =    QUOTE(DFUNC(handleEndTransmission));
                
                handleSignalData            =    QUOTE(DFUNC(handleSignalData));
                handleMultipleTransmissions =    QUOTE(DFUNC(handleMultipleTransmissions));
                
                handlePTTDown                =    QUOTE(DFUNC(handlePTTDown));
                handlePTTUp                    =     QUOTE(DFUNC(handlePTTUp));
            };
            
            class CfgAcreInteractInterface {
                openGui                        =     QUOTE(DFUNC(openGui));                // [RadioId]
                closeGui                    =    QUOTE(DFUNC(closeGui));                // []
            };
        };
    };
};