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
        UDmain.ShowSingleMessageBox("Your ruined vulva traces the outline of your fist as you pull your hand out, the worm's tail gripped tight. Your entire body goes taut as the squirming creature fights for the last inch, then, as you pop it out, it all gives way to immense relief.")
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
            sMsg = "how did you inflate the plug and end up at zero inflation? no, it's a serious question. make a bug report."
        elseif currentVal == 1
            sMsg = "You shimmy the worm's head a bit more into you, its squirming body slapping against your thighs. Its mouth nibbles at you, trying to squeeze further in."
        elseif currentVal == 2
            sMsg = "You spread your cheeks wide and push at the critter with your palm. It eagerly reciprocates you; its body pulses once, twice, and suddenly you feel something softly nibbling at you from deeper inside. Its tail swings side to side and goes still, locking itself in; your teeth chatter from the unexpected stimulation."
        elseif currentVal == 3
            sMsg = "You reach for the worm. As soon as you touch its lukewarm hide, it wriggles in discomfort. A jolt of pleasure strikes your spine like lightning; your womb clenches of its own accord and, before you can stop it, sucks the worm in further. Its ribbed carapace plays mayhem with your vagina on its way in. When it stops, all you want is for it to keep going."
        elseif currentVal == 4
            sMsg = "You clench your cheeks and thighs, and force your womb to suck the worm even further, helping it along with your hand. The critter wriggles from side-to-side, making you gasp as it stretches you wider, then with a pop, it slides further in. You can barely breathe without feeling your vagina compress around the worm. Any more and you think you might burst."
        else
            sMsg = "Your fist fully in your cunt, you push at the worm. Something gives, something inside you shifts, and the worm wriggles away. You can't feel where it went. Your body was not equipped to sense things that far in. There is a dull throbbing emanating from your bellybutton, waves of pain as your womb is stretched where it shouldn't. Each one is more pleasant than the last."  
        endif
        UDMain.ShowSingleMessageBox(sMsg) 
    endif
EndFunction

Function sendDeflateMessage()
    if haveHelper()
        if WearerIsPlayer()
            UDmain.Print(getHelperName() + " helped you pull " + getDeviceName() + " slightly further out of your pussy!",1)
        elseif PlayerInMinigame()
            UDmain.Print("You helped pull some of " + getWearerName() + "'s " + getDeviceName() + " out of their pussy!",1)
        endif
    else
        if WearerIsPlayer()
            UDmain.Print("You succesfully pulled your " + getDeviceName() + " further out of your pussy!",1)
        elseif PlayerInMinigame()
            UDmain.Print(getWearerName() + "'s " + getDeviceName()+ " has been partially pulled out!",1)
        endif
    endif
EndFunction

string Function getArousalFailMessage(float fArousal)
    if fArousal <= 10 && knowsCureIngredient() && hasCureIngredient()
        return "Your troll fat coated fingers slipped, and the worm wriggled out of their grasp and back into you."
    elseif fArousal < 40
        return "The worm spread itself wide, its barbed body gripping at your insides with every bit of force it could muster. You felt like you were trying to pull a champagne cork through a straw."
    elseif fArousal < 80
        return "Your wet pussy covered your hand in its juices as you struggled to pull the worm out. With every tug, your body quivered in pain and ecstasy, and your grip on the worm became that much looser. When it slips away and burrows back into you, you sigh in relief - you'll get to keep it for that bit longer."
    else
        return "The worm spread itself apart, sending painful ripples of pressure through your insides as its teeth hooked into your flesh. Your body decided that parting with this creature was a mistake; your vagina clenched, seized, and shot the worm back into you with a dull squelch."
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