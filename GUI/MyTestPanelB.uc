// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MyTestPanelB extends GUITabPanel;

var Automated moComboBox ComboTest;
var Automated GUILabel lbListBoxTest;
var Automated GUIListBox ListBoxTest;
var Automated GUILabel lbScrollTextBox;
var Automated GUIScrollTextBox ScrollTextBoxTest;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i,c;
    local string t;

	Super.Initcomponent(MyController, MyOwner);

    c = rand(30)+5;
    for (i=0;i<c;i++)
    	ComboTest.AddItem("Test "$Rand(100));


    c = rand(75)+25;
    for (i=0;i<c;i++)
    	ListBoxTest.List.Add("Testing "$Rand(100));

	ListBoxTest.SetFriendlyLabel(lbListBoxTest);


    c = rand(75)+25;
    for (i=0;i<c;i++)
    {
    	if (t!="")
        	t = T $"|";

    	t = t$"All Work & No Play Makes Me Sad";
    }

    ScrollTextBoxTest.SetContent(t);
	ScrollTextBoxTest.SetFriendlyLabel(lbScrollTextBox);

}

defaultproperties
{
     Begin Object Class=moComboBox Name=caOne
         Caption="moComboBox Test"
         ComponentJustification=TXTA_Left
         Hint="This is a combo box"
         WinTop=0.079339
         WinLeft=0.031250
         Name="caOne"
     End Object
     ComboTest=moComboBox'GUI.MyTestPanelB.caOne'
     Begin Object Class=GUILabel Name=laTwo
         Caption="ListBox Test"
         WinTop=0.200000
         WinLeft=0.031250
         WinWidth=0.156250
         WinHeight=0.050000
         Name="laTwo"
     End Object
     lbListBoxTest=GUILabel'GUI.MyTestPanelB.laTwo'
     Begin Object Class=GUIListBox Name=caTwo
         bVisibleWhenEmpty=True
         WinTop=0.251653
         WinLeft=0.031250
         WinWidth=0.445313
         WinHeight=0.706250
         TabOrder=1
         Name="caTwo"
     End Object
     ListBoxTest=GUIListBox'GUI.MyTestPanelB.caTwo'
     Begin Object Class=GUILabel Name=laThree
         Caption="Scrolling Text Test"
         WinTop=0.200000
         WinLeft=0.515625
         WinWidth=0.257813
         WinHeight=0.050000
         Name="laThree"
     End Object
     lbScrollTextBox=GUILabel'GUI.MyTestPanelB.laThree'
     Begin Object Class=GUIScrollTextBox Name=caThree
         CharDelay=0.050000
         bVisibleWhenEmpty=True
         WinTop=0.251653
         WinLeft=0.515625
         WinWidth=0.445313
         WinHeight=0.706250
         TabOrder=2
         Name="caThree"
     End Object
     ScrollTextBoxTest=GUIScrollTextBox'GUI.MyTestPanelB.caThree'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinTop=55.980499
     WinHeight=0.807813
}
