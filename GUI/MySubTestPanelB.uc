// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MySubTestPanelB extends GUITabPanel;

var Automated GUIListBox ListBoxTest;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i,c;

	Super.Initcomponent(MyController, MyOwner);

    c = rand(75)+25;
    for (i=0;i<c;i++)
    	ListBoxTest.List.Add("All Work & No Play Makes Me Sad");

}

defaultproperties
{
     Begin Object Class=GUIListBox Name=Cone
         bVisibleWhenEmpty=True
         WinHeight=1.000000
         Name="Cone"
     End Object
     ListBoxTest=GUIListBox'GUI.MySubTestPanelB.Cone'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinTop=55.980499
     WinHeight=0.807813
}
