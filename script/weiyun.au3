#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_icon=..\..\..\WINDOWS\System32\SHELL32.dll|-46
#PRE_Outfile=weiyun.exe
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
;HotKeySet("^q", "weiyun")
;HotKeySet("^{F1}", "tuichu") ; 设置退出快捷键为 Ctrl+F1。
_MyProExists()

 #comments-start----带选择版本
While 1
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		Local $ok=MsgBox(32+4+8192+262144,"检测到复制了磁力或电驴下载链接","是否添加微云离线下载？",10)
		If $ok=6 Then
			weiyun(ClipGet())
			ClipPut("")
		ElseIf $ok=7 Then
			ClipPut("")
			MsgBox(64+262144,"提示","已取消下载！",10)
			TrayTip("提示", "正在尝试为"&ClipGet()&"添加到微云离线下载，请不要移动鼠标！", 5, 1)
		Else
			ClipPut("")
			MsgBox(48+262144,"提示","超时没有选择，已取消下载！",10)
		EndIf
	Else
		Sleep(1000)
	EndIf
WEnd
 #comments-end

 TrayTip("提示", "微云下载助手已经开始运行，我会持续监控下载链接并帮助您添加为到微云！", 5, 1)
 While 1
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		TrayTip("提示", "检测到下载链接，正在为您添加到微云离线下载，请不要移动鼠标！", 5, 1)
		weiyun(ClipGet())
		ClipPut("")
	EndIf
	Sleep(1000)
WEnd

Func weiyun($clip)
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
			Local $lixian = WinGetPos("离线下载")
			Sleep(100)
			If @error Then
				TrayTip("错误", "添加微云离线下载失败！", 5, 2)
				Exit
			EndIf
			MouseMove($lixian[0]+250, $lixian[1]+60)
			MouseClick("")
			Sleep(100)
			MouseMove($lixian[0]+250, $lixian[1]+260)
			MouseClick("")
			Sleep(100)

			Clipput($clip)
			Send("^v")
			MouseMove($lixian[0]+450, $lixian[1]+400)
			MouseClick("")
			Sleep(500)
			MouseClick("")
			Sleep(500)
			MouseClick("",$size[0]+80, $size[1]+585)
			Sleep(5000)
			WinClose("腾讯微云")
			Sleep(500)
			If Not WinExists("离线下载") Then
				;MsgBox(64+262144, "提示", "已经成功添加"&ClipGet()&"到微云离线下载",2)
				TrayTip("提示", "链接已成功添加到微云离线下载！", 5, 1)
			Else
				WinClose("离线下载")
				;MsgBox(16+262144, "提示", "添加失败",2)
				TrayTip("错误", "添加微云离线下载失败！", 5, 2)
			EndIf
		Else
			;MsgBox(16+262144, "错误", "找不到离线下载窗口",2)
			TrayTip("提示", "找不到微云离线下载窗口！", 5, 3)
		EndIf
		BlockInput(0)
		;ProcessClose($iPID)
	EndFunc   ;==>Examplemagnet:magnet

Func _MyProExists()
	$my_Version = "微云离线下载助手"
	If WinExists($my_Version) Then
		;MsgBox(16, "错误", "已经运行了一个程序，不需要运行多个！",2)
		TrayTip("错误", "程序已经在运行了，不需要运行多个！", 5, 3)
		Exit
	EndIf
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists