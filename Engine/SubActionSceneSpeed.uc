// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// SubActionSceneSpeed:
//
// Alters the speed of the scene without affecting the engine speed.
//=============================================================================
class SubActionSceneSpeed extends MatSubAction
	native;

var(SceneSpeed)	range	SceneSpeed;

defaultproperties
{
     Icon=Texture'Engine.SubActionSceneSpeed'
     Desc="Scene Speed"
}
