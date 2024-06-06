scriptname UD_CustomSLPFaceHuggerGag_RS extends UD_CustomGag_RenderScript

; MORE OR LESS PLACEHOLDER - FILL OUT PROPERLY

import UD_native

SLP_fcts_parasites Property fctParasites  Auto

string SLPDeviceName = "FaceHuggerGag"

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Face Hugger"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), SLPDeviceName)
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor, SLPDeviceName)
EndFunction