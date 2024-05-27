Scriptname UD_CustomSLPBarnacles_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites  Auto

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(GetWearer(), "Barnacles" )
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.OnRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(getWearer(), "Barnacles")
EndFunction