Scriptname UD_CustomSLPTentacleMonster_RS extends UD_CustomPlug_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS

Function OnEquippedPost(actor akActor)
	libs.Log("RestraintScript OnEquippedPost BodyHarness")

	fctParasites.applyParasiteByString(akActor, "TentacleMonster" )
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The tentacles writhe inside and outside; your skin tingles beneath their streaks of slime.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction