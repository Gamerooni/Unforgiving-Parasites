scriptname UD_CustomSLPSprigganBoots_RS extends UD_CustomBoots_RenderScript

import UD_native

SLP_fcts_parasites Property fctParasites  Auto

string SLPDeviceName = "SprigganRootFeet"

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Spriggan Feet"
EndFunction

Function InitPostPost()
    parent.InitPostPost()
    fctParasites.applyParasiteByString(getWearer(), SLPDeviceName)
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    fctParasites.cureParasiteByString(akActor, SLPDeviceName)
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
float Function getAccesibility()
    parent.getAccesibility()
EndFunction