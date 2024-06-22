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

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function InitPost()
    parent.InitPost()
EndFunction
Function safeCheck()
    parent.safeCheck()
EndFunction
Function patchDevice()
    parent.patchDevice()
EndFunction
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
EndFunction
bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return parent.struggleMinigame(type, abSilent)
EndFunction
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    return parent.struggleMinigameWH(akHelper, aiType)
EndFunction
float Function getAccesibility()
    return parent.getAccesibility()
EndFunction
int Function getPlugType()
    return parent.getPlugType()
EndFunction
bool Function forceOutPlugMinigame(Bool abSilent = False)
    return parent.forceOutPlugMinigame(abSilent)
EndFunction
Bool Function forceOutPlugMinigameWH(Actor akHelper,Bool abSilent = False)
    return parent.forceOutPlugMinigameWH(akHelper, abSilent)
EndFunction
Function updateWidget(bool force = false)
    parent.updateWidget(force)
EndFunction
Function onSpecialButtonPressed(float fMult)
    parent.onSpecialButtonPressed(fMult)
EndFunction
Function OnCritDevicePost()
    parent.OnCritDevicePost()
EndFunction
bool Function Details_CanShowResist()
    return parent.Details_CanShowResist()
EndFunction 
bool Function Details_CanShowHitResist()
    return parent.Details_CanShowHitResist()
EndFunction 
Function OnMinigameTick1()
    parent.OnMinigameTick1()
EndFunction