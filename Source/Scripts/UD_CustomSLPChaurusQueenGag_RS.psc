Scriptname UD_CustomSLPChaurusQueenGag_RS extends UD_CustomGag_RenderScript

; fix keys and locks (i.e. remove them)

SLP_fcts_parasites Property fctParasites  Auto

function InitInitPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "ChaurusQueenGag" )
EndFunction

Function OnRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "ChaurusQueenGag")
EndFunction 