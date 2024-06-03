Scriptname UD_CustomSLPSpiderEgg_RS extends UD_CustomSLPPlug_RenderScript

import UnforgivingDevicesMain
import UD_Native

; Possibly sentient?
; Nope, sentient it too inflexible. Will need own implementation
; this will involve:
; - XXXXXonminigamestart checksentient
; - XXXXXoncritfailure checksentient
; - XXXXXforce the struggle minigame
; - XXXXXrandom activation
; XXXXXAdd custom sounds

; Bring everything out into a parent script
;  - initpostpost parasite application
;  - devicemenuinitpost turning off charging
;  - getAccessibility
;  - addInfoString
;  - inflate
;  - deflate
;  - activateDevice
;  - onMinigameStart?
;  - critfailure effects
;  - onRemoveDevicePre flavour text
;  - onRemoveDevicePost add cum and remove parasite
;  - struggleminigame


;Just the normal ordinary dwarven oil from skyrim
Ingredient Property DwarvenOil Auto


;Accessibility multiplier if we have no Dwarven Oil (DO)
float _dwarvenOilAdjust = 0.2


;=====HELPER FUNCTIONS=====

;Whether we know about the ol' DO trick
bool function _dwarvenOilKnown()
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iSpiderEggsKnown")==1
EndFunction

;Whether anyone involved in the struggle has any DO
bool function _isDwarvenOilPresent()
    return getWearer().GetItemCount(DwarvenOil) > 0 || (getHelper() && getHelper().GetItemCount(DwarvenOil) > 0)
endfunction

;Black box to give us a multiplier regarding our DO proclivities
float function _getDwarvenOilAdjust()
    if _dwarvenOilKnown() && _isDwarvenOilPresent()
        return 1.0
    else
        return _dwarvenOilAdjust
    endif
EndFunction

;=====OVERRIDES=====
Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Insertion"
    UD_DeviceType = "Spider Egg Cluster"
    UD_Cooldown = 90
EndFunction

;Manually set parasite name to spideregg, manually add dwarven oil
Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "SpiderEgg"
    endif
    if !SLPParasiteCureName
        SLPParasiteCureName = "SpiderEggAll"
    endif
    if !DwarvenOil
        DwarvenOil = Game.GetFormFromFile(0x000F11C0, "Skyrim.esm") as Ingredient
    endif
    parent.safeCheck()
EndFunction

;Adjust accessibility by whether we know about DO and have it on hand
float Function getAccesibility()
    return parent.getAccesibility() * _getDwarvenOilAdjust()
EndFunction

;If we have DO, we can deflate like a normal plug
bool Function canDeflate()
    if _dwarvenOilKnown()
        if iInRange(getPlugInflateLevel(),1,2)
            if _isDwarvenOilPresent()
                return True
            else
                debug.MessageBox("You're lacking the Dwarven Oil to calm the eggs")
            endif
        else
            UDmain.ShowSingleMessageBox("The eggs have gone too far in! You'll need to coax them out first.")
        endif
    endif
    return parent.canDeflate()
EndFunction

Function OnMinigameStart()
    setMinigameMult(1, getMinigameMult(1) * getAccesibility())
    string sMsg = ""
    bool bRetaliate = true
    if _dwarvenOilKnown()
        if _isDwarvenOilPresent()
            UDOM.UpdateArousal(getWearer(), 2)
            if haveHelper()
                if WearerIsPlayer()
                    sMsg = getHelperName() + " spreads the Dwarven Oil around your groin. You almost moan as their fingers slip past the eggs and into your pussy."
                elseif PlayerInMinigame()
                    sMsg = "You spread Dwarven Oil around "+ getWearerName() + "'s vagina. When your hand pushes past the eggs and into their vagina, they twitch and gasp."
                endif
            else
                sMsg = "You rub the Dwarven Oil into your hands and lower them down to your pussy. You squirm together with the eggs as you lubricate yourself."
            endif
            bRetaliate = false
        else
            sMsg = "You recall that it's unwise to begin this without Dwarven Oil."
        endif
    endif
    if sMsg != ""
        UDmain.Print(sMsg)
    endif
    setRetaliate(bRetaliate)
    parent.OnMinigameStart()
EndFunction

Function OnRemoveDevicePre(Actor akActor)
    UDmain.ShowSingleMessageBox("The eggs pop out of your hole one-by-one, each one pulling out the next by a thread of the foamy and slimy lubricant that kept them together.")
    parent.OnRemoveDevicePre(akActor)
