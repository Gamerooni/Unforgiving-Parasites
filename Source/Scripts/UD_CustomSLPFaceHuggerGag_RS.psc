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

;whether the device will retaliate in response to the player's meddling
bool shouldRetaliate = true

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
    libs.SexLab.AddCum(akActor, Vaginal = false, Oral = true, Anal = false)
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
    ; if cure is applied, don't retaliate
    setRetaliate(bNoCure)
    startMinigameArousal = UDOM.getArousal(getWearer())
    retaliate()
    ; Minigames get harder based on:
    ;  - arousal (on top of accessibility's arousal)
    ;  - whether the cure's active
    ;  - the plug's inflate level (on top of its accessibility)
    ; The condition multipliers are also greatly affected by whether the cure is active
    setMinigameOffensiveVar(true, 0.0, fRange(_condition_mult_add - 0.5 + getCureMultiplier(), -1.0, 5.0), true, getMinigameMult(0) * (getArousalAdjustment() + 0.5) / 1.5 * getCureMultiplier())
    ; We also make crits far less common and far more weak if there is no cure
    setMinigameCustomCrit((UD_StruggleCritChance * getCureMultiplier() * 2) as int, 0.75, 1.0 * getCureMultiplier() * 2)
    parent.OnMinigameStart()
EndFunction

; Retaliate.
Function OnCritFailure()
    parent.OnCritFailure()
    retaliate(0.5)
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

string Function getArousalFailMessage(float fArousal)
    if fArousal <= 10 && knowsCureIngredient() && hasCureIngredient()
        return "Before you could remove the Hugger, the salts wore off. Its legs scrambled for purchase across your skull - and they found it."
    elseif fArousal < 40
        return "As you began to pull the Hugger away, a musky slime oozed from gaps in its carapace. It mixed with your saliva and overpowered your senses. Blindly, you tried to unhook its legs, but your slime-covered hands were of little help."
    elseif fArousal < 80
        return "As you touched the Hugger's carapace, it sent a stream of odd-tasting fluid into your mouth. The more you touched, the more it forced you to swallow. Its tail began to constrict your neck; the fluid had nowhere to go. Mouth and nostrils full, you had no choice - you had to let it be."
    else
        return "Sensing your arousal, the hugger's tail wound around your throat and constricted it in a most exhilirating embrace, wrapping tightly around its own proboscis. Its appendage probed deeper down your throat; you couldn't feel it beyond a dull ache. With a sigh of relief, you let go - you're glad that this won't end anytime soon."
    endif
EndFunction

;Sets whether the device will retaliate
Function setRetaliate(bool newRetaliate)
    shouldRetaliate = newRetaliate
EndFunction

;calculates the chance the device will retaliate. if `shouldRetaliate` is false it'll do nothing; else it'll take a chance on `getArousalAdjustment`
bool Function willRetaliate(float fMult = 1.0)
    if shouldRetaliate && Round(fMult * (1.0 - getArousalAdjustment()) * 90.0) > RandomInt(1,99)
        return true
    endif
    return false
EndFunction

Function mendDevice(float afMult = 1.0)
    if onMendPre(afMult) && GetRelativeDurability() > 0.0
        Float   loc_amount  = (1 - 0.1*UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier() * UD_DefaultHealth / 2
        refillDurability(loc_amount)
        refillCuttingProgress(afMult * 50)
        onMendPost(loc_amount)
    endif
EndFunction

;What the device will do if it retaliates. effect scales with `fMult`
Function retaliate(float fMult = 1.0)
    if willRetaliate(fMult)
        libs.SexLab.AddCum(getWearer(), Vaginal = false, Oral = true, Anal = false)
        UDOM.UpdateArousal(getWearer(), 20 * fMult)
        mendDevice((2 - getArousalAdjustment()) / 2)
        sendRetaliationMessage()
    endif
EndFunction

;The message the device will send upon retaliation
Function sendRetaliationMessage()
    if WearerIsPlayer()
        Udmain.ShowSingleMessageBox("The " + getDeviceName() + " senses your tampering and clamps around your head!")
    elseif UDcdmain.AllowNPCMessage(getWearer(), true)
        Udmain.Print("The " + getDeviceName() + " senses " + getWearerName() + " tampering and retaliates!")
    endif
EndFunction

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
        return "As you tugged at the critter's legs, your eager throat instead strained to suck and swallow its phallic appendage. Sticky fluid rolled into your stomach; too deep for you to even have a taste. You couldn't breathe; your body was too entranced by the Hugger to even consider it."
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
        sMsg = "You tip a shot of " + getCureName() + " onto the critter. You bend over double as its proboscis slams against your cheeks, and shoots in and out of your throat. It slows down, then it stops, occasionally twitching."
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