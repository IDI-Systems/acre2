#include "compressed_base.hpp"

#include <limits.h>
#include <stddef.h>
#include <limits.h>
#include <stddef.h>
#include <string.h>
#include <malloc.h>

#define COMPRESS_ASSERT(val) if (!(val)) return LZO_E_ERROR
#define M2_MAX_OFFSET   0x0800

#define NEED_OP(x)  if ((unsigned)(op_end - op) < (unsigned)(x)) return LZO_E_OUTPUT_OVERRUN;
#define TEST_LB()   if (m_pos < out || m_pos >= op) return LZO_E_LOOKBEHIND_OVERRUN;

#define COPY4(dst,src)    * (unsigned *)(dst) = * (const unsigned *)(src)

#define LZO_E_OK                    0
#define LZO_E_ERROR                 (-1)
#define LZO_E_OUTPUT_OVERRUN        (-5)
#define LZO_E_LOOKBEHIND_OVERRUN    (-6)
#define LZO_E_OUTPUT_UNDERRUN    (-4)

#define READ_CHAR(var) in_.read((char *)&var, sizeof(uint8_t))

namespace acre {
    /*lzo1x_decompress_safe   ( const lzo_bytep src, lzo_uint  src_len,
    lzo_bytep dst, lzo_uintp dst_len,
    lzo_voidp wrkmem  ) */
    int _compressed_base::_decompress_safe(std::istream & in, uint32_t expected_size) {
        // We read 512 bytes at a time, until we have hit the end of the compressed stream
        uint8_t     *buffer;
        std::streamsize input_size = 0;
        int32_t     result;
        std::streampos   save_pos;

        save_pos = in.tellg();
        buffer = new uint8_t[expected_size + 1024];

        in.read((char *)buffer, expected_size + 1024);
        input_size = in.gcount();
        if (in.eof()) {
            in.clear();
        }
        _data = std::unique_ptr<uint8_t[]>(new uint8_t[expected_size + (expected_size % 8)]);
        result = _mikero_lzo1x_decompress_safe(buffer, _data.get(), expected_size);
        if (result < 0) {
            delete[] buffer;
            LOG(ERROR) << "Decompression failed";
            assert(false);
        }
        in.seekg(save_pos);
        in.seekg(result, in.cur);

        delete[] buffer;

        return result;
    }
    int _compressed_base::_mikero_lzo1x_decompress_safe(const uint8_t* in, uint8_t* out, uint32_t OutLen) {
        register uint8_t* op;
        register const uint8_t* ip;
        register size_t t;
        register const uint8_t* m_pos;

        uint8_t* const op_end = out + OutLen;

        OutLen = 0;
        op = out;
        ip = in;

        if (*ip > 17)
        {
            t = *ip++ - 17;
            if (t < 4) goto match_next;
            COMPRESS_ASSERT(t > 0);// return LZO_E_ERROR;
            NEED_OP(t);
            do *op++ = *ip++; while (--t > 0);
            goto first_literal_run;
        }

        while (1)
        {
            t = *ip++;
            if (t >= 16)           goto match;
            if (t == 0)
            {
                while (*ip == 0)
                {
                    t += 255;
                    ip++;
                }
                t += 15 + *ip++;
            }
            COMPRESS_ASSERT(t > 0); NEED_OP(t + 3);

            COPY4(op, ip);
            op += 4; ip += 4;
            if (--t > 0)
            {
                if (t >= 4)
                {
                    do {
                        COPY4(op, ip);
                        op += 4; ip += 4; t -= 4;
                    } while (t >= 4);
                    if (t > 0) do *op++ = *ip++; while (--t > 0);
                }
                else
                    do *op++ = *ip++; while (--t > 0);
            }

        first_literal_run:

            t = *ip++;
            if (t >= 16)  goto match;

            m_pos = op - (1 + M2_MAX_OFFSET);
            m_pos -= t >> 2;
            m_pos -= *ip++ << 2;

            TEST_LB();
            NEED_OP(3);
            *op++ = *m_pos++; *op++ = *m_pos++; *op++ = *m_pos;

            goto match_done;

            do {
            match:
                if (t >= 64)
                {

                    m_pos = op - 1;
                    m_pos -= (t >> 2) & 7;
                    m_pos -= *ip++ << 3;
                    t = (t >> 5) - 1;
                    TEST_LB();     COMPRESS_ASSERT(t > 0); NEED_OP(t + 3 - 1);
                    goto copy_match;
                }
                else if (t >= 32)
                {
                    t &= 31;
                    if (t == 0)
                    {
                        while (*ip == 0)
                        {
                            t += 255;
                            ip++;
                        }
                        t += 31 + *ip++;
                    }

                    m_pos = op - 1;
                    m_pos -= (ip[0] >> 2) + (ip[1] << 6);

                    ip += 2;
                }
                else if (t >= 16)
                {

                    m_pos = op;
                    m_pos -= (t & 8) << 11;

                    t &= 7;
                    if (t == 0)
                    {
                        while (*ip == 0)
                        {
                            t += 255;
                            ip++;
                        }
                        t += 7 + *ip++;
                    }

                    m_pos -= (ip[0] >> 2) + (ip[1] << 6);

                    ip += 2;
                    ////// done
                    if (m_pos == op)
                    {
                        COMPRESS_ASSERT(t == 1);
                        if (m_pos != op_end)
                            return LZO_E_LOOKBEHIND_OVERRUN;
                        return ip - in;
                    }
                    m_pos -= 0x4000;
                }
                else
                {
                    m_pos = op - 1;
                    m_pos -= t >> 2;
                    m_pos -= *ip++ << 2;

                    TEST_LB();
                    NEED_OP(2);
                    *op++ = *m_pos++; *op++ = *m_pos;
                    goto match_done;
                }

                TEST_LB();
                COMPRESS_ASSERT(t > 0);
                NEED_OP(t + 3 - 1);

                if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4)
                {
                    COPY4(op, m_pos);
                    op += 4; m_pos += 4; t -= 4 - (3 - 1);
                    do {
                        COPY4(op, m_pos);
                        op += 4; m_pos += 4; t -= 4;
                    } while (t >= 4);
                    if (t > 0) do *op++ = *m_pos++; while (--t > 0);
                }
                else
                {
                copy_match:
                    *op++ = *m_pos++; *op++ = *m_pos++;

                    do *op++ = *m_pos++; while (--t > 0);

                }
            match_done:

                t = ip[-2] & 3;
                if (t == 0)   break;
            match_next:
                COMPRESS_ASSERT(t > 0); COMPRESS_ASSERT(t < 4); NEED_OP(t);
                *op++ = *ip++;
                if (t > 1) { *op++ = *ip++; if (t > 2) { *op++ = *ip++; } }

                t = *ip++;
            } while (1);
        }
    }

