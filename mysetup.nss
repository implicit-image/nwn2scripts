
#include "utils"
#include "feats"
#include "characters"

void main() {
    object oPC      = GetControlledCharacter(OBJECT_SELF);
    string charName = GetName(oPC);
    string s2DAPath = GetFeatFilePath(charName);
        /* string s2DAPath = "setup_feats"; */
    int testing = 1;
    int setup_result = SetupCharacter(oPC);
    if (setup_result == -1) {
        Log( "No feat config for " + charName + " found", STATUS_BAD);
    }
    Log( "CONFIG ENDED");
}
