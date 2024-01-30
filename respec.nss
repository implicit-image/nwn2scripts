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
    Log("TARGET PACKAGE ID: " + IntToString(newPackageId));
    if (newPackageId == -1) {
        Log("Using current class package");
        newPackageId = GetCreatureStartingPackage(oCharacter);
        if (newPackageId == 255) {
            Log("Current package is invalid!", STATUS_BAD);
            return -1;
        }
    }
    Log("Setting xp to 0");
    SetXP(oCharacter, 0);
    Log("Setting up new package");
    SetLevelUpPackage(oCharacter, newPackageId);
    ResetCreatureLevelForXP(oCharacter, 0, FALSE);
    return 0;
}


void main(string class) {
    int newPackageId;
    object oPC = GetControlledCharacter(OBJECT_SELF);
    string name = GetName(oPC);
    Log("RESPECCING " + name);
    newPackageId = GetClassPackageId(class);
    int currPackage = GetCreatureStartingPackage(oPC);
    Log("Current package id is: " + IntToString(currPackage));
    int currXP = GetXP(oPC);
    int res = GetFirstLevelAsClass(oPC, class);
    SetXP(oPC, currXP);
}
