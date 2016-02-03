// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
#exec Texture Import File=Textures\S_KVehFact.pcx Name=S_KVehFact Mips=Off MASKED=1

//=============================================================================
// KVehicle spawner location.
//=============================================================================
class KVehicleFactory extends Actor 
	placeable;

var()	class<KVehicle>		VehicleClass;
var()	int					MaxVehicleCount;

var		int					VehicleCount;

event Trigger( Actor Other, Pawn EventInstigator )
{
	local KVehicle CreatedVehicle;

	if(VehicleCount >= MaxVehicleCount)
		return;

	if(VehicleClass != None)
	{
		CreatedVehicle = spawn(VehicleClass, , , Location, Rotation);
		VehicleCount++;
		CreatedVehicle.ParentFactory = self;
	}
}

defaultproperties
{
     bHidden=True
     bNoDelete=True
     bDirectional=True
     RemoteRole=ROLE_None
     Texture=Texture'Engine.S_KVehFact'
}
