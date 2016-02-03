// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.moNumericEdit
//  Parent: GUI.GUIMenuOption
//
//  <Enter a description here>
// ====================================================================

class moNumericEdit extends GUIMenuOption;

var		GUINumericEdit	MyNumericEdit;
var		int				MinValue, MaxValue;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	MyNumericEdit = GUINumericEdit(MyComponent);
	MyNumericEdit.MinValue = MinValue;
	MyNumericEdit.MaxValue = MaxValue;
	MyNumericEdit.CalcMaxLen();
	MyNumericEdit.OnChange = InternalOnChange;
}

function SetValue(int V)
{
	MyNumericEdit.SetValue(v);
}

function int GetValue()
{
	return int(MyNumericEdit.Value);
}

function InternalOnChange(GUIComponent Sender)
{
	OnChange(self);
}

defaultproperties
{
     ComponentClassName="GUI.GUINumericEdit"
     OnClickSound=CS_Click
}
