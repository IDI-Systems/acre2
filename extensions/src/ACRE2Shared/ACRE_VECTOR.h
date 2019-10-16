#pragma once

#include <math.h>
#include "Types.h"

namespace acre {
    template <typename T>
    struct Vector3 {
        // Data
        T x;
        T y;
        T z;

        // Constructors and Destructors
        Vector3() {
            x = static_cast<T>(0);
            y = static_cast<T>(0);
            z = static_cast<T>(0);
        }

        Vector3(const T x_, const T y_, const T z_) {
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

        const Vector3 operator*(const T w) {
            return Vector3((x * w), (y * w), (z * w));
        }

        const Vector3 operator/(const T w) {
            return Vector3((x / w), (y / w), (z / w));
        }
        const T length() {
            return static_cast<T>(std::sqrt((x * x) + (y * y) + (z * z)));
        }
        const T distance(Vector3 a, Vector3 b) {
            Vector3 lineVector(a - b);
            return lineVector.length();
        }
        const T distance(const Vector3 &a) {
            Vector3 lineVector;
            lineVector.x = x - a.x;
            lineVector.y = y - a.y;
            lineVector.z = z - a.z;

            return lineVector.length();
        }
    };

    using vec3_fp32_t = Vector3<float32_t>;
    using vec3_fp64_t = Vector3<float64_t>;
} /* namespace acre */
