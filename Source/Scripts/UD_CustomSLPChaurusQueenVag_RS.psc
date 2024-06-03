Scriptname UD_CustomSLPChaurusQueenVag_RS extends UD_CustomSLPPlug_RenderScript

; needs more work on minigame etc.
; needs proper inflation events
; needs new menu for inflation stuff
; needs more work on difficulty
; needs to not return item on removal. ever.

import UD_Native


;==========LOCAL VARS==========

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Chaurus Queen Seed"
    UD_ActiveEffectName = "Seed Growth"
EndFunction

Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "ChaurusQueenVag"
    endif
    ;Troll Fat
    ; if !SLP_CureIngredient
    ;     SLP_CureIngredient = Game.GetFormFromFile(0x0003AD72, "Skyrim.esm") as Ingredient
    ; endif
    parent.safeCheck()
EndFunction

string Function addInfoString(string str = "")
    str += "Seed expansion level: " + getPlugInflateLevel() + "\n"
    return str
EndFunction


;==========HELPER FUNCTIONS===========


string Function getArousalFailMessage(float fArousal)
    string msg = ""
    if (fArousal < libs.ArousalThreshold("Desire"))
        msg = "Your fingers slip. The seed extends and throbs in response, and your juices gush from the stimulation."
    elseif (fArousal < libs.ArousalThreshold("Horny"))
        msg = "As you push and tug, the Seed - coated in your lubrication - slips away and grows thicker. It forces your lips even further apart."
    elseif (fArousal < libs.ArousalThreshold("Desperate"))
        msg = "You reach into your sopping-wet opening and pull at the slimy worm. It inflates and fastens like a rivet; it's impossible to push on."
    Else
        msg = "The moment your hand tried to push the Seed back in, you own eager vagina clenches around the worm, with streams of your slimy fluid shooting out from the pressure."
    endif
    return msg
EndFunction

;The message the device will send upon retaliation
Function sendRetaliationMessage()
    if WearerIsPlayer()
        Udmain.ShowSingleMessageBox("The " + getDeviceName() + " senses your tampering and retaliates!")
    elseif UDcdmain.AllowNPCMessage(getWearer(), true)
        Udmain.Print("The " + getDeviceName() + " senses " + getWearerName() + " tampering and retaliates!")
    endif
EndFunction

;The message the device will send upon activation
Function sendActivationMessage()
    if WearerIsPlayer()
        Udmain.Print("Your " + getDeviceName() + " contracts back into your womb, writhes, then shoots back out with renewed force!")
    elseif UDCDMain.AllowNPCMessage(getWearer(), false)
        UDmain.Print(getWearerName() + "'s "+ getDeviceName() + " suddenly spreads her even wider!",3)
    endif
EndFunction

;The message the device will send upon inflation
Function sendInflateMessage(int iInflateNum = 1)
    int currentVal = getPlugInflateLevel() + iInflateNum
    int iLogLevel = 1
    string msg = ""
    if haveHelper()
        if WearerIsPlayer()
            msg = getHelperName() + " helped you pull the " + getDeviceName() + " out further!"
        elseif WearerIsFollower() && HelperIsPlayer()
            msg = "You helped pull " + getWearerName() + "'s " + getDeviceName() + " further out!"
        elseif WearerIsFollower()
            msg = getHelperName() + " helped pulling " + getWearerName() + "'s " + getDeviceName() + " further out!"
        endif            
    else
        if WearerIsPlayer()
            msg = "You reach into your vagina and pull on your " + getDeviceName() + ". Something gives, and more of it comes out."
        elseif WearerIsFollower()
            msg = getWearerName() + "'s " + getDeviceName() + " pushed further out of them!"
            iLogLevel = 3
        endif
    endif
    UDmain.Print(msg, iLogLevel)
EndFunction

;The message the device will send upon deflation
Function sendDeflateMessage()
    if WearerIsPlayer()
        UDMain.Print("You pack some of the " + getDeviceName() + " back into your womb, relieving some of the pressure in your hole.")
    endif
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
    parent.getAccesibility()
EndFunction
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
EndFunction
Function OnDeviceRemovePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
EndFunction
bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return parent.struggleMinigame(type, abSilent)
EndFunction
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    return parent.struggleMinigameWH(akHelper, aiType)
EndFunction
Function OnMinigameStart()
    parent.OnMinigameStart()
EndFunction
Function OnCritFailure()
    parent.OnCritFailure()
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
bool Function canDeflate()
    parent.canDeflate()
EndFunction
Function OnMinigameEnd()
    parent.OnMinigameEnd()
EndFunction
float Function getArousalAdjustment()
    parent.getArousalAdjustment()
EndFunction
Function setRetaliate(bool newRetaliate)
    parent.setRetaliate(newRetaliate)
EndFunction
bool Function willRetaliate(float fMult = 1.0)
    parent.willRetaliate(fMult)
EndFunction
Function retaliate(float fMult = 1.0)
    parent.retaliate(fMult)
EndFunction
string Function getCureName()
    return SLP_CureIngredient.GetName()
EndFunction
bool Function doesCureExist()
    parent.doesCureExist()
EndFunction
bool Function knowsCureIngredient()
    parent.knowsCureIngredient()
EndFunction
bool Function hasCureIngredient()
    parent.hasCureIngredient()
EndFunction
float Function getCureMultiplier()
    parent.getCureMultiplier()
EndFunction
string Function getCureFailText()
    parent.getCureFailText()
EndFunction
string Function getCureApplyText()
    parent.getCureApplyText()
EndFunction