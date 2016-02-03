// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_DisableRun extends ScriptedAction;

var(Action)     bool disabled;

function bool InitActionFor(ScriptedController C)
{
    local DOTZPlayerControllerBase P;

    ForEach C.DynamicActors(class'DOTZPlayerControllerBase', P)
        P.bScriptDisabled = disabled;
    return false;
}

defaultproperties
{
     Disabled=True
     ActionString="disableRun"
}
