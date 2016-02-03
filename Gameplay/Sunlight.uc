// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Directional sunlight
//=============================================================================
class Sunlight extends Light;

#exec Texture Import File=Textures\SunIcon.pcx  Name=SunIcon Mips=Off MASKED=1

defaultproperties
{
     LightEffect=LE_Sunlight
     bDirectional=True
     Texture=Texture'Gameplay.SunIcon'
}
