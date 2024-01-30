#include "utils"
#include "feats"
#include "slots"

string GetCharacterFile(string sCharacterName, string sFileType) {
    int row;
    // correct path
    string s2DAPath = "characters";
    Log("characters file path is " + s2DAPath);
    string sColumn = "FEATS_FILE";
    if (sFileType == "EQUIPMENT") {
        sColumn = "EQUIPMENT_FILE";
    }
    int row_cap = GetNum2DARows(s2DAPath);
    for (row = 0;row<row_cap;row++) {
        string name = Get2DAString(s2DAPath, "NAME", row);
        if (name == "") {
            Log("READING FROM " + s2DAPath + " FUCKED UP!!!", STATUS_BAD);
        }
        if (name == sCharacterName) {
            string rsrcPath = Get2DAString(s2DAPath, sColumn, row);
            Log("PATH: " + rsrcPath);
            if (rsrcPath == "****") {
                // character is defined but does not have feats file
                if (sColumn == "EQUIPMENT_FILE") {
                    return "def_eq";
                } else if (sColumn == "FEATS_FILE") {
                    return "def_feats";
                }
            }
            return rsrcPath;
        }
    }
    return "";
}


string GetFeatFilePath(string sCharacterName) {
    return GetCharacterFile(sCharacterName, "FEATS_FILE");
}

string GetEquipmentFilePath(string sCharacterName) {
    return GetCharacterFile(sCharacterName, "EQUIPMENT_FILE");
}


void LoadFeatsFromFile(object oPC, string s2DAPath) {
    int row;
    int row_cap = GetNum2DARows(s2DAPath);
    for (row = 1; row <= row_cap; row++) {
        string feat_label = Get2DAString(s2DAPath, "LABEL", row);
        string sFeatID    = Get2DAString(s2DAPath, "ID", row);
        string sLength    = Get2DAString(s2DAPath, "LENGTH", row);
        string sFeatList  = Get2DAString (s2DAPath, "FEATLISTDATA", row);
        if (sFeatID == "" || feat_label == "" || sLength == "" ) {
            Log( "END OF FILE", STATUS_GOOD);
            break;
        }
        int featID = StringToInt(sFeatID);
        Log("Adding feat " + feat_label);
        int length  = StringToInt(sLength);
        if (length > 1) {
            AddCompactFeat(oPC, featID, length);
        } else if (sFeatList != "" && sFeatList != "**") {
            AddCompactFeatList(oPC, sFeatList);
        } else {
            FeatAdd(oPC, featID, 0, 1, 0);
        }
    }
}


int SetupCharacter(object oPC, int useDefault) {
    string name = GetName(oPC);
    // give bonus spell slots corresponding to class
    GiveSlots(oPC);
    string s2DAPath = GetFeatFilePath(name);
    if (s2DAPath == "") {
        if (useDefault == 1) { // 1 == TRUE
            Log("Using default feat config");
            s2DAPath = "def_feats";
        } else {
            // this character does not have feat file path defined
            return -1;
        }
    }
    Log("Character feat file path is " + s2DAPath);
    LoadFeatsFromFile(oPC, s2DAPath);
    return 0;
}
