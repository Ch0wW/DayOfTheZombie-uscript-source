// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_DestroyPawn extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	C.DestroyPawn();
	return true;
}

defaultproperties
{
     ActionString="destroy pawn"
     bValidForTrigger=False
}
