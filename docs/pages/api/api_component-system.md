---
title: Component System
permalink: api_component-system.html
folder: api
---

## Overview

The ACRE2 component system is designed to build physical links between different ACRE components, be it radios, antennas, fill devices, racks, etc. Using a tree like topology components can define connections to other components through compatible connectors on each device. Connected components can be simple components (non-unique, no custom parameters, such as simple antennas) with no further connections or complex components (for example radios) that can link to other components, including themselves, through multiple connectors.

Each connection has attributes that explain the nature of the connection. These attributes are defined as free form and functionality can be built around definitions of attributes. This allows for thing such as defining the physical characteristics of a connection, such as the type of wire, the physical wire in the game world (for example when attaching a radio to a remote antenna) and other things that are needed by the connection.

The component system implements the same data system that radios use in ACRE2 (as of the current release ACRE2 radios are defined as complex ACRE components). All complex components implement events for handling new connections to other components and disconnecting from components. Furthermore all complex components that are connected can exchange messages with each other as events. This allows for programming specific inter-device functionality.

Components now also extend to in game vehicle objects. Early in ACRE2 the data system only handled unique ID'd items in an inventory. That is not the case now. In game objects can now define themselves as unique ACRE components and the data system will handle them appropriately, allowing you to extend the same functionality to them that was previously only available to items in your inventory (or in the cargo of a vehicle). This includes the ability to define component connections.


## Core Concepts

### Components

Components exist as two types, *simple* and *complex*. 

#### Simple

A simple component is any component that has no further available connections. It can be thought of as a terminating point for any chain of connected components. This would include things like speakers or antennas that do not have any complex functionality nor do any further devices attach to them. It is important to remember though that things traditionally defined as a simple component do not have to be simple components. For example an antenna or a speaker can just as easily be a complex component.

#### Complex

A complex component is any component that is uniquely identifiable and has the ability to maintain a unique state. Furthermore they are able to have more than one connector. A complex component for example is a radio. A radio retains a unique state, has multiple connectors, and is fully unique in the game world.

### Connectors

Connectors are defined in both complex and simple components. A simple component only has one connector where as a complex component can have as many connectors as needed. A connector has a type defined that determines it's ability to connect to another component.

### Connections

With a component and a connector you can establish connections. In the component system these exist purely as a data structure. There is no physical restrictions implemented beyond their ability to connect to each others connectors. There is no need for a device to physically exist in the same container or near each other for them to be connected in the component system. Physical restrictions will be added through helper functionality that can maintain the physical constraints of a system (for example, objects being required to be in the same parent container, or within a certain distance of each other). The component's data system is purely concerned with the data relationship between components.

### Attributes

Attributes are defined for connections (technically defined on connectors, but at the moment only defined for a connection). A connections attributes are shared between both components connectors. Attributes allow for the definition of anything that is needed to define the nature of the connection. For example a remote antenna would define the physical linkage (read wire) it has with the radio through an attribute. This attribute can be inspected by any system to determine additional needed functionality, such as signal loss, or if the connection is physically sound.

{% include links.html %}
