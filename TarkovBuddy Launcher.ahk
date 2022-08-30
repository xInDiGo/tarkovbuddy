#SingleInstance, Force
#include JSON.ahk
;#include <Vis2> ;https://github.com/xInDiGo/Vis2

FormatTime, Date,, ShortDate
FormatTime, Time,, Time

Global DebugMode = 1 ;Toggles the debugger -- Set to 1 for window or 0 for no window.

Global MyExt = 1 ; Extension setting -- Set to 1 for ahk extension, 0 for exe extension

Global ext := ex(MyExt) ; Uses extension manager function to set ext to an extension

Global DbgMsg .=

GLobal Date
Global Time

Gui, Add, GroupBox, xm ym w350 h450, Launcher Debuger
Gui, Add, Edit, r20 xm+10 ym+20 w330 h410 ReadOnly Multi Wrap vDisplayDebug, % DbgMsg

If (DebugMode)
	Gui, Show,, Debugger
else
	Gui, Hide,

SetWorkingDir %A_ScriptDir%
IniRead, ThisLaunchVersNum, %A_ScriptDir%\tbsettings.ini, MyLaunchVersNum, Version
IniRead, ThisTarkovBuddyVersNum, %A_ScriptDir%\tbsettings.ini, MyTarkovBuddyVersNum, Version

{
DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Application Started on " Date " at " Time)
DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Application directory: "  A_ScriptDir)
DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Extension set to: " MyExt)
DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Extension is:  " ext)
DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "The ini read is: " ThisLaunchVersNum)
}

if (ThisLaunchVersNum = "Error"){
;If true this will prompt the user for a directory, & run the install function
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Error Detected, could not read ini, trying to do fresh install.")
	MsgBox, 49, TarkovBuddy Installation, Please choose your install path to proceed
	IfMsgBox OK
	{
		Install(ex(MyExt))
		ExitApp
	}
	else{ ; this is just redundent
		DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User Attempted to cancel install, trying to confirm")
		MsgBox, 17, Choose an installation path to continue, You must choose an installation path to continue.
		IfMsgBox OK
		{
			("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Starting Install Function")
			Install(ex(MyExt))
			ExitApp
		}
		else{
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User terminated installation")
			MsgBox, 16, Error, User terminated installation. Exting Application
			ExitApp
		}
	}
}
else if (ThisTarkovBuddyVersNum = "Error"){
		if !FileExist("TarkovBuddy." %ext%){
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Application Detection, Downloading TarkovBuddy")
			DLFile("https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy." ext, A_ScriptDir "\TarkovBuddy." ext)
			;MsgBox, 0, Starting, Launching TarkovBuddy, 5
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy is Starting")
			Run, TarkovBuddy.%ext%
			WinCheck()
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Launcher is Exiting")
			ExitApp
		}
		else
			ExitApp
		}

else if !(ThisTarkovBuddyVersNum = "Error"){
	var := DataGrab()
	Num := "App1"
	VersNum := ThisLaunchVersNum
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Checking for update:" A_Space var["data"`,Num`,"Name"] A_Space "-" A_Space VersNum)
	;MsgBox, 64, Hello, % "Checking for update: " var["data"`,Num`,"Name"] " - " VersNum , 5
	If (VersCheck(var["data"], Num, VersNum)){
		Num := "App2"
		VersNum := ThisTarkovBuddyVersNum
		If (VersCheck(var["data"], Num, VersNum)){
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy is Starting")
			Run TarkovBuddy.%ext%
			;MsgBox, 0, Starting, Launching TarkovBuddy, 3
			WinCheck()
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Launcher is Exiting")
			ExitApp
		}
		else{
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy requires an update to continue")
			MsgBox, 17, Update Required, TarkovBuddy requires an update to continue
			IfMsgBox OK
				{
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Downloading TarkovBuddy update")
				DLFile("https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy." ext, A_ScriptDir "\TarkovBuddy." ext)
				MsgBox, 48, Complete, Update Complete! Launching TarkovBuddy, 5
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy is Starting")
				Run, TarkovBuddy.%ext%
				WinCheck()
				ExitApp
				}
			else
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User did not update application")
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Exiting Application")
				ExitApp
		}
	}
	else {
		DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy Launcher requires an update")
		MsgBox, 17, Update Required, TarkovBuddy Launcher requires an update to continue
			IfMsgBox OK
				{
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Downloading TarkovBuddy Launcher update")
				DLFile("https://github.com/xInDiGo/tarkovbuddy/raw/main/TarkovBuddy Launcher." ext, A_ScriptDir "\TarkovBuddy Launcher." ext "_temp")
				UDVers := var["data", "App1", "VersNum"]
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Set Version:" A_Space var["data", "App1", "VersNum"] A_Space "to" A_Space "UDVers")
				IniWrite, %UDVers%, %A_ScriptDir%\tbsettings.ini, MyLaunchVersNum, Version
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Writing Version:" A_Space UDVers A_Space "to path:" A_Space A_ScriptDir "\tbsettings.ini")
				MsgBox, 48, Complete, Update Complete! Restarting
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "TarkovBuddy Launcher is restarting")
				Run CMD.exe /c timeout 3 & Del "%A_ScriptDir%\TarkovBuddy Launcher.%ext%" & ren "%A_ScriptDir%\TarkovBuddy Launcher.%ext%_temp" "TarkovBuddy Launcher.%ext%" & "%A_ScriptDir%\TarkovBuddy Launcher.%ext%",, HIDE
				ExitApp
				}
			else
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User did not update Launcher")
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Exiting Launcher")
				ExitApp
	}
}

