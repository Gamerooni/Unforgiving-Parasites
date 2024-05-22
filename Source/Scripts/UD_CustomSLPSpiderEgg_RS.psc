Scriptname UD_CustomSLPSpiderEgg_RS extends UD_CustomInflatablePlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

; Possibly sentient?
; Add custom sounds

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "SpiderEgg" )
EndFunction