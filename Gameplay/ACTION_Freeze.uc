// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_Freeze extends LatentScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	if ( C.Pawn != None )
	{
		C.Pawn.bPhysicsAnimUpdate = false;
		C.Pawn.StopAnimating();
		C.Pawn.SetPhysics(PHYS_None);
	}
	C.CurrentAction = self;
	return true;	
}

defaultproperties
{
     ActionString="Freeze"
}
