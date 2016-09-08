#include "landscape.hpp"

acre::wrp::landscape::landscape(std::string path_)
{
    std::ifstream stream(path_, std::ifstream::binary);
    _process(stream);
    stream.close();
}

acre::wrp::landscape::landscape(std::istream &stream_)
{
    _process(stream_);
}

acre::wrp::landscape::~landscape()
{
}

bool acre::wrp::landscape::_read_binary_tree_block(std::istream &stream_, uint32_t bit_length, uint32_t block_size, uint32_t cell_size, uint32_t block_offset_x, uint32_t block_offset_y)
{
    uint32_t current_block_size = block_size / 4;//256..64..16..1
    uint32_t current_block_offset_x, current_block_offset_y;

    uint16_t A, B;
    uint16_t packet_flag;
    stream_.read((char *)&packet_flag, sizeof(uint16_t));

    for (int bit_count = 0; bit_count < 16; bit_count++, packet_flag >>= 1)
    {
        current_block_offset_x = block_offset_x + (bit_count % 4) * block_size*bit_length;// 0,1,2,3
        current_block_offset_y = block_offset_y + ((bit_count / 4) * block_size); // 0,1,2,3

        if (packet_flag & 1)
        {
            if (!_read_binary_tree_block(stream_, bit_length, current_block_size, cell_size, current_block_offset_x, current_block_offset_y)) return false;
        }
        else
        {
            stream_.read((char *)&A, bit_length);
            stream_.read((char *)&B, bit_length);
            if (!A && !B)     continue;// filler
            if ((current_block_offset_x >= cell_size) || (current_block_offset_y >= cell_size)) return false;

            for (uint32_t iy = 0; iy < current_block_offset_y; iy++) {
                for (uint32_t ix = 0; ix < current_block_size; ix++)
                {
                    int OffsetAB = ((current_block_offset_y + iy)*cell_size) + current_block_offset_x + ix;
                    //_Grid[OffsetAB] = A; _Grid[OffsetAB + ThisBlockSize.x] = B;
                }
            }
        }
    }
    return true;
}

bool acre::wrp::landscape::_process(std::istream &stream_)
{
    stream_.read(filetype, 4);
    filetype[4] = 0x00;

    if (strcmp(filetype, "8WVR") == 0) {
        // Header
        //Texture Size
        stream_.read((char *)&layer_size_x, sizeof(uint32_t));
        stream_.read((char *)&layer_size_y, sizeof(uint32_t));
        //TerrainGrid Size
        stream_.read((char *)&map_size_x, sizeof(uint32_t));
        stream_.read((char *)&map_size_y, sizeof(uint32_t));
        //Cell size
        stream_.read((char *)&cell_size, sizeof(float));
        map_grid_size = cell_size;

        // elevations (Elevations   [TerrainGridSize.y][TerrainGridSize.x];)
        elevations = compressed<float>(stream_, map_size_x*map_size_x, false, false, version);

        //Generate peaks.
        return true;
    }
    
    // Proceed with OPRW/ACRE
    stream_.read((char *)&version, sizeof(uint32_t));
    if (version > 24)
        stream_.read((char *)&some_bit, sizeof(uint32_t));
    stream_.read((char *)&layer_size_x, sizeof(uint32_t));
    stream_.read((char *)&layer_size_y, sizeof(uint32_t));
    stream_.read((char *)&map_size_x, sizeof(uint32_t));
    stream_.read((char *)&map_size_y, sizeof(uint32_t));

    stream_.read((char *)&cell_size, sizeof(float));
    map_grid_size = cell_size * layer_size_x / map_size_x;

    uint8_t flag; // Determines if the blocks are present.

    stream_.read((char *)&flag, sizeof(uint8_t));
    if (flag == '\x1') {
        _read_binary_tree_block(stream_, sizeof(uint16_t), 16, map_size_x, 0, 0);
    } else {
        // Grid is not present, read the fill bits.
        uint32_t fill_bits;
        stream_.read((char *)&fill_bits, sizeof(uint32_t));
    }

    stream_.read((char *)&flag, sizeof(uint8_t));
    if (flag == '\x1') {
        _read_binary_tree_block(stream_, sizeof(uint16_t), 16, map_size_x, 0, 0);
    } else {
        // Grid is not present, read the fill bits.
        uint32_t fill_bits;
        stream_.read((char *)&fill_bits, sizeof(uint32_t));
    }

    uint32_t peak_count;
    stream_.read((char *)&peak_count, sizeof(uint32_t));

    float *peak_floats = new float[peak_count * 3];
    stream_.read((char *)peak_floats, sizeof(float)*peak_count * 3);

    for (uint32_t i = 0; i < peak_count * 3; i = i + 3) {
        peaks.push_back(vector3<float>(peak_floats[i], peak_floats[i + 1], peak_floats[i + 2]));
    }
    delete[] peak_floats;

    /* GridBlock - RvmatLayerIndex*/
    stream_.read((char *)&flag, sizeof(uint8_t));
    if (flag == '\x1') {
        _read_binary_tree_block(stream_, sizeof(int16_t), 16, layer_size_x, 0, 0);
    } else {
        // Grid is not present, read the fill bits.
        uint32_t fill_bits;
        stream_.read((char *)&fill_bits, sizeof(uint32_t));
    }

    /* CHEEKY HACK for our dummy Tanoa WRP */
    if (strcmp(filetype, "ACRE") == 0) {
        elevations = compressed<float>(stream_, map_size_x*map_size_x, false, false, version);
    } else {
        if (version <= 20) {
            compressed<int16_t> test_demcompress_old = compressed<int16_t>(stream_, layer_size_x*layer_size_y, true, false, version);
        }
        //Random clutter
        compressed<uint8_t> test_demcompress1 = compressed<uint8_t>(stream_, map_size_x*map_size_x, true, false, version);
        if (version >= 22) //CompressedBytes 1
            compressed<int8_t> test_demcompress2 = compressed<int8_t>(stream_, map_size_x*map_size_x, true, false, version);//map_size_x*map_size_x

        elevations = compressed<float>(stream_, map_size_x*map_size_x, true, false, version);
    }
    return true;
}
