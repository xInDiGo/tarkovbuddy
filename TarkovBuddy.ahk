#SingleInstance, Force
#Include JSON.ahk
;#include <Vis2>

SetWorkingDir %A_ScriptDir%
IniWrite, 0.0.1.0, tbsettings.ini, MyTarkovBuddyVersNum, version
;FileAppend, [MyTarkovBuddyVersNum] Version=0.0.1.0, tbsettings.ini


ids:={}
For key, value in query().value.data.items{
	string .= value["name"] "|"
	ids[value["name"]]:=value["id"]
}

Gui,+AlwaysOnTop
Gui, Add, CheckBox, gDisable vOCR, Use Character Recgognition?
Gui, Add, ComboBox, Sort x10 y20 w160 h250 gDataCalc vItemData,% String
Gui, Add, Text, x177 y16 w25, Number of items
Gui, Add, Edit, x220 y20 w25 Number vCount, 1
Gui, Add, Text, x10 y50 w50 , ItemName:
Gui, Add, Text, x80 y50 w150 vMyTruName,
Gui, Add, Text, x10 y70 w50 , Item ID:
Gui, Add, Text, x80 y70 w150 vMyItemID,
Gui, Add, Text, x10  y90 w65, Trader Name:
Gui, Add, Text, x80 y90 w60 vTraderName,
Gui, Add, Text, x10  y110 w65, Trader Price:
Gui, Add, Text, x80 y110 w60 vTraderPrice,
Gui, Add, Text, x10 y130 w65, Flea Price:
Gui, Add, Text, x80 y130 w60 vFleaPrice,

Gui, Add, Text, x195 y90 w70, My Flea Price:
Gui, Add, Edit, x190 y105 w60 number vMyFleaPrice,
Gui, Add, Button, x250 y104 gButton, Ok
Gui, Add, Text, x190 y130 w65, My Flea Fea:
Gui, Add, Text, x200 y145 w60 vCustomFleaFea,
Gui, Add, Text, x200 y160 w65, Sub Total:
Gui, Add, Text, x200 y175 w60 vdif,

Gui, Add, Text, x10 y130 w80, Flea Fee:
Gui, Add, Text, x80 y130 w60 vFleaFee,

Gui, Add, Text, x10 y150 w150, IntelCenterLevel:
Gui, Add, ComboBox, x100 y145 w35 vICL, 1|2|3||
Gui, Add, Text, x10 y170 w150, HideoutManagementLevel:
Gui, Add, ComboBox, x145 y165 w35 h135 vHML, 1|2|3|4|5|6|7|8|9|10||11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51

Gui, Add, Text, x75 y190 w100, ---BEST PROFITS---
Gui, Add, Text, x10  y215 w80, Trader:
Gui, Add, Text, x80 y215 w150 vBTraderName,
Gui, Add, Text, x10  y235 w80, Price:
Gui, Add, Text, x80 y235 w150 vTprice,
Gui, Add, Text, x10 y255 w80, Flea Fee:
Gui, Add, Text, x80 y255 w100 vbff,
Gui, Add, Text, x10 y275 w100, Total Profits:
Gui, Add, Text, x80 y275 w100 vBprofit,
Gui, Show, h325 , InDiGo's TarkovBuddy BETA
return



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
	GuiControl,,TPrice,% highest["priceRUB"] " x " count " = " (highest["priceRUB"]*count) " RUB"
	GuiControl,,bff, No Fea
	GuiControl,,bprofit, % (highest["priceRUB"]*count) " RUB"
}
else{
	GuiControl,,BTraderName, Flea Market
	GuiControl,,TPrice, % MyFleaPrice " x " count " = " (MyFleaPrice*count) " RUB"
	GuiControl,,bff, % cff
	GuiControl,,bprofit, % ((MyFleaPrice*count) - cff)
}
return

^R::
Reload

GuiClose:
ExitApp

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
