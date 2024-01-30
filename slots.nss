#include "utils"
#include "feats"


string ClassFromLabel(string label) {
    string class;
    class = GetSubString(label, 16, 30);
    Log("Class: " + class + " from label " + label);
    return class;
}



void GiveSlots(object oPC) {
    int row;
    int class_pos;
    string s2DAPath = "extra_slots";
    int row_cap = GetNum2DARows(s2DAPath);
    for (class_pos = 1; class_pos <= 4; class_pos++) {
        int classId = GetClassByPosition(class_pos, oPC);
        if (classId == CLASS_TYPE_INVALID) {
            break;
        }
        string uClass = GetStringUpperCase(Get2DAString("classes", "LABEL", classId));
        for (row = 0; row <row_cap; row++) {
            string label = Get2DAString(s2DAPath, "LABEL", row);
            string classLabel = GetStringUpperCase(ClassFromLabel(label));
            if (classLabel == uClass) {
                int id = StringToInt(Get2DAString(s2DAPath, "ID", row));
                int length = StringToInt(Get2DAString(s2DAPath, "LENGTH", row));
                AddCompactFeat(oPC, id, length);
            }
        }
    }
}