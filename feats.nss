#include "x0_i0_stringlib"


// intelligently add features heck for requirements, can give requirements
// or not give a feat if requirements are not satisfied
// TODO: deal with prerequisite cycles and redundat adding of feats
int SmartAddFeat(
    object oCreature,
    int featID,
    int bCheckReq=FALSE,
    int bGiveReq=FALSE,
    int bFeedback=FALSE)
    {
        string sFeat2DA      = "feat";
        string currFeatLabel = Get2DAString(sFeat2DA, "LABEL", featID);
        int    prereq1       = StringToInt(Get2DAString(sFeat2DA, "PREREQFEAT1", featID));
        string prereq1Label  = Get2DAString(sFeat2DA, "LABEL", prereq1);
        int    prereq2       = StringToInt(Get2DAString(sFeat2DA, "PREREQFEAT2", featID));
        string prereq2Label  = Get2DAString(sFeat2DA, "LABEL", prereq2);
        int    hasPrereq1    = GetHasFeat(prereq1, oCreature);
        int    hasPrereq2    = GetHasFeat(prereq2, oCreature);

        Log( "NOW GIVING " + currFeatLabel);
        if (bGiveReq) {
            bCheckReq = FALSE;
            if (prereq1) {
                Log("PREREQ 1 is " + prereq1Label);
                if (!hasPrereq1) {
                    Log( "PLAYER DOESNT HAVE " + prereq1Label + ", ADDING");
                    SmartAddFeat(oCreature, prereq1, bCheckReq, bGiveReq, bFeedback);
                }
                if (prereq2) { //there are 2 prereqs
                    Log( "PREREQ 2 is " + prereq2Label);
                    if (!hasPrereq2) {
                        Log( "PLAYER DOESNT HAVE " + prereq2Label + ", ADDING");
                        SmartAddFeat(oCreature, prereq2, bCheckReq, bGiveReq, bFeedback);
                    }
                }
            }
            FeatAdd(oCreature, featID, FALSE);
        } else if (bCheckReq) {
            if (hasPrereq1 && hasPrereq2) {
                //reqs are satisfied
                FeatAdd(oCreature, featID, FALSE);
                return 0;
            }
            return -1;
        }
        return FeatAdd(oCreature, featID, FALSE);
}

//FIRST COMPACT FEATS IMPLEMENTATION
//
//
// compact feat entries are basicly just pointers to rows in feat.2da
// adding compact feats is just adding a set number of consequent feat entries
// returns 1 if everything succeds
//
//                                             how many next feats to take
//                                             starting from position ID
//arbitrary, for user only                           |
//         |           is a feat id from feat.2da    |
//         v            v                            v
//         LABEL      ID                          LENGTH
//   0    splfocus    x                              8
//
// AddCompactFeat(oPC, x, 8) adds x, x+1, x+2, ..., x + 7
//
int AddCompactFeat(object oCreature, int featID, int length) {
    int cnt = 0;
    for (cnt = 0; cnt < length; cnt++) {
        SmartAddFeat(oCreature, featID + cnt, 0, 1, 0);
    }
    return 0;
}






//SECOND COMPACT FEATS IMPLEMENTATION
//
//      LABEL    ......   FEATLISTDATA
//0      label   ......  "4:7,34:5,234:20"
//
//
//
int AddCompactFeatList(object oCreature, string sFeatList) {
    //TODO: check if read data is in fact a feat list
    struct sStringTokenizer tokenizer = GetStringTokenizer(sFeatList, ",");
    while(HasMoreTokens(tokenizer)) {
        tokenizer    = AdvanceToNextToken(tokenizer);
        string token = GetNextToken(tokenizer);
        int row    = StringToInt(GetTokenByPosition(token, ":", 0));
        int length = StringToInt(GetTokenByPosition(token, ":", 1));

        AddCompactFeat(oCreature, row, length);
    }
    return 0;
}
