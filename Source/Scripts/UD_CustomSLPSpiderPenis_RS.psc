Scriptname UD_CustomSLPSpiderPenis_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS
;MUST FILL IN CUSTOM SOUND EVENTS FOR FAILURE/SUCCESS

import UD_Native

Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Spider Barbs"
    UD_DeviceType = "Spider Penis"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "SpiderPenis" )
EndFunction

bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return forceOutPlugMinigame()
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The spider penis's barbs expand and contract, pushing it further in.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction

; becomes less accessible as wearer is more aroused 
float Function getAccesibility()
    return _getArousalMultiplier() * parent.getAccesibility()
EndFunction

float Function _getArousalMultiplier()
    int iDexterity = 20 + (libs.PlayerRef.GetActorValue("Pickpocket") as Int) / 5
    return fRange(1.0 - (libs.Aroused.GetActorArousal(GetWearer()) - iDexterity) / 70.0, 0.0, 1.0)
EndFunction

int startMinigameArousal = 0
string Function _getArousalFailMessage()
    int iArousal = startMinigameArousal;libs.Aroused.GetActorExposure(getWearer())
    string msg = ""
    if (iArousal < libs.ArousalThreshold("Desire"))
        msg = "Your fingers slipped, and the penis buried itself futher inside you. Your juices flow even faster. You will have to give it another try when you are not so horny."
    elseif (iArousal < libs.ArousalThreshold("Horny"))
        msg = "As you gently nudged the penis's bulbous base, its barbs shot out in all directions and held it in place."
    elseif (iArousal < libs.ArousalThreshold("Desperate"))
        msg = "Your fingers tried to grip the penis's hilt, but your slippery juices gave them no purchase. The barbs dug further into your membrane."
    Else
        msg = "The moment your hand entered your abused hole, you own eager womb clenched painfully around the penis - barbs and all. Your vagina is sealed shut."
    endif
    return msg
EndFunction

Function OnMinigameStart()
    startMinigameArousal = libs.Aroused.GetActorExposure(getWearer())
    parent.OnMinigameStart()
EndFunction

; taunt player and regenerate if minigame failed
Function OnMinigameEnd()
    if !IsUnlocked && WearerIsPlayer()
        libs.NotifyPlayer(_getArousalFailMessage(), true)
        _regeneratePenis()
    endif
EndFunction

; Deal damage and regenerate if crit fail
Function OnCritFailure()
    _regeneratePenis()
    _dealBarbDamage(2.0)
EndFunction

Function _regeneratePenis()
    if onMendPre(1.0) && GetRelativeDurability() > 0.0
        refillDurability(_getRegenerateAmount())
    endif
EndFunction

; Calculate the amount to regenerate based on condition and wearer arousal (between 0% and 50%)
Float Function _getRegenerateAmount()
    return (libs.Aroused.GetActorExposure(getWearer())/100.0 * getRelativeCondition()) * getMaxDurability() / 2
EndFunction

; 80% chance for the wearer to take damage
Function OnMinigameTick3()
    if (RandomInt() < 80)
        _dealBarbDamage()
    endif
EndFunction

; Calculate barb damage based on wearer's arousal (between 1 and 11)
float Function _getBarbDamage()
    return RandomFloat(0.5, 1.0) * (libs.Aroused.GetActorExposure(getWearer()) + 10) / 100.0 * 10.0
EndFunction

Function _dealBarbDamage(float multiplier = 1.0, bool silent=false)
    float totalDamage = _getBarbDamage() * multiplier
    getWearer().DamageActorValue("Health", totalDamage)
    if (!silent && totalDamage > 10 )
        libs.SexlabMoan(GetWearer(), libs.Aroused.GetActorExposure(getWearer()))
    endif
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    if WearerIsPlayer()
        libs.NotifyPlayer("The spider penis's barbs shredded your pussy as they popped out one-by-one. Your now-misshapen opening feels strangely hollow.")
    endif
EndFunction

; Can't cut all the way in there
bool Function canBeCutted()
    return false;
EndFunction