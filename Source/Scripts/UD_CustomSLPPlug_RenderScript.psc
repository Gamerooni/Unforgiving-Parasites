Scriptname  UD_CustomSLPPlug_RenderScript extends UD_CustomInflatablePlug_RenderScript

import UD_Native

SLP_fcts_parasites Property fctParasites Auto

; Name of the parasite (to be used to apply and cure it)
string Property SLPParasiteName Auto
; What the device says if it retaliates against the player
string Property UD_SLP_RetaliateMessagePlayer Auto
; What the device says if it retaliates against an NPC
string Property UD_SLP_RetaliateMessageNPC Auto

; The below is designed with UD_Chaos in mind

;==========LOCAL VARS==========

;wearer's arousal at the beginning of a minigame
float startMinigameArousal = 0.0

;whether the device will retaliate in response to the player's meddling
bool shouldRetaliate = true

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Parasite Plug"
    UD_ActiveEffectName = "Parasitic Stimulation"
    SLPParasiteName = "DEFAULT PARASITE"
EndFunction

;Apply the parasite, inflate the plug
Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), SLPParasiteName)
    inflatePlug(RandomInt(1, 3))
EndFunction

;Lower accessibility based on arousal
float Function getAccesibility()
    return parent.getAccesibility() * getArousalAdjustment()
EndFunction

;Deactivate soulgem charging
Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    UDCDmain.currentDeviceMenu_switch1 = False
EndFunction

;Deactivate soulgem charging
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    UDCDmain.currentDeviceMenu_switch1 = False
EndFunction

string Function addInfoString(string str = "")
    str += "Insertion level: " + getPlugInflateLevel() + "\n"
    return str
EndFunction

Function inflate(bool silent = false, int iInflateNum = 1)
    if !silent
        sendInflateMessage()
    endif
    parent.inflate(true, iInflateNum)
EndFunction

Function deflate(bool silent = False)
    if !silent
        sendDeflateMessage()
    endif
    parent.deflate(true)
EndFunction

;Normal deflate function, except with custom flavour text and stricter requirements
bool Function canDeflate()
    if iInRange(getPlugInflateLevel(),1,2)
        return True
    elseif getPlugInflateLevel() == 0
        if WearerIsPlayer()
            debug.MessageBox(getDeviceName() + " could not fill you any less.")
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " cannot fill them any less.",1)
        endif
        return False
    endif
    if WearerIsPlayer()
        debug.MessageBox(getDeviceName() + " stretches your hole too far. You can't do anything about it!")
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "s "+ getDeviceName() + " is stuck fast inside them!",1)
    endif
    return False
EndFunction

;Copied from parent. Cooldown resets faster based on arousal. Custom message.
Function activateDevice()
    resetCooldown(fRange(getArousalAdjustment(), 0.3, 1.0))
    bool loc_canInflate = getPlugInflateLevel() <= 4
    bool loc_canVibrate = canVibrate() && !isVibrating()
    if loc_canInflate
        sendActivationMessage()
        inflatePlug(1)
    endif
    if loc_canVibrate
        vibrate()
    endif
EndFunction

;Apply cum to appropriate areas, cure parasite
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    int loc_plugType = getPlugType()
    bool loc_vaginal = true
    bool loc_anal = true
    if loc_plugType == 1
        loc_vaginal = false
    elseif loc_plugType == 0
        loc_anal = false
    endif
    libs.SexLab.AddCum(akActor, Vaginal = loc_vaginal, Oral = false, Anal = loc_vaginal)
    fctParasites.cureParasiteByString(akActor, SLPParasiteName)
EndFunction

; Save the arousal at the beginning for later use. retaliate.
Function OnMinigameStart()
    startMinigameArousal = UDOM.getArousal(getWearer())
    retaliate()
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
    if !IsUnlocked && WearerIsPlayer()
        libs.NotifyPlayer(getArousalFailMessage(), true)
    endif
EndFunction

; Always struggle
bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return forceOutPlugMinigame()
EndFunction

; always struggle
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    return forceOutPlugMinigameWH(akHelper)
EndFunction

;==========HELPER FUNCTIONS===========

;Get adjustment to accessibility. Device is harder to access when aroused, but the Agility skill makes it easier
float Function getArousalAdjustment()
    return 1.0 - fRange((UDOM.getArousal(getWearer()) - UDmain.UDSKILL.GetAgilitySkill(getWearer()))/80.0, 0.0, 1.0)
endFunction

;Creates a message to the player based on their current arousal when they fail a minigame. This placeholder is naturally empty
string Function getArousalFailMessage()
    return "you cry about it"
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

;What the device will do if it retaliates. effect scales with `fMult`
Function retaliate(float fMult = 1.0)
    if willRetaliate(fMult)
        if UDCDmain.activateDevice(self)
            if WearerIsPlayer() && UD_SLP_RetaliateMessagePlayer
                UDmain.ShowSingleMessageBox(UD_SLP_RetaliateMessagePlayer)
            elseif UDCDmain.AllowNPCMessage(GetWearer(), true) && UD_SLP_RetaliateMessageNPC
                UDmain.Print(UD_SLP_RetaliateMessageNPC, 3)
            endif
        endif
    endif
EndFunction

