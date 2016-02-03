// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIImage
//
//	GUILabel - A text label that get's displayed.  By default, it
//  uses the default font, however you can override it if you wish.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUILabel extends GUIComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var(Menu)	localized 	string				Caption;			// The text to display
var(Menu)				eTextAlign			TextAlign;			// How is the text aligned in it's bounding box
var(Menu)				color				TextColor;			// The Color to display this in.
var(Menu)				color				FocusedTextColor;	// The Color to display this in.
var(Menu)				EMenuRenderStyle	TextStyle;			// What canvas style to use
var(Menu)				string 				TextFont;			// The Font to display it in
var(Menu)				bool				bTransparent;		// Draw a Background for this label
var(Menu)				bool				bMultiLine;			// Will cut content to display on multiple lines when too long
var(Menu)				color				BackColor;			// Background color for this label

cpptext
{
		void Draw(UCanvas* Canvas);

}


defaultproperties
{
     TextColor=(B=255,G=255,R=255,A=255)
     FocusedTextColor=(G=255,R=255,A=255)
     TextStyle=MSTY_Normal
     TextFont="MenuFont"
     bTransparent=True
     BackColor=(A=255)
     RenderWeight=0.100000
}
