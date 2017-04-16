#pragma once

#include "compat.h"
#include "Macros.h"
#include "Types.h"

#include "Player.h"

#include <string>

class CSelf : public CPlayer {
public:
    CSelf() : CPlayer() {
        this->setSpeaking(false);
        this->setCurveModel(ACRE_CURVE_MODEL_ORIGINAL);
        this->setCurrentLanguageId(0);
    };
    DECLARE_MEMBER(ACRE_CURVE_MODEL, CurveModel);
    DECLARE_MEMBER(bool, Speaking);
    DECLARE_MEMBER(int, CurrentLanguageId);
};