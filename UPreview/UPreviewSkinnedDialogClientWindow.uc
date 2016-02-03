// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================

class UPreviewSkinnedDialogClientWindow extends UWindowDialogClientWindow;


var bool bStretched;	// Should we strech the texture or tile
var int DrawStyle;		// The render style
var Color Hue;			// Used to set the Tranparancy level in DrawStyle=3
var Texture Skin;		// The Skin to use as the backgroun
var bool bBkIsFrame;	// Set to TRUE to allow the background of the window to
						// act as it's frame for movement.

// used for moving the window

var float					MoveX, MoveY;	// co-ordinates where the move was requested	
var bool					bMoving;		// We are moving

// Before painting the controls, we paint the background.  In this case, we don't call the
// super to avoid having the black background drawn.


function Paint(Canvas C, float X, float Y)
{
	local int S;
	local Color H;
	
	H = C.DrawColor;
	S = C.Style;

	C.Style = DrawStyle;
	C.DrawColor = Hue;
	
	if (bStretched)
		C.DrawTile( Skin, WinWidth, WinHeight, 0,0, Skin.USize, Skin.VSize );
	else
		C.DrawTile( Skin, Skin.USize, Skin.VSize, 0,0, Skin.USize, Skin.VSize);

	C.Style = S;
	C.DrawColor = H;

}

// Handle movement (taking from FrameWindow and all sizing code removed)

function LMouseDown(float X, float Y)
{

	Super.LMouseDown(X, Y);
	MoveX = X;
	MoveY = Y;
	bMoving = True;
	Root.CaptureMouse();
}


function MouseMove(float X, float Y)
{
	if (!bBkIsFrame)
		return;
	
	if(bMoving && bMouseDown)
	{
		WinLeft = Int(WinLeft + X - MoveX);
		WinTop = Int(WinTop + Y - MoveY);
	}
	else
		bMoving = False;

}

defaultproperties
{
     bStretched=True
     DrawStyle=1
     Hue=(B=255,G=255,R=255,A=255)
}
