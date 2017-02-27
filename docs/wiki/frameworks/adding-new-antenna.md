---
title: Adding new antenna
---

Every radio in ACRE can be equipped with at least one antenna. Since radios usually have specific antennas designed and tuned for the radio and the frequency range used, it is likely one must add a new antenna if a [new radio](creating-new-radio) is created for ACRE.

In order to allow an antenna to work properly in ACRE, there are a few required config entries and most importantly a set of gain data covering the desired frequency range. The gain data is used by the signal processing functions for calculation of signal strengths. For basics refer to [Radio Loss](http://acre2.idi-systems.com/wiki/user/radio-signal-loss.html).

## Example Antenna Config

Antennas themselves are defined in the `sys_antennas` component of ACRE2 [sys_antennas/CfgAcreComponents.hpp](https://github.com/IDI-Systems/acre2/blob/master/addons/sys_antenna/CfgAcreComponents.hpp). The parameters should be self explanatory as the following examples shows.

```
class CfgAcreComponents {
    class ACRE_ComponentBase;
    
    class ACRE_BaseAntenna: ACRE_ComponentBase {
        type = ACRE_COMPONENT_ANTENNA;
        simple = true;
        polarization = VERTICAL_POLARIZE;
        heightAG = AVERAGE_MAN_HEIGHT;
        orient = 90; // in degrees off of flat plane
        name = "Default Antenna";
        connector = ACRE_CONNECTOR_TNC;
        height = 1.2; //meters
        binaryGainFile = QPATHTOF(binary\VHF_1.2m_whip_gain.aba);
    };

    class ACRE_2HALFINCH_UHF_TNC: ACRE_BaseAntenna {
        name = "2.5 Inch UHF Antenna AN/PRC-343 ONLY";
        connector = ACRE_CONNECTOR_TNC;
        height = 0.062457; //meters
        binaryGainFile = QPATHTOF(binary\prc343_gain.aba);
    };
};
```

## Generating Antenna Gain Data

As ACRE tries to simulate radios as close to reality as possible, the gain data used is coming from a tool used for antenna and electromagnetic effects simulation. This tool is called 4NEC2 and can be obtained for free: [4NEC2](http://www.qsl.net/4nec2/)
For installation instructions and a bunch of good tutorials, please refer to the website. 

### Setting up the antenna

The first step after opening 4NEC2 is to create a model of the antenna. Usually it is more than sufficient to use a vertical wire and a simple ground setting. These models are stored in the `.nec` format which is basically a text file. The `.nec` files from all existing antennas could be found in the `extras/antenna` folder and a good practice is to simply take an existing file and change the parameters either in a text editor or directly in 4NEC2. 

To be continued...
