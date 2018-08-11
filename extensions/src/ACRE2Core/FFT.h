#ifndef _FFT_H_
#define _FFT_H_


#include <complex>
#include <vector>
#include "Types.h"


class FFT
{
    public:
        typedef std::complex<double> Complex;
        
        /* Initializes FFT. n must be a power of 2. */
        FFT(int n, bool inverse = false);
        /* Computes Discrete Fourier Transform of given buffer. */
        std::vector<Complex> transform(const std::vector<Complex>& buf);
        static float64_t getIntensity(Complex c);
        static float64_t getPhase(Complex c);
        
    private:
        int32_t m_n, m_lgN;
        bool m_inverse;
        std::vector<Complex> m_omega;
        std::vector<Complex> m_result;
        
        void bitReverseCopy(const std::vector<Complex>& src, std::vector<Complex>& dest) const;
};


#endif
