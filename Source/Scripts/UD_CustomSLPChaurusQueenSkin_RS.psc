Scriptname UD_CustomSLPChaurusQueenSkin_RS extends UD_CustomHarness_RenderScript

; remove locks and keys

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenSkin" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenSkin")
EndFunction 