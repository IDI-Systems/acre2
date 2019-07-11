#pragma once

#include <math.h>
#include "Types.h"

namespace acre {
    struct Vector3 {
        // Data
        float32_t x;
        float32_t y;
        float32_t z;

        // Constructors and Destructors
        Vector3() {
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
        }

        Vector3(const float32_t x_, const float32_t y_, const float32_t z_) {
            x = x_;
            y = y_;
            z = z_;
        }

        // Operators
        Vector3 &operator=(const Vector3 &v) {
            x = v.x;
            y = v.y;
            z = v.z;
            return *this;
        }

        bool operator== (const Vector3 &rhs) const {
            return (x == rhs.x) && (y == rhs.y) && (z == rhs.z);
        }

        // Math functions
        const Vector3 operator+(const Vector3 &v) {
            return Vector3((x + v.x), (y + v.y), (z + v.z));
        }

        const Vector3 operator-(const Vector3 &v) {
            return Vector3((x - v.x), (y - v.y), (z - v.z));
        }

        const Vector3 operator*(const float32_t w) {
            return Vector3((x * w), (y * w), (z * w));
        }

        const Vector3 operator/(const float32_t w) {
            return Vector3((x / w), (y / w), (z / w));
        }
        const float32_t length() {
            return static_cast<float32_t>(sqrt((x * x) + (y * y) + (z * z)));
        }
        const float32_t distance(Vector3 a, Vector3 b) {
            Vector3 lineVector(a - b);
            return lineVector.length();
        }
        const float32_t distance(const Vector3 &a) {
            Vector3 lineVector;
            lineVector.x = x - a.x;
            lineVector.y = y - a.y;
            lineVector.z = z - a.z;

            return lineVector.length();
        }
    };

    using Vector3_t = Vector3;
} /* namespace acre */
