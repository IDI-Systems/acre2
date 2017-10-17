---
title: Vehicle Intercom
---

{% include note.html content="Development Build only!" %}

## Vehicle intercom

Vehicle intercom consists of two separate networks depending on the vehicle type: crew and passenger intercom. Intercom gives the ability to speak to other players within the same network using a headset. This allows them to communicate without the disturbance of the vehicle's noise.

While *crew intercom* is limited to crew members and players in cargo positions cannot have access to it, *passenger intercom* can be accessed by both crew and passengers. This allows the crew to communicate with the passengers if such network exist. In order to connect to the *passenger intercom*, ACE3 Interaction Menu is needed: simply interact with the vehicle when being in a seat with access to *passenger intercom* and select connect. *Crew intercom* is automatically assigned to players in "crew" positions.

Vehicle intercom system allows for an easier communication among crew members of a vehicle that has intercom functionality. It functions just like intercom in real life vehicles, giving the crew ability to speak to each other using a headset.

Some vehicles have additionally, restrictions on the amount of connections available in order to join the *passenger intercom*. Crew positions do not contribute towards this limit.

## Infantry telephone

{% include important.html content="Requires ACE3 Interaction Menu!" %}

Infantry also has the possibility, in vehicles like tanks or IFVs, to communicate with the crew and/or passengers without entering the vehicle. To do so, face the vehicle, interact with it and take the infantry telephone by selecting the appropriate network if it is not in use already. You can either put it back, give it to another player or switch networks.

Telephone can be mounted on the hull of the vehicle or in the center of the vehicle. If mounted on the hull (requires config support), maximum distance is 1.5m, otherwise it is 10m. The telephone will automatically be returned if the distance exceeds the maximum, either by player movement or vehicle movement.

Crew members (not passengers) can make the infantry telephone ring as long as it is not in use. In order to do so, interact with the vehicle from one of the allowed positions (driver, commander, gunner and turret positions) and select start/stop ringing. The ringing will automatically stop once the infantry telephone is picked up, the vehicle is destroyed or no crew members are aboard.

For technical details for addon makers see [vehicle intercom configuration](/wiki/frameworks/vehicle-intercom).
