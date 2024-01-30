
#include "utils"
#include "feats"
#include "characters"


void main() {
    object oPC      = GetControlledCharacter(OBJECT_SELF);
    string charName = GetName(oPC);
    string s2DAPath = GetFeatFilePath(charName);
    int setup_result = SetupCharacter(oPC, 1);
    Log( "CONFIG ENDED");
}
