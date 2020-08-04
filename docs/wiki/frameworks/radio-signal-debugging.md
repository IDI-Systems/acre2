---
title: Radio Signal Debugging
---

ACRE2 does log a few things to your RPT file already, however these are not extensive. For info on where to find your RPT file see the [Arma 3 wiki](https://community.bistudio.com/wiki/Crash_Files).

## Radio signal

Signal strength in ACRE is measured as the dBm that the recieving antenna picks up. A value that can be recieved will be typically be between 0 and -100. Different radios have different sensitivites but the lower limits are around -105 to -117 depending on the radio. Anything less will not be recieved or heard.

### Radio signal strength hint

If you want to test the incoming signal strength feel free to enable the signal hint. This will display a hint with data on all transmissions you are recieving.
`acre_sys_signal_showSignalHint = true;`

### Log signal traces to RPT

If you want to log radio transmissions to your rpt use `ACRE_SIGNAL_DEBUGGING = 1;`. Signal traces will now appear in the RPT.

Sample trace in the RPT.
```
ACRE TX from Snippers (on radio ACRE_PRC343_ID_1, distance at end: 67m), duration 1.1s: [-992,-992,-85,-85,-85,-85]
```
The signal trace is the array at the end (starts with '[' and ends with ']'). The value -992 is used as a placeholder signal strength value while ACRE awaits the signal calculation result from the extension. While waiting for a result ACRE will keep checking every 0.06 seconds. Once a non-placeholder is retrieved the radio signal is updated every 0.2 seconds apart.

If this signal debugging mode is active. Acre.dll will also log the inputs which are outputted to `Arma 3/logs/acre_dll.log`
```
2016-07-08 23:41:23,732-{INFO }- SIGNAL: ACRE_PRC343_ID_17_ACRE_2HALFINCH_UHF_TNC_ACRE_PRC343_ID_12_ACRE_2HALFINCH_UHF_TNC,27859.7,25269.6,54.3022,-0.754939,-0.111193,-0.646299,ACRE_2HALFINCH_UHF_TNC,27917.2,25384,54.7164,0.559324,-0.504565,-0.6577,ACRE_2HALFINCH_UHF_TNC,2400,100,0,2459.39,-85.0606,1.24914e-05
```

### Signal map visualization debug tool

{% include image.html file="dev/signal-map.png" alt="Signal Map" %}

This tool allows you to render radio signals on the map. The tool renders squares as an approximate for radio signal strength for each cell (size controlled by 'sample size'). The colour and transparency of the cell transitions from bright green at full signal to red and transparent at minimum signal receivable strength. This range of colours is configured by the sensitivity min and max. Anything outside of the minimum range (or not receivable) will be fully transparent and the radio signal would not be received.

#### Prerequisites
- Have Arma 3 Tools Installed.
- Mount the work drive. Ensure `P:\TexView2\Pal2PacE.exe` exists. This may involve copying `TexView2` from the Arma 3 Tools installation folder or setting up a symlink (via `mklink`).
- Ensure Arma 3 is running as Administrator to ensure write access for the tool to create textures (these will be dumped in your `Arma 3/userconfig` folder)

#### Usage
- Use debug console in a mission or editor preview and execute `[] call acre_sys_signalmap_fnc_open;`.
- Open in-game map, the tool should now be visible on the right side. Use the buttons to select a TX (Transmit position) and an RX (Receiving) area and click 'Process' to generate the map. _Note: selecting very large areas will take some time to process._
