#SingleInstance, Force
#include JSON.ahk
;#include <Vis2> ;https://github.com/iseahound/Vis2


SetWorkingDir %A_ScriptDir%

IniWrite, 0.0.1.01, tbsettings.ini, MyTarkovBuddyVersNum, version
IniRead, IntelligenceLevel,  tbsettings.ini, IntelligenceLevel, Level
IniRead, HideoutManagementLevel,  tbsettings.ini, HideoutManagementLevel, Level

ids:={}
For key, value in query().value.data.items{
	string .= value["name"] "|"
	ids[value["name"]]:=value["id"]
}

Gui,+AlwaysOnTop
Gui, Add, GroupBox, xm ym w300 h110, --ITEM DATA--
Gui, Add, ComboBox, Sort xp+4 yp+20 w290 gDataCalc vItemData, % String
Gui, Add, Text, xp yp+25 w150 vMyTruName, Item Name
Gui, Add, Text, xp yp+15, Trader Name:
Gui, Add, Text, xp+70 yp w60 vTraderName,
Gui, Add, Text, xp-70 yp+15 , Trader Price:
Gui, Add, Text, xp+70 yp w60 vTraderPrice,
Gui, Add, Text, xp-70 yp+15 , Avg 24hr Flea Price:
Gui, Add, Text, xp+105 yp w60 vFleaPrice,

Gui, Add, GroupBox, xm ym+110 w145 h105, --FLEA DATA--
Gui, Add, Text, xp+4 yp+20, My Flea Price:
Gui, Add, Edit, xp+70 yp-2 w65 vMyFleaPrice,
Gui, Add, Text, xp-70 yp+27, # of items:
Gui, Add, Edit, xp+50 yp-4 w30 Number vCount, 1
Gui, Add, Button, xp+30 yp-1 w56 gButton, Ok
Gui, Add, Text, xp-80 yp+25, My Flea Fea:
Gui, Add, Text, xp+70 yp w60 vCustomFleaFea,
Gui, Add, Text, xp-70 yp+20 , Sub Total:
Gui, Add, Text, xp+70 yp w60 vdif,

Gui, Add, GroupBox, xm+155 ym+110 w145 h105, --BEST PROFITS--
Gui, Add, Text, xp+4 yp+20, Sell To:
Gui, Add, Text, xp+45 yp w75 vBTraderName,
Gui, Add, Text, xp-45 yp+20, Trader Price:
Gui, Add, Text, xp+65 yp w75 vTprice,
Gui, Add, Text, xp-65 yp+20, Flea Fee:
Gui, Add, Text, xp+55 yp w75 vbff,
Gui, Add, Text, xp-55 yp+20 , Total Profits:
Gui, Add, Text, xp+65 yp w80 vBprofit,

Gui, Add, GroupBox, xm ym+215 w300 h100, --SETTINGS--
Gui, Add, Text, xp+4 yp+20 , IntelCenterLevel:
Gui, Add, DropDownList, xp+83 yp-3 w35 gSaveInt vICL Choose%IntelligenceLevel%, % ListGen(3)
Gui, Add, Text, xp-84 yp+25 , HideoutManagementLevel:
Gui, Add, DropDownList, xp+130 yp-3 w36 gSaveHM vHML Choose%HideoutManagementLevel%, % ListGen(51)
Gui, Add, Text, xp-130 yp+22 w150 vMyItemID,
Gui, Add, Checkbox, yp+18 gDisable vOCR, Use Character Recgognition? ; Disabled until I can manage different screen resolutions
GuiControl, Disable, OCR ; Disabled until I can manage different screen resolutions

Gui, Show,, InDiGo's TarkovBuddy BETA
Return


/*
^L::
if (dis = 1){
	highest :=
	fleap :=
	GuiControl,,TraderName,
	GuiControl,,TraderPrice,
	Gui, Submit, NoHide
	TruName :=OCR([1261, 200, 442, 33])
	ItemID := Query2(TruName, Count, ICL, HML).value.data.items.1.id
	for k, v in Query2(TruName, Count, ICL, HML).value.data.items.1.sellfor
		if v.vendor.name = "Flea Market"{
			;msgbox vendor
			fleap := v
		}
	else if v.priceRub > highest.priceRub{
			;msgbox price
			highest := v
		}
	GuiControl,,MyItemID, % Query2(TruName, Count, ICL, HML).value.data.items.1.id
	GuiControl,,MyTruName, % TruName
	GuiControl,,TraderName, % highest["vendor","name"]
	GuiControl,,TraderPrice, % highest["priceRUB"]
	GuiControl,,FleaPrice, % fleap.priceRub
	GuiControl,,FleaFee, % Query2(TruName, Count, ICL, HML).value.data.items.1.fleamarketfee
	return
	}
else{
	msgbox, Please check OCR
	return
}
*/

Disable:
Gui, Submit, NoHide
If (dis){
	dis = 0
	GuiControl, Enable, ItemData
	return
}
else{
	GuiControl, Disable, ItemData
	dis = 1
	tooltip, CTRL + L in fleamarket to automatically find item name
	SetTimer, RemoveToolTip, -5000
	return

}

RemoveToolTip:
ToolTip
return


DataCalc:
highest :=
fleap :=
GuiControl,,TraderName,
GuiControl,,TraderPrice,
Gui, Submit, NoHide
ItemID := ids[ItemData]
GuiControl,,MyTruName, % ItemData
GuiControl,, MyItemID, % ids[ItemData]
for k, v in Query(ItemID, Count, ICL, HML).value.data.items.1.sellfor
	if v.vendor.name = "Flea Market"{
			;msgbox vendor
			fleap := v
		}
	else if v.priceRub > highest.priceRub{
			;msgbox price
			highest := v
		}
