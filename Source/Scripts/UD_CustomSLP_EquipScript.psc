Scriptname UD_CustomSLP_EquipScript extends UD_CustomDevice_EquipScript

import UD_Native
import UnforgivingDevicesMain

SLP_fcts_parasites Property fctParasites  Auto

function _setupFaceHuggerQuest()
	deviceQuest.SetObjectiveCompleted(00)
if libs.PlayerRef.WornHasKeyword(zad_DeviousPlug)
	deviceQuest.setStage(20)
	deviceQuest.SetObjectivedisplayed(20)
else
	deviceQuest.setStage(10)
	deviceQuest.SetObjectivedisplayed(10)
Endif
EndFunction


Function _resetFaceHuggerQuest()
  deviceQuest.SetObjectiveDisplayed(10,false)
  deviceQuest.SetObjectiveCompleted(10,false)
  deviceQuest.SetObjectiveDisplayed(20,false)
  deviceQuest.SetObjectiveCompleted(20,false)
  deviceQuest.SetObjectiveDisplayed(30,false)
  deviceQuest.SetObjectiveCompleted(30,false)
  deviceQuest.SetObjectiveDisplayed(80,false)
  deviceQuest.SetObjectiveCompleted(80,false)
  deviceQuest.SetObjectiveDisplayed(100,false)
  deviceQuest.SetObjectiveCompleted(100,false)
  deviceQuest.Reset()
EndFunction

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
    if silent && !IsPlayer(akActor)
        return 0
    EndIf    
    
    if akActor.WornHasKeyword(libs.zad_DeviousBelt)
        if deviceRendered.HasKeyword(libs.zad_DeviousPlugAnal) && akActor.WornHasKeyword(libs.zad_permitAnal)
            ; open belts allow putting in anal plugs.
            return 0
        EndIf
        if IsPlayer(akActor) && !silent
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

