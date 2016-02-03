// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// PolyMarker.
//
// These are markers for the polygon drawing mode.
//
// These should NOT be manually added to the level.  The editor adds and
// deletes them on it's own.
//
//=============================================================================
class PolyMarker extends Keypoint
	placeable
	native;

#exec Texture Import File=Textures\S_PolyMarker.pcx Name=S_PolyMarker Mips=Off MASKED=1

defaultproperties
{
     bEdShouldSnap=True
     Texture=Texture'Engine.S_PolyMarker'
}
