Scriptname UD_CustomSLPChaurusQueenGag_RS extends UD_CustomGag_RenderScript


SLP_fcts_parasites Property fctParasites  Auto

function InitInitPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenGag" )
    parent.InitPostPost()
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenSkin")
EndFunction 