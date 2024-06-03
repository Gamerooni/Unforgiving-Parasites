Scriptname UD_CustomSLPFaceHugger_RS extends UD_CustomSLPPlug_RenderScript

import UD_Native

; rework tryParasiteNextStage in SLP_fcts_parasites to use vib and inflation events instead
; maybe way later

; do the same with facehuggergag

; add FHU stuff in the OnInflate func


; FIGURE OUT WHY THE VIBRATION EVENT AND ICONS DON'T PROPERLY WORK
; ----I give up lol. Nothing seems to let them pop up. No clue what's up with that. Oh well, I'll patch it out later if need be.

;==========PROPERTIES==========

Ingredient  Property FireSalts Auto


;==========LOCAL VARS==========

float _fireSaltsAdjust = 0.2

;==========LOCAL FUNCS==========

;Apparently there's no check for this in the OG SLP unlike with Spider Eggs? need to investigate
bool Function _fireSaltsKnown()
    return true
EndFunction

;Checks whether player or helper has any fire salts
bool Function _isFireSaltsPresent()
    return getWearer().GetItemCount(FireSalts) > 0 || (getHelper() && getHelper().GetItemCount(FireSalts) > 0)
EndFunction

;Gets multiplier based on whether player knows about Fire Salts and they have em
float Function _getFireSaltsAdjust()
    if _fireSaltsKnown() && _isFireSaltsPresent()
        return 1.0
    else
        return _fireSaltsAdjust
    endif
EndFunction

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Crotch Hugger"
    UD_ActiveEffectName = "Lively Proboscis"
EndFunction

Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "FaceHugger"
    endif
    parent.safeCheck()
EndFunction

string Function addInfoString(string str = "")
    str += "Proboscis depth: " + getPlugInflateLevel() + "\n"
    return str
EndFunction

;We'll have to struggle for every deflation
bool Function canDeflate()
    if _fireSaltsKnown()
        if iInRange(getPlugInflateLevel(),1,2)
            if _isFireSaltsPresent()
                return True
            else
                debug.MessageBox("You're lacking the Fire Salts to stun the Crotch Hugger.")
            endif
        else
            UDmain.ShowSingleMessageBox("The Crotch Hugger's proboscis and sac are too far in. Fire Salts will still stun the critter, but it won't be easy!")
        endif
    endif
    return parent.canDeflate()
EndFunction

; Save the arousal at the beginning for later use. retaliate.
Function OnMinigameStart()
    setMinigameMult(1, getMinigameMult(1) * getAccesibility())
    string sMsg = ""
    bool bRetaliate = true
    if _fireSaltsKnown()
        if _isFireSaltsPresent()
            OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,1,0.25,2)
            OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,9,0.25,2)
            if haveHelper()
                if WearerIsPlayer()
                    sMsg = getHelperName() + " sprinkles the Fire Salts on the unwitting critter. A jolt of pain runs through you as it writhes spasmodically, then suddenly goes still."
                elseif PlayerInMinigame()
                    sMsg = "You sprinkle the Fire Salts onto " + getWearerName() + "'s critter. She yelps as a flurry of quick movements momentarily distends her from inside."
                endif
            else
                sMsg = "You rub the Dwarven Oil into your hands and lower them down to your pussy. You squirm together with the eggs as you lubricate yourself."
            endif
            bRetaliate = false
        else
            sMsg = "You recall that it's unwise to begin this without Fire Salts."
        endif
    endif
    if sMsg != ""
        UDmain.Print(sMsg)
    endif
    setRetaliate(bRetaliate)
    parent.OnMinigameStart()
EndFunction


;==========HELPER FUNCTIONS===========

;Having no firesalts makes this nearly impossible
float Function getArousalAdjustment()
    return (parent.getArousalAdjustment() * _getFireSaltsAdjust())
endFunction

string Function getArousalFailMessage(float fArousal)
    if fArousal < 10.0
        return "The critter held on tight as you tried to unwrap it from your waist"
    elseif fArousal < 40.0
        return "The critter lapped at your leaking juices from the inside with its proboscis, and - bolstered by them - refused to budge from around your waist."
    elseif fArousal < 80.0
        return "Your sloppy quim coated the critter's head in a layer of thin fluid. You struggled to find purchase on it and pull it out; meanwhile, the Hugger squirmed further in to taste more of you."
    else
        return "As you tugged at the critter's legs, your eager pussy contracted with a jolt in a perfect mould around the proboscis and fluid sac. A wave of shudders struck your body down to the fingertips with every pull."
    endif
