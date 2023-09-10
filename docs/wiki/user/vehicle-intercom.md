---
title: Vehicle Intercom
---

## Vehicle Intercom

Vehicle intercom consists of two separate networks depending on the vehicle type: crew and passenger (pax) intercom. Intercom gives the ability to speak to other players within the same network using a headset. This allows them to communicate without the disturbance of the vehicle's noise.

While *crew intercom* is limited to crew members and players in cargo positions cannot have access to it, *pax intercom* can be accessed by both crew and passengers. This allows the crew to communicate with the passengers if such network exist. In order to connect to the *pax intercom*, ACE3 Interaction Menu is needed: simply interact with the vehicle when being in a seat with access to *pax intercom* and select connect. *Crew intercom* is automatically assigned to players in "crew" positions.

Vehicle intercom system allows for an easier communication among crew members of a vehicle that has intercom functionality. It functions just like intercom in real life vehicles, giving the crew ability to speak to each other using a headset. Each station has three configurations:

  - *Receive*: the unit will only be able to hear incomming messages and all outgoing messages will not be transmitted through intercom. This configuration is displayed as **(R)** in the HUD.
  - *Transmit*: the unit will only be able to transmit messages through intercom but it will not hear any incomming messages. This configuration is displayed as **(T)** in the HUD.
  - *Receive and Transmit*: the unit can hear and send messages through the intercom system. This configuration is displayed as **(R/T)** in the HUD.

In addition, two operating modes are available through ACE self interaction menu:

  - *Voice activation*: the unit automatically uses intercom when starting speaking (**P** subsitutes the **T** entry in the HUD).
  - *PTT activation*: the unit only transmit using the intercom when manually pressing the intercom PTT key (unbound by default) (**B** subsitutes the **T** entry in the HUD).

Some vehicles have additionally, restrictions on the amount of connections available in order to join the *pax intercom*. These positions are configured by default to be in *PTT activation* mode.

Optionally, each network has a master station. Such stations can broadcast a message (activation through intercom broadcast PTT key), temporarily disabling all transmit functionality in all stations. One useful feature in the master station is the *accent feature*. When enabled, incoming radio transmissions will have their volume reduced by 20% if intercom is being used by any crew member at the same time. All intercom stations are affected by this behaviour.

### Full Functional Crew Station (FFCS)

{% include image.html file="intercom/anvic3_ffcs_interface.png" alt="AN/VIC3 FFCS" %}

This interface can be opened using the ACE Interaction menu or through a shortcut (default <kbd>⇧&nbsp;Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>Tab&nbsp;⇥</kbd>). The opened intercom will be displayed in green in the HUD.

#### Volume Knob

Sets the overall volume of the intercom and monitored/active radios. Red frange boosts the volume for noisy environments.

#### Monitor Knob

Monitors the selected radio or all radios. Radios in this configuration are set to receive only.

#### Work Knob

The selected radio is capable of receiving and transmitting.

#### Intercom Knob

It has 4 positions. When at PTT, the intercom will behave as *PTT activation* mode, LIVE and VOX is the equivalent of *Voice activation* and O/R allows the FFCS to transmit a priority message by temporarily disabling all other FFCS stations.


## Infantry Telephone

Infantry also has the possibility, in vehicles like tanks or IFVs, to communicate with the crew and/or passengers without entering the vehicle. To do so, face the vehicle, interact with it and take the infantry telephone by selecting the appropriate network if it is not in use already. You can either put it back, give it to another player or switch networks.

Telephone can be mounted on the hull of the vehicle or in the center of the vehicle. If mounted on the hull (requires config support), maximum distance is 1.5m, otherwise it is 10m. The telephone will automatically be returned if the distance exceeds the maximum, either by player movement or vehicle movement.

Crew members (not passengers) can make the infantry telephone ring as long as it is not in use. In order to do so, interact with the vehicle from one of the allowed positions (driver, commander, gunner and turret positions) and select start/stop ringing. The ringing will automatically stop once the infantry telephone is picked up, the vehicle is destroyed or no crew members are aboard.

For technical details for addon makers see [vehicle intercom configuration](/wiki/frameworks/vehicle-intercom).
