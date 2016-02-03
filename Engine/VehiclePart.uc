// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class VehiclePart extends Actor
	native
	abstract
	placeable;

var bool bUpdating;		// set true if currently updating

// Update() called each tick by the Vehicle which owns this vehiclepart
function Update(float DeltaTime);

function Activate(bool bActive);

defaultproperties
{
}
