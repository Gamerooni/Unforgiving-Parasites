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
float Function getAccesibility()
    return parent.getAccesibility()
EndFunction
bool Function OnUpdateHourPost()
    return parent.OnUpdateHourPost()
EndFunction
Function patchDevice()
    parent.patchDevice()
EndFunction