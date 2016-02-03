// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// InventorySpot.
//=============================================================================
class InventorySpot extends SmallNavigationPoint
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Pickup markedItem;

/* GetMoveTargetFor()
Possibly return pickup rather than self as movetarget
*/
function Actor GetMoveTargetFor(AIController B, float MaxWait)
{
	if ( (markedItem != None) && markedItem.ReadyToPickup(MaxWait) && (B.Desireability(markedItem) > 0) )
		return markedItem;
	
	return self;
}

/* DetourWeight()
value of this path to take a quick detour (usually 0, used when on route to distant objective, but want to grab inventory for example)
*/
event float DetourWeight(Pawn Other,float PathWeight)
{
	if ( (markedItem != None) && markedItem.ReadyToPickup(0) )
		return markedItem.DetourWeight(Other,PathWeight);
}	

cpptext
{
	virtual UBOOL IsIdentifiedAs(FName ActorName);
    virtual AInventorySpot* GetAInventorySpot() { return this; } 

}


defaultproperties
{
     bCollideWhenPlacing=False
     bHiddenEd=True
}
