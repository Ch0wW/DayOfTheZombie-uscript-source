// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ShotgunAmmoPickup extends DOTZAmmoPickup;

defaultproperties
{
     ActionPickupMessage="Press Action to pick up shotgun ammo"
     AmmoAmount=4
     InventoryType=Class'DOTZWeapons.ShotGunAmmunition'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ammo.ShotgunShells'
}
