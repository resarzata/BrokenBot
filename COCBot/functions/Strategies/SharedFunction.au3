;Function needed by all strategies


;Check Out of Sync or Disconnection, if detected, bump speedBump by 0.5 seconds
Func ChkDisconnection($disconnected = False)
	_CaptureRegion()
	Local $dummyX = 0
	Local $dummyY = 0
	If _ImageSearch(@ScriptDir & "\images\Client.bmp", 1, $dummyX, $dummyY, 50) = 1 Then
		If $dummyX > 290 And $dummyX < 310 And $dummyY > 325 And $dummyY < 340 Then
			$disconnected = True
			$speedBump += 500
			If $speedBump > 5000 Then
				$speedBump = 5000
				SetLog(GetLangText("msgOOSAlreadySlow"), $COLOR_RED)
			Else
				SetLog(GetLangText("msgOOSSlowingSearch"), $COLOR_RED)
			EndIf
		EndIf
	EndIf
	If _ImageSearch(@ScriptDir & "\images\Lost.bmp", 1, $dummyX, $dummyY, 50) = 1 Then
		If $dummyX > 320 and $dummyX < 350 and $dummyY > 330 and $dummyY < 350 Then
			$disconnected = True
			$speedBump += 500
			If $speedBump > 5000 Then
				$speedBump=5000
				SetLog(GetLangText("msgLCAlreadySlow"), $COLOR_RED)
			Else
				SetLog(GetLangText("msgLCSlowingSearch"), $COLOR_RED)
			EndIf
		EndIf
	EndIf

	If $disconnected = True Then
		;increase disconnect counts
		GUICtrlSetData($lblresultsearchdisconnected, GUICtrlRead($lblresultsearchdisconnected) + 1)
		If $DebugMode = 1 Then _GDIPlus_ImageSaveToFile($hBitmap, $dirDebug & "DisConnt-" & @HOUR & @MIN & @SEC & ".png")
		If $PushBulletEnabled = 1 Then

			Local $iCount = _FileCountLines($sLogPath)
			Local $myLines = ""
			Local $i
			For $i = 1 to 5
				$myLines = $myLines &  FileReadLine($sLogPath, ($iCount - 5 + $i)) & "\n"
			Next
			_Push("Disconnected", "Your bot got disconnected while searching for enemy, total disconnections:" & GUICtrlRead($lblresultsearchdisconnected) & "\n" & _
				"Last 5 lines of log:\n" & $myLines)
		EndIf
	EndIf
	Return $disconnected
EndFunc