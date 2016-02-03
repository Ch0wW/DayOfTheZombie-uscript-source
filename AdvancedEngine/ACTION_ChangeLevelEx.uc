// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_ChangeLevelEx extends ScriptedAction;

var(Action) string URL;
var(Action) bool bShowLoadingMessage;
var(Action) bool bTakeItems;

function bool InitActionFor(ScriptedController C)
{
	if( bShowLoadingMessage )
		C.Level.ServerTravel(URL, bTakeItems);
	else
		C.Level.ServerTravel(URL$"?quiet", bTakeItems);
	return true;
}

function string GetActionString()
{
	return ActionString;
}

defaultproperties
{
     bTakeItems=True
     ActionString="Change level"
}
