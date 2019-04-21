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
        this->setCurveModel(AcreCurveModel::original);
        this->setCurrentLanguageId(0);
    };
    DECLARE_MEMBER(AcreCurveModel, CurveModel);
    DECLARE_MEMBER(BOOL, Speaking);
    DECLARE_MEMBER(int, CurrentLanguageId);
};