Scriptname UD_CustomSLPLivingArmor_RenderScript extends UD_CustomVibratorBase_RenderScript

SLP_fcts_parasites Property fctParasites Auto

;MUST FILL IN CUSTOM SOUND IN ESP
;MUST FILL IN AS CHAOS

Function OnEquippedPost(actor akActor)
	libs.Log("RestraintScript OnEquippedPost BodyHarness")

	fctParasites.applyParasiteByString(akActor, "LivingArmor" )
EndFunction

Function OnVibrationStart()
	libs.NotifyPlayer("The oozing tendrils glued to your body begin to softly suck at your skin.")
	libs.SexlabMoan(getWearer())
	parent.OnVibrationStart()
EndFunction