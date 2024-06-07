Scriptname  UD_CustomSLPPlug_RenderScript extends UD_CustomInflatablePlug_RenderScript

import UD_Native

SLP_fcts_parasites Property fctParasites Auto

; Name of the parasite (to be used to apply it)
string Property SLPParasiteApplyName Auto
; Name of the parasite (to be used to cure it)
string Property SLPParasiteCureName Auto
; What the device says if it retaliates against the player
string Property UD_SLP_RetaliateMessagePlayer Auto
; What the device says if it retaliates against an NPC
string Property UD_SLP_RetaliateMessageNPC Auto

; The ingredient to cure the parasite, if any
Ingredient Property SLP_CureIngredient Auto
; The difficulty multiplier if there's no cure. Default is 0.2
Float Property SLP_CureMultiplier Auto
; Flavour text for the inflation
String Property SLP_InflationType Auto

; The below is designed with UD_Chaos in mind


; maybe change from accessibility to some other form of difficulty for minigame calculations?


;==========LOCAL VARS==========

;wearer's arousal at the beginning of a minigame
float startMinigameArousal = 0.0

;whether the device will retaliate in response to the player's meddling
bool shouldRetaliate = true

;whether the current minigame is a struggle minigame or something else
bool isStruggle = false

;whether the most recent deflate has been successful
bool isDeflateSuccessful = false

;==========OVERRIDES==========

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Parasite Plug"
    UD_ActiveEffectName = "Parasitic Stimulation"
    SLP_InflationType = "Insertion level"
    UD_PumpDifficulty = 250
EndFunction

;Apply the parasite, inflate the plug, make cooldown shorter
Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), SLPParasiteApplyName)
    inflatePlug(RandomInt(1, 3))
    resetCooldown(0.2)
EndFunction

Function safeCheck()
    parent.safeCheck()
    if SLPParasiteApplyName && !SLPParasiteCureName
        SLPParasiteCureName = SLPParasiteApplyName
    elseif SLPParasiteCureName && !SLPParasiteApplyName
        SLPParasiteApplyName = SLPParasiteCureName
    endif
    if !SLP_CureMultiplier
        SLP_CureMultiplier = 0.2
    endif
EndFunction

;Lower accessibility based on arousal
;Naw scratch that, just make the minigames harder
float Function getAccesibility()
    return parent.getAccesibility(); * getArousalAdjustment()
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
    if doesCureExist() && knowsCureIngredient()
        str += "Remedy: " + getCureName() + "\n"
    endif
    str += SLP_InflationType + ": " + getPlugInflateLevel() + "\n"
    return str
EndFunction

Function inflate(bool silent = false, int iInflateNum = 1)
    if !silent
        sendInflateMessage(iInflateNum)
    endif
    parent.inflate(true, iInflateNum)
EndFunction

Function deflate(bool silent = False)
    if !silent
        sendDeflateMessage()
    endif
    parent.deflate(true)
EndFunction

;We'll have to struggle for every deflation
bool Function canDeflate()
    if getPlugInflateLevel() == 0
        if WearerIsPlayer()
            debug.MessageBox(getDeviceName() + " could not fill you any less.")
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " cannot fill them any less.",1)
        endif
    ; if we have the cure, we apply it
    elseif iInRange(getPlugInflateLevel(),1,2) && doesCureExist() && knowsCureIngredient() && hasCureIngredient()
        Udmain.Print(getCureApplyText())
        return true
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
    fctParasites.cureParasiteByString(akActor, SLPParasiteCureName)
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
    ; Also change minigame difficulty here
    setMinigameDmgMult(getMinigameMult(0) * getArousalAdjustment() * getCureMultiplier())
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
        if isStruggle || !isDeflateSuccessful
            sMsg = getArousalFailMessage(startMinigameArousal)
        endif
        Udmain.ShowSingleMessageBox(sMsg)
    endif
    isStruggle = false
    isDeflateSuccessful = false
EndFunction

; Always struggle
bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    isStruggle = true
    return forceOutPlugMinigame()
EndFunction

; always struggle
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    isStruggle = true
    return forceOutPlugMinigameWH(akHelper)
EndFunction

Function OnDeflated()
    parent.OnDeflated()
    isDeflateSuccessful = true
EndFunction

;==========HELPER FUNCTIONS===========

;Get adjustment to accessibility. Device is harder to access when aroused, but the Agility skill makes it easier
float Function getArousalAdjustment()
    return 1.0 - fRange((UDOM.getArousal(getWearer()) - UDmain.UDSKILL.GetAgilitySkill(getWearer()))/80.0, 0.0, 1.0)
endFunction

;Creates a message to the player based on their current arousal when they fail a minigame. This placeholder is naturally empty
string Function getArousalFailMessage(float fArousal)
    return "you cry about it (you're not supposed to be seeing this message)"
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
            sendRetaliationMessage()
        endif
    endif
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
        Udmain.Print("Your " + getDeviceName() + " contracts into a tight coil, writhes, and begins to spread you even wider!")
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
            msg = getHelperName() + " helped you insert the " + getDeviceName() + " deeper!"
        elseif WearerIsFollower() && HelperIsPlayer()
            msg = "You helped push " + getWearerName() + "'s " + getDeviceName() + " deeper in!"
        elseif WearerIsFollower()
            msg = getHelperName() + " helped pushing " + getWearerName() + "'s " + getDeviceName() + " further in!"
        endif            
    else
        if WearerIsPlayer()
            msg = "You succesfully pushed " + getDeviceName() + " deeper in"
        elseif WearerIsFollower()
            msg = getWearerName() + "'s " + getDeviceName() + " slid deeper into them!"
            iLogLevel = 3
        endif
    endif
    UDmain.Print(msg, iLogLevel)
EndFunction

;The message the device will send upon deflation
Function sendDeflateMessage()
    if WearerIsPlayer()
        UDMain.Print("The " + getDeviceName() + " relieves some of the pressure in your hole.")
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

string Function getCureApplyText()
    string sMsg = ""
    if haveHelper()
        if WearerIsPlayer()
            sMsg = getHelperName() + " spreads the " + getCureName() + " around your groin. You almost moan as their fingers slip past the " + getDeviceName() + " and into your pussy."
        elseif PlayerInMinigame()
            sMsg = "You spread " + getCureName() + " around " + getWearerName() + "'s vagina. When your hand pushes past the " + getDeviceName() + " and into their vagina, they twitch and gasp."
        endif
    else
        sMsg = "You rub the " + getCureName() + " into your hands and lower them down to your pussy. You squirm in sync with the " + getDeviceName() + " as you lubricate yourself."
    endif
    return sMsg
EndFunction

;the funniest possible way to stop the UD Patcher from chucking locks onto this device
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    return 0x00000000
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function OnInflated()
    parent.OnInflated()
EndFunction
bool Function inflateMinigame()
    return parent.InflateMinigame()
EndFunction
bool Function deflateMinigame()
    return parent.deflateMinigame()
EndFunction
bool Function canBeActivated()
    return Parent.canBeActivated()
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