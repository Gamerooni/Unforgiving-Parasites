Scriptname UD_CustomSLPTentacleMonster_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS
;MUST FILL IN AS SENTIENT

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "TentacleMonster")
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The tentacles writhe inside and outside; your skin tingles beneath their streaks of slime.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction

; bool Function canBeStruggled(float afAccesibility = -1.0)
; 	return false
; EndFunction

float Function getAccesibility()
	return 0.0
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    UDCDmain.currentDeviceMenu_allowSpecialMenu = False
EndFunction

Function onRemoveDevicePost(Actor akActor)
    fctParasites.cureParasiteByString(getWearer(), "TentacleMonster")
    parent.onRemoveDevicePost(akActor)
EndFunction

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 5)
    return 0x00000000
EndFunction