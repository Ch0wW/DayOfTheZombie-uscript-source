// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_Crouch extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	C.Pawn.ShouldCrouch(true);
	return false;	
}

defaultproperties
{
     ActionString="crouch"
     bValidForTrigger=False
}
