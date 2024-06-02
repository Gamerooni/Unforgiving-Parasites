Scriptname UD_CustomSLPSpiderPenis_RS extends UD_CustomSLPPlug_RenderScript

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

; Calculate the amount to regenerate based on condition and wearer arousal (between 0% and 50%)
Float Function _getRegenerateAmount()
    return (UDOM.getArousal(getWearer())/100.0 * getRelativeCondition()) * getMaxDurability() / 2
EndFunction

Function _regeneratePenis()
    UDmain.Log("penis regenerated", 5)
    if onMendPre(1.0) && GetRelativeDurability() > 0.0
        refillDurability(_getRegenerateAmount())
    endif
EndFunction


Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Spider Penis Barbs"
    UD_DeviceType = "Spider Penis"
EndFunction

;Disable option to inflate the Spider Penis (you can't make it barb you)
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    UDCDmain.currentDeviceMenu_switch3 = False
    UDCDmain.currentDeviceMenu_switch5 = False
EndFunction

;Disable option to inflate the Spider Penis (you can't make it barb you)
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    UDCDmain.currentDeviceMenu_switch3 = False
    UDCDmain.currentDeviceMenu_switch5 = False
EndFunction

string Function addInfoString(string str = "")
    str += "Barb distension level: " + getPlugInflateLevel() + "\n"
    return str
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The spider penis's barbs expand and contract, pushing it further in.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction

; regenerate if minigame failed
Function OnMinigameEnd()
    parent.OnMinigameEnd()
    if !IsUnlocked
        _regeneratePenis()
    endif
EndFunction

; 80% chance for the wearer to take damage
Function OnMinigameTick3()
    if (RandomInt() < 80)
        _dealBarbDamage()
    endif
EndFunction

; Flavour text
Function OnRemoveDevicePost(Actor akActor)
    parent.OnRemoveDevicePost(akActor)
    if WearerIsPlayer()
        libs.NotifyPlayer("The spider penis's barbs shredded your pussy as they popped out one-by-one. The eggs, no longer held back by the phallus, droop out.")
    endif
EndFunction

; Can't cut all the way in there
bool Function canBeCutted()
    return false;
EndFunction


string Function getArousalFailMessage(float fArousal)
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

Function retaliate(float fMult = 1.0)
    if willRetaliate(fMult)
        _regeneratePenis()
        _dealBarbDamage(fMult * 6.0)
    endif
    parent.retaliate(fMult)
EndFunction

Function sendRetaliationMessage()
    if WearerIsPlayer()
        Udmain.ShowSingleMessageBox("The cold" + getDeviceName() + " reacts to your touch and comes alive!")
    Else
        parent.sendRetaliationMessage()
    endif
EndFunction

Function sendDeflateMessage()
    if WearerIsPlayer()
        UDmain.Print("The " + getDeviceName() + "'s barbs loosen their hold on your pussy.")
    endif
EndFunction

Function sendActivationMessage()
    if WearerIsPlayer()
        Udmain.Print("The " + getDeviceName() + "'s icy barbs extend further from underneath its chitinous carapace and fill your vagina with searing agony!")
    elseif UDCDMain.AllowNPCMessage(getWearer(), false)
        UDmain.Print(getWearerName() + "'s "+ getDeviceName() + " digs it barbs deeper into her vagina, spreading it wide around the phallus!",3)
    endif
EndFunction