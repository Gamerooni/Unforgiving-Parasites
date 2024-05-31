Scriptname UD_CustomSLPChaurusQueenArmor_RS extends UD_CustomHarness_RenderScript

; remove locks

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenArmor" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenArmor")
EndFunction 

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 3)
    return 0x00000000
EndFunction