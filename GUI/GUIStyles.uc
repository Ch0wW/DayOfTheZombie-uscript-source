// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIStyles
//
//	The GUIStyle is an object that is used to describe common visible
//  components of the interface.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIStyles extends GUI
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var		string				KeyName;			// This is the name of the style used for lookup
var		EMenuRenderStyle	RStyles[5];			// The render styles for each state
var		Material			Images[5];			// This array holds 1 material for each state (Blurry, Watched, Focused, Pressed, Disabled)
var		eImgStyle			ImgStyle[5];		// How should each image for each state be drawed
var		Color				FontColors[5];		// This array holds 1 font color for each state
var		Color				ImgColors[5];		// This array holds 1 image color for each state
var		GUIFont				Fonts[5];			// Holds the fonts for each state
var		int					BorderOffsets[4];	// How thick is the border
var		string				FontNames[5];		// Holds the names of the 5 fonts to use

// Set by Controller
var	bool					bRegistered;		// Used as Default only. Tells if Controller has this style registered.

// the OnDraw delegate Can be used to draw.  Return true to skip the default draw method

delegate bool OnDraw(Canvas Canvas, eMenuState MenuState, float left, float top, float width, float height);
delegate bool OnDrawText(Canvas Canvas, eMenuState MenuState, float left, float top, float width, float height, eTextAlign Align, string Text);

native function Draw(Canvas Canvas, eMenuState MenuState, float left, float top, float width, float height);
native function DrawText(Canvas Canvas, eMenuState MenuState, float left, float top, float width, float height, eTextAlign Align, string Text);

event Initialize()
{
	local int i;

	// Preset all the data if needed

	for (i=0;i<5;i++)
	{
		Fonts[i] = Controller.GetMenuFont(FontNames[i]);
	}
}

cpptext
{
		void Draw(UCanvas* Canvas, BYTE MenuState, FLOAT Left, FLOAT Top, FLOAT Width, FLOAT Height);
		void DrawText(UCanvas* Canvas, BYTE MenuState, FLOAT Left, FLOAT Top, FLOAT Width, FLOAT Height, BYTE Just, const TCHAR* Text);
		void TextSize(UCanvas* Canvas, BYTE MenuState, const TCHAR* Test, INT& XL, INT& YL);

}


defaultproperties
{
     RStyles(0)=MSTY_Normal
     RStyles(1)=MSTY_Normal
     RStyles(2)=MSTY_Normal
     RStyles(3)=MSTY_Normal
     RStyles(4)=MSTY_Normal
     ImgStyle(0)=ISTY_Stretched
     ImgStyle(1)=ISTY_Stretched
     ImgStyle(2)=ISTY_Stretched
     ImgStyle(3)=ISTY_Stretched
     ImgStyle(4)=ISTY_Stretched
     FontColors(0)=(B=255,G=255,R=255,A=255)
     FontColors(1)=(B=255,G=255,R=255,A=255)
     FontColors(2)=(B=255,G=255,R=255,A=255)
     FontColors(3)=(B=255,G=255,R=255,A=255)
     FontColors(4)=(B=128,G=128,R=128,A=255)
     ImgColors(0)=(B=255,G=255,R=255,A=255)
     ImgColors(1)=(B=255,G=255,R=255,A=255)
     ImgColors(2)=(B=255,G=255,R=255,A=255)
     ImgColors(3)=(B=255,G=255,R=255,A=255)
     ImgColors(4)=(B=128,G=128,R=128,A=255)
     BorderOffsets(0)=9
     BorderOffsets(1)=9
     BorderOffsets(2)=9
     BorderOffsets(3)=9
     FontNames(0)="MenuFont"
     FontNames(1)="MenuFont"
     FontNames(2)="MenuFont"
     FontNames(3)="MenuFont"
     FontNames(4)="MenuFont"
}