;The message the device will send upon activation
Function sendActivationMessage()
    if WearerIsPlayer()
        Udmain.Print("Your " + getDeviceName() + " contracts into a tight coil, writhes, and begins to spread you even wider!")
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "'s "+ getDeviceName() + " suddenly spreads her even wider!",3)
    endif
EndFunction

;The message the device will send upon inflation
Function sendInflateMessage()
    Udmain.Print(getDeviceName() + " makes " + getWearerName() + " thicker than a bowl of oatmeal! (you shouldn't be seeing this message)")
EndFunction

;The message the device will send upon deflation
Function sendDeflateMessage()
    Udmain.Print(getDeviceName() + ", to everyone's great shock, makes " + getWearerName() + " less thick. Any less thick and they will be like overmilked instant oats. (you shouldn't be seeing this message)")
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function OnInflated()
    parent.OnInflated()
EndFunction
Function OnDeflated()
    parent.OnInflated()
EndFunction
bool Function inflateMinigame()
    return parent.InflateMinigame()
EndFunction
bool Function deflateMinigame()
    return parent.deflateMinigame()
EndFunction
bool Function canBeActivated()
    Parent.canBeActivated()
EndFunction
Function safeCheck()
    parent.safeCheck()
EndFunction
Function patchDevice()
    parent.patchDevice()
EndFunction
Function OnVibrationStart()
    parent.OnVibrationStart()
EndFunction
Function OnVibrationEnd()
    parent.OnVibrationEnd()
EndFunction
float Function getVibOrgasmRate(float afMult = 1.0)
    return parent.getVibOrgasmRate(afMult)
EndFunction
float Function getVibArousalRate(float afMult = 1.0)
    return parent.getVibArousalRate(afMult)
EndFunction
bool Function OnMendPre(float mult) ;called on device mend (regain durability)
    return parent.OnMendPre(mult)
EndFunction
Function OnMendPost(float mult) ;called on device mend (regain durability). Only called if OnMendPre returns true
    parent.OnMendPost(mult)
EndFunction
bool Function OnCritDevicePre() ;called on minigame crit
    return parent.OnCritDevicePre()
EndFunction
bool Function OnOrgasmPre(bool sexlab = false) ;called on wearer orgasm. Is only called if wearer is registered
    return parent.OnOrgasmPre(sexlab)
EndFunction
Function OnMinigameOrgasm(bool sexlab = false) ;called on wearer orgasm while in minigame. Is only called if wearer is registered
    parent.OnMinigameOrgasm(sexlab)
EndFunction
Function OnMinigameOrgasmPost() ;called on wearer orgasm while in minigame. Is only called after OnMinigameOrgasm. Is only called if wearer is registered
    parent.OnMinigameOrgasmPost()
EndFunction
Function OnOrgasmPost(bool sexlab = false) ;called on wearer orgasm. Is only called if OnOrgasmPre returns true. Is only called if wearer is registered
    parent.OnOrgasmPost(sexlab)
EndFunction
Function OnMinigameTick(Float abUpdateTime) ;called on every tick of minigame. Uses MCM performance setting
    parent.OnMinigameTick(abUpdateTime)
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction
Function OnDeviceCutted() ;called when device is cutted
    parent.OnDeviceCutted()
EndFunction
Function OnDeviceLockpicked() ;called when device is lockpicked
    parent.OnDeviceLockpicked()
EndFunction
Function OnLockReached() ;called when device lock is reached
    parent.OnLockReached()
EndFunction
Function OnLockJammed() ;called when device lock is jammed
    parent.OnLockJammed()
EndFunction
Function OnDeviceUnlockedWithKey() ;called when device is unlocked with key
    parent.OnDeviceUnlockedWithKey()
EndFunction
Function OnUpdatePre(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePre(timePassed)
EndFunction
Function OnUpdatePost(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePost(timePassed)
EndFunction
bool Function OnCooldownActivatePre()
    return parent.OnCooldownActivatePre()
EndFunction
Function OnCooldownActivatePost()
    parent.OnCooldownActivatePost()
EndFunction
Function DeviceMenuExt(int msgChoice)
    parent.DeviceMenuExt(msgChoice)
EndFunction
Function DeviceMenuExtWH(int msgChoice)
    parent.DeviceMenuExtWH(msgChoice)
EndFunction
bool Function OnUpdateHourPre()
    return parent.OnUpdateHourPre()
EndFunction
bool Function OnUpdateHourPost()
    return parent.OnUpdateHourPost()
EndFunction
Function OnRemoveDevicePre(Actor akActor)
    parent.OnRemoveDevicePre(akActor)
EndFunction
Function onLockUnlocked(bool lockpick = false)
    parent.onLockUnlocked(lockpick)
EndFunction
Function onSpecialButtonReleased(Float fHoldTime)
    parent.onSpecialButtonReleased(fHoldTime)
EndFunction
bool Function onWeaponHitPre(Weapon source)
    return parent.onWeaponHitPre(source)
EndFunction
Function onWeaponHitPost(Weapon source)
    parent.onWeaponHitPost(source)
EndFunction
bool Function onSpellHitPre(Spell source)
    return parent.onSpellHitPre(source)
EndFunction
Function onSpellHitPost(Spell source)
    parent.onSpellHitPost(source)
EndFunction
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
bool Function proccesSpecialMenu(int msgChoice)
    return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction