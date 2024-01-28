
#include "x0_i0_stringlib"


void Log(object oTarget, string message, int isBad=FALSE) {
  string color = "green";
  if (isBad) {
    color = "red";
  }
  string RGBmsg = "<color=" + color + ">" + message + "</color>";
  SendMessageToPC(oTarget, RGBmsg);
}



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

    Log(oCreature, "NOW GIVING " + currFeatLabel);
    if (bGiveReq) {
      bCheckReq = FALSE;
      if (prereq1) {
        Log(oCreature, "PREREQ 1 is " + prereq1Label);
        if (!hasPrereq1) {
          Log(oCreature, "PLAYER DOESNT HAVE " + prereq1Label + ", ADDING");
          SmartAddFeat(oCreature, prereq1, bCheckReq, bGiveReq, bFeedback);
        }
        if (prereq2) { //there are 2 prereqs
          Log(oCreature, "PREREQ 2 is " + prereq2Label);
          if (!hasPrereq2) {
            Log(oCreature, "PLAYER DOESNT HAVE " + prereq2Label + ", ADDING");
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



void main()
  {
    int row;
    object oPC      = GetControlledCharacter(OBJECT_SELF);
    string s2DApath = "setup_feats";
    int row_cap     = -1;
    /* int row_cap     = GetNum2DARows(s2DApath); */



    if( row_cap == -1 ) {
      //Log(oPC, "FILE NOT FOUND", TRUE);
      string sNotFeatList = Get2DAString(s2DApath, "FETLISTDATA", 20);
      Log(oPC, sNotFeatList, TRUE);
      string sFeatList  = Get2DAString(s2DApath, "FEATLISTDATA", 28);
      Log(oPC, sFeatList, TRUE);
      AddCompactFeatList(oPC, sFeatList);
    } else {
      for (row = 1; row <= row_cap; row++) {
        string feat_label = Get2DAString(s2DApath, "LABEL", row);
        string sFeatID    = Get2DAString(s2DApath, "ID", row);
        string sLength    = Get2DAString(s2DApath, "LENGTH", row);
        string sFeatList  = Get2DAString (s2DApath, "FEATLISTDATA", row);
        if (sFeatID == "" || feat_label == "" || sLength == "" ) {
          Log(oPC, "END OF FILE", TRUE);
          break;
        }
        int featID = StringToInt(sFeatID);
        int length  = StringToInt(sLength);
        if (length > 1) {
          Log(oPC, "This is a compact one", TRUE);
          AddCompactFeat(oPC, featID, length);
        } else if (sFeatList != "" && sFeatList != "**") {
          AddCompactFeatList(oPC, sFeatList);
        } else {
          FeatAdd(oPC, featID, 0, 1, 0);
        }
      }
    }
    SmartAddFeat(oPC, 2, FALSE, TRUE, TRUE);
    Log(oPC, "CONFIG ENDED");
}
