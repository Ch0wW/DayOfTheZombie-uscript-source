// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
#exec Texture Import File=Textures\S_FluidSurfOsc.pcx Name=S_FluidSurfOsc Mips=Off MASKED=1

//=============================================================================
// FluidSurfaceOscillator.
//=============================================================================
class FluidSurfaceOscillator extends Actor
	native
	placeable;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// FluidSurface to oscillate
var() edfindable FluidSurfaceInfo	FluidInfo;
var() float							Frequency;
var() byte							Phase;
var() float							Strength;
var() float							Radius;

var transient const float			OscTime;

cpptext
{
	void UpdateOscillation( FLOAT DeltaTime );
	virtual void PostEditChange();
	virtual void Destroy();

}


defaultproperties
{
     Frequency=1.000000
     Strength=10.000000
     bHidden=True
     Texture=Texture'Engine.S_FluidSurfOsc'
}
