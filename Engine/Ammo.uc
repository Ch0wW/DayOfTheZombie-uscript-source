// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Ammo.
//=============================================================================
class Ammo extends Pickup
	abstract
	native;

#exec Texture Import File=Textures\Ammo.pcx Name=S_Ammo Mips=Off MASKED=1

var() int AmmoAmount;

/* DetourWeight()
value of this path to take a quick detour (usually 0, used when on route to distant objective, but want to grab inventory for example)
*/
function float DetourWeight(Pawn Other,float PathWeight)
{
	local Ammunition AlreadyHas;

	if ( Other.Weapon.AIRating >= 0.5 )
		return 0;
	AlreadyHas = Ammunition(Other.FindInventoryType(InventoryType));
	if ( AlreadyHas == None )
		return 0;
	if ( AlreadyHas.AmmoAmount == 0 )
		return MaxDesireability/PathWeight;
	return 0;
}

function float BotDesireability(Pawn Bot)
{
	local Ammunition AlreadyHas;

	if ( Bot.Controller.bHuntPlayer )
		return 0;
	AlreadyHas = Ammunition(Bot.FindInventoryType(InventoryType));
	if ( AlreadyHas == None )
		return (0.35 * MaxDesireability);
	if ( AlreadyHas.AmmoAmount == 0 )
		return MaxDesireability;
	if (AlreadyHas.AmmoAmount >= AlreadyHas.MaxAmmo) 
		return -1;

	return ( MaxDesireability * FMin(1, 0.15 * AmmoAmount/AlreadyHas.AmmoAmount) );
}

function inventory SpawnCopy( Pawn Other )
{
	local Inventory Copy;

	Copy = Super.SpawnCopy(Other);
	Ammunition(Copy).AmmoAmount = AmmoAmount;
	return Copy;
}

defaultproperties
{
     MaxDesireability=0.200000
     RespawnTime=30.000000
     PickupMessage="You picked up some ammo."
     Texture=Texture'Engine.S_Ammo'
     AmbientGlow=255
}
