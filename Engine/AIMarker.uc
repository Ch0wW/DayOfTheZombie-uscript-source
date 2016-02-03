// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// AIMarker.
//=============================================================================
class AIMarker extends SmallNavigationPoint
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var AIScript markedScript;

cpptext
{
	virtual UBOOL IsIdentifiedAs(FName ActorName);

}


defaultproperties
{
     bCollideWhenPlacing=False
     bHiddenEd=True
}
