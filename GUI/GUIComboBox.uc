// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//	Class: GUI.GUIComboBox
//
//  A Combination of an EditBox, a Down Arrow Button and a ListBox
//
//  Written by Michel Comeau
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIComboBox extends GUIMultiComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Automated 	GUIEditBox 		Edit;
var Automated 	GUIComboButton 	MyShowListBtn;
var Automated 	GUIListBox 		MyListBox;
var				GUIList			List;


var(Menu)	int			MaxVisibleItems;
var(Menu)	bool		bListItemsOnly;
var(Menu)	bool		bShowListOnFocus;
var(Menu)	bool		bReadOnly;

var		int		Index;
var		string	TextStr;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	List 			  = MyListBox.List;
	List.OnChange 	  = ItemChanged;
	List.bHotTrack	  = true;
	List.OnClickSound = CS_Click;
	List.OnCLick 	  = InternalListClick;
    List.OnInvalidate = InternalOnInvalidate;

    MyListBox.Hide();

	Edit.OnChange 			= TextChanged;
	Edit.OnMousePressed 	= InternalEditPressed;
	Edit.INIOption  		= INIOption;
	Edit.INIDefault 		= INIDefault;
	Edit.bReadOnly  		= bReadOnly;

	List.OnDeActivate = InternalListDeActivate;

	MyShowListBtn.OnClick = ShowListBox;
	MyShowListBtn.FocusInstead = List;

    SetHint(Hint);

}

function SetHint(string NewHint)
{
	local int i;
	Super.SetHint(NewHint);

    for (i=0;i<Controls.Length;i++)
    	Controls[i].SetHint(NewHint);
}

function InternalListDeActivate()
{
	if (!Edit.bPendingFocus)
		MyListBox.Hide();
}

function InternalOnInvalidate(GUIComponent Who)
{
	if ( Who != Controller.ActivePage )
    	return;

	MyListBox.Hide();
    Edit.SetFocus(None);
}

function InternalEditPressed(GUIComponent Sender, bool bRepeat)
{
	if ( (Edit.bReadOnly) && (!bRepeat) )
	{
		Controller.bIgnoreNextRelease = true;

		if ( !MyListBox.bVisible )
		{
			ShowListBox(Self);
		}
		else
			HideListBox();
	}

	return;
}

function bool InternalListClick(GUIComponent Sender)
{
	List.InternalOnClick(Sender);
	Edit.SetFocus(none);
	return true;

}

function HideListBox()
{
	MyListBox.Hide();
}

event SetVisibility(bool bIsVisible)
{
	Super.SetVisibility(bIsVisible);

	Edit.SetVisibility(bIsVisible);
	MyShowListBtn.SetVisibility(bIsVisible);
	MyListBox.SetVisibility(false);
}


function bool ShowListBox(GUIComponent Sender)
{

	MyListBox.SetVisibility(!MyListBox.bVisible);

	if (MyListBox.bVisible)
		List.SetFocus(none);

	return true;
}

function ItemChanged(GUIComponent Sender)
{
	Edit.SetText(List.SelectedText());
	Index = List.Index;
}

function TextChanged(GUIComponent Sender)
{
	TextStr = Edit.TextStr;
	OnChange(self);
}

function SetText(string NewText)
{
	Edit.SetText(NewText);
	List.Find(NewText);
}

function string Get()
{
	local string temp;

	temp = List.Get();

	if ( temp~=Edit.GetText() )
		return Edit.GetText();
	else
		return temp;
}

function string GetText() {
	return self.Get();
}

function object GetObject()
{
	local string temp;

	temp = List.Get();

	if ( temp~=Edit.GetText() )
		return List.GetObject();
	else
		return none;
}

function string GetExtra()
{
	local string temp;

	temp = List.Get();

	if ( temp~=Edit.GetText() )
		return List.GetExtra();
	else
		return "";
}

function SetIndex(int I)
{
	List.SetIndex(i);
}

function int GetIndex()
{
	return List.Index;
}

function AddItem(string Item, Optional object Extra, Optional string Str)
{
	List.Add(Item,Extra,Str);
}

function RemoveItem(int item, optional int Count)
{
	List.Remove(item, Count);
}

function string GetItem(int index)
{
	List.SetIndex(Index);
	return List.Get();
}

function object GetItemObject(int index)
{
	List.SetIndex(Index);
	return List.GetObject();
}

function string find(string Text, optional bool bExact)
{
	return List.Find(Text,bExact);
}

function int ItemCount()
{
	return List.ItemCount;
}

function ReadOnly(bool b)
{
	Edit.bReadOnly = b;
}

function InternalOnMousePressed(GUIComponent Sender, bool bRepeat)
{
	if (!bRepeat)
    {
		MyListBox.Show();
    }
}

cpptext
{
		void PreDraw(UCanvas* Canvas);


}


defaultproperties
{
     Begin Object Class=GUIEditBox Name=EditBox1
         Name="EditBox1"
     End Object
     Edit=GUIEditBox'GUI.GUIComboBox.EditBox1'
     Begin Object Class=GUIComboButton Name=ShowList
         Name="ShowList"
     End Object
     MyShowListBtn=GUIComboButton'GUI.GUIComboBox.ShowList'
     Begin Object Class=GUIListBox Name=ListBox1
         StyleName="ComboListBox"
         bVisible=False
         Name="ListBox1"
     End Object
     MyListBox=GUIListBox'GUI.GUIComboBox.ListBox1'
     MaxVisibleItems=8
     PropagateVisibility=True
     WinHeight=0.060000
}
