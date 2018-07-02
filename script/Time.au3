#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Icon=时间管理.exe
#PRE_Outfile=时间管理.exe
#PRE_Compression=4
#PRE_UseX64=n
#PRE_Res_Comment=一个小软件，纯绿色无广告。可以设置开机自动启动，并具有开机自动隐藏和记忆是否自动启动定时关机功能。
#PRE_Res_Fileversion=1.5.0.74
#PRE_Res_Fileversion_AutoIncrement=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#region ACN预处理程序参数(常用参数)
;#PRE_Res_Field=AutoIt Version|%AutoItVer%		;自定义资源段
;#PRE_Run_Tidy=                   				;脚本整理
;#PRE_Run_Obfuscator=      						;代码迷惑
;#PRE_Run_AU3Check= 							;语法检查
;#PRE_Run_Before= 								;运行前
;#PRE_Run_After=								;运行后
;#PRE_UseX64=n									;使用64位解释器
;#PRE_Compile_Both								;进行双平台编译
#endregion ACN预处理程序参数(常用参数)
#cs ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
	
	Au3 版本:3.3.9.4
	脚本作者:zaoki.com
	电子邮件:361995143@qq.com
	QQ/TM:361995143
	脚本版本:0.5.0.14
	脚本功能:
	1.定时关机功能。可以自由设置定时关机时间，并具有记忆关机时间功能。可以选择是否开机即选择定时关机。
	2.正点提示功能。具有自动判断是否是工作日和周末功能。整点自动弹出温馨提示气泡。可以记忆是否开启提示功能
	3.开机自动隐藏功能。
	
#ce ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿脚本开始＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <Date.au3>
#include <IE.au3>
#include <File.au3>
#include <INet.au3>
#region ### START Koda GUI section ### Form=c:\users\chen\desktop\form1.kxf
Global $h = 10 ;内容高度可调选项

