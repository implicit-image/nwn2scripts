#include "utils"


void LoadItemsFromFile(string s2DAPath, int amount) {
    object oPC = GetControlledCharacter(OBJECT_SELF);
    int i = 0;
    int row_cap = GetNum2DARows(s2DAPath);
    // TODO: load item amount from file
    for (i = 0; i<= row_cap;i++) {
        string item = Get2DAString(s2DAPath, "REF", i);
        CreateItemOnObject(item, oPC, amount);
    }
    Log("END");
}
