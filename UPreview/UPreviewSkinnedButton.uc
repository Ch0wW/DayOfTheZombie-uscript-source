// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  This button is used for graphical menus.  It extends button to allow
//  for different rendering styles and colors in the 4 different states
//
//  FixMe: In the future, convert his to use arrays for quicker setup
// ====================================================================

class UPreviewSkinnedButton extends UWindowButton;

#exec AUDIO IMPORT FILE=Sounds\Pick.wav Name=mnuPick


var Color		UpHue, DownHue, DisabledHue, OverHue;
var int			UpDrawStyle,  DownDrawStyle,  DisabledDrawStyle,  OverDrawStyle;

// This just makes setting up the button easier.

function SetRenderInfo(int Mode, texture T,Color C, int s)
{
	switch (mode)
	{
		case 0 :
			UpTexture = T;
			UpHue = C;
			UpDrawStyle = S;
			break;
			
		case 1 :
			DownTexture = T;
			DownHue = C;
			DownDrawStyle = S;
			break;
			
		case 2 :
			DisabledTexture = T;
			DisabledHue = C;
			DisabledDrawStyle = S;
			break;
			
		case 3 :
			OverTexture = T;
			OverHue = C;
			OverDrawStyle = S;
			break;
	}
}
			

// Overload paint to set the hue and style

function Paint(Canvas C, float X, float Y)
{
	local color oldC;
	local int oldS;
	
	oldC = C.DrawColor;
	oldS = C.Style;

	if(bDisabled) 
	{
		C.DrawColor =DisabledHue;
		C.Style = DisabledDrawStyle;
	} 
	else 
	{
		if(bMouseDown)
		{
			
			C.DrawColor =DownHue;
			C.Style = DownDrawStyle;
		}
		else 
		{
		
			if(MouseIsOver()) 
			{
				C.DrawColor =OverHue;
				C.Style = OverDrawStyle;
			}
			else 
			{
				C.DrawColor=UpHue;
				C.Style = UpDrawStyle;
			}
		}
	}
	
	Super.Paint(C,X,Y);
	
	C.DrawColor = oldC;
	C.Style = oldS;
	
	
}

defaultproperties
{
     UpHue=(B=255,G=255,R=255,A=255)
     DownHue=(B=255,G=255,R=255,A=255)
     DisabledHue=(B=255,G=255,R=255,A=255)
     OverHue=(B=255,G=255,R=255,A=255)
     UpDrawStyle=1
     DownDrawStyle=1
     DisabledDrawStyle=1
     OverDrawStyle=1
     DownSound=Sound'UPreview.mnuPick'
}
