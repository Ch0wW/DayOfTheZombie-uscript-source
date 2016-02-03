// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class InventoryAttachment extends Actor
	native
	nativereplication;

function InitFor(Inventory I)
{
	Instigator = I.Instigator;
}
		

defaultproperties
{
     DrawType=DT_Mesh
     bOnlyDrawIfAttached=True
     bOnlyDirtyReplication=True
     bUseLightingFromBase=True
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=10.000000
}
