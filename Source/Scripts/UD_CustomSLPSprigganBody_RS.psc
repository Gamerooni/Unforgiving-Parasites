scriptname UD_CustomSLPSprigganBody_RS extends UD_CustomHarness_RenderScript

import UD_native

SLP_fcts_parasites Property fctParasites  Auto

string SLPDeviceName = "SprigganRootBody"

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Spriggan Skin"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), SLPDeviceName)
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor, SLPDeviceName)
EndFunction