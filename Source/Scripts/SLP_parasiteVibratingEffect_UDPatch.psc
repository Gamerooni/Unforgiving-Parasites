Scriptname SLP_parasiteVibratingEffect_UDPatch extends SLP_parasiteVibratingEffect

UDCustomDeviceMain Property UDCDmain auto

;/
Disables normal parasite vibrate if we've got UD devices
/;
bool Function HasKeywords(actor akActor)
	if akActor.hasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
        if UDCDmain.getVibratorNum(akActor) 
            return false
        else
            return parent.HasKeywords(akActor)
        endif
    else
        return parent.HasKeywords(akActor)
    endif
EndFunction


;====================================
;=========PARENT OVERRIDES===========
;====================================

Int Function GetChanceModified(actor akActor, int chanceMod)
	parent.GetChanceModified(akActor, chanceMod)
EndFunction

Bool Function Filter(actor akActor, int chanceMod=0)
	parent.Filter(akActor, chanceMod)
EndFunction

Function Execute(actor akActor)
    parent.Execute(akActor)
EndFunction