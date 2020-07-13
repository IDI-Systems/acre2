#include "landscape.hpp"
#include <exception>

acre::wrp::landscape::landscape(const std::string &path_) {
    std::ifstream stream(path_, std::ifstream::binary);
    _process(stream);
    stream.close();
}

acre::wrp::landscape::landscape(std::istream &stream_) {
    _process(stream_);
}

acre::wrp::LandscapeResult acre::wrp::landscape::parse(const std::string &path_) {
    std::ifstream stream(path_, std::ifstream::binary);
    _process(stream);
    stream.close();

    return failure;
}

acre::wrp::LandscapeResult acre::wrp::landscape::parse(std::istream &stream_) {
    _process(stream_);

    return failure;
}

acre::wrp::landscape::~landscape() {
}

bool acre::wrp::landscape::_read_binary_tree_block(std::istream &stream_, const uint32_t bit_length, const uint32_t block_size, const uint32_t cell_size, const uint32_t block_offset_x, const uint32_t block_offset_y)
{
    uint32_t blockSize = 1;
    if (block_size != 0) {
        blockSize = static_cast<uint32_t>(ceil((log10(block_size) / log10(2.0)) / 2.0));
        blockSize = static_cast<uint32_t>(pow(2, 2.0 * blockSize));
    }

    const uint32_t current_block_size = blockSize / 4u;//256..64..16..1

    uint16_t packet_flag = 0;
    stream_.read((char *)&packet_flag, sizeof(uint16_t));

    for (int32_t bit_count = 0; bit_count < 16; bit_count++, packet_flag >>= 1) {
        const uint32_t current_block_offset_x = block_offset_x + (bit_count % 4) * blockSize*bit_length;// 0,1,2,3
        const uint32_t current_block_offset_y = block_offset_y + ((bit_count / 4) * blockSize); // 0,1,2,3

        if (packet_flag & 1) {
            if (!_read_binary_tree_block(stream_, bit_length, current_block_size, cell_size, current_block_offset_x, current_block_offset_y)) {
                return false;
            }
        } else {
            uint16_t A = 0, B = 0;
            stream_.read((char *)&A, bit_length);
            stream_.read((char *)&B, bit_length);
            if (!A && !B) {
                continue; // filler
            }

            if ((current_block_offset_x >= cell_size) || (current_block_offset_y >= cell_size)) {
                return false;
            }

            for (uint32_t iy = 0u; iy < current_block_offset_y; iy++) {
                for (uint32_t ix = 0u; ix < current_block_size; ix++)
                {
                    const int32_t OffsetAB = ((current_block_offset_y + iy)*cell_size) + current_block_offset_x + ix;
                    //_Grid[OffsetAB] = A; _Grid[OffsetAB + ThisBlockSize.x] = B;
                }
            }
        }
    }
    return true;
}

