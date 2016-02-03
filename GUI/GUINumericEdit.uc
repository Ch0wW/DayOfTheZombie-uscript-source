// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//	Class: GUI. UT2NumericEdit
//
//  A Combination of an EditBox and 2 spinners
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUINumericEdit extends GUIMultiComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Automated GUIEditBox MyEditBox;
var Automated GUISpinnerButton MyPlus;
var Automated GUISpinnerButton MyMinus;

var(Menu)	string				Value;
var(Menu)	bool				bLeftJustified;
var(Menu)	int					MinValue;
var(Menu)	int					MaxValue;
var(Menu)	int					Step;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

	Super.Initcomponent(MyController, MyOwner);

	MyEditBox.OnChange = EditOnChange;
	MyEditBox.SetText(Value);
	MyEditBox.OnKeyEvent = EditKeyEvent;

	CalcMaxLen();

	MyPlus.OnClick = SpinnerPlusClick;
	MyPlus.FocusInstead = MyEditBox;
	MyMinus.OnClick = SpinnerMinusClick;
	MyMinus.FocusInstead = MyEditBox;

    SetHint(Hint);

}

function CalcMaxLen()
{
	local int digitcount,x;

	digitcount=1;
	x=10;
	while (x<MaxValue)
	{
		digitcount++;
		x*=10;
	}

	MyEditBox.MaxWidth = DigitCount;
}
function SetValue(int V)
{
	if (v<MinValue)
		v=MinValue;

	if (v>MaxValue)
		v=MaxValue;

	MyEditBox.SetText(""$v);
}

function bool SpinnerPlusClick(GUIComponent Sender)
{
	local int v;

	v = int(Value) + Step;
	if (v>MaxValue)
	  v = MaxValue;

	MyEditBox.SetText(""$v);
	return true;
}

function bool SpinnerMinusClick(GUIComponent Sender)
{
	local int v;

	v = int(Value) - Step;
	if (v<MinValue)
		v=MinValue;

	MyEditBox.SetText(""$v);
	return true;
}

function bool EditKeyEvent(out byte Key, out byte State, float delta)
{
	if ( (key==0xEC) && (State==3) )
	{
		SpinnerPlusClick(none);
		return true;
	}

	if ( (key==0xED) && (State==3) )
	{
		SpinnerMinusClick(none);
		return true;
	}

	return MyEditBox.InternalOnKeyEvent(Key,State,Delta);
}

function EditOnChange(GUIComponent Sender)
{
	Value = MyEditBox.TextStr;
    OnChange(Sender);
}

function SetHint(string NewHint)
{
	local int i;
	Super.SetHint(NewHint);

    for (i=0;i<Controls.Length;i++)
    	Controls[i].SetHint(NewHint);
}

cpptext
{
		void Draw(UCanvas* Canvas);

}


defaultproperties
{
     Begin Object Class=GUIEditBox Name=cMyEditBox
         bIntOnly=True
         Name="cMyEditBox"
     End Object
     MyEditBox=GUIEditBox'GUI.GUINumericEdit.cMyEditBox'
     Begin Object Class=GUISpinnerButton Name=cMyPlus
         PlusButton=True
         Name="cMyPlus"
     End Object
     MyPlus=GUISpinnerButton'GUI.GUINumericEdit.cMyPlus'
     Begin Object Class=GUISpinnerButton Name=cMyMinus
         Name="cMyMinus"
     End Object
     MyMinus=GUISpinnerButton'GUI.GUINumericEdit.cMyMinus'
     Value="0"
     Step=1
     PropagateVisibility=True
     bAcceptsInput=True
     WinHeight=0.060000
}
