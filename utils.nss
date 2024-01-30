
const int STATUS_GOOD = 0;
const int STATUS_BAD = 1;
const int STATUS_INFO = 2;


void Log(string message, int status=STATUS_INFO) {
    string color = "green";
    if (status == 1) {
        color = "red";
    }
    if (status == 2) {
        color = "yellow";
    }
    string RGBmsg = "<color=" + color + ">" + message + "</color>";
    SendMessageToPC(OBJECT_SELF, RGBmsg);
    PrintString(message);
}
