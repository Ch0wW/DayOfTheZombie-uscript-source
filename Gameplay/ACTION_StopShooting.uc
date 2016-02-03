// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_StopShooting extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	C.bShootTarget = false;
	C.bShootSpray = false;
	return false;	
}

defaultproperties
{
}
