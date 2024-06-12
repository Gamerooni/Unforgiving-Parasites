scriptname UD_CustomSLPFaceHuggerGag_RS extends UD_CustomGag_RenderScript

; MORE OR LESS PLACEHOLDER - FILL OUT PROPERLY

import UD_native

SLP_fcts_parasites Property fctParasites  Auto

; The ingredient to cure the parasite, if any
Ingredient Property SLP_CureIngredient Auto
; The difficulty multiplier if there's no cure. Default is 0.2
Float Property SLP_CureMultiplier Auto

;==========LOCAL VARS==========

;wearer's arousal at the beginning of a minigame
float startMinigameArousal = 0.0

string SLPDeviceName = "FaceHuggerGag"

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Face Hugger"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), SLPDeviceName)
EndFunction

Function safeCheck()
    parent.safeCheck()
    ; fire salts
    if !SLP_CureIngredient
        SLP_CureIngredient = Game.GetFormFromFile(0x0003AD5E, "Skyrim.esm") as Ingredient
    endif
    if !SLP_CureMultiplier
        SLP_CureMultiplier = 0.2
    endif
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor, SLPDeviceName)
EndFunction

string Function addInfoString(string str = "")
    if doesCureExist() && knowsCureIngredient()
        str += "Remedy: " + getCureName() + "\n"
    endif
    return str
EndFunction

; Save the arousal at the beginning for later use. retaliate.
; Also use up the cure
; TODO: maybe make some orgasm/arousal/horny increases from applying the cure?
Function OnMinigameStart()
    bool bNoCure = false
    if doesCureExist()
        bNoCure = true
        if knowsCureIngredient()
            if hasCureIngredient()
                bNoCure = false
                Udmain.ShowSingleMessageBox(getCureApplyText())
            Else
                Udmain.ShowSingleMessageBox(getCureFailText())
            endif
        endif
    endif
    startMinigameArousal = UDOM.getArousal(getWearer())
    ; Also change minigame difficulty here
    setMinigameDmgMult(getMinigameMult(0) * getArousalAdjustment() * getCureMultiplier())
    parent.OnMinigameStart()
EndFunction

; Taunt player if minigame failed
Function OnMinigameEnd()
    parent.OnMinigameEnd()
    string sMsg = ""
    if !IsUnlocked && WearerIsPlayer()
        sMsg = getArousalFailMessage(startMinigameArousal)
        Udmain.ShowSingleMessageBox(sMsg)
    endif
EndFunction

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Udmain.Log("attempt to put a lock on " + getDeviceName() + "thwarted", 5)
    return 0x00000000
EndFunction

;==========HELPER FUNCTIONS===========

;Get adjustment to accessibility. Device is harder to access when aroused, but the Agility skill makes it easier
float Function getArousalAdjustment()
    return 1.0 - fRange((UDOM.getArousal(getWearer()) - UDmain.UDSKILL.GetAgilitySkill(getWearer()))/80.0, 0.0, 1.0)
endFunction

string Function getCureName()
    return SLP_CureIngredient.GetName()
EndFunction

;Whether there exists a cure for this device at all
bool Function doesCureExist()
    return SLP_CureIngredient
EndFunction

;Whether the player knows about the cure ingredient
bool Function knowsCureIngredient()
    return true
EndFunction

;Whether the wearer or helper has the ingredient in their inventories
bool Function hasCureIngredient()
    return getWearer().GetItemCount(SLP_CureIngredient) > 0 || (getHelper() && getHelper().GetItemCount(SLP_CureIngredient) > 0)
EndFunction

;If cure is known and present (or doesn't exist), return 1, else returns the cure multiplier
float Function getCureMultiplier()
    if !doesCureExist() || (knowsCureIngredient() && hasCureIngredient())
        return 1.0
    else
        return SLP_CureMultiplier
    endif
EndFunction

;If the player knows the cure but has no cure
string Function getCureFailText()
    return "You recall it's unwise to begin this without " + getCureName()
EndFunction

string Function getArousalFailMessage(float fArousal)
    if fArousal < 10.0
        return "The critter held on tight as you tried to unwrap it from your face."
    elseif fArousal < 40.0
        return "The critter lapped at your dripping saliva from the inside with its proboscis, and - bolstered by it - refused to budge from around your face and throat."
    elseif fArousal < 80.0
        return "Your drooling mouth coated the critter in a thin layer of slick. You struggled to find purchase on it and pull it out; meanwhile, the Hugger squirmed further in to taste more of you."
    else
        return "As you tugged at the critter's legs, your eager throat instead strained to suck and swallow it down as far as it would go. Sticky fluid rolled into your stomach; too deep for you to even taste it. You couldn't breathe; your body was too entranced by the Hugger to even consider it."
    endif
EndFunction

string Function getCureApplyText()
    string sMsg = ""
    if haveHelper()
        if WearerIsPlayer()
            sMsg = getHelperName() + " sprinkles the Fire Salts on the unwitting critter. You choke on it as it writhes spasmodically, then suddenly goes still."
        elseif PlayerInMinigame()
            sMsg = "You sprinkle the Fire Salts onto " + getWearerName() + "'s critter. She yelps as a flurry of quick movements momentarily distends her mouth and throat."
        endif
    else
        sMsg = "You tip a shot of " + getCureName() + " onto the critter, and bend over double as it s proboscis slams against your cheeks and shoots in and out of your throat. It slows down, then stops, occasionally twitching."
    endif
    return sMsg
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