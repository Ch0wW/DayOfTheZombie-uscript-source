// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Ambushpoint.
//=============================================================================
class AmbushPoint extends NavigationPoint
	notplaceable;

var vector lookdir; //direction to look while ambushing
//at start, ambushing creatures will pick either their current location, or the location of
//some ambushpoint belonging to their team
var byte survivecount; //used when picking ambushpoint 
var() float SightRadius; // How far bot at this point should look for enemies
var() bool	bSniping;	// bots should snipe from this position

function PreBeginPlay()
{
	lookdir = 2000 * vector(Rotation);

	Super.PreBeginPlay();
}

defaultproperties
{
     SightRadius=5000.000000
     bDirectional=True
     bObsolete=True
     SoundVolume=128
}