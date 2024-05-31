Scriptname UD_CustomSLPFaceHugger_RS extends UD_CustomInflatablePlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

; rework tryParasiteNextStage in SLP_fcts_parasites to use vib and inflation events instead

; do the same with facehuggergag

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), "FaceHugger" )
EndFunction