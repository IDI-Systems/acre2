#pragma once

#include "shared.hpp"
#include "vector.hpp"

namespace acre {
    template <typename T>
    class transform_matrix_base {
    public:
        transform_matrix_base & operator= (const transform_matrix_base& other) { _x = other.x(); _y = other.y(); _z = other.z(); _n = other.n();  return *this; }

        transform_matrix_base() {}
        transform_matrix_base(std::istream &stream_, uint32_t version = 68) : _x(stream_), _y(stream_), _z(stream_), _n(stream_) { }
        transform_matrix_base(acre::vector3<T> x_, acre::vector3<T> y_, acre::vector3<T> z_, acre::vector3<T> n_) : _x(x_), _y(y_), _z(z_), _n(n_) { }

        const acre::vector3<T> & x() const { return _x; }
        const acre::vector3<T> & y() const { return _y; }
        const acre::vector3<T> & z() const { return _z; }
        const acre::vector3<T> & n() const { return _n; }

        void x(const acre::vector3<T> val) { _x = val; }
        void y(const acre::vector3<T> val) { _y = val; }
        void z(const acre::vector3<T> val) { _z = val; }
        void n(const acre::vector3<T> val) { _n = val; }

    protected:
        acre::vector3<T> _x;
        acre::vector3<T> _y;
        acre::vector3<T> _z;
        acre::vector3<T> _n;
    };

    typedef transform_matrix_base<float> transform_matrix;
};