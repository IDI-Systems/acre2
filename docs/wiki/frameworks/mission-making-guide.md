---
title: Mission Making Guide
---

## Overview

In an attempt to help provide more documentation and information on the availability of the vast configurability of ACRE2, below are sets of examples for different common scenarios ACRE2 utilizes. Because we are utilized by many communities, ranging from persistent worlds to die-hard military simulation communities and everything in between, we've found a common set of examples which can help anyone integrate ACRE2 fairly quickly.

In general, we've found that the majority of communities wish for examples and assistance in setting up their missions in such a way as to streamline the user process; this can include pre-programming radios, assigning channel names, deploying radios given the Arma 3 unit type, and modifying the ACRE2 core settings such as signal loss for their play style. All of this is possible, and we've tried to provide the best possible summaries and examples below.

- [Official Example Missions](https://github.com/IDI-Systems/acre2/tree/master/extras/examples)

### For Milsim Communities

ACRE2 is heavily used within Military Simulation communities for gameplay purposes given that we provide a drastically higher fidelity of realistic communications. We understand that many communities operate the same way, and are generally looking for assistance in providing seamless experiences to their player base for operations. Chief among these needs is usually setting up consistent signals orders for their RTOs, commanders and units to follow. ACRE2 provides functionality that a community can include either in their operational missions or in their modpack directly to provide setting up these parameters.

Such things that we have found milsim communities most commonly use are:

- Presetting channel names for given nets
- Switching players to their appropriate channels automatically
- Setting up their signals cards and channel setups

We've provided an example which is heavily documented to provide the information for a milsim community to set up a company-level signals order. This first example is strictly for signals, and does not include unit-level 343 setup. The second example provides a single squads 343 setup.

## Mission Maker Scripts

- [Basic TVT](https://github.com/IDI-Systems/acre2/blob/master/extras/examples/mission_setupBasicTVT.sqf)
- [Company RTO](https://github.com/IDI-Systems/acre2/blob/master/extras/examples/mission_setupCompanySignals.sqf)
- [Company with Squads](https://github.com/IDI-Systems/acre2/blob/master/extras/examples/mission_setupFullCompanyWithAutoswitch.sqf)
