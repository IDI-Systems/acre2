#include "FFT.h"
#include <vector>
#include <cassert>


#define PI 3.14159265

FFT::FFT(const int32_t n, const bool inverse)
    : m_n(n), m_inverse(inverse), m_result(std::vector<Complex>(n))
{
    m_lgN = 0;
    for (int32_t i = m_n; i > 1; i >>= 1)
    {
        ++m_lgN;
        assert((i & 1) == 0);
    }
    m_omega.resize(m_lgN);
    int32_t m = 1;
    for (int32_t s = 0; s < m_lgN; ++s)
    {
        m <<= 1;
        if (m_inverse)
            m_omega[s] = std::exp(Complex(0, 2.0 * PI / m));
        else
            m_omega[s] = std::exp(Complex(0, -2.0 * PI / m));
    }
}


std::vector<FFT::Complex> FFT::transform(const std::vector<Complex>& buf)
{
    bitReverseCopy(buf, m_result);
    int m = 1;
    for (int s = 0; s < m_lgN; ++s)
    {
        m <<= 1;
        for (int k = 0; k < m_n; k += m)
        {
            Complex current_omega = 1;
            for (int j = 0; j < (m >> 1); ++j)
            {
                Complex t = current_omega * m_result[k + j + (m >> 1)];
                Complex u = m_result[k + j];
                m_result[k + j] = u + t;
                m_result[k + j + (m >> 1)] = u - t;
                current_omega *= m_omega[s];
            }
        }
    }
    if (m_inverse == false)
        for (int32_t i = 0; i < m_n; ++i)
            m_result[i] /= m_n;
    return m_result;
}


double FFT::getIntensity(Complex c)
{
    return abs(c);
}


double FFT::getPhase(Complex c)
{
    return arg(c);
}


void FFT::bitReverseCopy(const std::vector<Complex>& src, std::vector<Complex>& dest) const
{
    for (int32_t i = 0; i < m_n; ++i)
    {
        int32_t index = i, rev = 0;
        for (int32_t j = 0; j < m_lgN; ++j)
        {
            rev = (rev << 1) | (index & 1);
            index >>= 1;
        }
        dest[rev] = src[i];
    }
}
