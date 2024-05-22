Scriptname UD_CustomSLP_EquipScript extends UD_CustomDevice_EquipScript

import UD_Native
import UnforgivingDevicesMain

SLP_fcts_parasites Property fctParasites  Auto

Function EquipPreTentacle(actor akActor, bool silent=false)
    if !silent
		if IsPlayer(akActor)
			libs.NotifyActor("The slimy tentacles wrap themselves tightly around your body. A throbbing appendage forces its way between your legs.", akActor, true)
		Else
			libs.NotifyActor(GetMessageName(akActor) +" yelps as the tentacles wraps around her body.", akActor, true)
			
		EndIf
	EndIf
EndFunction

int Function EquipFilterTentacle(actor akActor, bool silent=false)
    ActorBase 	pActorBase  
	if akActor == none
		akActor == UDmain.Player
	EndIf
	pActorBase = akActor.GetActorBase()

	if ! akActor.IsEquipped(deviceRendered)
		if akActor!=libs.PlayerRef && ShouldEquipSilently(akActor)
			libs.Log("Avoiding FTM duplication bug (Harness).")
			return 0
		EndIf
		if akActor.WornHasKeyword(libs.zad_DeviousCorset)
			MultipleItemFailMessage("Corset")
			return 2
		Endif
		if (pActorBase.GetSex()==0)
			libs.NotifyActor("The creature refuses to wrap itself around a male.", akActor, true)
			return 2
		Endif
		if akActor.WornHasKeyword(libs.zad_DeviousBelt)
			libs.NotifyActor("The creature slips through and around the chastity belt and is locked safely in place", akActor, true)
		endif
	Endif
	return 0
EndFunction

Function EquipPreSpiderDong(actor akActor, bool silent=false)
	string sMsg = ""
	int loc_arousal = libs.Aroused.GetActorExposure(akActor)
	if IsPlayer(akActor)
		if loc_arousal < libs.ArousalThreshold("Desire")
			sMsg = "You force the spider penis into your unwilling opening. Its sharp barbs dig into your insides. It feels cold and foreign."
		elseif loc_arousal < libs.ArousalThreshold("Horny")
			sMsg = "You find your moist cavity with the penis's sharp tip and slowly slide it in, fighting shudders of pain and pleasure."
		elseif loc_arousal < libs.ArousalThreshold("Desperate")
			sMsg = "You push the penis into your quivering cunt. You feel nothing but ecstasy as your vagina contracts and swallows it whole."
		else
			sMsg = "Barely in control, you jam the penis into your steamy opening. You almost collapse under waves of pleasure as barbs rend your insides."
		endif
	else
		sMsg = akActor.GetLeveledActorBase().GetName() + " shudders and recoils as you stuff the spider penis into her."
	EndIf
	if !silent
		libs.NotifyActor(sMsg, akActor, true)
	EndIf
Endfunction

Function EquipPreSpiderEgg(actor akActor, bool silent=false)
	string sMsg = ""
	int loc_arousal = libs.Aroused.GetActorExposure(akActor)
	if IsPlayer(akActor)
		if loc_arousal < libs.ArousalThreshold("Desire")
			sMsg = "The cold, slimy eggs lubricate your unwilling hole as you push them in one by one. Their chilly presence sends a shiver up your spine."
		elseif loc_arousal < libs.ArousalThreshold("Horny")
			sMsg = "You slide a couple of eggs into your warm quim at a time. Some disappear deep within you, pleasantly stretching your insides. You feel snug and full."
		elseif loc_arousal < libs.ArousalThreshold("Desperate")
			sMsg = "You spread your thighs wide and thrust the eggs into your sloppy, exposed opening. Your insides contract in extasy around the cold eggs and hold them like a vice."
		else
			sMsg = "Your body moves on its own. You slam the egg cluster all at once into your burning, throbbing cunt. A wave of cold and blinding pleasure courses through your guts and ribs."
		endif
	else
		sMsg = GetActorName(akActor) + "shudders as you push the eggs deep inside her."
	endif
	if !silent
		libs.NotifyActor(sMsg, akActor, true)
	EndIf
EndFunction

Int Function EquipFilterSpiderEgg(actor akActor, bool silent=false)
	; FTM optimization
    if silent && akActor != libs.PlayerRef
        return 0
    EndIf    
    
    if akActor.WornHasKeyword(libs.zad_DeviousBelt)
        if deviceRendered.HasKeyword(libs.zad_DeviousPlugAnal) && akActor.WornHasKeyword(libs.zad_permitAnal)
            ; open belts allow putting in anal plugs.
            return 0
        EndIf
        if akActor == libs.PlayerRef && !silent
            libs.NotifyActor("Fortunately, the belt you are wearing prevents you from filling yourself with spider eggs.", akActor, true)
        ElseIf  !silent
            libs.NotifyActor("The belt " + GetActorName(akActor) + " is wearing makes it impossible to fill her with spider eggs.", akActor, true)
        EndIf
        if !silent
            return 2
        Else
            return 0
        EndIf
    Endif
    return 0
EndFunction

Function OnEquippedPre(actor akActor, bool silent=false)
    if deviceInventory.haskeyword(fctParasites._SLP_ParasiteTentacleMonster) || deviceInventory.haskeyword(fctParasites._SLP_ParasiteLivingArmor)
        EquipPreTentacle(akActor, silent)
		;return ; No plug equip
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteSpiderPenis)
		EquipPreSpiderDong(akActor, silent)
		;return ; We don't want to do the plug equip
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteSpiderEgg)
		EquipPreSpiderEgg(akActor, silent)
    endif
    Parent.OnEquippedPre(akActor, true)
EndFunction

int Function OnEquippedFilter(actor akActor, bool silent=false)
    if deviceInventory.haskeyword(fctParasites._SLP_ParasiteTentacleMonster) || deviceInventory.haskeyword(fctParasites._SLP_ParasiteLivingArmor)
        return EquipFilterTentacle(akActor, silent)
	ElseIf deviceInventory.HasKeyword(fctParasites._SLP_ParasiteSpiderEgg)
		EquipFilterSpiderEgg(akActor, silent)
    endif
    return Parent.OnEquippedFilter(akActor, silent)
EndFunction

; Do Post in its own file