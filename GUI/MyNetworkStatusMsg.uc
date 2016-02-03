// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  (c) 2003, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class MyNetworkStatusMsg extends GUIPage;


var automated GUIButton NetStatBackground;
var automated GUIButton NetStatOk;
var automated GUILabel 	NetStatLabel;

var bool bIgnoreEsc;

var		localized string LeaveMPButtonText;
var		localized string LeaveSPButtonText;

var		float ButtonWidth;
var		float ButtonHeight;
var		float ButtonHGap;
var		float ButtonVGap;
var		float BarHeight;
var		float BarVPos;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(Mycontroller, MyOwner);
	PlayerOwner().ClearProgressMessages();
}


function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==NetStatOk) // OK
	{
		Controller.ReplaceMenu("GUI.MyMainMenu");
	}

	return true;
}

event HandleParameters(string Param1, string Param2)
{
	NetStatLabel.Caption = Param1$"|"$Param2;
	PlayerOwner().ClearProgressMessages();
}

defaultproperties
{
     Begin Object Class=GUIButton Name=cNetStatBackground
         StyleName="SquareBar"
         bAcceptsInput=False
         bNeverFocus=True
         WinTop=0.375000
         WinHeight=0.250000
         Name="cNetStatBackground"
     End Object
     NetStatBackground=GUIButton'GUI.MyNetworkStatusMsg.cNetStatBackground'
     Begin Object Class=GUIButton Name=cNetStatOk
         Caption="OK"
         bBoundToParent=True
         WinTop=0.675000
         WinLeft=0.375000
         WinWidth=0.250000
         WinHeight=0.050000
         __OnClick__Delegate=MyNetworkStatusMsg.InternalOnClick
         Name="cNetStatOk"
     End Object
     NetStatOk=GUIButton'GUI.MyNetworkStatusMsg.cNetStatOk'
     Begin Object Class=GUILabel Name=cNetStatLabel
         TextAlign=TXTA_Center
         TextFont="HeaderFont"
         bMultiLine=True
         bBoundToParent=True
         WinTop=0.125000
         WinHeight=0.500000
         Name="cNetStatLabel"
     End Object
     NetStatLabel=GUILabel'GUI.MyNetworkStatusMsg.cNetStatLabel'
     bIgnoreEsc=True
     bRequire640x480=False
     WinTop=0.375000
     WinHeight=0.250000
}
