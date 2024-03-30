#include "utils"
#include "feats"
#include "slots"

string GetCharacterFile(string sCharacterName, string sFileType) {
    int row;
    // correct path
    string s2DAPath = "characters";
    Info("characters file path is " + s2DAPath);
    string sColumn = "FEATS_FILE";
    if (sFileType == "EQUIPMENT") {
        sColumn = "EQUIPMENT_FILE";
    }
    int row_cap = GetNum2DARows(s2DAPath);
    for (row = 0;row<row_cap;row++) {
        string name = Get2DAString(s2DAPath, "NAME", row);
        if (name == "") {
            Error("READING FROM " + s2DAPath + " FUCKED UP!!!");
        }
        if (name == sCharacterName) {
            string rsrcPath = Get2DAString(s2DAPath, sColumn, row);
            Info("PATH: " + rsrcPath);
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
        Success("sFeatList for " + feat_label + " is " + sFeatLis);
        if (feat_label == "") {
            Success( "END OF FILE");
            break;
        }
        int featID = StringToInt(sFeatID);
        int length  = StringToInt(sLength);
        if (length > 1) {
            Success("ADDING COMPACT FEAT: " + feat_label);
            AddCompactFeat(oPC, featID, length);
        } else if (sFeatList != "") {
            Success("ADDING COMPACT FEAT LIST: " + feat_label + " " + sFeatList);
            AddCompactFeatList(oPC, sFeatList);
        } else {
            FeatAdd(oPC, featID, 0, 1, 0);
        }
    }
}

void GiveBasicFeats(object oPC) {
    Info("GIVING BASIC FEATS: ");
    LoadFeatsFromFile(oPC, "def_feats");
}

int GiveCharacterFeats(object oPC) {
    string name = GetName(oPC);
    Info("LOADING CHARACTER FEATS FOR" + name);
    string s2DAPath = GetFeatFilePath(name);
    if (s2DAPath == "") {
        // this character does not have feat file path defined
        Error("FAILED GETTING CHARACTER FEAT FILE")
;       return -1;
    }
    LoadFeatsFromFile(oPC, s2DAPath);
    return 0;
}

int SetupCharacter(object oPC) {
    string name = GetName(oPC);
    Error("SETTING UP " + name + " -------------");
    // give bonus spell slots corresponding to class
    GiveSlots(oPC);
    GiveBasicFeats(oPC);
    GiveCharacterFeats(oPC);
    return 0;
}
