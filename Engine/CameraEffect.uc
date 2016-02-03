// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class CameraEffect extends Object
	abstract
	native
	noexport
	noteditinlinenew;

var float	Alpha;			// Used to transition camera effects. 0 = no effect, 1 = full effect
var bool	FinalEffect;	// Forces the renderer to ignore effects on the stack below this one.

//
//	Default properties
//

defaultproperties
{
     Alpha=1.000000
}
