Scriptname UD_CustomSLPChaurusQueenArmor_RS extends UD_CustomHarness_RenderScript

; remove locks

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenArmor" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenArmor")
EndFunction 