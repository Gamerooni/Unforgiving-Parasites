Scriptname UD_CustomSLPChaurusQueenBody_RS extends UD_CustomHarness_RenderScript

; remove locks (probably)

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenBody" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenBody")
EndFunction 