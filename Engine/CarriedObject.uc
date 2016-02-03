// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class CarriedObject extends Actor
    native nativereplication abstract notplaceable;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var bool            bHome;
var bool            bHeld;

var PlayerReplicationInfo HolderPRI;
var Pawn      Holder;

var const NavigationPoint LastAnchor;		// recent nearest path
var		float	LastValidAnchorTime;	// last time a valid anchor was found

replication
{
    reliable if (Role == ROLE_Authority)
        bHome, bHeld, HolderPRI;
}

function Actor Position()
{
    if (bHeld)
        return Holder;

    return self;
}

cpptext
{
	INT* GetOptimizedRepList( BYTE* Recent, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );

}


defaultproperties
{
     DrawType=DT_Mesh
     bOrientOnSlope=True
     bAlwaysZeroBoneOffset=True
     bUseCylinderCollision=True
}
