// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// TimedTrigger: causes an event after X seconds.
//=============================================================================
class TimedTrigger extends Trigger;

var() float DelaySeconds;
var() bool bRepeating;

function Timer()
{
	TriggerEvent(Event,self,None);

	if ( !bRepeating )
		Destroy();
}

function MatchStarting()
{
	SetTimer(DelaySeconds, bRepeating);
}

defaultproperties
{
     DelaySeconds=1.000000
     bCollideActors=False
     bObsolete=True
}
