// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class HoldSpot extends UnrealScriptedSequence
    notplaceable;

function FreeScript()
{
    Destroy();
}

defaultproperties
{
     Actions(0)=ACTION_MoveToPoint'DebaitAdapters.UnrealScriptedSequence.DefensePointDefaultAction1'
     Actions(1)=ACTION_WaitForTimer'DebaitAdapters.UnrealScriptedSequence.DefensePointDefaultAction2'
     bStatic=False
     bCollideWhenPlacing=False
}
