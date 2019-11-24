#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Icon=google_wallet_128px_1226424_easyicon.net.ico
#PRE_Outfile=微云离线助手.exe
#PRE_UseX64=n
#PRE_Res_Comment=通过Autoit实现自动添加微云离线下载
#PRE_Res_Fileversion=0.0.0.3
#PRE_Res_Fileversion_AutoIncrement=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
;HotKeySet("^q", "weiyun")
;HotKeySet("^{F1}", "tuichu") ; 设置退出快捷键为 Ctrl+F1。
_MyProExists()

HotKeySet("^w", "loop") 
HotKeySet("{Esc}", "Terminate") 
Global $file = FileOpen(@ScriptDir & "\links-for-weiyun-download.txt", 9)

Func Terminate()
	TrayTip("提示", "微云离线下载小程序已退出！", 5, 1)
	FileClose($file)
	Sleep(500)
	FileDelete($file)
	WinClose("腾讯微云")
	WinClose("离线下载")
	WinClose("提示")
    Exit 
EndFunc   ;==>Terminate

Opt("TrayMenuMode", 3) ; 默认托盘菜单项目(脚本已暂停/退出脚本) (Script Paused/Exit) 将不显示.

$start = TrayCreateItem("开始离线下载")
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
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		TrayTip("提示", "检测到电驴或磁力链接，正在为您收集！", 5, 1)
		shouji()
		ClipPut("")
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
		;Case $msg = $TRAY_EVENT_PRIMARYDOUBLE
		;	GUISetState(@SW_SHOW, $Form1)
	EndSelect
	;-------------------------------------------------------------结束托盘设置
	
WEnd

Func shouji()
	FileSetAttrib($file, "+H+T", 1)
	FileWriteLine($file, ClipGet())
	FileClose($file)
EndFunc

Func loop()	
	Local $count =0
	While 1
		Local $line = FileReadLine($file)
		$count=$count+1
		If @error = -1 Then 
			TrayTip("提示", "所有链接均已添加到离线下载！", 5, 1)
			Terminate()
		EndIf
		ClipPut($line)
		weiyun()
		
	WEnd	
EndFunc

Func weiyun()
		Local $iPID = Run("C:\Program Files (x86)\Tencent\weiyundisk\WeiyunDisk\WeiyunDisk\Bin\wydrive.exe", "", @SW_MAXIMIZE)
		WinWait("腾讯微云", "", 10)
		BlockInput(1)
		Sleep(1000)
		Local $size = WinGetPos("腾讯微云")
		MouseMove($size[0]+100, $size[1]+110)
		Sleep(100)
		MouseMove($size[0]+100, $size[1]+250)
		MouseClick("")
		WinWait("离线下载", "", 10)
		Sleep(100)
		If WinExists("离线下载") Then
			Sleep(100)			
			If @error Then
				TrayTip("错误", "添加微云离线下载失败！", 5, 2)
				Exit
			EndIf	
			
			Local $lixian = WinGetPos("离线下载")
			Local $color = PixelGetColor($lixian[0]+245, $lixian[1]+232)
			If $color=0xFFFFFF Then 
				TrayTip("错误", "今日已到达微云离线下载添加上限！", 5, 2)
				Terminate()
			EndIf
			
			
			MouseMove($lixian[0]+250, $lixian[1]+60)
			MouseClick("")
			Sleep(100)
			MouseMove($lixian[0]+250, $lixian[1]+260)
			MouseClick("")
			Sleep(100)

			Send("^v")
			MouseMove($lixian[0]+450, $lixian[1]+400)
			MouseClick("")
			Sleep(500)
			MouseClick("")

			If  WinExists("离线下载") Or WinExists("提示") Then
				WinClose("离线下载")
				WinClose("提示")
				TrayTip("错误", "添加微云离线下载失败！", 5, 2)
			EndIf
		Else
			TrayTip("提示", "找不到微云离线下载窗口！", 5, 3)
		EndIf
		BlockInput(0)
		;ProcessClose($iPID)
	EndFunc   ;==>Examplemagnet:magnet

Func _MyProExists()
	$my_Version = "微云离线下载助手"
	If WinExists($my_Version) Then
		TrayTip("错误", "程序已经在运行了，不需要运行多个！", 5, 3)
		Exit
	EndIf
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists