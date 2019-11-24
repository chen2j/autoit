#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Icon=google_wallet_128px_1226424_easyicon.net.ico
#PRE_Outfile=微云离线助手.exe
#PRE_UseX64=n
#PRE_Res_Comment=通过Autoit实现自动添加微云离线下载
#PRE_Res_Fileversion=1.2.5.12
#PRE_Res_Fileversion_AutoIncrement=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
_MyProExists()

HotKeySet("^w", "loop")
HotKeySet("{Esc}", "Terminate")
Global $dir=@TempDir & "\links-for-weiyun-download.txt"
Global $file = FileOpen($dir, 9)
Global $count = 0
Func Terminate()
	TrayTip("提示", "微云离线下载小程序已退出！", 5, 1)
	FileClose($file)
	Sleep(500)
	FileDelete($dir)
	WinClose("腾讯微云")
	WinClose("离线下载")
	WinClose("提示")
	Exit
EndFunc   ;==>Terminate

Opt("TrayMenuMode", 3) ; 默认托盘菜单项目(脚本已暂停/退出脚本) (Script Paused/Exit) 将不显示.

$start = TrayCreateItem("开始离线下载（Ctrl+D）")
TrayCreateItem("")
$shuliang = TrayCreateItem("待离线下载链接数：0")
TrayCreateItem("")
$about = TrayCreateItem("关于本软件")
TrayCreateItem("")
$homepage = TrayCreateItem("访问官网")
TrayCreateItem("")
$exititem = TrayCreateItem("退出")

TraySetToolTip("微云离线下载小工具") ; 鼠标移动到托盘显示的提示。
TraySetClick(8) ;右键才会显示菜单

TrayTip("提示", "微云下载助手已经开始运行，我会持续监控下载链接并帮助您添加为到微云！", 5, 1)

While 1
	If StringInStr(ClipGet(), "ed2k://") Or StringInStr(ClipGet(), "magnet:?") Then
		shouji()
	EndIf
	Sleep(100)
	
	;-------------------------------------------------------------开始托盘设置
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $about
			TrayTip("提示", "程序制作：jemch" & @CRLF & "版本号：" & FileGetVersion(@ScriptFullPath), 5, 1)
		Case $msg = $homepage
			ShellExecute("http://www.jemch.com", "", "", "", @SW_MAXIMIZE)
		Case $msg = $exititem
			Exit
		Case $msg = $start
			loop()
		Case $msg = $shuliang
			$shuliang=0
			
			;Case $msg = $TRAY_EVENT_PRIMARYDOUBLE
			;	GUISetState(@SW_SHOW, $Form1)
	EndSelect
	;-------------------------------------------------------------结束托盘设置
	
WEnd

Func shouji()
	$file = FileOpen($dir, 9)
	FileWriteLine($file, ClipGet())
	FileClose($file)
	$count = $count + 1
	TrayTip("提示", "检测到电驴或磁力链接，共为您收集到"&$count&"个链接。", 5, 1)
	TrayItemSetText($shuliang, "待离线下载链接数：" & $count &"，点击可清理为0")
	ClipPut("")
EndFunc   ;==>shouji

Func loop()
	TrayTip("提示", "开始添加链接到微云，请勿移动鼠标或键盘！", 5, 2)
	$file = FileOpen($dir, 0)
	While 1
		Local $line = FileReadLine($file)
		If @error = -1 Then
			If $count=0 Then
				TrayTip("提示", "还没有复制任何下载链接，请添加后重试！", 5, 2)
				ExitLoop
			EndIf
			TrayTip("提示", $count & "个链接已添加到微云离线下载！", 5, 1)
			Terminate()
		EndIf
		ClipPut($line)
		weiyun()

	WEnd
EndFunc   ;==>loop

Func weiyun()
	Local $iPID = Run("C:\Program Files (x86)\Tencent\weiyundisk\WeiyunDisk\WeiyunDisk\Bin\wydrive.exe", "", @SW_MAXIMIZE)
	WinWait("腾讯微云", "", 10)
	BlockInput(1)
	Sleep(1000)
	Local $size = WinGetPos("腾讯微云")
	MouseMove($size[0] + 100, $size[1] + 110)
	Sleep(100)
	MouseMove($size[0] + 100, $size[1] + 250)
	MouseClick("")
	WinWait("离线下载", "", 10)
	Sleep(100)
	If WinExists("离线下载") Then
		Sleep(100)
		If @error Then
			TrayTip("错误", "添加微云离线下载失败！", 5, 3)
			Exit
		EndIf
		
		Local $lixian = WinGetPos("离线下载")
		
		
#CS 		Local $color = PixelGetColor($lixian[0] + 317, $lixian[1] + 235)
   		If $color = 0xFFFFFF Then
   			TrayTip("出错啦！", "今日已到达微云离线下载添加上限，只能明天再试了！", 5, 3)
   			Terminate()
   		EndIf
#CE
		
		
		MouseMove($lixian[0] + 250, $lixian[1] + 60)
		MouseClick("")
		Sleep(100)
		MouseMove($lixian[0] + 250, $lixian[1] + 260)
		MouseClick("")
		Sleep(100)

		Send("^v")
		MouseMove($lixian[0] + 450, $lixian[1] + 400)
		MouseClick("")
		Sleep(500)
		MouseClick("")

		If WinExists("离线下载") Or WinExists("提示") Then
			WinClose("离线下载")
			WinClose("提示")
			TrayTip("错误", "添加微云离线下载失败！", 5, 3)
		EndIf
	Else
		TrayTip("提示", "找不到微云离线下载窗口！", 5, 3)
	EndIf
	BlockInput(0)
	;ProcessClose($iPID)
EndFunc   ;==>weiyun

Func _MyProExists()
	$my_Version = "微云离线下载助手"
	If WinExists($my_Version) Then
		TrayTip("错误", "程序已经在运行了，不需要运行多个！", 5, 3)
		Exit
	EndIf
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists
