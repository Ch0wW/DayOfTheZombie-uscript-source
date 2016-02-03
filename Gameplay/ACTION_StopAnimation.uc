// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_StopAnimation extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	C.ClearAnimation();
	return false;	
}

defaultproperties
{
     ActionString="stop animation"
     bValidForTrigger=False
}
