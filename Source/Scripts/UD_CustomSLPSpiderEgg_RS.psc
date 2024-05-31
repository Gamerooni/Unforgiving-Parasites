Scriptname UD_CustomSLPSpiderEgg_RS extends UD_CustomInflatablePlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

import UnforgivingDevicesMain
import UD_Native

; Possibly sentient?
; Nope, sentient it too inflexible. Will need own implementation
; this will involve:
; - XXXXXonminigamestart checksentient
; - XXXXXoncritfailure checksentient
; - XXXXXforce the struggle minigame
; - XXXXXrandom activation
; Add custom sounds

float _dwarvenOilAdjust = 0.2

;=====PARENT DUMB VAR OVERRIDE=====
float deflateprogress = 0.0
bool deflateMinigame_on = false

float inflateprogress = 0.0
bool inflateMinigame_on = false

int _inflateLevel = 0 ;for npcs


;=====HELPER FUNCTIONS=====
int Function _getDexterity()
    int iDexterity = 10 + (libs.PlayerRef.GetActorValue("Pickpocket") as Int) / 10
    return iDexterity
EndFunction

float Function _getArousalAdjustment()
    return 1.0 - fRange((UDOM.getArousal(getWearer()) - _getDexterity())/80.0, 0.0, 1.0)
EndFunction

bool function _dwarvenOilKnown()
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iSpiderEggsKnown")==1
EndFunction

bool function _isDwarvenOilPresent()
    Ingredient _dwarvenOil = Game.GetFormFromFile(0x000F11C0, "Skyrim.esm") as Ingredient
    return getWearer().GetItemCount(_dwarvenOil) > 0 || getHelper().GetItemCount(_dwarvenOil) > 0
endfunction

float function _getDwarvenOilAdjust()
    if _dwarvenOilKnown() && _isDwarvenOilPresent()
        return 1.0
    else
        return _dwarvenOilAdjust
    endif
EndFunction

Function _retaliatoryInflate(float fMult = 1.0)
    if Round(fMult * (1.0 - _getArousalAdjustment()) * 90.0) > RandomInt(1,99)
        UDCDmain.activateDevice(self)
        if WearerIsPlayer()
            UDmain.ShowSingleMessageBox("The eggs sense your tampering and retaliate!")
        endif
    endif
EndFunction

;=====OVERRIDES=====
Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Insertion"
    UD_DeviceType = "Spider Egg Plug"
    UD_Cooldown = 90
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "SpiderEgg" )
    inflatePlug(RandomInt(1, 3))
EndFunction

float Function getAccesibility()
    return parent.getAccesibility() * _getArousalAdjustment() * _getDwarvenOilAdjust()
EndFunction

string Function addInfoString(string str = "")
    str += "Insertion level: " + getPlugInflateLevel() + "\n"
    ; can't do below because deflateprogress isn't available
    ; if getPlugInflateLevel() > 0
    ;     str += "Egg pressure: " + Math.Ceiling(100.0 - 100.0*deflateprogress/UD_PumpDifficulty) + " %\n"
    ; endif
    return str
EndFunction

Function inflate(bool silent = false, int iInflateNum = 1)
    int currentVal = getPlugInflateLevel() + iInflateNum
        if !silent
            if haveHelper()
                if WearerIsPlayer()
                    UDmain.Print(getHelperName() + " helped you insert the " + getDeviceName() + " deeper!",1)
                elseif WearerIsFollower() && HelperIsPlayer()
                    UDmain.Print("You helped push " + getWearerName() + "s " + getDeviceName() + " deeper in!",1)
                elseif WearerIsFollower()
                    UDmain.Print(getHelperName() + " helped pushing " + getWearerName() + "s " + getDeviceName() + " further in!",1)
                endif            
            else
                if WearerIsPlayer()
                    UDmain.Print("You succesfully pushed " + getDeviceName() + " deeper in",1)
                    string sMsg = ""
                    if currentVal == 0
                        sMsg = "The eggs hang mostly outside your vagina like a loose sack, their alien membrane smacking against your thighs."
                    elseif currentVal == 1
                        sMsg = "More eggs rest firmly within you, but the rest dangle obscenely outside. The way they brush against your thighs and leave them slimy is getting on your nerves. It wouldn't hurt to push them in a bit further, right?"
                    ; elseif currentVal == 1
                    ;     libs.notify("Your plug is a bit inflated but doesn't stimulate you too much - just enough to make you long for more. You could give the pump a healthy squeeze!", messagebox = true)
                    elseif currentVal == 2
                        sMsg = "Half the egg cluster is inside you. You feel completely full. The slimy eggs softly shift and settle, not unpleasantly. You feel you should be revulsed, but you're not. You get a twinge of pleasure as you imagine pushing them in further."
                    ; elseif currentVal == 2
                    ;     libs.notify("Your plug is inflated. Its gentle movements inside you please you without causing you discomfort. You are getting more horny and wonder if you should inflate it even more?", messagebox = true)
                    elseif currentVal == 3
                        sMsg = "The cluster of eggs within your quim press against your insides. They remind you of their presence every time you move, shifting around and kneading every sensitive spot."
                        ; elseif currentVal == 3
                    ;     libs.notify("Your fairly inflated plug is impossible to ignore as it moves around inside of you, constantly pleasing you and making you more horny as you already are.", messagebox = true)
                    elseif currentVal == 4
                        sMsg = "You cannot possibly fit any more eggs within you. They press your vagina apart and stretch it to its breaking point. With every step, you're filled with pain and blinding pleasure - you struggle holding back your squeals. Of delight?"
                    ; elseif currentVal == 4
                    ;     libs.notify("Your plug is almost inflated to capacity. You cannot move at all without shifting it around inside of you, making you squeal in an odd sensation of pleasurable pain.", messagebox = true)
                    else
                        sMsg = "The eggs fill you completely, as solid as a rivet. You don't know how you haven't burst, but the pain makes you wonder if maybe you had. Your guts feel like a furnace of searing agony - but that's nothing compared to the throbbing ecstasy spreading from your crotch."
                    ; else
                    ;     libs.notify("Your plug is fully inflated and almost bursting inside you. It's causing you more discomfort than anything. But no matter what - you won't be able to remove it from your body anytime soon.", messagebox = true)      
                    UDMain.ShowSingleMessageBox(sMsg)   
                    EndIf    
                elseif WearerIsFollower()
                    UDmain.Print(getWearerName() + "s " + getDeviceName() + " inflated!",2)
                endif
            endif
        endif
    parent.inflate(true, iInflateNum)
