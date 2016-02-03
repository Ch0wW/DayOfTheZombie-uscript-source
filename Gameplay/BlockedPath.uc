// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// BlockedPath.
// 
//=============================================================================
class BlockedPath extends NavigationPoint
	placeable;

function Trigger( actor Other, pawn EventInstigator )
{
	bBlocked = !bBlocked;
}

defaultproperties
{
     bBlocked=True
}