GuiControl,,TraderName, % highest["vendor","name"]
GuiControl,,TraderPrice, % highest["priceRUB"]
GuiControl,,FleaPrice, % fleap.priceRub
GuiControl,,FleaFee, % Query(ItemID, Count, ICL, HML).value.data.items.1.fleamarketfee
return

Button:
Gui, Submit, NoHide
cff := Query(ItemID, Count, ICL, HML, MyFleaPrice).value.data.items.1.fleamarketfee
GuiControl,, CustomFleaFea, % cff
GuiControl,, dif, % ((MyFleaPrice*Count) - cff)
;
if highest["priceRUB"]*Count > ((MyFleaPrice*Count) - cff){
	GuiControl,,BTraderName, % highest["vendor","name"]
	GuiControl,,TPrice,% highest["priceRUB"] " x " count
	GuiControl,,bff, No Fea
	GuiControl,,bprofit, % (highest["priceRUB"]*count) " RUB"
}
else{
	GuiControl,,BTraderName, Flea Market
	GuiControl,,TPrice, % MyFleaPrice " x " count
	GuiControl,,bff, % cff
	GuiControl,,bprofit, % ((MyFleaPrice*count) - cff)
}
return

SaveInt:
Gui, Submit, Nohide
IniWrite, %ICL%, %A_ScriptDir%\tbsettings.ini, IntelligenceLevel, Level
return

SaveHM:
Gui, Submit, Nohide
IniWrite, %HML%, %A_ScriptDir%\tbsettings.ini, HideoutManagementLevel, Level
return

^R::
Reload

GuiClose:
ExitApp


ListGen(num:=""){
	Loop %num%{
		;msgbox % A_Index
		MyListNum .= A_Index "|"
	}
	Return MyListNum
}

Query(myid="", mycount="", myicl="", myhml="", myfp="")
{

	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.Open("POST", "https://api.tarkov.dev/graphql", false)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	WinHTTP.SetRequestHeader("Accept", "gzip, deflate, br")
	WinHTTP.SetRequestHeader("Connection", "keep-alive")
	WinHTTP.SetRequestHeader("DNT", "1")
	WinHTTP.SetRequestHeader("Origin", "https://api.tarkov.dev")

	if ((myid) and (mycount) and (myicl) and (myhml) and (myfp)){
		;msgbox getting custom flea price
		;msgbox % myid " my count: " mycount " my icl: " myicl " myhml: " myhml " myfp: " myfp
		Body = {"query":"{\n  items(ids: \"%myid%\") {\n    sellFor {\n      vendor {\n        name\n      }\n      priceRUB\n    }\n    fleaMarketFee(price: %myfp% count: %mycount% intelCenterLevel: %myicl% hideoutManagementLevel: %myhml%)\n  }\n}\n"}
	}
	else if ((myid) and (mycount) and (myicl) and (myhml)){
		;msgbox getting default flea price
		;msgbox % myid " my count: " mycount " my icl: " myicl " myhml: " myhml " myfp: " myfp
		Body = {"query":"{\n  items(ids: \"%myid%\") {\n    sellFor {\n      vendor {\n        name\n      }\n      priceRUB\n    }\n    fleaMarketFee(count: %mycount% intelCenterLevel: %myicl% hideoutManagementLevel: %myhml%)\n  }\n}\n"}
	}
	else{
		;msgbox  populating items
		Body = {"query":"{\n  items{\n    name\n    id\n  }\n}"}
	}
	WinHTTP.Send(Body)
	arr := {}
	arr["Data"] := WinHTTP.ResponseText
	arr["Status"] := WinHTTP.Status
	arr["Value"] := JSON.Load(arr["Data"])
	return % arr
}

Query2(mytruname="", mycount2="", myicl2="", myhml2="")
{
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.Open("POST", "https://api.tarkov.dev/graphql", false)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	WinHTTP.SetRequestHeader("Accept", "gzip, deflate, br")
	WinHTTP.SetRequestHeader("Connection", "keep-alive")
	WinHTTP.SetRequestHeader("DNT", "1")
	WinHTTP.SetRequestHeader("Origin", "https://api.tarkov.dev")


	Body = {"query":"{\n  items(name: \"%mytruname%\"){\n    id\n    sellFor{\n      vendor{\n        name\n      }\n       priceRUB\n    }\n    fleaMarketFee(count: %mycount2% intelCenterLevel: %myicl2% hideoutManagementLevel: %myhml2%)\n  }\n}\n\n"}
	WinHTTP.Send(Body)
	;msgbox %  "searching for: " mytruname
	arr := {}
	arr["Data"] := WinHTTP.ResponseText
	arr["Status"] := WinHTTP.Status
	arr["Value"] := JSON.Load(arr["Data"])
	return % arr
}

st_printArr(array, depth=50, indentLevel="")
{
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

;curl 'https://api.tarkov.dev/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'DNT: 1' -H 'Origin: https://api.tarkov.dev' --data-binary '{"query":"{\n  items(name: \"855\"){\n    name\n    id\n    sellFor{\n      vendor{\n        name\n      }\n       priceRUB\n    }\n    fleaMarketFee(count: 1 intelCenterLevel: 1 hideoutManagementLevel: 1)\n  }\n}\n\n"}' --compressed
