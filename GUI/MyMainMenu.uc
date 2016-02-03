// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  (c) 2003, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class MyMainMenu extends GUIPage;

#exec OBJ LOAD FILE=GUIContent.utx

var automated 	GUIButton	TestButton1;
var automated 	GUIButton	TestButton2;
var automated 	GUIButton	QuitButton;

var bool	AllowClose;

function bool MyKeyEvent(out byte Key,out byte State,float delta)
{
	if(Key == 0x1B && State == 1)	// Escape pressed
	{
		AllowClose = true;
		return true;
	}
	else
		return false;
}

function bool CanClose(optional Bool bCancelled)
{
	if(AllowClose)
		Controller.OpenMenu("GUI.MyQuitPage");

	return false;
}


function bool ButtonClick(GUIComponent Sender)
{
	local GUIButton Selected;

	if (GUIButton(Sender) != None)
		Selected = GUIButton(Sender);

	if (Selected == None) return false;

	switch (Selected)
	{
		case TestButton1:
			return Controller.OpenMenu("GUI.MyTest2Page"); break;
		case TestButton2:
			return Controller.OpenMenu("GUI.MyTestPage"); break;
		case QuitButton:
			return Controller.OpenMenu("GUI.MyQuitPage"); break;
	}
	return false;
}

defaultproperties
{
     Begin Object Class=GUIButton Name=cTestButton1
         Caption="Test 1"
         StyleName="TextButton"
         Hint="The First Test"
         WinTop=0.334635
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.075000
         bFocusOnWatch=True
         __OnClick__Delegate=MyMainMenu.ButtonClick
         Name="cTestButton1"
     End Object
     TestButton1=GUIButton'GUI.MyMainMenu.cTestButton1'
     Begin Object Class=GUIButton Name=cTestButton2
         Caption="Test 2"
         StyleName="TextButton"
         Hint="More Tests"
         WinTop=0.506251
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.075000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=MyMainMenu.ButtonClick
         Name="cTestButton2"
     End Object
     TestButton2=GUIButton'GUI.MyMainMenu.cTestButton2'
     Begin Object Class=GUIButton Name=cQuitButton
         Caption="QUIT"
         StyleName="TextButton"
         Hint="Exit"
         WinTop=0.905725
         WinLeft=0.391602
         WinWidth=0.205078
         WinHeight=0.042773
         TabOrder=5
         bFocusOnWatch=True
         __OnClick__Delegate=MyMainMenu.ButtonClick
         Name="cQuitButton"
     End Object
     QuitButton=GUIButton'GUI.MyMainMenu.cQuitButton'
     Background=Texture'GUIContent.Menu.EpicLogo'
     bAllowedAsLast=True
     bDisconnectOnOpen=True
     __OnCanClose__Delegate=MyMainMenu.CanClose
     WinHeight=1.000000
     __OnKeyEvent__Delegate=MyMainMenu.MyKeyEvent
}
