// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIListBox
//
//  The GUIListBoxBase is a wrapper for a GUIList and it's ScrollBar
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================
class GUIListBox extends GUIListBoxBase
	native;

var	Automated GUIList List;	// For Quick Access;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
    InitBaseList(List);
	List.OnClick=InternalOnClick;
	List.OnClickSound=CS_Click;
	List.OnChange=InternalOnChange;

}

function bool InternalOnClick(GUIComponent Sender)
{
	List.InternalOnClick(Sender);
	OnClick(Self);
	return true;
}

function InternalOnChange(GUIComponent Sender)
{
	OnChange(Self);
}

function int ItemCount()
{
	return List.ItemCount;
}

defaultproperties
{
     Begin Object Class=GUIList Name=TheList
         Name="TheList"
     End Object
     List=GUIList'GUI.GUIListBox.TheList'
}
