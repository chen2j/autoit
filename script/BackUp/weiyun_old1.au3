#Region ;**** ���������� ACNWrapper_GUI ****
#PRE_Icon=google_wallet_128px_1226424_easyicon.net.ico
#PRE_Outfile=΢����������.exe
#PRE_UseX64=n
#PRE_Res_Comment=ͨ��Autoitʵ���Զ����΢����������
#PRE_Res_Fileversion=0.0.0.3
#PRE_Res_Fileversion_AutoIncrement=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** ���������� ACNWrapper_GUI ****
;HotKeySet("^q", "weiyun")
;HotKeySet("^{F1}", "tuichu") ; �����˳���ݼ�Ϊ Ctrl+F1��
_MyProExists()

HotKeySet("^w", "loop") 
HotKeySet("{Esc}", "Terminate") 
Global $file = FileOpen(@ScriptDir & "\links-for-weiyun-download.txt", 9)

Func Terminate()
	TrayTip("��ʾ", "΢����������С�������˳���", 5, 1)
	FileClose($file)
	Sleep(500)
	FileDelete($file)
	WinClose("��Ѷ΢��")
	WinClose("��������")
	WinClose("��ʾ")
    Exit 
EndFunc   ;==>Terminate

Opt("TrayMenuMode", 3) ; Ĭ�����̲˵���Ŀ(�ű�����ͣ/�˳��ű�) (Script Paused/Exit) ������ʾ.

$start = TrayCreateItem("��ʼ��������")
TrayCreateItem("")
$about = TrayCreateItem("���ڱ����")
TrayCreateItem("")
$homepage = TrayCreateItem("���ʹ���")
TrayCreateItem("")
$exititem = TrayCreateItem("�˳�")

TraySetToolTip("΢����������С����") ; ����ƶ���������ʾ����ʾ��
TraySetClick(8) ;�Ҽ��Ż���ʾ�˵�

TrayTip("��ʾ", "΢�����������Ѿ���ʼ���У��һ��������������Ӳ����������Ϊ��΢�ƣ�", 5, 1)

 While 1
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		TrayTip("��ʾ", "��⵽��¿��������ӣ�����Ϊ���ռ���", 5, 1)
		shouji()
		ClipPut("")
	EndIf
	Sleep(100)
	
		;-------------------------------------------------------------��ʼ��������
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $about
			TrayTip("��ʾ", "����������jemch" & @CRLF & "�汾�ţ�" & FileGetVersion(@ScriptFullPath), 5, 1)
		Case $msg = $homepage
			ShellExecute("http://www.jemch.com", "", "", "", @SW_MAXIMIZE)
		Case $msg = $exititem
			Exit
		Case $msg = $start
			loop()	
		;Case $msg = $TRAY_EVENT_PRIMARYDOUBLE
		;	GUISetState(@SW_SHOW, $Form1)
	EndSelect
	;-------------------------------------------------------------������������
	
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
			TrayTip("��ʾ", "�������Ӿ�����ӵ��������أ�", 5, 1)
			Terminate()
		EndIf
		ClipPut($line)
		weiyun()
		
	WEnd	
EndFunc

Func weiyun()
		Local $iPID = Run("C:\Program Files (x86)\Tencent\weiyundisk\WeiyunDisk\WeiyunDisk\Bin\wydrive.exe", "", @SW_MAXIMIZE)
		WinWait("��Ѷ΢��", "", 10)
		BlockInput(1)
		Sleep(1000)
		Local $size = WinGetPos("��Ѷ΢��")
		MouseMove($size[0]+100, $size[1]+110)
		Sleep(100)
		MouseMove($size[0]+100, $size[1]+250)
		MouseClick("")
		WinWait("��������", "", 10)
		Sleep(100)
		If WinExists("��������") Then
			Sleep(100)			
			If @error Then
				TrayTip("����", "���΢����������ʧ�ܣ�", 5, 2)
				Exit
			EndIf	
			
			Local $lixian = WinGetPos("��������")
			Local $color = PixelGetColor($lixian[0]+245, $lixian[1]+232)
			If $color=0xFFFFFF Then 
				TrayTip("����", "�����ѵ���΢����������������ޣ�", 5, 2)
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

			If  WinExists("��������") Or WinExists("��ʾ") Then
				WinClose("��������")
				WinClose("��ʾ")
				TrayTip("����", "���΢����������ʧ�ܣ�", 5, 2)
			EndIf
		Else
			TrayTip("��ʾ", "�Ҳ���΢���������ش��ڣ�", 5, 3)
		EndIf
		BlockInput(0)
		;ProcessClose($iPID)
	EndFunc   ;==>Examplemagnet:magnet

Func _MyProExists()
	$my_Version = "΢��������������"
	If WinExists($my_Version) Then
		TrayTip("����", "�����Ѿ��������ˣ�����Ҫ���ж����", 5, 3)
		Exit
	EndIf
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists