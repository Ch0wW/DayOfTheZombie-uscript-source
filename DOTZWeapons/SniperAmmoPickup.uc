// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class SniperAmmoPickup extends DOTZAmmoPickup;

defaultproperties
{
     ActionPickupMessage="Press Action to pick up sniper ammo"
     AmmoAmount=5
     InventoryType=Class'DOTZWeapons.SniperAmmunition'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ammo.SniperRifleClip'
}
