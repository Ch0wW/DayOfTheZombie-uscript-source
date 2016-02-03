// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//	GUITabButton - A Tab Button has an associated Tab Control, and
//  TabPanel.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUITabPanel extends GUIPanel
		Native Abstract;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


var(Menu)	bool			bFillHeight;	// If true, the panel will set it's height = Top - ClipY
var			GUITabButton	MyButton;

function InitPanel();	// Should be Subclassed
function OnDestroyPanel(optional bool bCancelled)	// Always call Super.OnDestroyPanel()
{
	MyButton = None;
}

function ShowPanel(bool bShow)	// Show Panel should be subclassed if any special processing is needed
{
	SetVisibility(bShow);
}

function bool CanShowPanel()	// Subclass this function to change selection behavior of the tab
{
	return true;
}

cpptext
{
		void PreDraw(UCanvas* Canvas);

}


defaultproperties
{
     PropagateVisibility=False
}
