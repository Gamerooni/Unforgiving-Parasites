Scriptname UD_CustomSLPChaurusWorm_RS extends UD_CustomSLPPlug_RenderScript

import UD_Native

; maybe add some damage to represent the worm's teeth?

; DON'T FORGET TO ADD TO EQUIP SCRIPT AND ESP

;=====HELPER FUNCTIONS=====

;=====OVERRIDES=====
Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Worm Squirming"
    UD_DeviceType = "Chaurus Anal worm"
EndFunction

Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "ChaurusWorm"
    endif
    ;troll fat
    if !SLP_CureIngredient
        SLP_CureIngredient = Game.GetFormFromFile(0x0003AD72, "Skyrim.esm") as Ingredient
    endif
    parent.safeCheck()
EndFunction

; just some extra flavour text
Function OnRemoveDevicePre(Actor akActor)
    if (IsPlayer(akActor))
        UDmain.ShowSingleMessageBox("Your ruined anus traces the outline of your fist as you pull your hand out, the worm's tail gripped tight. Your entire body goes taut as the squirming creature fights for the last inch, then, as you pop it out, it all gives way to immense relief.")
    endif
    parent.OnRemoveDevicePre(akActor)
EndFunction


;===========CUSTOM OVERRIDES===========

Function sendRetaliationMessage()
    if WearerIsPlayer() && UD_SLP_RetaliateMessagePlayer
        UDmain.ShowSingleMessageBox("The worm comes to life and starts to burrow into you away from your hand!")
    elseif UDCDmain.AllowNPCMessage(GetWearer(), true) && UD_SLP_RetaliateMessageNPC
        UDmain.Print("The worm senses " + getWearerName() + "'s tampering and becomes lively!", 3)
    endif
EndFunction

Function sendInflateMessage(int iInflateNum = 1)
    parent.sendInflateMessage()
    int currentVal = getPlugInflateLevel() + iInflateNum
    if WearerIsPlayer()
        string sMsg = ""
        if currentVal == 0
            sMsg = "The worm's squirming body hangs mostly outside your ass, making it look like an obscene tail."
        ;finish the other ones
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

; done
Function sendDeflateMessage()
    if haveHelper()
        if WearerIsPlayer()
            UDmain.Print(getHelperName() + " helped you pull " + getDeviceName() + " slightly further out of your ass!",1)
        elseif PlayerInMinigame()
            UDmain.Print("You helped pull some of " + getWearerName() + "'s " + getDeviceName() + " out of their ass!",1)
        endif
    else
        if WearerIsPlayer()
            UDmain.Print("You succesfully pulled your " + getDeviceName() + " further out of your ass!",1)
        elseif PlayerInMinigame()
            UDmain.Print(getWearerName() + "'s " + getDeviceName()+ " has been partially pulled out!",1)
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
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iChaurusWormKnown")==1
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