// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class MyTestPanelA extends GUITabPanel;

var Automated moCheckBox CheckTest;
var Automated moEditBox EditTest;
var Automated moFloatEdit FloatTest;
var Automated moNumericEdit NumEditTest;
var Automated GUILabel lbSliderTest;
var Automated GUISlider SliderTest;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

	CheckTest.SetLinkOverrides(CheckTest,EditTest,CheckTest,CheckTest);
    EditTest.SetLinkOverrides( CheckTest,FloatTest,EditTest,EditTest);
    FloatTest.SetLinkOverrides(EditTest,NumEditTest,FloatTest,FloatTest);
    NumEditTest.SetLinkOverrides(FloatTest,SliderTest,NumEditTest,NumEditTest);
    SliderTest.SetLinkOverrides(NumEditTest,SliderTest,SliderTest,SliderTest);

	Super.InitComponent(MyController,MyOwner);
    SliderTest.SetFriendlyLabel(lbSliderTest);
}

defaultproperties
{
     Begin Object Class=moCheckBox Name=cTwo
         Caption="moCheckBox Test"
         CaptionWidth=0.900000
         ComponentJustification=TXTA_Left
         bSquare=True
         Hint="This is a check Box"
         WinTop=0.200000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=1
         Name="cTwo"
     End Object
     CheckTest=moCheckBox'GUI.MyTestPanelA.cTwo'
     Begin Object Class=moEditBox Name=cThree
         Caption="moEditBox Test"
         CaptionWidth=0.400000
         Hint="This is an Edit Box"
         WinTop=0.300000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=2
         Name="cThree"
     End Object
     EditTest=moEditBox'GUI.MyTestPanelA.cThree'
     Begin Object Class=moFloatEdit Name=cFour
         MaxValue=1.000000
         Step=0.050000
         Caption="moFloatEdit Test"
         CaptionWidth=0.725000
         ComponentJustification=TXTA_Left
         Hint="This is a FLOAT numeric Edit Box"
         WinTop=0.500000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=3
         Name="cFour"
     End Object
     FloatTest=moFloatEdit'GUI.MyTestPanelA.cFour'
     Begin Object Class=moNumericEdit Name=cFive
         MinValue=1
         MaxValue=16
         Caption="moNumericEdit Test"
         CaptionWidth=0.600000
         Hint="This is an INT numeric Edit box"
         WinTop=0.400000
         WinLeft=0.250000
         WinHeight=0.050000
         TabOrder=4
         Name="cFive"
     End Object
     NumEditTest=moNumericEdit'GUI.MyTestPanelA.cFive'
     Begin Object Class=GUILabel Name=laSix
         Caption="Slider Test"
         TextAlign=TXTA_Center
         WinTop=0.654545
         WinLeft=0.375000
         WinWidth=0.226563
         WinHeight=0.050000
         Name="laSix"
     End Object
     lbSliderTest=GUILabel'GUI.MyTestPanelA.laSix'
     Begin Object Class=GUISlider Name=cSix
         MaxValue=1.000000
         Hint="This is a Slider Test."
         WinTop=0.713997
         WinLeft=0.367188
         WinWidth=0.250000
         TabOrder=5
         Name="cSix"
     End Object
     SliderTest=GUISlider'GUI.MyTestPanelA.cSix'
     Background=Texture'GUIContent.Menu.EpicLogo'
     WinTop=55.980499
     WinHeight=0.807813
}
