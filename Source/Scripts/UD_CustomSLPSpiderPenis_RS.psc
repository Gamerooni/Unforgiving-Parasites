Scriptname UD_CustomSLPSpiderPenis_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS
;MUST FILL IN CUSTOM SOUND EVENTS FOR FAILURE/SUCCESS

import UD_Native

; Calculate barb damage based on wearer's arousal (between 1 and 11)
float Function _getBarbDamage()
    return RandomFloat(0.5, 1.0) * (UDOM.getArousal(getWearer()) + 10) / 10.0
EndFunction

Function _dealBarbDamage(float multiplier = 1.0, bool silent=false)
    float totalDamage = _getBarbDamage() * multiplier
    float maxDamage = getWearer().GetAV("Health") - 10.0
    getWearer().DamageActorValue("Health",  fRange(totalDamage, 0.0, maxDamage))
    if (!silent && totalDamage > 10 )
        libs.SexlabMoan(GetWearer(), round(UDOM.getArousal(getWearer())))
    endif
EndFunction

float Function _getArousalMultiplier()
    int iDexterity = 20 + (libs.PlayerRef.GetActorValue("Pickpocket") as Int) / 5
    return fRange(1.0 - (UDOM.getArousal(getWearer()) - iDexterity) / 70.0, 0.0, 1.0)
EndFunction

float startMinigameArousal = 0.0
string Function _getArousalFailMessage()
    float fArousal = startMinigameArousal;libs.Aroused.GetActorExposure(getWearer())
    string msg = ""
    if (fArousal < libs.ArousalThreshold("Desire"))
        msg = "Your fingers slipped, and the penis buried itself futher inside you. Your juices flow even faster. You will have to give it another try when you are not so horny."
    elseif (fArousal < libs.ArousalThreshold("Horny"))
        msg = "As you gently nudged the penis's bulbous base, its barbs shot out in all directions and held it in place."
    elseif (fArousal < libs.ArousalThreshold("Desperate"))
        msg = "Your fingers tried to grip the penis's hilt, but your slippery juices gave them no purchase. The barbs dug further into your membrane."
    Else
        msg = "The moment your hand entered your abused hole, you own eager womb clenched painfully around the penis - barbs and all. Your vagina is sealed shut."
    endif
    return msg
EndFunction

Function _regeneratePenis()
    UDmain.Log("penis regenerated", 5)
    if onMendPre(1.0) && GetRelativeDurability() > 0.0
        refillDurability(_getRegenerateAmount())
    endif
EndFunction

; Calculate the amount to regenerate based on condition and wearer arousal (between 0% and 50%)
Float Function _getRegenerateAmount()
    return (UDOM.getArousal(getWearer())/100.0 * getRelativeCondition()) * getMaxDurability() / 2
EndFunction

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

Function OnMinigameStart()
    startMinigameArousal = UDOM.getArousal(getWearer())
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
    _dealBarbDamage(6.0)
EndFunction

; 80% chance for the wearer to take damage
Function OnMinigameTick3()
    if (RandomInt() < 80)
        _dealBarbDamage()
    endif
EndFunction

Function onSpecialButtonPressed(float fMult)
    UDmain.Log("special button pressed")
    parent.onSpecialButtonPressed(fMult)
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.OnRemoveDevicePost(akActor)
    if WearerIsPlayer()
        libs.NotifyPlayer("The spider penis's barbs shredded your pussy as they popped out one-by-one. Your now-misshapen opening feels strangely hollow.")
    endif
    fctParasites.cureParasiteByString(getWearer(), "SpiderPenis")
EndFunction

; Can't cut all the way in there
bool Function canBeCutted()
    return false;
EndFunction
