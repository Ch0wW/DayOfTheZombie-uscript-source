// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIHorzScrollZone
//  Parent: GUI.GUIComponent
//
//  <Enter a description here>
// ====================================================================

class GUIHorzScrollZone extends GUIComponent
		Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	OnClick = InternalOnClick;
}

function bool InternalOnClick(GUIComponent Sender)
{
	local float perc;

	if (!IsInBounds())
		return false;

	perc = ( Controller.MouseX - ActualLeft() ) / ActualWidth();
	OnScrollZoneClick(perc);

	return true;

}


delegate OnScrollZoneClick(float Delta)		// Should be overridden
{
}

cpptext
{
		void Draw(UCanvas* Canvas);

}


defaultproperties
{
     StyleName="ScrollZone"
     bAcceptsInput=True
     bCaptureMouse=True
     bNeverFocus=True
     bRepeatClick=True
}
