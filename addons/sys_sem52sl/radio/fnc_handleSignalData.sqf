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

#include "script_component.hpp"

/*
 *  If any processing of the incoming signal is necessary,
 *  this can be handled inside this function
 *
 *  Type of Event:
 *      Transmission
 *  Event:
 *      handleSignalData
 *  Event raised by:
 *      - Process Radio Speaker
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "handleSignalData")
 *      2:  Eventdata
 *          2.0:    Radio ID of transmitting radio
 *          2.1:    Radio ID of receiving radio
 *          2.2:    Signal Quality
 *          2.3:    Signal strength
 *          2.4:    Signal Model
 *      3:  Radiodata 
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true
*/


params ["","","_eventData"];

_eventData;
