/*
    Copyright © 2016, International Development & Integration Systems, LLC
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
class Prc343_RscBackground
{
        type = CT_STATIC;
        idc = -1;
        style = ST_BACKGROUND + ST_KEEP_ASPECT_RATIO;
        colorBackground[] = {0, 0, 0, .75};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;
};

// text
class Prc343_RscText
{
    idc = -1;
    type = CT_STATIC;
    style = ST_LEFT + ST_KEEP_ASPECT_RATIO;
    font = EtelkaMonospaceProBold;
    colorText[] = {1,1,1,1};
    colorBackground[] = {0, 0, 0, 0};
    sizeEx = 0.024;
    w = 0.2;
    h = 0.03;
};

class Prc343_RscButton
{
  type = CT_BUTTON;
  idc = -1;
  style = ST_CENTER + ST_KEEP_ASPECT_RATIO;

  x = 0.0;
  y = 0.0;
  w = 0.1;
  h = Dlg_CONTROLHGT;
  sizeEx = 0.0325;
  offsetX = 0;
  offsetY = 0.002;
  offsetPressedX = 0;
  offsetPressedY = 0.002;
  borderSize = 0;

  #define ClrWhite 1,1,1
  #define ClrBlack 0,0,0
  #define ClrGray 0.5,0.5,0.5
  #define ClrBlue 0.2,0.5,1

  colorText[] = {ClrWhite,1};
  colorBackground[] = {ClrGray, 0};
  colorFocused[] = {ClrGray,00};

  colorShadow[] = {ClrBlack,0};
  colorBorder[] = {ClrWhite,0};
  colorBackgroundActive[] = {ClrGray,0};
  colorDisabled[] = {ClrGray, 0};
  colorBackgroundDisabled[] = {ClrGray,0};
  font = FontM;

  tooltipColorShade[] = {ClrGray, 0.25};
  tooltipColorText[] = {ClrWhite, 0.75};
  tooltipColorBox[] = {ClrGray, 0};

  soundEnter[] = {"", 0.2, 1};
  soundPush[] = {"", 0.2, 1};
  soundClick[] = {"", 0.2, 1};
  soundEscape[] = {"", 0.2, 1};

  default = false;
  text = "";
  action = "";
};

class Prc343_RscPicture : Prc343_RscButton
{
    type = CT_STATIC;
    idc = -1;
    style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
    text = "";
};