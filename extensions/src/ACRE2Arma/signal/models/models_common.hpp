#ifndef MODELS_MODELS_COMMON_HPP_
#define MODELS_MODELS_COMMON_HPP_

#include <glm/vec3.hpp>
#include <utility>
#include <vector>
#include <cmath>

#include "Types.h"
#include "../map/map.hpp"

namespace acre {
    namespace signal {
        struct reflection {
            reflection() {
                point = glm::vec3();
                normal = glm::vec3();
                phase = 0.0f;
                reflect_coefficient = 0.0f;
                path_budget_dbm = 0.0f;
                path_budget_v = 0.0f;
            };
            reflection(const glm::vec3 &point_, const glm::vec3 &normal_, const float32_t phase_, const float32_t reflect_coefficient_, const float32_t path_budget_dbm_, const float32_t path_budget_v_) : point(point_),
                    normal(normal_), phase(phase_), reflect_coefficient(reflect_coefficient_), path_budget_dbm(path_budget_dbm_), path_budget_v(path_budget_v_) { };

            reflection(const reflection &copy_) {
                point = copy_.point;
                normal = copy_.normal;
                phase = copy_.phase;
                reflect_coefficient = copy_.reflect_coefficient;
                path_budget_dbm = copy_.path_budget_dbm;
                path_budget_v = copy_.path_budget_v;
            }
            reflection(reflection &&move_) {
                point = std::move(move_.point);
                normal = std::move(move_.normal);
                phase = move_.phase;
                reflect_coefficient = move_.reflect_coefficient;
                path_budget_dbm = move_.path_budget_dbm;
                path_budget_v = move_.path_budget_v;
            }
            reflection & operator=(const reflection &copy_) {
                point = copy_.point;
                normal = copy_.normal;
                phase = copy_.phase;
                reflect_coefficient = copy_.reflect_coefficient;
                path_budget_dbm = copy_.path_budget_dbm;
                path_budget_v = copy_.path_budget_v;
                return *this;
            }
            reflection & operator=(reflection &&move_) {
                if (this == &move_) {
                    return *this;
                }
                point = std::move(move_.point);
                normal = std::move(move_.normal);
                phase = move_.phase;
                reflect_coefficient = move_.reflect_coefficient;
                path_budget_dbm = move_.path_budget_dbm;
                path_budget_v = move_.path_budget_v;
                return *this;
            }

            glm::vec3 point;
            glm::vec3 normal;
            float32_t phase;
            float32_t reflect_coefficient;
            float32_t path_budget_dbm;
            float32_t path_budget_v;
        };

        class result {
        public:
            result() : result_dbm(-1000.0f), result_v(0.0f) { };
            ~result() { };
            result(const result &copy_) {
                reflect_points = copy_.reflect_points;
                result_dbm = copy_.result_dbm;
                result_v = copy_.result_v;
            }
            result(result &&move_) {
                reflect_points = std::move(move_.reflect_points);
                result_dbm = move_.result_dbm;
                result_v = move_.result_v;
            }
            result & operator=(const result &copy_) {
                reflect_points = copy_.reflect_points;
                result_dbm = copy_.result_dbm;
                result_v = copy_.result_v;
                return *this;
            }
            result & operator=(result &&move_) {
                if (this == &move_) {
                    return *this;
                }
                reflect_points = std::move(move_.reflect_points);
                result_dbm = move_.result_dbm;
                result_v = move_.result_v;
                return *this;
            }
            std::vector<reflection> reflect_points;
            float32_t result_dbm;
            float32_t result_v;
        };

        class SignalModel {
        public:
            SignalModel() {}
            ~SignalModel() {}
        protected:
            map_p _map;
            float32_t dbm_to_v(const float32_t dBm, const float32_t r) {
                return sqrtf((r*.001f) * powf(10.0f, dBm * 0.1f));
            }
            float32_t v_to_dbm(const float32_t v, const float32_t r) {
                return 10.0f * logf((v*v) / (r * 0.001f)) / 2.3025f;
            }

            float32_t mW_to_dbm (const float32_t power_mW) {
                return 10.0f*log10f(power_mW/1000.0f) + 30.0f;
            }
        };
    }
}

#endif /* MODELS_MODELS_COMMON_HPP_ */
