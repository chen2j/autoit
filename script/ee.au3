#include <GUIConstantsEx.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("����", 200, 100, 200, 200)
$Button = GUICtrlCreateButton("�ر�", 162, 128, 40, 20)
_SetWindowPos($Form1, 200, 200) ;�������ô���ʼ������ǰ��
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
 $nMsg = GUIGetMsg()
 Switch $nMsg
  Case $GUI_EVENT_CLOSE, $Button
   Exit

 EndSwitch
WEnd

Func _SetWindowPos($hWnd, $x, $y) ;ʹ��API�����屣����ǰ
 Local $cX, $cY
 Dim $hWndInsertAfter = -1
 Dim $wFlags = 1
 DllCall("user32.dll", "long", "SetWindowPos", "long", $hWnd, "long", $hWndInsertAfter, "long", $x, _
   "long", $y, "long", $cX, "long", $cY, "long", $wFlags)
EndFunc   ;==>_SetWindowPos