Esc::
ExitApp

GuiClose:
ExitApp



DLFile(URL="", Nme=""){
	While !(MyDL = 0){
		Loop 3{
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "The URL is:" A_Space URL)
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "The File Name is:" A_Space Nme)
			DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "DL attempt:" A_Space A_Index)
			;Msgbox, DL attempt: %A_Index%
			UrlDownloadToFile, %URL%, %Nme%
			Loop 5{
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Verifing file was downloaded at:" A_Space Nme A_Space)
				DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Check attempt number:" A_Space A_Index)
				If !FileExist(Nme){
					MyDL = 0
					sleep 1000
				}
				else if FileExist(Nme){
					DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space Nme A_Space "was found")
					MyDL = 1
					return 1
				}
			}
		}
	}
}

DebugDataPush(DebugMessgage){
    DbgMsg .= DebugMessgage "`n"
    GuiControl,, DisplayDebug, %DbgMsg%
	sleep 50
	;FileAppend, %DbgMsg%, %A_ScriptDir%\Log.txt

}

WinCheck(){ ;checks if a window is active (used before exiting the launcher)
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Checking for window before exiting")
	If !(MyExt = 1)
		While !WinExist("InDiGo's TarkovBuddy BETA") ;may need a time out for if the window never opens
			sleep 1000
	else
		ExitApp
}

Ex(MyExt=""){ ;Extension Manager
	if (MyExt)
		return "ahk"
	else
		return "exe"
}
VersCheck(MyData:="", AppNum:="", ThisVersNum=""){
	if !(MyData[AppNum,"VersNum"] = ThisVersNum){
		DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space MyData[AppNum`,"Name"] " " MyData[AppNum`,"VersNum"] " does not equal " ThisVersNum)
		;MsgBox, 50, Warning!, % MyData[AppNum`,"Name"] " " MyData[AppNum`,"VersNum"] " does not equal " ThisVersNum ;need to add this to a gui element
		return False
	}
	else if (MyData[AppNum,"VersNum"] = ThisVersNum){
		DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Approved," A_Space MyData[AppNum`,"Name"] A_Space "is good. The version number is" A_Space ThisVersNum A_Space "which is the same as the recent version" A_Space MyData[AppNum`,"VersNum"])
		;MsgBox, 64, Approved, % MyData[AppNum`,"Name"] " is good. The version number is " ThisVersNum " which is the same as the recent version " MyData[AppNum`,"VersNum"] , 5 ;need to add this to a gui element
		return True
	}
}

Install(MyExt=""){
;Gets the new dir from function & creates, moves, & writes the currentapp data to the new dir, creates a shortcut to the new exe in the same location as the dir
	MyDirLocation := ChooseDIR()
	FileCreateDir, %MyDirLocation%\TarkovBuddy
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Creating Dir:" A_Space MyDirLocation)
	IniWrite, 0.0.1.01, %MyDirLocation%\TarkovBuddy\tbsettings.ini, MyLaunchVersNum, Version
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Generated INI" A_Space MyDirLocation)
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Wrote Version to INI:" A_Space 0.0.1.01)
	FileCopy %A_WorkingDir%\TarkovBuddy Launcher.%ext%, %MyDirLocation%\TarkovBuddy\
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Moving Launcher to:" A_Space MyDirLocation "\TarkovBuddy\")
	FileCreateShortcut, %MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.%ext%, %A_ScriptDir%\TarkovBuddy Launcher.lnk, %MyDirLocation%\TarkovBuddy\
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Creating Launcher shortcut at:" A_Space A_ScriptDir "\TarkovBuddy Launcher.lnk")
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Starting new Launcher" A_Space MyDirLocation "\TarkovBuddy\")
	Run "%MyDirLocation%\TarkovBuddy\TarkovBuddy Launcher.%ext%"
	Run CMD.exe /c timeout 3 & Del "%A_ScriptFullPath%",, HIDE
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "Exiting Old Launcher" A_Space MyDirLocation "\TarkovBuddy\")
	Exitapp
}

ChooseDIR(){
	DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User is selecting a location")
	FileSelectFolder, DirLocation
	if !(ErrorLevel)
		return % DirLocation
	else{
		DebugDataPush("[" A_LineNumber "]" A_Space "(" Time ")" A_Space "User terminated installation")
		MsgBox, 16, Error, User terminated installation. Exting Application
		ExitApp
	}
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
