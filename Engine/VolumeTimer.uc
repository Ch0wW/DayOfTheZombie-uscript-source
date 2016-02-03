// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class VolumeTimer extends info;

var PhysicsVolume V;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0, true);
	V = PhysicsVolume(Owner);
}

function Timer()
{
	V.TimerPop(self);
}

defaultproperties
{
}
