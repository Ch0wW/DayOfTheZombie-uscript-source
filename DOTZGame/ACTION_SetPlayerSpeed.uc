// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_SetPlayerSpeed extends ScriptedAction;

var(Action)     float MovementRate;

function bool InitActionFor(ScriptedController C)
{
    local AdvancedPlayerController P;

    foreach C.DynamicActors(class'AdvancedPlayerController', P)
        P.SetSpeedMultiplier(MovementRate);

    return false;
}

defaultproperties
{
     ActionString="setplayerspeed"
}
