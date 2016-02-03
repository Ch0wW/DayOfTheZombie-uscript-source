// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MyTestPanelC extends GUITabPanel;

var Automated GUISplitter MainSplitter;

function ShowPanel(bool bShow)	// Show Panel should be subclassed if any special processing is needed
{
	Super.ShowPanel(bShow);
   	Controller.MouseEmulation(bShow);
}

defaultproperties
{
     Begin Object Class=GUISplitter Name=Cone
         DefaultPanels(0)="GUI.MySubTestPanelA"
         DefaultPanels(1)="GUI.MySubTestPanelB"
         MaxPercentage=0.800000
         WinHeight=1.000000
         Name="Cone"
     End Object
     MainSplitter=GUISplitter'GUI.MyTestPanelC.Cone'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinTop=55.980499
     WinHeight=0.807813
}
