// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MyTest2Page extends GUIPage;

var Automated moComboBox ComboTest;
var Automated moCheckBox CheckTest;
var Automated moEditBox EditTest;
var Automated moFloatEdit FloatTest;
var Automated moNumericEdit NumEditTest;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
    ComboTest.AddItem("Test1");
    ComboTest.AddItem("Test2");
    ComboTest.AddItem("Test3");
    ComboTest.AddItem("Test4");
    ComboTest.AddItem("Test5");
}

defaultproperties
{
     Begin Object Class=moComboBox Name=Cone
         Caption="moComboBox Test"
         ComponentJustification=TXTA_Left
         WinTop=0.100000
         WinLeft=0.250000
         WinHeight=0.050000
         Name="Cone"
     End Object
     ComboTest=moComboBox'GUI.MyTest2Page.Cone'
     Begin Object Class=moCheckBox Name=cTwo
         Caption="moCheckBox Test"
         CaptionWidth=0.900000
         ComponentJustification=TXTA_Left
         bSquare=True
         WinTop=0.200000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=1
         Name="cTwo"
     End Object
     CheckTest=moCheckBox'GUI.MyTest2Page.cTwo'
     Begin Object Class=moEditBox Name=cThree
         Caption="moEditBox Test"
         CaptionWidth=0.400000
         WinTop=0.300000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=2
         Name="cThree"
     End Object
     EditTest=moEditBox'GUI.MyTest2Page.cThree'
     Begin Object Class=moFloatEdit Name=cFour
         MaxValue=1.000000
         Step=0.050000
         Caption="moFloatEdit Test"
         CaptionWidth=0.725000
         ComponentJustification=TXTA_Left
         WinTop=0.400000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=3
         Name="cFour"
     End Object
     FloatTest=moFloatEdit'GUI.MyTest2Page.cFour'
     Begin Object Class=moNumericEdit Name=cFive
         MinValue=1
         MaxValue=16
         Caption="moNumericEdit Test"
         CaptionWidth=0.600000
         WinTop=0.500000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=4
         Name="cFive"
     End Object
     NumEditTest=moNumericEdit'GUI.MyTest2Page.cFive'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinHeight=1.000000
}
