// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class RevolverAmmoPickup extends DOTZAmmoPickup;

defaultproperties
{
     ActionPickupMessage="Press Action to pick up revolver ammo"
     AmmoAmount=6
     InventoryType=Class'DOTZWeapons.RevolverAmmunition'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ammo.RevolverSpeedLoader'
}
