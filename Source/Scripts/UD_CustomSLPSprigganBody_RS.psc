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

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 5)
    return 0x00000000
EndFunction