// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class RedirectionTrigger extends Triggers;

var() name RedirectionEvent;

function Trigger( actor Other, pawn EventInstigator )
{
	local Pawn P;

	ForEach DynamicActors(class'Pawn',P,Event)
	{
		if ( P.Health > 0 )
			P.TriggerEvent(RedirectionEvent,self,P);
	}
}

defaultproperties
{
}
