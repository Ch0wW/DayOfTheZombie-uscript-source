// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// RockingSkyZoneInfo.
//=============================================================================
class RockingSkyZoneInfo extends SkyZoneInfo;

simulated function Tick(float DeltaTime)
{
	local rotator NewRot;

	Super.Tick(DeltaTime);

	NewRot.Pitch = Rotation.Pitch + 1024 * DeltaTime;
	NewRot.Roll  = Rotation.Roll;
	NewRot.Yaw   = Rotation.Yaw;

	SetRotation(NewRot);
}

defaultproperties
{
}
