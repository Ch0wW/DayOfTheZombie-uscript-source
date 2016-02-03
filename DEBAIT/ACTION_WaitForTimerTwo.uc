// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_WaitForTimerTwo extends LatentScriptedAction;



var(Action) float PauseTime;

function bool InitActionFor(ScriptedController C)
{
    C.CurrentAction = self;
    C.SetTimer(PauseTime, false);
    //            // Log( self @ "Setting timer for: " $ C $ "of length :" $ PauseTime )    ;
    return true;
}

function bool CompleteWhenTriggered()
{
    return false;
}

function bool CompleteWhenTimer()
{
    return true;
}

function string GetActionString()
{
    return ActionString@PauseTime;
}

defaultproperties
{
     ActionString="Wait for timer"
}