bool acre::wrp::landscape::_process(std::istream &stream_) {
    stream_.read(filetype, 4);
    filetype[4] = 0x00;
    failure = LandscapeResult::Success;

    if (strcmp(filetype, "8WVR") == 0) {
        // Header
        //Texture Size
        stream_.read((char *)&layer_size_x, sizeof(uint32_t));
        stream_.read((char *)&layer_size_y, sizeof(uint32_t));
        //TerrainGrid Size
        stream_.read((char *)&map_size_x, sizeof(uint32_t));
        stream_.read((char *)&map_size_y, sizeof(uint32_t));
        //Cell size
        stream_.read((char *)&cell_size, sizeof(float32_t));
        map_grid_size = cell_size;

        // elevations (Elevations   [TerrainGridSize.y][TerrainGridSize.x];)
        elevations = compressed<float32_t>(stream_, map_size_x * map_size_x, false, false, version);

        //Generate peaks.
        return true;
    }
    
    // Proceed with OPRW/ACRE
    stream_.read((char *)&version, sizeof(uint32_t));
    if (version > 24) {
        stream_.read((char *)&some_bit, sizeof(uint32_t));
    }
    stream_.read((char *)&layer_size_x, sizeof(uint32_t));
    stream_.read((char *)&layer_size_y, sizeof(uint32_t));
    stream_.read((char *)&map_size_x, sizeof(uint32_t));
    stream_.read((char *)&map_size_y, sizeof(uint32_t));

    stream_.read((char *)&cell_size, sizeof(float32_t));
    map_grid_size = cell_size * layer_size_x / map_size_x;

    // Failure is only likely on recompression/reading gridblocks.
    try {
        uint8_t flag; // Determines if the blocks are present.

        /* GridBlock - CellEnv */
        stream_.read((char *)&flag, sizeof(uint8_t));
        if (flag == '\x1') {
            _read_binary_tree_block(stream_, sizeof(uint16_t), 16, map_size_x, 0, 0);
        } else {
            // Grid is not present, read the fill bits.
            uint32_t fill_bits;
            stream_.read((char *)&fill_bits, sizeof(uint32_t));
        }

        /* GridBlock - CfgEnvSounds */
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

        float32_t *peak_floats = new float32_t[peak_count * 3u];
        stream_.read((char *)peak_floats, sizeof(float32_t)*peak_count * 3u);

        for (uint32_t i = 0u; i < peak_count * 3u; i = i + 3u) {
            peaks.push_back(vector3<float32_t>(peak_floats[i], peak_floats[i + 1u], peak_floats[i + 2u]));
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
            elevations = compressed<float32_t>(stream_, map_size_x * map_size_x, false, false, version);
        } else {
            //Random clutter
            if (version <= 20) {
                compressed<int16_t> test_demcompress_old = compressed<int16_t>(stream_, layer_size_x*layer_size_y, true, false, version); // int16_t
            } else {
                compressed<uint8_t> test_demcompress1 = compressed<uint8_t>(stream_, map_size_x*map_size_y, true, false, version);
            }
            if (version >= 22) { //CompressedBytes 1
                compressed<uint8_t> test_demcompress2 = compressed<uint8_t>(stream_, map_size_x*map_size_y, true, false, version);
            }

            elevations = compressed<float32_t>(stream_, map_size_x * map_size_y, true, false, version);
        }
    } catch (std::exception& e) {
        LOG(ERROR) << "WRP Parsing exception: " << e.what();
        //Insert 1 peak in the middle.
        peaks.clear();
        peaks.push_back(vector3<float32_t>((map_size_x * map_grid_size)/2.0f, (map_size_y * map_grid_size)/2.0f, 0.0f));

        // Fill elevation grid with 0 data.
        for (uint32_t x = 0u; x < (map_size_x * map_size_y); x++) {
            elevations.data.push_back(0.0f);
        }
        //elevations.size = elevations
        failure = LandscapeResult::Recovered;
    }
    return true;
}


acre::Result acre::wrp::landscape::generateAcreWrp(std::ofstream &out) {

    /*
     * Following the file format https://community.bistudio.com/wiki/Wrp_File_Format_-_OPRWv17_to_24
     * in order to be compatible with our parser.
     */

    // ===================== Header =====================
    out.write("ACRE", 4);                                // Filetype
    out.write((char *)&version, sizeof(uint32_t));       // Version

    // Some dummy bits
    uint32_t fill_bits = 0u;
    out.write((char *)&fill_bits, sizeof(uint32_t));     // As of version 25

    out.write((char *)&layer_size_x, sizeof(uint32_t));  // Layer  Size
    out.write((char *)&layer_size_y, sizeof(uint32_t));

    out.write((char *)&map_size_x, sizeof(uint32_t));    // Map Size
    out.write((char *)&map_size_y, sizeof(uint32_t));

    out.write((char *)&cell_size, sizeof(uint32_t));     // Layer Cell Size

    // ===================== Grid Block Cell Environment =====================
    uint8_t not_present = 0;
    out.write((char *)&not_present, sizeof(uint8_t));    // In order to spare size, we do not fill anything
    out.write((char *)&fill_bits, sizeof(uint32_t));

    // ===================== Grid Block CfgEnvSounds =====================
    out.write((char *)&not_present, sizeof(uint8_t));    // In order to spare size, we do not fill anything
    out.write((char *)&fill_bits, sizeof(uint32_t));

    // ===================== Peaks =====================
    fill_bits = static_cast<uint32_t>(peaks.size());
    out.write((char *)&fill_bits, sizeof(uint32_t));

    for (auto peak : peaks) {
        float32_t value = peak.x();
        out.write((char *)&value, sizeof(float32_t));
        value = peak.y();
        out.write((char *)&value, sizeof(float32_t));
        value = peak.z();
        out.write((char *)&value, sizeof(float32_t));
    }

    // ===================== Grid Block Rvmat Layer Index =====================
    out.write((char *)&not_present, sizeof(uint8_t));    // In order to spare size, we do not fill anything
    out.write((char *)&fill_bits, sizeof(uint32_t));

    // ===================== And now the ACRE hack: elevations =====================
    for (uint32_t elevIdx = 0u; elevIdx < (map_size_x * map_size_y); elevIdx++) {
        out.write((char *) &elevations[elevIdx], sizeof(float32_t));
    }

    return acre::Result::ok;
}
