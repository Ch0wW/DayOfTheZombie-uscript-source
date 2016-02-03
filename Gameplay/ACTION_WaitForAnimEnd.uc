// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_WaitForAnimend extends LatentScriptedAction;

var(Action) int Channel;

function bool CompleteOnAnim(int Num)
{
	return (Channel == Num);
}

defaultproperties
{
     ActionString="Wait for animend"
     bValidForTrigger=False
}
