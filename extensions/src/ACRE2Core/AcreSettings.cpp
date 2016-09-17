#include "AcreSettings.h"
#include "Log.h"
#include <fstream>

ACRE_RESULT CAcreSettings::save(std::string filename) {
    // Write the shit out by hand for now
    std::ofstream iniFile;

    iniFile.open(filename, std::ios::trunc);
    if (!iniFile.is_open()) {
        return ACRE_ERROR;
    }
    iniFile << "[acre2]\n";
    iniFile << "lastVersion = " << ACRE_VERSION << ";\n";
    iniFile << "globalVolume = " << this->m_GlobalVolume << ";\n";
    iniFile << "premixGlobalVolume = " << this->m_PremixGlobalVolume << ";\n";
    iniFile << "disableUnmuteClients = " << (this->m_DisableUnmuteClients ? "true" : "false") << ";\n";

    //LOG("Config Save: %f,%f", m_GlobalVolume, m_PremixGlobalVolume);
    iniFile.flush();
    iniFile.close();

    return ACRE_OK;
}

ACRE_RESULT CAcreSettings::load(std::string filename) {
    // Write the shit out by hand for now
    ini_reader config(filename);

    if (config.ParseError() < 0) {
        LOG("Failed to load ACRE ini file. Using defaults...");
        this->save(filename);
        return ACRE_ERROR;
    } else {
        LOG("Successfully loaded ACRE ini file (any failures above can be ignored).");
    }

    this->m_LastVersion = config.Get("acre2", "lastVersion", ACRE_VERSION);
    this->m_GlobalVolume = (float)config.GetReal("acre2", "globalVolume", 1.0f);
    this->m_PremixGlobalVolume = (float)config.GetReal("acre2", "premixGlobalVolume", 1.0f);
    this->m_DisableUnmuteClients = config.GetBoolean("acre2", "disableUnmuteClients", false);

    //LOG("Config Load: %f,%f", m_GlobalVolume, m_PremixGlobalVolume);
    this->m_Path = filename;

    return ACRE_OK;
}

ACRE_RESULT CAcreSettings::save() {
    // Write the shit out by hand for now
    return this->save(this->m_Path);
}
ACRE_RESULT CAcreSettings::load() {
    // Write the shit out by hand for now
    return load(this->m_Path);
}

CAcreSettings::CAcreSettings() :
    m_GlobalVolume(1.0f),
    m_PremixGlobalVolume(1.0f),
    m_DisablePosition(false),
    m_DisableMuting(false),
    m_EnableAudioTest(false),
    m_DisableRadioFilter(false),
    m_DisableUnmuteClients(false),
    m_LastVersion(ACRE_VERSION),
    m_Path("acre2.ini")
    {
    // Set defaults!
    //LOG("Config Singleton Initialized");
    this->load();
}


CAcreSettings::~CAcreSettings() {

}
