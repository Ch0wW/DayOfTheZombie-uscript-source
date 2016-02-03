// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_TeleportPlayer extends LatentScriptedAction;

var(Action) name DestinationTag;	// tag of destination - if none, then use the ScriptedSequence
var(Action) bool bPlaySpawnEffect;

var Actor Dest;

function bool InitActionFor(ScriptedController C)
{
	local Pawn P;
	Dest = C.SequenceScript.GetMoveTarget();

	if ( DestinationTag != '' )
	{
		ForEach C.AllActors(class'Actor',Dest,DestinationTag)
			break;
	}
	P = C.Level.GetLocalPlayerController().Pawn;
	P.SetLocation(Dest.Location);
	P.SetRotation(Dest.Rotation);
	P.OldRotYaw = P.Rotation.Yaw;
	if ( bPlaySpawnEffect )
		P.PlayTeleportEffect(false,true);
	return false;
}

defaultproperties
{
}
