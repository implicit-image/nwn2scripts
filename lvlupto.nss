#include "utils"


void main(int nTargetLevel) {
    int i;
    int xpToGive = 0;
    int lastLevelXP = 1000;
    object oPC = GetControlledCharacter(OBJECT_SELF);
    for (i = 1; i <= nTargetLevel; i++) {
        xpToGive += i * 1000;
    }
    SetXP(oPC, xpToGive);
}
