#pragma once

#include <math.h>

typedef struct ACRE_SIMPLE_VECTOR {
    float x;
    float y;
    float z;
} ACRE_SIMPLE_VECTOR, *PACRE_SIMPLE_VECTOR;

typedef struct ACRE_VECTOR {
    //
    // Data
    //
    float x;
    float y;
    float z;
    
    //
    // Constructors/Destructors
    //
    ACRE_VECTOR() { 
        x=0;
        y=0;
        z=0;
    }
    ACRE_VECTOR(float in_x, float in_y, float in_z) { 
        x=in_x;
        y=in_y;
        z=in_z; 
    }
    ACRE_VECTOR & operator=(const ACRE_VECTOR &o) { 
        x = o.x; 
        y = o.y; 
        z = o.z; 
        return *this; 
    }
    ACRE_VECTOR(const ACRE_VECTOR &o) { 
        x = o.x; 
        y = o.y; 
        z = o.z; 
    }
    bool operator== (const ACRE_VECTOR& rhs ) const {
        if(x == rhs.x && y == rhs.y && z == rhs.z)
            return true;
        else
            return false;
    }

    //
    // math functions
    //
    const ACRE_VECTOR operator+(ACRE_VECTOR v) {
        return ACRE_VECTOR((x + v.x), (y + v.y), (z + v.z));
    }

    const ACRE_VECTOR operator-(ACRE_VECTOR v) {
        return ACRE_VECTOR((x - v.x), (y - v.y), (z - v.z));
    }

    const ACRE_VECTOR operator*(float w) {
        return ACRE_VECTOR((x * w), (y * w), (z * w));
    }

    const ACRE_VECTOR operator/(float w) {
        return ACRE_VECTOR((x / w), (y / w), (z / w));
    }
    const float length() {
        return (float)sqrt((x * x) + (y * y) + (z * z));
    }
    const float distance(ACRE_VECTOR a, ACRE_VECTOR b) {
        ACRE_VECTOR lineVector;
        lineVector = a - b;
        return lineVector.length();
    }
    const float distance(ACRE_VECTOR a) {
        ACRE_VECTOR lineVector;
        lineVector.x = x - a.x;
        lineVector.y = y - a.y;
        lineVector.z = z - a.z;

        return lineVector.length();
    }
} ACRE_VECTOR, *PACRE_VECTOR;