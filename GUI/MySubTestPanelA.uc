// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MySubTestPanelA extends GUITabPanel;

var Automated GUIMultiColumnListBox MultiColumnListBoxTest;

defaultproperties
{
     Begin Object Class=GUIMultiColumnListBox Name=Cone
         DefaultListClass="GUI.MyTestMultiColumnList"
         bVisibleWhenEmpty=True
         WinHeight=1.000000
         Name="Cone"
     End Object
     MultiColumnListBoxTest=GUIMultiColumnListBox'GUI.MySubTestPanelA.Cone'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinTop=55.980499
     WinHeight=0.807813
}
