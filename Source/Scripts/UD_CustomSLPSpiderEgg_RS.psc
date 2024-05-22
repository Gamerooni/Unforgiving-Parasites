Scriptname UD_CustomSLPSpiderEgg_RS extends UD_CustomInflatablePlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

import UD_Native

; Possibly sentient?
; Add custom sounds

float _dwarvenOilAdjust = 0.2

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "SpiderEgg" )
EndFunction

int Function _getDexterity()
    int iDexterity = 10 + (libs.PlayerRef.GetActorValue("Pickpocket") as Int) / 10
	UDmain.Print("Dexterity: " + iDexterity, 3)
    return iDexterity
EndFunction

float Function _getArousalAdjustment()
    return 1.0 - fRange((libs.Aroused.GetActorExposure(getWearer()) - _getDexterity())/80.0, 0.0, 1.0)
EndFunction

bool function _dwarvenOilKnown()
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iSpiderEggsKnown")==1
EndFunction

float function _getDwarvenOilAdjust()
    if _dwarvenOilKnown()
        return 1.0
    else
        return _dwarvenOilAdjust
    endif
EndFunction

float Function getAccesibility()
    return parent.getAccesibility() * _getArousalAdjustment() * _getDwarvenOilAdjust()
EndFunction