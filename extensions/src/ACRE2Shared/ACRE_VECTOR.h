#pragma once

#include <math.h>
#include "Types.h"

typedef struct ACRE_SIMPLE_VECTOR {
    float32_t x;
    float32_t y;
    float32_t z;
} ACRE_SIMPLE_VECTOR, *PACRE_SIMPLE_VECTOR;

typedef struct ACRE_VECTOR {
    //
    // Data
    //
    float32_t x;
    float32_t y;
    float32_t z;
    
    //
    // Constructors/Destructors
    //
    ACRE_VECTOR() { 
        x=0;
        y=0;
        z=0;
    }
    ACRE_VECTOR(const float32_t in_x, const float32_t in_y, const float32_t in_z) { 
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
        if (x == rhs.x && y == rhs.y && z == rhs.z)
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

    const ACRE_VECTOR operator*(float32_t w) {
        return ACRE_VECTOR((x * w), (y * w), (z * w));
    }

    const ACRE_VECTOR operator/(float32_t w) {
        return ACRE_VECTOR((x / w), (y / w), (z / w));
    }
    const float32_t length() {
        return (float32_t) sqrt((x * x) + (y * y) + (z * z));
    }
    const float32_t distance(ACRE_VECTOR a, ACRE_VECTOR b) {
        ACRE_VECTOR lineVector;
        lineVector = a - b;
        return lineVector.length();
    }
    const float32_t distance(ACRE_VECTOR a) {
        ACRE_VECTOR lineVector;
        lineVector.x = x - a.x;
        lineVector.y = y - a.y;
        lineVector.z = z - a.z;

        return lineVector.length();
    }
} ACRE_VECTOR, *PACRE_VECTOR;
