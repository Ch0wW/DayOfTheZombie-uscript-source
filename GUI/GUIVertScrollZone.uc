// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIVertScrollZone
//
//  The VertScrollZone is the background zone for a vertical scrollbar.
//  When the user clicks on the zone, it caculates it's percentage.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIVertScrollZone extends GUIComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	OnClick = InternalOnClick;
}

function bool InternalOnClick(GUIComponent Sender)
{
	local float perc;

	if (!IsInBounds())
		return false;

	perc = ( Controller.MouseY - ActualTop() ) / ActualHeight();
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
     RenderWeight=0.250000
}
