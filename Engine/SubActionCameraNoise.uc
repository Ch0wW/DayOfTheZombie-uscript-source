// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// SubActionCameraNoise:
//
// Hermite interpolates to random camera offsets
//=============================================================================
class SubActionCameraNoise extends MatSubAction
	native;

var(Shake)	rangevector	    NoiseRange;
var(Shake)  int             Smoothness;
var         int             smoothCount;

defaultproperties
{
     Smoothness=1
     Icon=Texture'Engine.SubActionCameraNoise'
     Desc="Noise"
}
