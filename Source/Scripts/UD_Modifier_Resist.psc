ScriptName UD_Modifier_Resist extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if (akModDevice == akMinigameDevice)
        bool bIsPlayer = akMinigameDevice.WearerIsPlayer()
        string sDeviceName = akMinigameDevice.getDeviceName()

        if UDMain.TraceAllowed()
            UDMain.Log("Resisting device activation of : " + akMinigameDevice.getDeviceHeader())
        endif
        ; We only activate if the actor can't sneak their way past the device
        if RandomInt(1, 75) * Multiplier > _getStealthSkill(akMinigameDevice.getWearer())
            if bIsPlayer
                UDmain.Print(sDeviceName + " notices you struggling against it!")
            endif
            akMinigameDevice.activateDevice()
        ElseIf (bIsPlayer)
            UDmain.Print("You stealthily begin to remove " + sDeviceName)
        endif
    endif
    parent.MinigameStarted(akModDevice, akMinigameDevice, aiDataStr, akForm1, akForm2, akForm3)
EndFunction

float Function _getStealthSkill(Actor akActor)
    return akActor.GetActorValue("Sneak") / 2 + akActor.GetActorValue("Lockpicking")
EndFunction