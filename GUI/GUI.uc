// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUI
// 
//  GUI is an abstract class that holds all of the enums and structs
//  for the UI system 
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUI extends object
	Abstract instanced native;

// -- These are set at spawn

var				GUIController 		Controller;				// Callback to the GUIController running the show
	
enum eMenuState		// Defines the various states of a component
{
	MSAT_Blurry,			// Component has no focus at all
	MSAT_Watched,			// Component is being watched (ie: Mouse is hovering over, etc)  
	MSAT_Focused,			// Component is Focused (ie: selected)
	MSAT_Pressed,			// Component is being pressed
	MSAT_Disabled,			// Component is disabled.
};

enum eTextAlign		// Used for aligning text in a box
{
	TXTA_Left,
	TXTA_Center,
	TXTA_Right,
};

enum eTextCase		// Used for forcing case on text
{
	TXTC_None,
	TXTC_Upper,
	TXTC_Lower,
};

enum eImgStyle		// Used to define the style for an image
{
	ISTY_Normal,
	ISTY_Stretched,
	ISTY_Scaled,
	ISTY_Bound,
	ISTY_Justified,
};

enum eImgAlign		// Used for aligning justified images in a box
{
	IMGA_TopLeft,
	IMGA_Center,
	IMGA_BottomRight,
};

enum eEditMask		// Used to define the mask of an input box
{
	EDM_None,
	EDM_Alpha,
	EDM_Numeric,
};

enum EMenuRenderStyle
{
	MSTY_None,
	MSTY_Normal,
	MSTY_Masked,
	MSTY_Translucent,
	MSTY_Modulated,
	MSTY_Alpha,
	MSTY_Additive,
	MSTY_Subtractive,
	MSTY_Particle,
	MSTY_AlphaZ,
};

enum eIconPosition
{
	ICP_Normal,
	ICP_Center,
	ICP_Scaled,
	ICP_Stretched,
	ICP_Bound,
};

enum ePageAlign			// Used to Align panels to a form.
{
	PGA_None,
	PGA_Client,
	PGA_Left,
	PGA_Right,
	PGA_Top,
	PGA_Bottom,
};

enum eXControllerCodes
{
	XC_Up, XC_Down, XC_Left, XC_Right,
    XC_A, XC_B, XC_X, XC_Y,
    XC_Black, XC_White,
    XC_LeftTrigger, XC_RightTrigger,
    XC_PadUp, XC_PadDown, XC_PadLeft, XC_PadRight,
    XC_Start, XC_Back,
    XC_LeftThumb, XC_RightThumb,
};

const QBTN_Ok			=1;
const QBTN_Cancel		=2;
const QBTN_Retry		=4;
const QBTN_Continue		=8;
const QBTN_Yes			=16;
const QBTN_No			=32;
const QBTN_Abort		=64;
const QBTN_Ignore		=128;
const QBTN_OkCancel		=3;
const QBTN_AbortRetry	=68;
const QBTN_YesNo		=48;
const QBTN_YesNoCancel	=50;

struct GUIListElem
{
	var string item;
	var object ExtraData;
	var string ExtraStrData;
};

defaultproperties
{
}
