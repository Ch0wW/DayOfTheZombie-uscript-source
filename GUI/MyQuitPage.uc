// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  (c) 2003, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class MyQuitPage extends GUIPage;

var automated GUIButton QuitBackground;
var automated GUIButton YesButton;
var automated GUIButton NoButton;
var automated GUILabel 	QuitDesc;

function bool InternalOnClick(GUIComponent Sender)
{
	if (Sender==YesButton)
	{
		if(PlayerOwner().Level.IsDemoBuild())
			Controller.ReplaceMenu("GUI.UT2DemoQuitPage");
		else
			PlayerOwner().ConsoleCommand("exit");
	}
	else
		Controller.CloseMenu(false);

	return true;
}

defaultproperties
{
     Begin Object Class=GUIButton Name=cQuitBackground
         StyleName="SquareBar"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinHeight=1.000000
         Name="cQuitBackground"
     End Object
     QuitBackground=GUIButton'GUI.MyQuitPage.cQuitBackground'
     Begin Object Class=GUIButton Name=cYesButton
         Caption="YES"
         bBoundToParent=True
         WinTop=0.750000
         WinLeft=0.125000
         WinWidth=0.200000
         __OnClick__Delegate=MyQuitPage.InternalOnClick
         Name="cYesButton"
     End Object
     YesButton=GUIButton'GUI.MyQuitPage.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="NO"
         bBoundToParent=True
         WinTop=0.750000
         WinLeft=0.650000
         WinWidth=0.200000
         TabOrder=1
         __OnClick__Delegate=MyQuitPage.InternalOnClick
         Name="cNoButton"
     End Object
     NoButton=GUIButton'GUI.MyQuitPage.cNoButton'
     Begin Object Class=GUILabel Name=cQuitDesc
         Caption="Are you sure you wish to quit?"
         TextAlign=TXTA_Center
         TextColor=(B=0,G=180,R=220)
         TextFont="HeaderFont"
         WinTop=0.400000
         WinHeight=32.000000
         Name="cQuitDesc"
     End Object
     QuitDesc=GUILabel'GUI.MyQuitPage.cQuitDesc'
     bRequire640x480=False
     WinTop=0.375000
     WinHeight=0.250000
}
