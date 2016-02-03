// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Keypoint, the base class of invisible actors which mark things.
//=============================================================================
class Keypoint extends Actor
	abstract
	placeable
	native;

// Sprite.
#exec Texture Import File=Textures\Keypoint.pcx Name=S_Keypoint Mips=Off MASKED=1

defaultproperties
{
     bStatic=True
     bHidden=True
     Texture=Texture'Engine.S_Keypoint'
     SoundVolume=0
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
