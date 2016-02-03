// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Ambient sound, sits there and emits its sound.  This class is no different
// than placing any other actor in a level and setting its ambient sound.
//=============================================================================
class AmbientSound extends Keypoint;

// Import the sprite.
#exec Texture Import File=Textures\Ambient.pcx Name=S_Ambient Mips=Off MASKED=1

defaultproperties
{
     bStatic=False
     bNoDelete=True
     RemoteRole=ROLE_None
     Texture=Texture'Engine.S_Ambient'
     SoundVolume=190
}