EndFunction


;===========CUSTOM OVERRIDES===========

Function sendRetaliationMessage()
    if WearerIsPlayer() && UD_SLP_RetaliateMessagePlayer
        UDmain.ShowSingleMessageBox("The eggs sense your tampering and squirm and writhe to avoid it!")
    elseif UDCDmain.AllowNPCMessage(GetWearer(), true) && UD_SLP_RetaliateMessageNPC
        UDmain.Print("The eggs sense " + getWearerName() + "'s tampering and become lively!", 3)
    endif
EndFunction

Function sendInflateMessage(int iInflateNum = 1)
    parent.sendInflateMessage()
    int currentVal = getPlugInflateLevel() + iInflateNum
    if WearerIsPlayer()
        string sMsg = ""
        if currentVal == 0
            sMsg = "The eggs hang mostly outside your vagina like a loose sack, their alien membrane smacking against your thighs."
        elseif currentVal == 1
            sMsg = "More eggs rest firmly within you, but the rest dangle obscenely outside. The way they brush against your thighs and leave them slimy is getting on your nerves. It wouldn't hurt to push them in a bit further, right?"
        elseif currentVal == 2
            sMsg = "Half the egg cluster is inside you. You feel completely full. The slimy eggs softly shift and settle, not unpleasantly. You feel you should be revulsed, but you're not. You get a twinge of pleasure as you imagine pushing them in further."
        elseif currentVal == 3
            sMsg = "The cluster of eggs within your quim press against your insides. They remind you of their presence every time you move, shifting around and kneading every sensitive spot."
        elseif currentVal == 4
            sMsg = "You cannot possibly fit any more eggs within you. They press your vagina apart and stretch it to its breaking point. With every step, you're filled with pain and blinding pleasure - you struggle holding back your squeals. Of delight?"
        else
            sMsg = "The eggs fill you completely, as solid as a rivet. You don't know how you haven't burst, but the pain makes you wonder if maybe you had. Your guts feel like a furnace of searing agony - but that's nothing compared to the throbbing ecstasy spreading from your crotch."     
        endif
        UDMain.ShowSingleMessageBox(sMsg) 
    endif
EndFunction

Function sendDeflateMessage()
    if haveHelper()
        if WearerIsPlayer()
            UDmain.Print(getHelperName() + " helped you to push out some" + getDeviceName() + "!",1)
        elseif PlayerInMinigame()
            UDmain.Print("You helped to push out some of" + getWearerName() + "s " + getDeviceName() + "!",1)
        endif
    else
        if WearerIsPlayer()
            UDmain.Print("You succesfully pushed out some of your "+getDeviceName()+"!",1)
        elseif PlayerInMinigame()
            UDmain.Print(getWearerName() + "s " + getDeviceName()+ " partially pushed out!",1)
        endif
    endif
EndFunction

string Function getArousalFailMessage(float fArousal)
    if fArousal <= 10 && _dwarvenOilKnown() && _isDwarvenOilPresent()
        return "Your fingers slipped, and the eggs only burrowed deeper inside you."
    elseif fArousal < 40
        return "The eggs clustered around your finger the moment it touched them, clogging your hole and sending waves of pain and pleasure with every twitch of your hand."
    elseif fArousal < 80
        return "For every egg you pulled out, two slid easily past your hand and back into your sloppy pussy. The cluster stretches you wide - it's almost impossible to remove them."
    else
        return "As desperately as you struggled to pull the glistening eggs out of your abused hole, your eager womb swallowed them back up each time with greedy abandon. It clenches painfully around them; they're now buried deep inside you."
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
bool Function proccesSpecialMenu(int msgChoice)
    return parent.proccesSpecialMenu(msgChoice)
EndFunction
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
EndFunction
int Function getPlugInflateLevel()
    return parent.getPlugInflateLevel()
EndFunction
string Function addInfoString(string str = "")
    parent.addInfoString(str)
EndFunction
Function inflate(bool silent = false, int iInflateNum = 1)
    parent.inflate(true, iInflateNum)
EndFunction
Function deflate(bool silent = False)
    parent.deflate(true)
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
    parent.struggleMinigame(type, abSilent)
EndFunction
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    parent.struggleMinigameWH(akHelper, aiType)
EndFunction