EndFunction

Function sendActivationMessage()
    if WearerIsPlayer()
        Udmain.Print("Your " + getDeviceName() + "'s proboscis and fluid sac digs further into your cunt!")
    elseif UDCDMain.AllowNPCMessage(getWearer(), false)
        UDmain.Print(getWearerName() + "'s "+ getDeviceName() + "'s head disappears futher into her!",3)
    endif
EndFunction

;Sort of placeholder message for now, until I come up with better stuff
Function sendInflateMessage(int iInflateNum = 1)
    parent.sendInflateMessage(iInflateNum)
    int currentVal = getPlugInflateLevel() + iInflateNum
    if WearerIsPlayer()
        string msg = ""
        if currentVal == 0
            msg = "Most of the critter's head hangs outside your pussy."
        elseif currentVal == 1
            msg = "You gently pull the critter's head into your vagina. Small jets of fluid escape the creature as it settles in place."
        elseif currentVal == 2
            msg = "You push the critter's head deeper in. Something shifts in its main body, and you gasp as its fluid sac parts you wide, moving into you."
        elseif currentVal == 3
            msg = "You tug at the legs and shift the critter to give its head more room. It eagerly takes the opportunity to push itself further in, its fluid sac resting snugly deep inside you."
        elseif currentVal == 4
            msg = "You massage the critter, guiding its head further in. An erotic pain spreads out from your bellybutton as its proboscis and fluid sac press against your cervix."
        else
            msg = "You give the critter's head a hard push, then another, then pain shoots through you like a neverending bolt of lightning. Its proboscis has pierced your cervix; you realize it's in a prime position to spray its fluids directly into your womb."
        endif
        UDmain.ShowSingleMessageBox(msg)
    Endif
    ;Udmain.Print(getDeviceName() + " makes " + getWearerName() + " thicker than a bowl of oatmeal! (you shouldn't be seeing this message)")
EndFunction

;The message the device will send upon deflation
Function sendDeflateMessage()
    ; we can only deflate by one increment at a time
    int currentVal = getPlugInflateLevel() - 1
    if WearerIsPlayer()
        string msg = ""
        if currentVal == 0
            msg = "You give the critter one final tug, and most of its head pops right out of your pussy. Only a small part of it desperately hangs on."
        elseif currentVal == 1
            msg = "You gently pull the critter's head into your vagina. Small jets of fluid escape the creature as it settles in place."
        elseif currentVal == 2
            msg = "You push the critter's head deeper in. Something shifts in its main body, and you gasp as its fluid sac parts you wide, moving into you."
        elseif currentVal == 3
            msg = "You tug at the legs and shift the critter to give its head more room. It eagerly takes the opportunity to push itself further in, its fluid sac resting snugly deep inside you."
        else
            msg = "A searing agony pulses from your groin as you force the critter out of your womb. You feel something inside you give way, and the agony makes way to a flood of sweet relief. Your womb is your own again."
        endif
        UDmain.ShowSingleMessageBox(msg)
    Endif
EndFunction


;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function InitPostPost()
    parent.InitPostPost()
EndFunction
float Function getAccesibility()
    return parent.getAccesibility()
EndFunction
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
EndFunction
Function inflate(bool silent = false, int iInflateNum = 1)
    parent.inflate(silent, iInflateNum)
EndFunction
Function deflate(bool silent = False)
    parent.deflate(silent)
EndFunction
Function activateDevice()
    return parent.activateDevice()
EndFunction
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
EndFunction
Function OnCritFailure()
    parent.OnCritFailure()
EndFunction
Function OnMinigameEnd()
    parent.OnMinigameEnd()
EndFunction
bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return parent.struggleMinigame(type, abSilent)
EndFunction
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    return parent.struggleMinigameWH(akHelper, aiType)
EndFunction
Function setRetaliate(bool newRetaliate)
    return parent.setRetaliate(newRetaliate)
EndFunction
bool Function willRetaliate(float fMult = 1.0)
    return parent.willRetaliate(fMult)
EndFunction
Function retaliate(float fMult = 1.0)
    return parent.retaliate(fMult)
EndFunction
Function sendRetaliationMessage()
    parent.sendRetaliationMessage()
EndFunction