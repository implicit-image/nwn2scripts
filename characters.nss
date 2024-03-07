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
    for (row = 0; row < row_cap; row++) {
        string feat_label = Get2DAString(s2DAPath, "LABEL", row);
        string sFeatID    = Get2DAString(s2DAPath, "ID", row);
        string sLength    = Get2DAString(s2DAPath, "LENGTH", row);
        string sFeatList  = Get2DAString (s2DAPath, "FEATLISTDATA", row);
        Log("sFeatList for " + feat_label + " is " + sFeatList, STATUS_GOOD);
        if (feat_label == "") {
            Log( "END OF FILE", STATUS_GOOD);
            break;
        }
        int featID = StringToInt(sFeatID);
        int length  = StringToInt(sLength);
        if (length > 1) {
            Log("ADDING COMPACT FEAT: " + feat_label, STATUS_GOOD);
            AddCompactFeat(oPC, featID, length);
        } else if (sFeatList != "") {
            Log("ADDING COMPACT FEAT LIST: " + feat_label + " " + sFeatList, STATUS_GOOD);
            AddCompactFeatList(oPC, sFeatList);
        } else {
            FeatAdd(oPC, featID, 0, 1, 0);
        }
    }
}

void GiveBasicFeats(object oPC) {
    Log("GIVING BASIC FEATS: ", STATUS_BAD);
    LoadFeatsFromFile(oPC, "def_feats");
}

int LoadCharacterFeats(object oPC) {
    string name = GetName(oPC);
    Log("LOADING CHARACTER FEATS FOR" + name, STATUS_BAD);
    string s2DAPath = GetFeatFilePath(name);
    if (s2DAPath == "") {
        // this character does not have feat file path defined
        Log("FAILED GETTING CHARACTER FEAT FILE", STATUS_BAD)
;       return -1;
    }
    LoadFeatsFromFile(oPC, s2DAPath);
    return 0;
}

int SetupCharacter(object oPC) {
    string name = GetName(oPC);
    Log("SETTING UP " + name + " -------------", STATUS_BAD);
    // give bonus spell slots corresponding to class
    GiveSlots(oPC);
    GiveBasicFeats(oPC);
    LoadCharacterFeats(oPC);
    return 0;
}
