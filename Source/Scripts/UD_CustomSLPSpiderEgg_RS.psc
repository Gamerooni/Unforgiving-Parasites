Scriptname UD_CustomSLPSpiderEgg_RS extends UD_CustomInflatablePlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

import UnforgivingDevicesMain
import UD_Native

; Possibly sentient?
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
	UDmain.Print("Dexterity: " + iDexterity, 3, true)
    return iDexterity
EndFunction

float Function _getArousalAdjustment()
    return 1.0 - fRange((libs.Aroused.GetActorExposure(getWearer()) - _getDexterity())/80.0, 0.0, 1.0)
EndFunction

bool function _dwarvenOilKnown()
    return StorageUtil.GetIntValue(libs.PlayerRef, "_SLP_iSpiderEggsKnown")==1
EndFunction

float function _getDwarvenOilAdjust()
    if _dwarvenOilKnown()
        return 1.0
    else
        return _dwarvenOilAdjust
    endif
EndFunction

;=====OVERRIDES=====
Function InitPost()
    parent.InitPost()
    if UD_ActiveEffectName == "Inflate"
        UD_ActiveEffectName == "Insertion"
    endif
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "SpiderEgg" )
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

Function inflate(bool silent=false, int iInflateNum = 1)
    parent.inflate(silent, iInflateNum)
EndFunction

; Function inflate(bool silent = false, int iInflateNum = 1)
;     int currentVal = getPlugInflateLevel() + iInflateNum
;         if !silent
;             if haveHelper()
;                 if WearerIsPlayer()
;                     UDmain.Print(getHelperName() + " helped you insert the " + getDeviceName() + " deeper!",1)
;                 elseif WearerIsFollower() && HelperIsPlayer()
;                     UDmain.Print("You helped push " + getWearerName() + "s " + getDeviceName() + " deeper in!",1)
;                 elseif WearerIsFollower()
;                     UDmain.Print(getHelperName() + " helped pushing " + getWearerName() + "s " + getDeviceName() + " further in!",1)
;                 endif            
;             else
;                 if WearerIsPlayer()
;                     UDmain.Print("You succesfully pushed " + getDeviceName() + " deeper in",1)
                    
;                     if currentVal == 0
;                         libs.notify("The eggs hang mostly outside your vagina like a loose sack, their alien membrane smacking against your thighs.", messagebox = true)
;                     elseif currentVal == 1
;                         libs.notify("More eggs rest firmly within you, but the rest dangle obscenely outside. The way they brush against your thighs and leave them slimy is getting on your nerves. It wouldn't hurt to push them in a bit further, right?", messagebox = true)
;                     ; elseif currentVal == 1
;                     ;     libs.notify("Your plug is a bit inflated but doesn't stimulate you too much - just enough to make you long for more. You could give the pump a healthy squeeze!", messagebox = true)
;                     elseif currentVal == 2
;                         libs.notify("Half the egg cluster is inside you. You feel completely full. The slimy eggs softly shift and settle, not unpleasantly. You feel you should be revulsed, but you're not. You get a twinge of pleasure as you imagine pushing them in further.", messagebox = true)
;                     ; elseif currentVal == 2
;                     ;     libs.notify("Your plug is inflated. Its gentle movements inside you please you without causing you discomfort. You are getting more horny and wonder if you should inflate it even more?", messagebox = true)
;                     elseif currentVal == 3
;                         libs.notify("The cluster of eggs within your quim press against your insides. They remind you of their presence every time you move, shifting around and kneading every sensitive spot.", messagebox = true)
;                         ; elseif currentVal == 3
;                     ;     libs.notify("Your fairly inflated plug is impossible to ignore as it moves around inside of you, constantly pleasing you and making you more horny as you already are.", messagebox = true)
;                     elseif currentVal == 4
;                         libs.notify("You cannot possibly fit any more eggs within you. They press your vagina apart and stretch it to its breaking point. With every step, you're filled with pain and blinding pleasure - you struggle holding back your squeals. Of delight?", messagebox = true)
;                     ; elseif currentVal == 4
;                     ;     libs.notify("Your plug is almost inflated to capacity. You cannot move at all without shifting it around inside of you, making you squeal in an odd sensation of pleasurable pain.", messagebox = true)
;                     else
;                         libs.notify("The eggs fill you completely, as solid as a rivet. You don't know how you haven't burst, but the pain makes you wonder if maybe you had. Your guts feel like a furnace of searing agony - but that's nothing compared to the throbbing ecstasy spreading from your crotch.", messagebox = true)
;                     ; else
;                     ;     libs.notify("Your plug is fully inflated and almost bursting inside you. It's causing you more discomfort than anything. But no matter what - you won't be able to remove it from your body anytime soon.", messagebox = true)         
;                     EndIf    
;                 elseif WearerIsFollower()
;                     UDmain.Print(getWearerName() + "s " + getDeviceName() + " inflated!",2)
;                 endif
;             endif
;         endif
;     parent.inflate(false, iInflateNum)
; EndFunction

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
    if iInRange(getPlugInflateLevel(),1,4)
        return True
    else
        if WearerIsPlayer()
            debug.MessageBox("Plug is already deflated")
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " is already mostly pushed out",1)
        endif
        return False
    endif
    if WearerIsPlayer()
        debug.MessageBox("Plug is too big to be deflated at the moment!")
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "s "+ getDeviceName() + " are too far in to be pushed out at this moment!",1)
    endif
    return False
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

bool Function canBeActivated()
    return parent.canBeActivated()
EndFunction

Function updateWidget(bool force = false)
    parent.updateWidget(force)
EndFunction

Function onUpdatePost(float timePassed)
    parent.onUpdatePost(timePassed)
EndFunction

Function activateDevice()
    parent.activateDevice()
EndFunction

bool Function OnCritDevicePre()
    return parent.OnCritDevicePre()
EndFunction

Function OnCritFailure()
    parent.OnCritFailure()
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