// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIPanel
//
//  The GUI panel is a visual control that holds components.  All
//  components who are children of the GUIPanel are bound to the panel
//  by default.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIPanel extends GUIMultiComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var(Menu)	Material	Background;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;

	Super.Initcomponent(MyController, MyOwner);

	for (i=0;i<Controls.length;i++)
	{
		Controls[i].bBoundToParent=true;
		Controls[i].bScaleToParent=true;
	}

    MapControls();

}

event MenuStateChange(eMenuState Newstate)
{
	Super(GUIComponent).MenuStateChange(NewState);	// Skip the Multicomp's state change
}

cpptext
{
		void Draw(UCanvas* Canvas);
		UBOOL PerformHitTest(INT MouseX, INT MouseY);


}


defaultproperties
{
     PropagateVisibility=True
     bTabStop=False
}
