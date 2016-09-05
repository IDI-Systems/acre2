#pragma once

#include "shared.hpp"
#include "glm\vec3.hpp"
#include "glm\vec2.hpp"
#include "antenna\antenna.hpp"
#include "map\map.hpp"

#define PHASE_EQ(d) ((6.28318530718f*(d) / (300.0f / f_mhz_)))

#define PI 3.14159265f


namespace acre {
    namespace signal {

        struct reflection {
            reflection() {};
            reflection(glm::vec3 point_, glm::vec3 normal_, float phase_, float reflect_coefficient_, float path_budget_dbm_, float path_budget_v_) : point(point_),
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
            float phase;
            float reflect_coefficient;
            float path_budget_dbm;
            float path_budget_v;
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
            float result_dbm;
            float result_v;


        };

        namespace model {

            class los_simple {
            public:
                los_simple() {};
                los_simple(map_p);
                ~los_simple();

                void process(result *, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const antenna_p &, const antenna_p &, float, float, float, bool);



                float _itu(float, float, float, float);
                float _diffraction_loss(glm::vec3, glm::vec3, float);
            protected:
                map_p _map;
                float _dbm_to_v(float dBm_, float r_) {
                    return sqrt((r_*.001f) * std::pow(10.0f, dBm_ * 0.1f));
                }
                float _v_to_dbm(float v_, float r_) {
                    return 10.0f * std::log((v_*v_) / (r_ * 0.001f)) / 2.3025f;
                }
                
            };

            class multipath : public los_simple {
            public:
                multipath() {};
                multipath(map_p);
                ~multipath();

                void process(result *, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const antenna_p &, const antenna_p &, float, float, float, bool);

            protected:

                void _get_peaks_spiral(float, float, int, int, std::vector<glm::vec3> &);
                std::vector<std::vector<glm::vec3>> _peak_buckets;
                float _phase(float path_distance_, float f_mhz_) {
                    return fmod(PHASE_EQ(path_distance_), PI * 2) - PI;
                }
                float _phase_amplitude(float a1_, float a2_, float phase_) {
                    return sqrt(std::pow(a1_, 2.0f) + std::pow(a2_, 2.0f) + 2.0f*a1_*a2_*cos(phase_));
                }
                float _search_distance(float, float);
                std::map<float, std::map<float, float>> _distance_cache;
                glm::vec3 _cached_tx_pos;
                std::vector<glm::vec3> _cached_peaks;
            };
        }
    }
}