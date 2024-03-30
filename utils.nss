
const int STATUS_GOOD = 0;
const int STATUS_BAD = 1;
const int STATUS_INFO = 2;


void Log(string message, int status=STATUS_INFO, string color="") {
    if (color == "") {
        string color = "green";
        if (status == 1) {
            color = "red";
        }
        if (status == 2) {
            color = "yellow";
        }
    }
    string RGBmsg = "<color=" + color + ">" + message + "</color>";
    SendMessageToPC(OBJECT_SELF, RGBmsg);
    PrintString(message);
}

void Info(string message, string color="") {
    Log(message, STATUS_INFO, color);
}

void Error(string message, string color="") {
    Log(message, STATUS_BAD, color);
}

void Success(string message, string color="") {
    Log(message, STATUS_GOOD, color);
}

int Clamp(int iValue, int iLower=0, int iUpper=40) {
    if (iValue > iUpper) { return iUpper; }
    if (iValue < iLower) { return iLower; }
    return iValue;
}
