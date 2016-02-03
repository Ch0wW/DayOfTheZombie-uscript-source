// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_IfRandomPct extends ScriptedAction;

var(Action) float Probability;

function ProceedToNextAction(ScriptedController C)
{
	C.ActionNum += 1;
	if ( FRand() > Probability )
		ProceedToSectionEnd(C);
}

function bool StartsSection()
{
	return true;
}

defaultproperties
{
}
