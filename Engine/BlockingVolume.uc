// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// BlockingVolume:  a bounding volume
// used to block certain classes of actors
// primary use is to provide collision for non-zero extent traces around static meshes 

//=============================================================================

class BlockingVolume extends Volume
	native;

var() bool bClampFluid;

defaultproperties
{
     bClampFluid=True
     bWorldGeometry=True
     bBlockActors=True
     bBlockPlayers=True
     bBlockZeroExtentTraces=False
     bBlockKarma=True
}
