---
title: Feature List
---

## Introduction

ACRE2 provides a lot of functionality and features; basically, 5 years of development worth the features. In that 5 years, it seems documentation and lists of our current feature set have been lost. Additionally, its hard to keep people informed about what ACRE2 can do; causing many to think it an inferior or unfinished product. This list's purpose is to give anyone an "at a glance" overview of what ACRE2 does, and what you can do with it.

### Features

### Performance

ACRE2 is tested by UnitedOperations.Net. They run test/pre-release builds of ACRE2 regularly prior to public release. Their playerbase consists of an average 30+ players every single day, peaking at 120 players for over 8 hours a day on weekends, every single weekend. These numbers are not exaggerated, you can view their server tracker on gametracker.com. Consistent regularly gameplay occurs Friday-Sunday for approximately 6-8 hours with 100+ players using ACRE2 all on the same server, in game, with real missions and AI.

This playtesting allows us to guarantee that ACRE2 supports, without glitches, 120+ player scenarios.

### High-Level Summary

* Provides realistic sounding radio and direct voice communications for ArmA3
* Signal loss and degradation is done using REAL WORLD ITU Terrain loss modeling and signal propagation techniques. We model everything from mapping terrain and creating loss maps to the antenna's, power and frequencies of the radios
* 'Regular' talking can travel over 100 meters in ideal terrain
* Direct speaking occlusion, buildings and objects block your voice
* AI direct speaking detection; AI can also hear you talking and alert to you
* All radios are modeled and SIMULATED to their real world counterparts
* Easy to use, only a few buttons are required to play
* Babel feature & Radio configurations allows for immersive TVT and brings radios/communication in as a gameplay mechanic
* Extensive and documented API and example set for easy use
* Template setups for milsim community operations
* All vehicles have realistic attenuation, meaning different positions hear inside/outside differently.
* Vehicle intercom system; Vehicles with intercoms automatically have crew communicate with them
* In-game speakers; you can put your radio on 'speaker' mode and everyone can listen. If you drop the radio, it keeps playing!
* Multiple Push-To-Talk keys, for assigning different radios to different hotkeys
* Preset naming and descriptions for radios that support it. Includes name showing in hints

### Radio Communications

* ITU Signal Loss and Terrain Modelling
* Radio Interfaces
* Easy to Use
* API/Pre-programming for milsim groups
* Antennas and Components

## Direct Communications

* Babel (TVT Languages)
* Distance and Scaling
* Building/object Occlusion
* Vehicle Intercoms
* Vehicle Attenuation
* AI Hears you

### TVT

#### Example TVT Gameplay

You can have a TVT with 2 sides. Each side speaks its own babel language, except for some translators. Each side also has their own radio configurations. This would mean that even if you stole another sides radio, you can hear them transmit and hear what they are saying - but not understand it. You'll need to get the radio to your translator to actually leverage that radio. Signal loss can play into this as well - maybe you can triangulate or discover enemies passed on their radio communications.

#### Babel

Babel provides a method for a mission maker to give each side or individual players their own languages. If you can't understand a language, that persons speaking sounds garbled and reversed. People have described it sounding like pig latin. This allows for whole new levels of gameplay where you can hear people or steal their radios, but not understand them. You can also include translators who speak both languages, extending possible mission scenarios.

#### TVT Radio Setups

ACRE has always supported assigning different radios and frequencies to different sides. We pioneered, almost 4 years ago, making ACRE radio's physical objects. This means that the radio's configuration is tracked with the object. If a radio is dropped, or collected off a dead player, the other player sees that radios configuration and can use it. This, combined with babel, allows for many different TVT scenarios and added levels of great gameplay.
