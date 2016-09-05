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

/* Use this to determine the attenution between people inside and outside vehicles. */

class CfgSoundEffects
{
    class AttenuationsEffects
    {
        acreDefaultAttenuation = 0;
        class CarAttenuation
        {
            acreAttenuation = 0.5;
        };
        class SemiOpenCarAttenuation
        {
            acreAttenuation = 0;
        };
        class SemiOpenCarAttenuation2
        {
            acreAttenuation = 0;
        };
        class OpenCarAttenuation
        {
            acreAttenuation = 0;
        };
        class TankAttenuation
        {
            acreAttenuation = 0.6;
        };
        class HeliAttenuation
        {
            acreAttenuation = 0.6;
        };
        class OpenHeliAttenuation
        {
            acreAttenuation = 0.1;
        };
        class SemiOpenHeliAttenuation
        {
            acreAttenuation = 0.4;
        };
        class HeliAttenuationGunner
        {
            acreAttenuation = 0.15;
        };
        class HeliAttenuationRamp
        {
            acreAttenuation = 0.15;
        };
        class PlaneAttenuation
        {
            acreAttenuation = 0.6;
        };
        class RHS_CarAttenuation
        {
            acreAttenuation = 0.5;
        };
        class CUP_UAZ_CarAttenuation
        {
            acreAttenuation = 0;
        };
        class CUP_Ural_CarAttenuation
        {
            acreAttenuation = 0;
        };
    };
};