EndFunction

Function deflate(bool silent = False)
    if !silent
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
    endif
    return parent.deflate(true)
EndFunction

bool Function canDeflate()
    if iInRange(getPlugInflateLevel(),1,2) && _dwarvenOilKnown() && _isDwarvenOilPresent()
        return True
    else
    ; else
    ;     if WearerIsPlayer()
    ;         debug.MessageBox("Plug is already deflated")
    ;     elseif WearerIsFollower()
    ;         UDmain.Print(getWearerName() + "s "+ getDeviceName() + " is already mostly pushed out",1)
    ;     endif
    ;     return False
    ; endif
    ; if WearerIsPlayer()
    ;     debug.MessageBox("Plug is too big to be deflated at the moment!")
    ; elseif WearerIsFollower()
    ;     UDmain.Print(getWearerName() + "s "+ getDeviceName() + " are too far in to be pushed out at this moment!",1)
    ; endif
        return False
    endif
EndFunction

Function activateDevice()
    resetCooldown(fRange(_getArousalAdjustment(), 0.3, 1.0))
    bool loc_canInflate = _inflateLevel <= 4
    bool loc_canVibrate = canVibrate() && !isVibrating()
    if loc_canInflate
        if WearerIsPlayer()
            Udmain.Print("Your "+ getDeviceName()+" contract into a tight ball, then shoot further into you!")
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " suddenly shoot further into her!",3)
        endif
        inflatePlug(1)
    endif
    if loc_canVibrate
        vibrate()
    endif
EndFunction

Function OnMinigameStart()
    setMinigameMult(1, getMinigameMult(1) * getAccesibility())
    string sMsg = ""
    bool bRetaliate = false
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
        else
            sMsg = "You recall that it's unwise to begin this without Dwarven Oil."
            bRetaliate = true;;_retaliatoryInflate()
        endif
    else
        bRetaliate = true;_retaliatoryInflate()
    endif
    if sMsg != ""
        UDmain.Print(sMsg)
    endif
    if bRetaliate
        _retaliatoryInflate()
    endif
    parent.OnMinigameStart()
EndFunction

Function OnCritFailure()
    _retaliatoryInflate(0.75)
    parent.OnCritFailure()
EndFunction

Function OnRemoveDevicePre(Actor akActor)
    UDmain.ShowSingleMessageBox("The eggs pop out of your hole one-by-one, each one pulling out the next by a thread of the foamy and slimy lubricant that kept them together.")
    parent.OnRemoveDevicePre(akActor)
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    libs.SexLab.AddCum(akActor, Vaginal = true, Oral = false, Anal = true)
    fctParasites.cureParasiteByString(akActor, "SpiderEggAll")
EndFunction

bool Function canBeActivated()
    if parent.canBeActivated() || (getPlugInflateLevel() <= 4 && getRelativeElapsedCooldownTime() >= 0.3)
        return true
    else
        return false
    endif
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
bool Function proccesSpecialMenu(int msgChoice)
    return parent.proccesSpecialMenu(msgChoice)
EndFunction

int Function getPlugInflateLevel()
    return parent.getPlugInflateLevel()
EndFunction

Function inflatePlug(int increase)
    return parent.inflatePlug(increase) 
EndFunction

Function deflatePlug(int decrease)
    return parent.deflatePlug(decrease)
EndFunction

Function updateWidget(bool force = false)
    parent.updateWidget(force)
EndFunction

Function onUpdatePost(float timePassed)
    parent.onUpdatePost(timePassed)
EndFunction

bool Function OnCritDevicePre()
    return parent.OnCritDevicePre()
EndFunction

Function OnMinigameEnd()
    parent.OnMinigameEnd()
EndFunction

Function OnMinigameTick(Float abUpdateTime)
    parent.OnMinigameTick(abUpdateTime)
EndFunction

Function patchDevice()
    parent.patchDevice()
EndFunction