#define N 4096
#define F 18
#define THRESHOLD 2
#define READ_CHAR2(var) in.read((char *)&temp, 1); var = (unsigned char)temp
    bool _compressed_base::_lzss_decompress(std::istream &in, long lensb)
    {
        unsigned char temp;
        _data = std::unique_ptr<uint8_t[]>(new uint8_t[lensb]);
        char *dst = (char *)_data.get();
        if (lensb <= 0) return true;
        std::unique_ptr<uint8_t[]> temp_buf = std::unique_ptr<uint8_t[]>(new uint8_t[4113]);
        unsigned char *text_buf = temp_buf.get();
        int i, j, r, c, csum = 0;
        int flags;
        for (i = 0; i<N - F; i++) text_buf[i] = ' ';
        r = N - F; flags = 0;
        while (lensb>0)
        {
            if (((flags >>= 1) & 256) == 0)
            {
                READ_CHAR2(c);
                flags = c | 0xff00;
            }
            if (in.fail() || in.eof())
            {
                //Fail("LZW: stream read failed");
                return false;
            }
            if (flags & 1)
            {
                c = in.get();
                if (in.fail() || in.eof())
                {
                    //Fail("LZW: stream read failed");
                    return false;
                }
                csum += (unsigned char)c;
                // save byte
                *dst++ = c;
                lensb--;
                // continue decompression
                text_buf[r] = (unsigned char)c;
                r++;r &= (N - 1);
            }
            else
            {
                READ_CHAR2(i);
                READ_CHAR2(j);
                if (in.fail() || in.eof())
                {
                    //Fail("LZW: stream read failed");
                    return false;
                }
                i |= (j & 0xf0) << 4; j &= 0x0f; j += THRESHOLD;

                int ii = r - i;
                int jj = j + ii;

                //int count = (jj+1)-ii;
                //int count = (j+ii+1)-ii;
                //int count = (j+1);
                if (j + 1>lensb)
                {
                    //Fail("LZW overflow");
                    return false;
                }

                for ( /*i=r-i,j+=i*/; ii <= jj; ii++)
                {
                    c = (byte)text_buf[ii&(N - 1)];
                    csum += (unsigned char)c;
                    // save byte
                    *dst++ = c;
                    lensb--;
                    // continue decompression
                    text_buf[r] = (unsigned char)c;
                    r++;r &= (N - 1);
                }
            }
        }
        int csr;
        in.read((char *)&csr, sizeof(long));
        if (in.fail() || in.eof())
        {
            //Fail("LZW: end of stream");
            return false;
        }
        if (csr != csum)
        {
            //Fail("Checksum");
            return false;
        }
        return true;
    }
}

