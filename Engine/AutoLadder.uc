// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*=============================================================================
// AutoLadder - automatically placed at top and bottom of LadderVolume
============================================================================= */

class AutoLadder extends Ladder
	notplaceable
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

cpptext
{
	virtual UBOOL IsIdentifiedAs(FName ActorName);

}


defaultproperties
{
     bCollideWhenPlacing=False
}
