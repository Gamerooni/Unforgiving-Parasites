Scriptname UD_CustomSLPFaceHugger_RS extends UD_CustomSLPPlug_RenderScript

import UD_Native

; rework tryParasiteNextStage in SLP_fcts_parasites to use vib and inflation events instead
; maybe way later

; do the same with facehuggergag

; add FHU stuff in the OnInflate func


; FIGURE OUT WHY THE VIBRATION EVENT AND ICONS DON'T PROPERLY WORK
; ----I give up lol. Nothing seems to let them pop up. No clue what's up with that. Oh well, I'll patch it out later if need be.

;==========PROPERTIES==========

;==========LOCAL VARS==========

;==========LOCAL FUNCS==========

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Crotch Hugger"
    UD_ActiveEffectName = "Lively Proboscis"
    SLP_InflationType = "Proboscis depth"
EndFunction

Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "FaceHugger"
    endif
    ; fire salts
    if !SLP_CureIngredient
        SLP_CureIngredient = Game.GetFormFromFile(0x0003AD5E, "Skyrim.esm") as Ingredient
    endif
    parent.safeCheck()
EndFunction

; this is both a belt and a plug. customplug makes plugs unremovable if there is a belt. so, we must change this. this is copied from customplug but removes the belt stuff
float Function getAccesibility()
    float   loc_res         = 1.0
    bool    loc_haveHelper   = haveHelper()

    if !wearerFreeHands() && (!loc_haveHelper || !HelperFreeHands())
        loc_res *= 0.25
    elseif !wearerFreeHands(true) && (!loc_haveHelper || !HelperFreeHands(true))
        loc_res *= 0.5
    endif
    
    if getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirt)
        loc_res *= 0.7
    elseif getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirtRelaxed)
        loc_res *= 0.8
    elseif getWearer().wornhaskeyword(libs.zad_DeviousSuit)
        loc_res *= 0.9
    endif
    
    return ValidateAccessibility(loc_res)
EndFunction

;==========HELPER FUNCTIONS===========


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

string Function getCureApplyText()
    string sMsg = ""
    if haveHelper()
        if WearerIsPlayer()
            sMsg = getHelperName() + " sprinkles the Fire Salts on the unwitting critter. A jolt of pain runs through you as it writhes spasmodically, then suddenly goes still."
        elseif PlayerInMinigame()
            sMsg = "You sprinkle the Fire Salts onto " + getWearerName() + "'s critter. She yelps as a flurry of quick movements momentarily distends her from inside."
        endif
    else
        sMsg = "You tip a shot of " + getCureName() + " onto the critter, and almost bend over double as its proboscis begins to slam back and forth against your insides. It slows down, then stops, occasionally twitching."
    endif
    return sMsg
EndFunction


;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
float Function getArousalAdjustment()
    return parent.getArousalAdjustment()
endFunction
Function InitPostPost()
    parent.InitPostPost()
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
    parent.activateDevice()
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
    parent.setRetaliate(newRetaliate)
EndFunction
bool Function willRetaliate(float fMult = 1.0)
    return parent.willRetaliate(fMult)
EndFunction
Function retaliate(float fMult = 1.0)
    parent.retaliate(fMult)
EndFunction
Function sendRetaliationMessage()
    parent.sendRetaliationMessage()
EndFunction
Function OnMinigameStart()
    parent.OnMinigameStart()
EndFunction
bool Function canDeflate()
    return parent.canDeflate()
EndFunction