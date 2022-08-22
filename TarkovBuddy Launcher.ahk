#SingleInstance, Force
#include JSON.ahk
;#include <Vis2> ;https://github.com/xInDiGo/Vis2

SetWorkingDir %A_ScriptDir%
IniRead, ThisLaunchVersNum, %A_ScriptDir%\tbsettings.ini, MyLaunchVersNum, Version
IniRead, ThisTarkovBuddyVersNum, %A_ScriptDir%\tbsettings.ini, MyTarkovBuddyVersNum, Version

if (ThisLaunchVersNum = "Error"){
;If true this will prompt the user for a directory, & run the install function
	MsgBox, 49, TarkovBuddy Installation, Please choose your install path to proceed
	IfMsgBox OK
	{
		Install()
		ExitApp
	}
	else{ ; this is just redundent
		MsgBox, 17, Choose an installation path to continue, You must choose an installation path to continue.
		IfMsgBox OK
		{
			Install()
			ExitApp
		}
		else
			ExitApp
	}
}
else if (ThisTarkovBuddyVersNum = "Error"){
		;if !FileExist(TarkovBuddy.ahk){
		if !FileExist(TarkovBuddy.exe){
			MsgBox, 49, Application Detection, Downloading TarkovBuddy
				IfMsgBox OK
				{
					;UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy.ahk, TarkovBuddy.ahk
					UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy.exe, %A_ScriptDir%\TarkovBuddy.exe
					MsgBox, 0, Starting, Launching TarkovBuddy, 5
					Sleep, 3000
					;Run, TarkovBuddy.ahk
					Run, TarkovBuddy.exe
					ExitApp ; Use if window detected before exit
				}
				else
					ExitApp
		}
	}
else if !(ThisTarkovBuddyVersNum = "Error"){
	var := DataGrab()
	Num := "App1"
	VersNum := ThisLaunchVersNum
	MsgBox, 64, Hello, % "Checking for update: " var["data"`,Num`,"Name"] " - " VersNum , 5
	If (VersCheck(var["data"], Num, VersNum)){
		Num := "App2"
		VersNum := ThisTarkovBuddyVersNum
		If (VersCheck(var["data"], Num, VersNum)){
			;Run TarkovBuddy.ahk
			Run TarkovBuddy.exe
			MsgBox, 0, Starting, Launching TarkovBuddy, 3
			ExitApp ; Use if window detected before exit
		}
		else{
			MsgBox, 17, Update Required, TarkovBuddy requires an update to continue
			IfMsgBox OK
				{ ;may need more work here
				;UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy.ahk, TarkovBuddy.ahk
				UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy.exe, %A_ScriptDir%\TarkovBuddy.exe
				MsgBox, 48, Complete, Update Complete! Launching TarkovBuddy, 5
				Sleep, 3000
				;Run, TarkovBuddy.ahk
				Run, TarkovBuddy.exe
				ExitApp ; Use if window detected before exit
				}
			else
				ExitApp
		}
	}
	else {
		MsgBox, 17, Update Required, TarkovBuddy Launcher requires an update to continue
			IfMsgBox OK
				{ ;really need more work here
				;UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy Launcher.ahk, TarkovBuddy.ahk
				;UrlDownloadToFile, https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy Launcher.exe, %A_ScriptDir%\TarkovBuddy.exe
				MsgBox, 48, Complete, Update Complete! Restarting, 5
				Sleep, 3000
				ExitApp ; Use if window detected before exit
				}
			else
				ExitApp
		ExitApp
	}
}

Esc::
ExitApp

GuiClose:
ExitApp

VersCheck(MyData:="", AppNum:="", ThisVersNum=""){
	if !(MyData[AppNum,"VersNum"] = ThisVersNum){
		MsgBox, 50, Warning!, % MyData[AppNum`,"Name"] " " MyData[AppNum`,"VersNum"] " does not equal " ThisVersNum
		;msgbox % "WARNING " MyData[AppNum,"Name"] " " MyData[AppNum,"VersNum"] " does not equal " ThisVersNum
		return False
	}
	else if (MyData[AppNum,"VersNum"] = ThisVersNum){
		MsgBox, 64, Approved, % MyData[AppNum`,"Name"] " is good. The version number is " ThisVersNum " which is the same as the recent version " MyData[AppNum`,"VersNum"] , 5
		;msgbox % MyData[AppNum,"Name"] " is good. The version number is " ThisVersNum " which is the same as the current version " MyData[AppNum,"VersNum"]
		return True
	}
}

Install(){
;Gets the new dir from function & creates, moves, & writes the currentapp data to the new dir, creates a shortcut to the new exe in the same location as the dir
	MyDirLocation := ChooseDIR()
	FileCreateDir, %MyDirLocation%\TarkovBuddy
	IniWrite, 0.0.1.0, %MyDirLocation%\TarkovBuddy\tbsettings.ini, MyLaunchVersNum, Version
	;FileCopy %A_WorkingDir%\TarkovBuddy Launcher.ahk, %MyDirLocation%\TarkovBuddy\
	FileCopy %A_WorkingDir%\TarkovBuddy Launcher.exe, %MyDirLocation%\TarkovBuddy\
	;FileCreateShortcut, %MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.ahk, %A_ScriptDir%\TarkovBuddy Launcher.lnk, %MyDirLocation%\TarkovBuddy\
	FileCreateShortcut, %MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.exe, %A_ScriptDir%\TarkovBuddy Launcher.lnk, %MyDirLocation%\TarkovBuddy\
	;Run %MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.ahk
	Run %MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.exe
	Run CMD.exe /c timeout 3 & Del "%A_ScriptFullPath%",, HIDE
	Exitapp
}



ChooseDIR(){
	FileSelectFolder, DirLocation
	;GuiControl, text, MyDir, %MyDirLocation%
	return % DirLocation
}

DataGrab()
{
	WinHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	Try{
		WinHTTP.Open("GET", "https://raw.githubusercontent.com/xInDiGo/tarkovbuddy/main/version.json", true)
		WinHTTP.Send()
		WinHTTP.WaitForResponse()
	}
	Catch e{
		MsgBox, 16, Error, %  Cant connect to server`, click okay to exit
		;MsgBox % "Error: Cant connect to server -- Click okay to exit"
		ExitApp
	}
	WinHTTP.WaitForResponse()
	Status := WinHTTP.Status
	if (Status=200){
		arr := {}
		arr["Data"] := JSON.Load(WinHTTP.ResponseText)
		return arr
	}
	else{
		MsgBox, 16, Error, %  "Error " Status " -- Click okay to exit."
		;msgbox % "Error " Status " -- Click okay to exit."
		ExitApp
		}
}

st_printArr(array, depth=50, indentLevel="")
{ ;by tidbit
   for k,v in Array
   {
      list.= indentLevel "[" k "]"
      if (IsObject(v) && depth>1)
         list.="`n" st_printArr(v, depth-1, indentLevel . "    ")
      Else
         list.=" => " v
      list.="`n"
   }
   return rtrim(list)
}