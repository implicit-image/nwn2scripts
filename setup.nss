
#include "utils"
#include "characters"
#include "items"

void main(string mode) {
    object oPC      = GetControlledCharacter(OBJECT_SELF);
    if (GetStringUpperCase(mode) == "FEATS") {
        //gives bonus spell slots according to class, default feats and feats
        //defined for this character in characters.2da
        SetupCharacter(oPC);
    }
    else if (GetStringUpperCase(mode) == "ITEMS") {
        LoadItemsFromFile("spc_items", 1);
    }
    else {
        Error("INCORRECT ARGUMENT " + mode + "\n QUITTING...");
    }
    Info("CONFIG ENDED");
}
