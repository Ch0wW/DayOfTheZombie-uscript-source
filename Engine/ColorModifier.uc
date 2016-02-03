// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ColorModifier extends Modifier
	noteditinlinenew
	native;

var() color Color;
var() bool	RenderTwoSided;
var() bool	AlphaBlend;

defaultproperties
{
     Color=(B=255,G=255,R=255,A=255)
     RenderTwoSided=True
     AlphaBlend=True
}