Function EquipPreBarnacles(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyActor("Glowing spores attach themselves to your skin and start throbbing as they exude sweet fluids.", akActor, true)
		Else
			libs.NotifyActor(GetMessageName(akActor) +" yelps as the glowing spores spread across her body.", akActor, true)
			
		EndIf
	EndIf
EndFunction

int Function EquipFilterBarnacles(actor akActor, bool silent=false)
	ActorBase 	pActorBase  
	if akActor == none
		akActor = libs.PlayerRef
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
			libs.NotifyActor("The spores refuse to attach themselves around a male.", akActor, true)
			return 2
		Endif
	Endif
	return 0
EndFunction

Function EquipPreChaurusQueenArmor(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyActor("The Seed wraps you in a protective layer of woven mucus and chitin.", akActor, true)
		EndIf
	EndIf
EndFunction

Function EquipPreChaurusQueenBody(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyActor("The Seed's protection turns into thick scales and heavy spikes.", akActor, true)
		EndIf
	EndIf
EndFunction

Function EquipPreChaurusQueenSkin(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyActor("The Seed digs roots into your skin, and invades your breasts. New glands force their way in among the old, and start exuding a sweet and sticky liquid.", akActor, true)
		EndIf
	EndIf
EndFunction

int Function EquipFilterChaurusQueenArmor(actor akActor, bool silent=false)
	ActorBase 	pActorBase  
	if akActor == none
		akActor = libs.PlayerRef
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
			; libs.NotifyActor("The spores refuse to attach themselves around a male.", akActor, true)
			return 2
		Endif
	Endif
	return 0
EndFunction

Function EquipPreFaceHugger(actor akActor, bool silent=false)
	libs.StoreExposureRate(akActor)
	string msg = ""
	if IsPlayer(akActor)
		; Quest setup
		if deviceQuest.GetStage() >= 10; && menuDisable==false)
			libs.Log("Resetting... (Stage>=10)")
			_resetFaceHuggerQuest()
		EndIf
		_setupFaceHuggerQuest()
		; Dialogue
		if Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desire")
			msg = "With serence confidence, you bring the squirming critter closer to your crotch."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Horny")
			msg = "With more confidence than foresight you press the squirming critter between your legs."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desperate")
			msg = "No longer fighting against your urges, you coax the squirmy critter to wrap around your waist."
		else
			msg = "In blind and feverish madness, you press and rub yourself against the squirmy critter. Its legs wrap around your waist and click shut."
		endif
	Else
		msg = akActor.GetLeveledActorBase().GetName() + " moans as you let the critter wrap itself around her hips."
	EndIf
	if !silent
		libs.NotifyActor(msg, akActor, true)
	EndIf
EndFunction

Function EquipPreChaurusQueenGag(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyPlayer("Thick scales quickly form a protective layer around your face.", true)
		EndIf
	EndIf
EndFunction

Function EquipPreChaurusQueenVag(actor akActor, bool silent=false)
	string msg = ""
	if IsPlayer(akActor)
		if Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desire")
			msg = "The Seed in your womb stirs and fills your vagina snugly, leaving your lips slightly parted and wet."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Horny")
			msg = "The Seed in your womb extends past your vagina and keeps your lips spread wide."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desperate")
			msg = "The Seed in your womb spreads your vagina wide open."
		else
			msg = "You can feel the Seed in your womb fill your vagina and squirm between your thighs."
		endif
	EndIf
	if !silent
		libs.NotifyActor(msg, akActor, true)
	EndIf
EndFunction

int Function EquipFilterChaurusQueenVag(actor akActor, bool silent=false)
	; FTM optimization
	if silent && !IsPlayer(akActor)
		return 2
	EndIf
	if !silent && !IsPlayer(akActor)
		libs.NotifyActor("Without the Seed Stone inside them, the parasite rejects " + akActor.GetLeveledActorBase().GetName() + " as a host.", akActor, true)
		return 2
	EndIf
	if akActor.WornHasKeyword(libs.zad_DeviousBelt)
		if akActor == libs.PlayerRef && !silent
			libs.NotifyActor("You can feel the Seed churn and push inside you, but the belt you are wearing is keeping it deep inside your womb.", akActor, true)
		EndIf
		return 2
	Endif
	if akActor.WornHasKeyword(libs.zad_DeviousPlug)
		if akActor == libs.PlayerRef && !silent
			libs.NotifyActor("You can feel the Seed churn and push inside you, but your holes are already full.", akActor, true)
		EndIf
		return 2
	Endif
	return 0
EndFunction

;===
;TWEAK THE TEXT ON THE BELOW 4 ITEMS
;===

Function EquipPreChaurusWorm(actor akActor, bool silent=false)
	string msg = ""
	float fArousal = UDmain.UDOM.getActorArousal(akActor)
	if IsPlayer(akActor)
		if fArousal < libs.ArousalThreshold("Desire")
			msg = "The worm fits snugly inside your hole, spreading a wave of pleasure deep into your belly."
		elseif fArousal < libs.ArousalThreshold("Horny")
			msg = "You carefully let the worm crawl its way into your opening, your lust growing with every inch it slides in."
		elseif fArousal < libs.ArousalThreshold("Desperate")
			msg = "You eagerly spread your lips to let the worm ease its way deep into your quivering hole, making you squeal with delight in the resulting waves of pleasure."
		else
			msg = "Barely in control of control your own body, you thrust the worm almost forcefully into your wet opening."
		endif
	else
		msg = getactorname(akActor) + " shudders as you let the worm crawl deep inside her."
	EndIf
	if !silent
		libs.NotifyActor(msg, akActor, true)
	EndIf
EndFunction

int Function EquipFilterChaurusWorm(actor akActor, bool silent=false)
	; FTM optimization
	bool bIsPlayer = IsPlayer(akActor)
	string sMsg = ""
	if silent && !bIsPlayer
		return 0
	EndIf
	if akActor.WornHasKeyword(zad_DeviousBelt)
		if !silent
			if !bIsPlayer
				sMsg = "Try as you might, the belt you are wearing prevents you from inserting the slimy worm inside you."
			Else
				sMsg = "The belt " + GetActorName(akActor) + " is wearing prevents you from inserting the slimy worm."
			EndIf
			libs.NotifyActor(sMsg, akActor, true)
		endif
		return 2
	Endif
	return 0
EndFunction

Function EquipPreSprigganBody(actor akActor, bool silent=false)
	string sMsg = ""
	if !silent
		if IsPlayer(akActor)
			sMsg = "Fungal growths quickly spread around your skin."
		Else
			sMsg = getActorName(akActor) +" cries out as fungal growths spread quickly."
		EndIf
		libs.NotifyActor(sMsg, akActor, true)
	EndIf
EndFunction

Function EquipPreSprigganGag(actor akActor, bool silent=false)
	if !silent
		if IsPlayer(akActor)
			libs.NotifyPlayer("Thick growths quickly form a protective layer around your face.", true)
		EndIf
	EndIf
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
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteBarnacles)
		EquipPreBarnacles(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenArmor)
		EquipPreChaurusQueenArmor(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenBody)
		EquipPreChaurusQueenBody(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenSkin)
		EquipPreChaurusQueenSkin(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenGag)
		EquipPreChaurusQueenGag(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenVag)
		EquipPreChaurusQueenVag(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteFaceHugger)
		EquipPreFaceHugger(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusWorm) || deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusWormVag)
		EquipPreChaurusWorm(akActor, silent)
	elseif deviceInventory.HasKeywordString("_SLP_ParasiteSprigganGag")
		EquipPreSprigganGag(akActor, silent)
	elseif deviceInventory.HasKeywordString("_SLP_ParasiteSprigganBody")
		EquipPreSprigganBody(akActor, silent)
    endif
    Parent.OnEquippedPre(akActor, true)
EndFunction

int Function OnEquippedFilter(actor akActor, bool silent=false)
    if deviceInventory.haskeyword(fctParasites._SLP_ParasiteTentacleMonster) || deviceInventory.haskeyword(fctParasites._SLP_ParasiteLivingArmor)
        return EquipFilterTentacle(akActor, silent)
	ElseIf deviceInventory.HasKeyword(fctParasites._SLP_ParasiteSpiderEgg)
		EquipFilterSpiderEgg(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteBarnacles)
		EquipFilterBarnacles(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenArmor) || deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenBody) || deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenSkin)
		EquipFilterChaurusQueenArmor(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusQueenVag)
		EquipFilterChaurusQueenVag(akActor, silent)
	elseif deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusWorm) || deviceInventory.HasKeyword(fctParasites._SLP_ParasiteChaurusWormVag)
		EquipFilterChaurusWorm(akActor, silent)
    endif
    return Parent.OnEquippedFilter(akActor, silent)
EndFunction

; Do Post in its own file