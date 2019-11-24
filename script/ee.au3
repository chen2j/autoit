#include <GUIConstantsEx.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("测试", 200, 100, 200, 200)
$Button = GUICtrlCreateButton("关闭", 162, 128, 40, 20)
_SetWindowPos($Form1, 200, 200) ;这里设置窗口始终在最前端
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
 $nMsg = GUIGetMsg()
 Switch $nMsg
  Case $GUI_EVENT_CLOSE, $Button
   Exit

 EndSwitch
WEnd

Func _SetWindowPos($hWnd, $x, $y) ;使用API将窗体保持最前
 Local $cX, $cY
 Dim $hWndInsertAfter = -1
 Dim $wFlags = 1
 DllCall("user32.dll", "long", "SetWindowPos", "long", $hWnd, "long", $hWndInsertAfter, "long", $x, _
   "long", $y, "long", $cX, "long", $cY, "long", $wFlags)
EndFunc   ;==>_SetWindowPos
