// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//
// Level Change
// When triggered causes change to level described in URL
// OBSOLETE - superceded by ScriptedTrigger
//
class LevelChange extends Triggers
	notplaceable;

var() string URL;

function Trigger( actor Other, pawn EventInstigator )
{
}

defaultproperties
{
     bObsolete=True
}
