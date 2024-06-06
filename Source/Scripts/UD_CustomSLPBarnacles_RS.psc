Scriptname UD_CustomSLPBarnacles_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "Barnacles" )
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.OnRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "Barnacles")
EndFunction

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 5)
    return 0x00000000
EndFunction