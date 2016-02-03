// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_KeepCurrentRotation extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	C.bUseScriptFacing = false;
	return false;	
}

defaultproperties
{
     ActionString="keep current rotation"
}
