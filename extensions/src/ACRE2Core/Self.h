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
        this->setCurveModel(acre::CurveModel::original);
        this->setCurrentLanguageId(0);
    };
    DECLARE_MEMBER(acre::CurveModel, CurveModel);
    DECLARE_MEMBER(BOOL, Speaking);
    DECLARE_MEMBER(int, CurrentLanguageId);
};