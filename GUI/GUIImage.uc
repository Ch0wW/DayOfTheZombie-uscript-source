// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIImage
//
//	GUIImage - A graphic image used by the menu system.  It encapsulates
//	Material.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIImage extends GUIComponent
	Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var(Menu) Material 			Image;				// The Material to Render
var(Menu) color				ImageColor;			// What color should we set
var(Menu) eImgStyle			ImageStyle;			// How should the image be displayed
var(Menu) EMenuRenderStyle	ImageRenderStyle;	// How should we display this image
var(Menu) eImgAlign			ImageAlign;			// If ISTY_Justified, how should image be aligned
var(Menu) int				X1,Y1,X2,Y2;		// If set, it will pull a subimage from inside the image

cpptext
{
		void Draw(UCanvas* Canvas);

}


defaultproperties
{
     ImageColor=(B=255,G=255,R=255,A=255)
     ImageRenderStyle=MSTY_Alpha
     x1=-1
     y1=-1
     x2=-1
     y2=-1
     RenderWeight=0.100000
}
