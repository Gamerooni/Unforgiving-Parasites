Scriptname UD_CustomSLPChaurusWormVag_RS extends UD_CustomSLPPlug_RenderScript

import UD_Native

; maybe add some damage to represent the worm's teeth?

; DON'T FORGET TO ADD TO EQUIP SCRIPT AND ESP

; DON'T FORGET TO SWITCH DESCRIPTIONS FROM VAGINAL TO ANAL

;=====HELPER FUNCTIONS=====

;=====OVERRIDES=====
Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Worm Squirming"
    UD_DeviceType = "Chaurus Vaginal Worm"
EndFunction

Function safeCheck()
    if !SLPParasiteApplyName
        SLPParasiteApplyName = "ChaurusWormVag"
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
            sMsg = "The worm's squirming body hangs mostly outside your ass. It looks like an obscene tail."
        ;finish the other ones
        elseif currentVal == 1
            sMsg = "placeholder"
        elseif currentVal == 2
            sMsg = "placeholder"
        elseif currentVal == 3
            sMsg = "placeholder"
        elseif currentVal == 4
            sMsg = "You clench your cheeks and thighs and force your rectum to suck the worm even further, helping it along with your hand. The worm wriggles from side-to-side, making you gasp as it stretches your anus wider then, with a pop, it slides further in. You can barely breathe without feeling your body grip the worm. Any more and you think your belly might burst."
        else
            sMsg = "Your fist fully in your ass, you push at the worm. Something gives, something inside you shifts, and the worm wriggles away. You can't feel where it went. Your body was not equipped to sense things that far in. There is a dull throbbing emanating from your bellybutton, waves of pain as your intestines are stretched where they shouldn't. Each one is more pleasant than the last."     
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

;done
string Function getArousalFailMessage(float fArousal)
    if fArousal <= 10 && knowsCureIngredient() && hasCureIngredient()
        return "Your troll fat coated fingers slipped, and the worm wriggled out of their grasp and back into you."
    elseif fArousal < 40
        return "The worm spread itself wide, its barbed body gripping at your insides with every bit of force it could muster. You felt like you were trying to pull a champagne cork through a straw."
    elseif fArousal < 80
        return "Your wet pussy covered your hand in its juices as you struggled to pull the worm out. With every tug, your body quivered in pain and ecstasy, and your grip on the worm became that much looser. When it slips away and burrows back into you, you sigh in relief - you'll get to keep it for that bit longer."
    else
        return "The worm spread itself apart, massaging your womb through the layer of flesh between it. Your body decided that parting with this creature was a mistake; your rectum clenched, seized, and shot the worm back into you with a dull squelch."
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