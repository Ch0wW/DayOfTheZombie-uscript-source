// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MyTestPage extends GUIPage;

#exec OBJ LOAD FILE=GUIContent.utx

var Automated GUITitleBar TabHeader;
var Automated GUITabControl TabC;
var Automated GUITitleBar TabFooter;
var Automated GUIButton BackButton;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

	Super.Initcomponent(MyController, MyOwner);

	TabHeader.DockedTabs = TabC;
    TabC.AddTab("Component Test","GUI.MyTestPanelA",,"Test of many non-list components");
    TabC.AddTab("List Tests","GUI.MyTestPanelB",,"Test of list components");
    TabC.AddTab("Splitter","GUI.MyTestPanelC",,"Test of the Splitter component");

}

event Closed(GUIComponent Sender, bool bCancelled)
{
	Super.Closed(Sender,bCancelled);
    Controller.MouseEmulation(false);
}

function TabChange(GUIComponent Sender)
{
	if (GUITabButton(Sender)==none)
		return;

	TabHeader.Caption = "Testing : "$GUITabButton(Sender).Caption;
}

event ChangeHint(string NewHint)
{
	TabFooter.Caption = NewHint;
}


function bool ButtonClicked(GUIComponent Sender)
{
	Controller.CloseMenu(true);
	return true;
}

event NotifyLevelChange()
{
	Controller.CloseMenu(true);
}

defaultproperties
{
     Begin Object Class=GUITitleBar Name=MyHeader
         Caption="Settings"
         Effect=Texture'GUIContent.Menu.BorderBoxF'
         StyleName="Header"
         WinTop=0.005414
         WinHeight=36.000000
         Name="MyHeader"
     End Object
     TabHeader=GUITitleBar'GUI.MyTestPage.MyHeader'
     Begin Object Class=GUITabControl Name=MyTabs
         bDockPanels=True
         TabHeight=0.040000
         bAcceptsInput=True
         WinTop=0.250000
         WinHeight=48.000000
         __OnChange__Delegate=MyTestPage.TabChange
         Name="MyTabs"
     End Object
     TabC=GUITabControl'GUI.MyTestPage.MyTabs'
     Begin Object Class=GUITitleBar Name=MyFooter
         Justification=TXTA_Center
         bUseTextHeight=False
         StyleName="Footer"
         WinTop=0.942397
         WinLeft=0.120000
         WinWidth=0.880000
         WinHeight=0.055000
         Name="MyFooter"
     End Object
     TabFooter=GUITitleBar'GUI.MyTestPage.MyFooter'
     Begin Object Class=GUIButton Name=MyBackButton
         Caption="BACK"
         StyleName="SquareMenuButton"
         Hint="Return to Previous Menu"
         WinTop=0.942397
         WinWidth=0.120000
         WinHeight=0.055000
         __OnClick__Delegate=MyTestPage.ButtonClicked
         Name="MyBackButton"
     End Object
     BackButton=GUIButton'GUI.MyTestPage.MyBackButton'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinHeight=1.000000
}
