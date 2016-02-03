// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class TriggeredPlayerStart extends PlayerStart;

function Trigger( actor Other, pawn EventInstigator )
{
	bEnabled = !bEnabled;
}

defaultproperties
{
     bStatic=False
}
