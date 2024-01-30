#include "utils"


int GetClassPackageId(string className) {
    int row;
    int packageId = -1;
    string s2DAPath = "packages";
    string uClassName = GetStringUpperCase(className);
    int row_cap = GetNum2DARows(s2DAPath);

    for (row = 0; row < row_cap;row++) {
        string packageLabel = Get2DAString(s2DAPath, "LABEL", row);
        if (packageLabel == "") {
            Log("ERROR GETTING CLASS PACKAGE LABEL", STATUS_BAD);
            return -1;
        }
        if (GetStringUpperCase(packageLabel) == uClassName) {
            packageId = row;
            break;
        }
    }
    return packageId;
}
//TODO: for some reason doesnt work for player character
int GetFirstLevelAsClass(object oCharacter, string className) {
    SetXP(oCharacter, 0);
    int packageId = GetClassPackageId(className);
    Log("PACKAGE ID: " + IntToString(packageId));
    if (packageId == -1) {
        Log("Using current class package");
        packageId = GetCreatureStartingPackage(oCharacter);
    }
    SetLevelUpPackage(oCharacter, packageId);
    ResetCreatureLevelForXP(oCharacter, 0, FALSE);
    return 0;
}


void main(string class) {
    int classPackageId;
    object oPC = GetControlledCharacter(OBJECT_SELF);
    classPackageId = GetClassPackageId(class);

    int currXP = GetXP(oPC);
    string sCurrXP = IntToString(currXP);
    int res = GetFirstLevelAsClass(oPC, class);

    SetXP(oPC, currXP);

    /* SetXP(oPC, 0); */
    /* SetXP(oPC, currXP); */
    /* SetXP(oPC, 0); */
}
