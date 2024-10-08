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


;=====HELPER FUNCTIONS=====

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
    ;dwarven oil
    if !SLP_CureIngredient
        SLP_CureIngredient = Game.GetFormFromFile(0x000F11C0, "Skyrim.esm") as Ingredient
    endif
    parent.safeCheck()
EndFunction

Function OnRemoveDevicePre(Actor akActor)
    UDmain.ShowSingleMessageBox("The eggs pop out of your hole one-by-one, each one pulling out the next by a thread of the foamy and slimy lubricant that kept them together.")
    parent.OnRemoveDevicePre(akActor)
EndFunction


;===========CUSTOM OVERRIDES===========

Function sendRetaliationMessage()
    if WearerIsPlayer()
        UDmain.ShowSingleMessageBox("The eggs sense your tampering and squirm and writhe to avoid it!")
    elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
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
    if fArousal <= 10 && knowsCureIngredient() && hasCureIngredient()
        return "Your fingers slipped, and the eggs only burrowed deeper inside you."
    elseif fArousal < 40
        return "The eggs clustered around your finger the moment it touched them, clogging your hole and sending waves of pain and pleasure with every twitch of your hand."
    elseif fArousal < 80
        return "For every egg you pulled out, two slid easily past your hand and back into your sloppy pussy. The cluster stretches you wide - it's almost impossible to remove them."
    else
        return "As desperately as you struggled to pull the glistening eggs out of your abused hole, your eager womb swallowed them back up each time with greedy abandon. It clenches painfully around them; they're now buried deep inside you."
    endif
EndFunction

bool Function knowsCureIngredient()
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iSpiderEggsKnown")==1
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
    return parent.addInfoString(str)
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
    return parent.struggleMinigame(type, abSilent)
EndFunction
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    return parent.struggleMinigameWH(akHelper, aiType)
EndFunction
float Function getAccesibility()
    return parent.getAccesibility()
EndFunction
Function OnMinigameStart()
    parent.OnMinigameStart()
EndFunction
bool Function canDeflate()
    return parent.canDeflate()
EndFunction
float Function getArousalAdjustment()
    return parent.getArousalAdjustment()
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
string Function getCureName()
    return SLP_CureIngredient.GetName()
EndFunction
bool Function doesCureExist()
    return parent.doesCureExist()
EndFunction
bool Function hasCureIngredient()
    return parent.hasCureIngredient()
EndFunction
float Function getCureMultiplier()
    return parent.getCureMultiplier()
EndFunction
string Function getCureFailText()
    return parent.getCureFailText()
EndFunction
string Function getCureApplyText()
    return parent.getCureApplyText()
EndFunction