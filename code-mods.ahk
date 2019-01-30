SendMode Input
SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance force
#Hotstring r
#Hotstring EndChars `n `t
~^!r::Reload

Printscreen & p::
exitapp
return
~Pause::
exitapp
return

^capslock::capslock
!capslock::end

+capslock::
send ^{left}
return

CapsLock::
send ^{right}
return

/*
;credit to SpaceCadetShift - https://github.com/Wegerich/SpaceCadetShift/blob/master/SpaceCadetShift.ahk
~RShift::
~LShift::
	;Configuration
	AcceptableMouseMovementPixels := 30 ;Normally around 30. Set to 10000 to disable mouse checking. Can be set very low because mouse should barely move while typing.
	LongestAcceptableShiftTapTime := 1500 ;Normally around 1500. Set to 10000 to type bracket no matter how long shift is held
	
	
	;Mouse clicks are ignored by A_PriorKey when shift is pressed
	;Therefore an alternative method must be used to detect shift-click select as no "keys" are pressed
	;This will be done by checking mouse position before and after {Shift Up} to see if something might be highlighted
	;Tooltip %A_PriorKey%
	MouseGetPos, startingXpos, startingYpos 
	KeyWait Shift
	;Tooltip "Shift Released"
	;Sleep 100
	MouseGetPos, endingXpos, endingYpos 
	xPosChange := Abs(startingXpos - endingXpos)
	yPosChange := Abs(startingYpos - endingYpos)
	MousePosChangeOverall := xPosChange + yPosChange
	;Tooltip %MousePosChangeOverall%
	;Sleep 100	
	

	
	If ( A_TimeSincePriorHotkey < LongestAcceptableShiftTapTime and InStr(A_PriorKey,"Shift") and MousePosChangeOverall < AcceptableMouseMovementPixels  )
		   SendRaw, % InStr(A_ThisHotkey,"LShift") ? "(" : ")" 
	
Return	
	;Debugging section
	ShiftWasLastKey := InStr(A_PriorKey,"Shift")
	IsTapTimeAcceptable := A_TimeSincePriorHotkey < LongestAcceptableShiftTapTime
	IsMouseMoveAcceptable := MousePosChangeOverall < AcceptableMouseMovementPixels
	Tooltip,
	(LTrim 
		"Taptime" %IsTapTimeAcceptable% 
		"Shiftpressed" %ShiftWasLastKey% 
		"Prior" %A_PriorKey% & %A_TimeSincePriorHotkey%
		"Mouse" %IsMouseMoveAcceptable% 
	)
	Sleep 1500	
	Tooltip
Return
*/

;credit to SpaceCadetShift - https://github.com/Wegerich/SpaceCadetShift/blob/master/SpaceCadetShift.ahk
~RControl::
~LControl::
	;Configuration
	AcceptableMouseMovementPixels := 30 ;Normally around 30. Set to 10000 to disable mouse checking. Can be set very low because mouse should barely move while typing.
	LongestAcceptableControltTapTime := 1500 ;Normally around 1500. Set to 10000 to type bracket no matter how long shift is held
	;Mouse clicks are ignored by A_PriorKey when shift is pressed
	;Therefore an alternative method must be used to detect shift-click select as no "keys" are pressed
	;This will be done by checking mouse position before and after {Shift Up} to see if something might be highlighted
	;Tooltip %A_PriorKey%
	MouseGetPos, startingXpos, startingYpos 
	KeyWait Control
	;Tooltip "Control Released"
	;Sleep 100
	MouseGetPos, endingXpos, endingYpos 
	xPosChange := Abs(startingXpos - endingXpos)
	yPosChange := Abs(startingYpos - endingYpos)
	MousePosChangeOverall := xPosChange + yPosChange
	;Tooltip %MousePosChangeOverall%
	;Sleep 100	
	
	If ( A_TimeSincePriorHotkey < LongestAcceptableControlTapTime and InStr(A_PriorKey,"Control") and MousePosChangeOverall < AcceptableMouseMovementPixels  )
		   SendRaw, % InStr(A_ThisHotkey,"LControl") ? "{" : "}" 
	
Return	
	;Debugging section
	ControlWasLastKey := InStr(A_PriorKey,"LControl")
	IsTapTimeAcceptable := A_TimeSincePriorHotkey < LongestAcceptableControlTapTime
	IsMouseMoveAcceptable := MousePosChangeOverall < AcceptableMouseMovementPixels
	Tooltip,
	(LTrim 
		"Taptime" %IsTapTimeAcceptable% 
		"Controlpressed" %ControlWasLastKey% 
		"Prior" %A_PriorKey% & %A_TimeSincePriorHotkey%
		"Mouse" %IsMouseMoveAcceptable% 
	)
	Sleep 1500	
	Tooltip
Return
