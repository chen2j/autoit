#Region ;**** ���������� ACNWrapper_GUI ****
#PRE_icon=..\..\..\WINDOWS\System32\SHELL32.dll|-46
#PRE_Outfile=weiyun.exe
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** ���������� ACNWrapper_GUI ****
;HotKeySet("^q", "weiyun")
;HotKeySet("^{F1}", "tuichu") ; �����˳���ݼ�Ϊ Ctrl+F1��
_MyProExists()

 #comments-start----��ѡ��汾
While 1
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		Local $ok=MsgBox(32+4+8192+262144,"��⵽�����˴������¿��������","�Ƿ����΢���������أ�",10)
		If $ok=6 Then
			weiyun(ClipGet())
			ClipPut("")
		ElseIf $ok=7 Then
			ClipPut("")
			MsgBox(64+262144,"��ʾ","��ȡ�����أ�",10)
			TrayTip("��ʾ", "���ڳ���Ϊ"&ClipGet()&"��ӵ�΢���������أ��벻Ҫ�ƶ���꣡", 5, 1)
		Else
			ClipPut("")
			MsgBox(48+262144,"��ʾ","��ʱû��ѡ����ȡ�����أ�",10)
		EndIf
	Else
		Sleep(1000)
	EndIf
WEnd
 #comments-end

 TrayTip("��ʾ", "΢�����������Ѿ���ʼ���У��һ��������������Ӳ����������Ϊ��΢�ƣ�", 5, 1)
 While 1
	If StringInStr(ClipGet(),"ed2k://" ) Or StringInStr(ClipGet(),"magnet:?" )  Then
		TrayTip("��ʾ", "��⵽�������ӣ�����Ϊ����ӵ�΢���������أ��벻Ҫ�ƶ���꣡", 5, 1)
		weiyun(ClipGet())
		ClipPut("")
	EndIf
	Sleep(1000)
WEnd

Func weiyun($clip)
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
			Local $lixian = WinGetPos("��������")
			Sleep(100)
			If @error Then
				TrayTip("����", "���΢����������ʧ�ܣ�", 5, 2)
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
			WinClose("��Ѷ΢��")
			Sleep(500)
			If Not WinExists("��������") Then
				;MsgBox(64+262144, "��ʾ", "�Ѿ��ɹ����"&ClipGet()&"��΢����������",2)
				TrayTip("��ʾ", "�����ѳɹ���ӵ�΢���������أ�", 5, 1)
			Else
				WinClose("��������")
				;MsgBox(16+262144, "��ʾ", "���ʧ��",2)
				TrayTip("����", "���΢����������ʧ�ܣ�", 5, 2)
			EndIf
		Else
			;MsgBox(16+262144, "����", "�Ҳ����������ش���",2)
			TrayTip("��ʾ", "�Ҳ���΢���������ش��ڣ�", 5, 3)
		EndIf
		BlockInput(0)
		;ProcessClose($iPID)
	EndFunc   ;==>Examplemagnet:magnet

Func _MyProExists()
	$my_Version = "΢��������������"
	If WinExists($my_Version) Then
		;MsgBox(16, "����", "�Ѿ�������һ�����򣬲���Ҫ���ж����",2)
		TrayTip("����", "�����Ѿ��������ˣ�����Ҫ���ж����", 5, 3)
		Exit
	EndIf
	AutoItWinSetTitle($my_Version)
EndFunc   ;==>_MyProExists