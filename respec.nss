#include "utils"


int GetClassPackageId(string className) {
    int row;
    int packageId = -1;
    string s2DAPath = "packages";
    string uClassName = GetStringUpperCase(className);
    int row_cap = GetNum2DARows(s2DAPath);

    for (row = 0; row < row_cap;row++) {
        string packageLabel = Get2DAString(s2DAPath, "LABEL", row);
        if (GetStringUpperCase(packageLabel) == uClassName) {
            packageId = row;
            break;
        }
    }
    return packageId;
}



//TODO: for some reason doesnt work for player character
int GetFirstLevelAsClass(object oCharacter, string className) {
    int newPackageId = GetClassPackageId(className);
    Info("TARGET PACKAGE ID: " + IntToString(newPackageId));
    if (newPackageId == -1) {
        Info("Using current class package");
        newPackageId = GetCreatureStartingPackage(oCharacter);
        if (newPackageId == 255) {
            Error("Current package is invalid!");
            return -1;
        }
    }
    Info("Setting xp to 0");
    SetXP(oCharacter, 0);
    Info("Setting up new package");
    SetLevelUpPackage(oCharacter, newPackageId);
    ResetCreatureLevelForXP(oCharacter, 0, FALSE);
    return 0;
}


void main(string class) {
    int newPackageId;
    object oPC = GetControlledCharacter(OBJECT_SELF);
    string name = GetName(oPC);
    Info("RESPECCING " + name);
    newPackageId = GetClassPackageId(class);
    int currPackage = GetCreatureStartingPackage(oPC);
    Info("Current package id is: " + IntToString(currPackage));
    int currXP = GetXP(oPC);
    int res = GetFirstLevelAsClass(oPC, class);
    SetXP(oPC, currXP);
}
