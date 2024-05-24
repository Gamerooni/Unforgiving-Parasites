Scriptname UD_CustomSLPLivingArmor_RenderScript extends UD_CustomVibratorBase_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "LivingArmor")
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The oozing tendrils glued to your body begin to softly suck at your skin.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction

float Function getAccesibility()
	return 0.0
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    UDCDmain.currentDeviceMenu_allowSpecialMenu = False
EndFunction

Function onRemoveDevicePost(Actor akActor)
    fctParasites.cureParasiteByString(getWearer(), "LivingArmor")
    parent.onRemoveDevicePost(akActor)
EndFunction