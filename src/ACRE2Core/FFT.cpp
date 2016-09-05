#include "FFT.h"
#include <vector>
#include <cassert>


#define PI 3.14159265


using namespace std;


FFT::FFT(int n, bool inverse)
    : n(n), inverse(inverse), result(vector<Complex>(n))
{
    lgN = 0;
    for (int i = n; i > 1; i >>= 1)
    {
        ++lgN;
        assert((i & 1) == 0);
    }
    omega.resize(lgN);
    int m = 1;
    for (int s = 0; s < lgN; ++s)
    {
        m <<= 1;
        if (inverse)
            omega[s] = exp(Complex(0, 2.0 * PI / m));
        else
            omega[s] = exp(Complex(0, -2.0 * PI / m));
    }
}


std::vector<FFT::Complex> FFT::transform(const vector<Complex>& buf)
{
    bitReverseCopy(buf, result);
    int m = 1;
    for (int s = 0; s < lgN; ++s)
    {
        m <<= 1;
        for (int k = 0; k < n; k += m)
        {
            Complex current_omega = 1;
            for (int j = 0; j < (m >> 1); ++j)
            {
                Complex t = current_omega * result[k + j + (m >> 1)];
                Complex u = result[k + j];
                result[k + j] = u + t;
                result[k + j + (m >> 1)] = u - t;
                current_omega *= omega[s];
            }
        }
    }
    if (inverse == false)
        for (int i = 0; i < n; ++i)
            result[i] /= n;
    return result;
}


double FFT::getIntensity(Complex c)
{
    return abs(c);
}


double FFT::getPhase(Complex c)
{
    return arg(c);
}


void FFT::bitReverseCopy(const vector<Complex>& src, vector<Complex>& dest)
        const
{
    for (int i = 0; i < n; ++i)
    {
        int index = i, rev = 0;
        for (int j = 0; j < lgN; ++j)
        {
            rev = (rev << 1) | (index & 1);
            index >>= 1;
        }
        dest[rev] = src[i];
    }
}