// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIMultiComponent
//
//	MenuOptions combine a label and any other component in to 1 single
//  control.  The Label is left justified, the control is right.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIMenuOption extends GUIMultiComponent
		Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var(Menu)	string			ComponentClassName;		// Name of the component to spawn
var(Menu)	localized string	Caption;				// Caption for the label
var(Menu)	string			LabelFont;				// Name of the Font for the label
var(Menu)	Color			LabelColor;				// Color for the label
var(Menu)	bool			bHeightFromComponent;	// Get the Height of this component from the Component
var(Menu)	float			CaptionWidth;			// How big should the Caption be
var(Menu)	float			ComponentWidth;			// How big should the Component be (-1 = 1-CaptionWidth)
var(Menu)	bool			bFlipped;				// Draw the Component to the left of the caption
var(Menu)	eTextAlign		LabelJustification;		// How do we justify the label
var(Menu)	eTextAlign		ComponentJustification;	// How do we justify the label
var(Menu)	bool			bSquare;				// Use the Height for the Width
var(Menu)	bool			bVerticalLayout;		// Layout controls vertically

var			GUILabel		MyLabel;				// Holds the label
var			GUIComponent	MyComponent;			// Holds the component


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	// Create the two components

    MyLabel = GUILabel(AddComponent("GUI.GUILabel"));
	if (MyLabel==None)
	{
		log("Failed to create "@self@" due to problems creating GUILabel");
		return;
	}

	if (bFlipped)
	{
		if (LabelJustification==TXTA_Left)
			LabelJustification=TXTA_Right;

		else if (LabelJustification==TXTA_Right)
			LabelJustification=TXTA_Left;

		if (ComponentJustification==TXTA_Left)
			ComponentJustification=TXTA_Right;

		else if (ComponentJustification==TXTA_Right)
   			ComponentJustification=TXTA_Left;
	}

	MyLabel.Caption  	= Caption;
	MyLabel.TextFont 	= LabelFont;
	MyLabel.TextColor	= LabelColor;
	MyLabel.TextAlign   = LabelJustification;
	MyLabel.StyleName 	= "TextLabel";

    MyComponent = AddComponent(ComponentClassName);
	// Check for errors
	if (MyComponent == None)
	{
		log("Could not create requested menu component"@ComponentClassName);
		return;
	}

	MyComponent.SetHint(Hint);

	if (bHeightFromComponent && !bVerticalLayout)
		WinHeight = MyComponent.WinHeight;

	MyComponent.OnChange = InternalOnChange;
	MyComponent.SetFriendlyLabel(MyLabel);



    MyComponent.bTabStop = true;
    MyComponent.TabOrder = 1;
}

function InternalOnChange(GUIComponent Sender)
{
	OnChange(self);
}

cpptext
{
		void PreDraw(UCanvas* Canvas);

}


defaultproperties
{
     LabelFont="MenuFont"
     LabelColor=(B=255,G=255,R=255,A=255)
     bHeightFromComponent=True
     CaptionWidth=0.500000
     ComponentWidth=-1.000000
     ComponentJustification=TXTA_Right
     PropagateVisibility=True
     WinTop=0.347656
     WinLeft=0.496094
     WinWidth=0.500000
     WinHeight=0.060000
}
