Scriptname UD_CustomSLPChaurusQueenGag_RS extends UD_CustomGag_RenderScript

; fix keys and locks (i.e. remove them)

SLP_fcts_parasites Property fctParasites  Auto

function InitInitPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenGag" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenGag")
EndFunction 

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 5)
    return 0x00000000
EndFunction

;Deactivate useless struggle
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    if !UDCDmain.currentDeviceMenu_allowstruggling ;canBeStruggled()
        UDCDMain.disableStruggleCondVar(false)
    endif
EndFunction

;Deactivate useless struggle
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    if !UDCDmain.currentDeviceMenu_allowstruggling ;canBeStruggled()
        UDCDMain.disableStruggleCondVar(false)
    endif
EndFunction