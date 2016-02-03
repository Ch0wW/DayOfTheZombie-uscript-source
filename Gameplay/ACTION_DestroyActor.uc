// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_DestroyActor extends ScriptedAction;

var(Action)		name			DestroyTag;

function bool InitActionFor(ScriptedController C)
{
	local Actor a;

	if(DestroyTag != 'None')
	{
		ForEach C.AllActors(class'Actor', a, DestroyTag)
		{
			a.Destroy();
		}
	}

	return false;	
}

function string GetActionString()
{
	return ActionString;
}

defaultproperties
{
     ActionString="Destroy actor"
}
