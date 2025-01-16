class CfgNonAIVehicles {
    class GVAR(connectorWireSegment) {
        scope = 2;
        displayName = "Connector Wire";
        simulation = "ropesegment";
        autocenter = 0;
        animated = 0;
        model = QPATHTOF(data\wire.p3d);
    };
};

class CfgVehicles {
    class Rope;
    class GVAR(connectorWire): Rope {
        segmentType = QGVAR(connectorWireSegment);
        model = QPATHTOF(data\wire.p3d);
    };

    class Car;
    class GVAR(connectorHelper): Car {
        displayName = "Connector Rope Helper";
        model = "core\default\default.p3d";
        scope = 2;
    };
};
