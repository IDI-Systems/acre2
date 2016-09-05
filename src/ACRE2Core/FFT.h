#ifndef _FFT_H_
#define _FFT_H_


#include <complex>
#include <vector>


class FFT
{
    public:
        typedef std::complex<double> Complex;
        
        /* Initializes FFT. n must be a power of 2. */
        FFT(int n, bool inverse = false);
        /* Computes Discrete Fourier Transform of given buffer. */
        std::vector<Complex> transform(const std::vector<Complex>& buf);
        static double getIntensity(Complex c);
        static double getPhase(Complex c);
        
    private:
        int n, lgN;
        bool inverse;
        std::vector<Complex> omega;
        std::vector<Complex> result;
        
        void bitReverseCopy(const std::vector<Complex>& src,
                std::vector<Complex>& dest) const;
};


#endif