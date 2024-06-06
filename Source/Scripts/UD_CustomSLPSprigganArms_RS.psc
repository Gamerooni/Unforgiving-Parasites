scriptname UD_CustomSLPSprigganArms_RS extends UD_CustomGloves_RenderScript

import UD_native

SLP_fcts_parasites Property fctParasites  Auto

string SLPDeviceName = "SprigganRootArms"

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Spriggan Hands"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), SLPDeviceName)
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor, SLPDeviceName)
EndFunction