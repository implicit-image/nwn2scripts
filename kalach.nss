#include "utils"

void main() {
    object oPC = GetControlledCharacter(OBJECT_SELF);

    if (GetHasFeat(1700, oPC, TRUE)) {
        Info("KALACH FEAT NR 1");
    }
    if (GetHasFeat(1823, oPC, TRUE)) {
        Info("KALACH FEAT NR 2");
    }
    if (GetHasFeat(1824, oPC, TRUE)){
        Info("KALACH FEAT NR 3");
    }
}
