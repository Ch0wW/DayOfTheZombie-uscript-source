// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class SVehicleTrigger extends AIScript
	notplaceable;

function UsedBy( Pawn user )
{
	// Enter vehicle code
	SVehicle(Owner).TryToDrive(User);
}

defaultproperties
{
     bStatic=False
     bHidden=False
     bOnlyAffectPawns=True
     bHardAttach=True
     RemoteRole=ROLE_None
     CollisionRadius=80.000000
     CollisionHeight=400.000000
}