;-----------ini文件读取
Local $shezhi_guanjihour = IniRead(@ScriptDir & "\" & "time.ini", "默认关机时间", "关机小时", "05")
Local $shezhi_guanjimin = IniRead(@ScriptDir & "\" & "time.ini", "默认关机时间", "关机分钟", "30")
Local $shezhi_dingshiguanji = IniRead(@ScriptDir & "\" & "time.ini", "定时关机", "设置", "1")
Local $shezhi_zhengdiantixing = IniRead(@ScriptDir & "\" & "time.ini", "正点提醒", "设置", "1")
Local $shezhi_tongbu = IniRead(@ScriptDir & "\" & "time.ini", "正点提醒", "内容自动网络同步", "1")
Local $shezhi_rizhi = IniRead(@ScriptDir & "\" & "time.ini", "打开日志", "设置", "0")
;-----------ini文件读取
#OnAutoItStartRegister "hello"  ;启动时的运行内容
OnAutoItExitRegister("tuichu")
;------------------------------------------------------form1
$Form1 = GUICreate("时间管理", 200, 260, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
$Label1 = GUICtrlCreateLabel("现在是", 20, $h + 12, 100, 17)
$Label2 = GUICtrlCreateLabel(_NowCalc(), 68, $h + 12, 150, 17)
;-------------------------------------定时关机GUI
$Group1 = GUICtrlCreateGroup("定时关机", 20, $h + 45, 160, 120)
$hour = GUICtrlCreateCombo("00", 30, $h + 67, 40, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData($hour, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23", $shezhi_guanjihour)
$min = GUICtrlCreateCombo("00", 110, $h + 67, 40, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData($min, "05|10|15|20|25|30|35|40|45|50|55", $shezhi_guanjimin)
$dian = GUICtrlCreateLabel("点", 75, $h + 70, 24, 17)
$fen = GUICtrlCreateLabel("分", 155, $h + 70, 24, 17)
$Button1 = GUICtrlCreateButton("执行", 40, $h + 97, 50, 28)
$Button2 = GUICtrlCreateButton("取消", 110, $h + 97, 50, 28)
$checkbox = GUICtrlCreateCheckbox("启动即开启定时关机", 30, $h + 138, 140, 17)
If $shezhi_dingshiguanji = 1 Then
	GUICtrlSetState($checkbox, $GUI_CHECKED)
	GUICtrlSetState($hour, $GUI_DISABLE)
	GUICtrlSetState($min, $GUI_DISABLE)
	GUICtrlSetState($Button1, $GUI_DISABLE)
	GUICtrlSetState($Button2, $GUI_ENABLE)
	GUISetState(@SW_HIDE, $Form1)
Else
	GUICtrlSetState($checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($hour, $GUI_ENABLE)
	GUICtrlSetState($min, $GUI_ENABLE)
	GUICtrlSetState($Button1, $GUI_ENABLE)
	GUICtrlSetState($Button2, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $Form1)
EndIf
;-------------------------------------定时关机GUI
;-------------------------------------正点播报GUI
$Group2 = GUICtrlCreateGroup("正点提醒", 20, $h + 180, 160, 50)
$Radio1 = GUICtrlCreateRadio("开启", 40, $h + 200, 50, 17)
$Radio2 = GUICtrlCreateRadio("关闭", 110, $h + 200, 50, 17)
If $shezhi_zhengdiantixing = 1 Then
	GUICtrlSetState($Radio1, $GUI_CHECKED)
Else
	GUICtrlSetState($Radio2, $GUI_CHECKED)
EndIf
;~ If $shezhi_dingshiguanji=1 Then GUISetState(@SW_HIDE, $Form1)  ;如果勾选了开机启动定时关机，则启动即隐藏界面。
;------------------------------------------------------form1
#endregion ### END Koda GUI section ###

Local $daojishi, $miaoshu, $dqtime, $Label2, $panduan

Opt("TrayMenuMode", 3) ; 默认托盘菜单项目(脚本已暂停/退出脚本) (Script Paused/Exit) 将不显示.
$kaiji = TrayCreateMenu("开机启动")
$kaijiyes = TrayCreateItem("设置", $kaiji)
$kaijino = TrayCreateItem("取消", $kaiji)
TrayCreateItem("")
$jiaoshi = TrayCreateItem("校准系统时间")
TrayCreateItem("")
$about = TrayCreateItem("关于本软件")
TrayCreateItem("")
$homepage = TrayCreateItem("访问官网")
TrayCreateItem("")
$exititem = TrayCreateItem("退出")
TraySetToolTip("时间管理小程序") ; 鼠标移动到托盘显示的提示。
TraySetClick(8) ;右键才会显示菜单
HotKeySet("^{F1}", "tuichu") ; 设置退出快捷键为 Ctrl+F1。

If $shezhi_tongbu Then
	InetGet("http://autoitzaoki.googlecode.com/svn/trunk/AutoitScript/%e5%ae%9a%e6%97%b6%e5%85%b3%e6%9c%ba/traytip.dat", @ScriptDir & "\traytip.dat", 0, 1) ; 同步网络上的提示内容。
EndIf

While 1 ;-------------------------------------------------------------开始循环
	
	Local $xiaoshi = GUICtrlRead($hour, 1);读取关机小时数。
	Local $fenzhong = GUICtrlRead($min, 1) ;读取关机分钟数。
	;-----------------------------------------------------------------------显示现在时间
	If $dqtime <> _NowCalc() Then
		GUICtrlSetData($Label2, _NowCalc())
		$dqtime = _NowCalc()
	EndIf
	;-----------------------------------------------------------------------结束现在时间
	;-------------------------------------------------------------开始判断是否快关机了
	If GUICtrlGetState($Button1) = 144 Then ;返回值144说明是禁用状态，返回值80说明是可用状态。
		If $fenzhong >= 05 And $fenzhong < 60 Then ;定时关机分钟数在05分到59分之间
			If (@HOUR = $xiaoshi And @MIN = $fenzhong - 5 And @SEC = 0) Then tishi("系统将在5分钟后关闭")
			If (@HOUR = $xiaoshi And @MIN = $fenzhong - 1 And @SEC = 0) Then tishi("系统将在1分钟后关闭")
		ElseIf $fenzhong >= 01 And $fenzhong < 05 Then ;定时关机分钟数在01分到04分之间
			If (@HOUR = $xiaoshi - 1 And @MIN = $fenzhong + 55 And @SEC = 0) Then tishi("系统将在5分钟后关闭")
			If (@HOUR = $xiaoshi And @MIN = $fenzhong - 1 And @SEC = 0) Then tishi("系统将在1分钟后关闭")
		Else ;定时关机分钟数为00
			If (@HOUR = $xiaoshi - 1 And @MIN = $fenzhong + 55 And @SEC = 0) Then tishi("系统将在5分钟后关闭")
			If (@HOUR = $xiaoshi - 1 And @MIN = $fenzhong + 59 And @SEC = 0) Then tishi("系统将在1分钟后关闭")
		EndIf
		;-------------------------------------------------------------结束判断是否快关机了
		;-------------------------------------------------------------开始判断是否真的要关机了
		If (@HOUR = $xiaoshi And @MIN = $fenzhong And @SEC = 0) Then
			$daojishi = MsgBox(1 + 262144, "提示", "系统即将关闭。确定？", 10)
			If $daojishi = 1 Or $daojishi = -1 Then Shutdown(1) ; 判断是否关机。
			If $daojishi = 2 Then
				GUICtrlSetState($hour, $GUI_ENABLE)
				GUICtrlSetState($min, $GUI_ENABLE)
				GUICtrlSetState($Button1, $GUI_ENABLE)
				GUICtrlSetState($Button2, $GUI_DISABLE)
			EndIf
		EndIf

	EndIf
	;-------------------------------------------------------------结束判断是否真的要关机了
	;-------------------------------------------------------------正点提示
	If GUICtrlRead($Radio1) = 1 Then ;打开了正点提醒
		If (@MIN = 0 And @SEC = 0) Then tishi(FileReadLine(@ScriptDir & "\traytip.dat", Random(1, _FileCountLines(@ScriptDir & "\traytip.dat"), 1))) ;正点提醒
		If (@HOUR = 16 And @MIN = 50 And @SEC = 0) And $shezhi_rizhi Then ;填日志啦！
			ShellExecute("D:\ziliao\Autoit\Script\填写日志.exe")
			Sleep(1500)
		EndIf
	EndIf
	;-------------------------------------------------------------正点提示
	;-------------------------------------------------------------开始判断是否已经设置了开机启动
	If FileExists(@StartupDir & "\时间管理.lnk") Then
		TrayItemSetState($kaijiyes, $TRAY_DISABLE)
		TrayItemSetState($kaijino, $TRAY_ENABLE)
	Else
		TrayItemSetState($kaijiyes, $TRAY_ENABLE)
		TrayItemSetState($kaijino, $TRAY_DISABLE)
	EndIf
	;-------------------------------------------------------------结束判断是否已经设置了开机启动

	;-------------------------------------------------------------开始判断GUI状态
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE)
		Case $Button1
			If $xiaoshi > -1 And $xiaoshi < 24 And $fenzhong > -1 And $fenzhong < 60 And Floor($xiaoshi) = $xiaoshi And Floor($fenzhong) = $fenzhong Then
				GUICtrlSetData($hour, StringFormat("%02s", $xiaoshi))
				GUICtrlSetData($min, StringFormat("%02s", $fenzhong))
				GUICtrlSetData($min, StringFormat("%02s", $fenzhong)) ;改变输入数字的位数。
				GUICtrlSetState($hour, $GUI_DISABLE)
				GUICtrlSetState($min, $GUI_DISABLE)
				GUICtrlSetState($Button1, $GUI_DISABLE)
				GUICtrlSetState($Button2, $GUI_ENABLE)
			Else
				MsgBox(0, "提示", "定时关机时间输入错误")
			EndIf
		Case $Button2
			GUICtrlSetState($hour, $GUI_ENABLE)
			GUICtrlSetState($min, $GUI_ENABLE)
			GUICtrlSetState($Button1, $GUI_ENABLE)
			GUICtrlSetState($Button2, $GUI_DISABLE)
	EndSwitch
	;-------------------------------------------------------------结束判断GUI状态
	;-------------------------------------------------------------开始托盘设置
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $kaijino
			FileDelete(@StartupDir & "\时间管理.lnk")
		Case $msg = $kaijiyes
			If FileExists(@StartupDir & "\时间管理.lnk") = 0 Then FileCreateShortcut(@AutoItExe, @StartupDir & "\时间管理.lnk")
		Case $msg = $jiaoshi
			duishi()
		Case $msg = $about
			tishi("程序制作：zaoki" & @CRLF & "版本号：" & FileGetVersion(@ScriptFullPath))
		Case $msg = $homepage
			ShellExecute("http://www.zaoki.com", "", "", "", @SW_MAXIMIZE)
		Case $msg = $exititem
			ExitLoop
		Case $msg = $TRAY_EVENT_PRIMARYDOUBLE
			GUISetState(@SW_SHOW, $Form1)
	EndSelect
	;-------------------------------------------------------------结束托盘设置
WEnd ;-------------------------------------------------------------结束循环

Func tuichu() ;==>快捷键设置函数
	;-------------------------------------------------------------ini文件写入开始
	IniWrite(@ScriptDir & "\" & "time.ini", "默认关机时间", "关机小时", $xiaoshi)
	IniWrite(@ScriptDir & "\" & "time.ini", "默认关机时间", "关机分钟", $fenzhong)
	IniWrite(@ScriptDir & "\" & "time.ini", "正点提醒", "设置", GUICtrlRead($Radio1))
	IniWrite(@ScriptDir & "\" & "time.ini", "正点提醒", "内容自动网络同步", $shezhi_tongbu)
	IniWrite(@ScriptDir & "\" & "time.ini", "定时关机", "设置", GUICtrlRead($checkbox))
	IniWrite(@ScriptDir & "\" & "time.ini", "打开日志", "设置", $shezhi_rizhi)
	;-------------------------------------------------------------ini文件写入结束
	Exit
EndFunc   ;==>tuichu

Func tishi($tishi) ;==>气泡设置函数
	Local $shezhi_title = "现在是" & _NowCalc()
	TrayTip($shezhi_title, $tishi, 10) ;
	Sleep(1000)
EndFunc   ;==>tishi

Func hello()
	_MyProExists() ;检查是否重复运行
	If IniRead(@ScriptDir & "\" & "time.ini", "定时关机", "设置", "1") = 1 Then tishi("时间管理工具隐藏到了这里，左键双击这里打开。")
EndFunc   ;==>hello

Func duishi()
	$lanSHIJIAN = _INetGetSource('http://diancom.sinaapp.com/timedatabar.php')
	If $lanSHIJIAN <> "" Then
		If _DateIsValid($lanSHIJIAN) Then
			$lanSHIJIAN = StringSplit($lanSHIJIAN, " ", 1)
			If IsArray($lanSHIJIAN) Then
				If $lanSHIJIAN[1] <> _NowDate() Then
					RunWait(@ComSpec & " /c date " & $lanSHIJIAN[1], @ScriptDir, @SW_HIDE)
					TrayTip("时间管理工具提醒您", "本地时间同步成功！", 10)
				EndIf
				If StringLeft(_NowTime(), 5) <> StringLeft($lanSHIJIAN[2], 5) Then RunWait(@ComSpec & " /c time " & $lanSHIJIAN[2], @ScriptDir, @SW_HIDE)
			EndIf
		EndIf
	Else
		TrayTip("时间管理工具提醒您", "获取网络时间失败！，本功能需要连接网络，请您检查您的网络设置是否正确。", 10)
	EndIf
EndFunc   ;==>duishi

Func _MyProExists()
	$my_Version = "时间管理_zaoki.com"
	If WinExists($my_Version) Then Exit
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists
