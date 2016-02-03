// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class TriggeredCondition extends Triggers;

var()	bool	bToggled;
var()	bool	bEnabled;
var()	bool	bTriggerControlled;	// false if untriggered
var		bool	bInitialValue;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bInitialValue = bEnabled;
}

function Trigger( actor Other, pawn EventInstigator )
{
	if ( bToggled )
		bEnabled = !bEnabled;
	else
		bEnabled = !bInitialValue;
}

function Untrigger( actor Other, pawn EventInstigator )
{
	if ( bTriggerControlled )
		bEnabled = bInitialValue;
}

defaultproperties
{
}
