// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// InterpolationPoint.
// Used as destinations to move the camera to in Matinee scenes.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

#exec Texture Import File=Textures\IntrpPnt.pcx Name=S_Interp Mips=Off MASKED=1

defaultproperties
{
     bDirectional=True
     Texture=Texture'Engine.S_Interp'
}
