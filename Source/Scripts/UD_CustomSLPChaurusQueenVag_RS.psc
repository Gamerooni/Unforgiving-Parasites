Scriptname UD_CustomSLPChaurusQueenVag_RS extends UD_CustomInflatablePlug_RenderScript

; needs more work on minigame etc.
; needs proper inflation events
; needs new menu for inflation stuff

import UD_Native

SLP_fcts_parasites Property fctParasites  Auto

float Function _getArousalMultiplier()
    int iDexterity = 20 + (libs.PlayerRef.GetActorValue("Pickpocket") as Int) / 5
    return fRange(1.0 - (libs.Aroused.GetActorArousal(GetWearer()) - iDexterity) / 70.0, 0.0, 1.0)
EndFunction

int startMinigameArousal = 0
string Function _getArousalFailMessage()
    int iArousal = startMinigameArousal;libs.Aroused.GetActorExposure(getWearer())
    string msg = ""
    if (iArousal < libs.ArousalThreshold("Desire"))
        msg = "Your fingers slip. The seed extends and throbs in response, and your juices gush from the stimulation."
    elseif (iArousal < libs.ArousalThreshold("Horny"))
        msg = "As you push and tug, the Seed - coated in your lubrication - slips away and grows thicker. Your lips are spread further apart."
    elseif (iArousal < libs.ArousalThreshold("Desperate"))
        msg = "You reach into your sopping-wet opening and pull at the slimy worm. It inflates like a rivet inside your whole vagina; it's impossible to push on."
    Else
        msg = "The moment your hand tried to push the Seed back in, you own eager vagina clenches around the worm, with streams of your slimy fluid shooting out from the pressure."
    endif
    return msg
EndFunction

bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    return forceOutPlugMinigame()
EndFunction

Function OnMinigameStart()
    startMinigameArousal = libs.Aroused.GetActorExposure(getWearer())
    parent.OnMinigameStart()
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenVag" )
EndFunction

; becomes less accessible as wearer is more aroused 
float Function getAccesibility()
    return _getArousalMultiplier() * parent.getAccesibility()
EndFunction

Function OnDeviceRemovePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor)
EndFunction