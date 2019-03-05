#pragma once

#include "shared.hpp"
#include "glm\vec3.hpp"
#include "glm\vec2.hpp"
#include "antenna\antenna.hpp"
#include "map\map.hpp"


namespace acre {
    namespace signal {
        namespace model {
            class Arcade {
                public:
                    Arcade();
                    ~Arcade();

                    void process(result *, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const antenna_p &, const antenna_p &, float, float, float, bool);
            }
        }
    }
}
