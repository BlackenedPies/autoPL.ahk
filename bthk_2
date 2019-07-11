#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
#SingleInstance force
#Hotstring r
#Hotstring EndChars `n `t
#InputLevel, 1

if not A_IsAdmin
{
run *RunAs "C:\Users\Shane Wray\OneDrive\AHK\bThk_2.ahk"
exitapp
}

~^!r::Reload

;postmessage
PostMessage(Receiver, Message) {
	oldTMM := A_TitleMatchMode, oldDHW := A_DetectHiddenWindows
	SetTitleMatchMode, 3
	DetectHiddenWindows, on
	PostMessage, 0x1001,%Message%,,, %Receiver% ahk_class AutoHotkeyGUI
	SetTitleMatchMode, %oldTMM%
	DetectHiddenWindows, %oldDHW%
}


slpfunc:
if (A_ComputerName = "BTHP")
{
gosub safeslp
return
}
else 
traytip,,bye bye,1
sleep, 1000
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return

safeslp:
traytip , , bye! , 1,
run cmd
winwait cmd.exe
sendraw diskpart
send {enter}
sendraw select disk 2
send {enter}
sendraw offline disk
send {enter}
sendraw exit
send {enter}
sendraw exit
send {enter}
sleep 1000
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return
*/

printscreen & 0::
gosub slpfunc
return

printscreen & numpad1::
sleep, ‭1800000‬
gosub slpfunc
return

printscreen & numpad2::
sleep, 3600000
gosub slpfunc
return

printscreen & numpad4::
sleep, 7200000
gosub slpfunc
return

printscreen & numpad3::
sleep, 5400000
gosub slpfunc
return

printscreen & numpad0::
inputbox, slpt, Slp Timer
if errorlevel = 1
return
else{
spt:=slpt*60000
sleep, %spt%
gosub slpfunc
}
return
