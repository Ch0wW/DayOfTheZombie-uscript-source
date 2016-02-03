// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUISplitter
//
//	GUISplitters allow the user to size two other controls (usually Panels)
//
//  Written by Jack Porter
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================
class GUISplitter extends GUIPanel
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EGUISplitterType
{
	SPLIT_Vertical,
	SPLIT_Horizontal,
};

var(Menu)			EGUISplitterType	SplitOrientation;
var(Menu)			float				SplitPosition;			// 0.0 - 1.0
var					bool				bFixedSplitter;			// Can splitter be moved?
var					bool				bDrawSplitter;			// Draw the actual splitter bar
var					float				SplitAreaSize;			// size of splitter thing

var					string				DefaultPanels[2];		// Names of the default panels
var					GUIComponent		Panels[2];				// Quick Reference
var					float				MaxPercentage;			// How big can any 1 panel get

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

    if (DefaultPanels[0]!="")
	{
		Panels[0] = AddComponent(DefaultPanels[0]);
		if (DefaultPanels[1]!="")
		    Panels[1] = Addcomponent(DefaultPanels[1]);
    }

	SplitterUpdatePositions();
}

event GUIComponent AppendComponent(GUIComponent NewComp)
{
    Controls[Controls.Length] = NewComp;

    NewComp.InitComponent(Controller, Self);
	NewComp.bBoundToParent = true;
    NewComp.bScaleToParent = true;
    RemapComponents();
    return NewComp;
}

native function SplitterUpdatePositions();

cpptext
{
		void PreDraw(UCanvas* Canvas);
		void Draw(UCanvas* Canvas);
		UBOOL MouseMove(INT XDelta, INT YDelta);
		UBOOL MousePressed(UBOOL IsRepeat);
        UBOOL MouseReleased();
		UBOOL MouseHover();
		void SplitterUpdatePositions();

}


defaultproperties
{
     SplitPosition=0.500000
     bDrawSplitter=True
     SplitAreaSize=8.000000
     StyleName="SquareButton"
     bBoundToParent=True
     bScaleToParent=True
     bAcceptsInput=True
     bNeverFocus=True
}
