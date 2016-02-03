// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class GlockAmmoPickup extends DOTZAmmoPickup;

defaultproperties
{
     ActionPickupMessage="Press Action to pick up glock ammo"
     AmmoAmount=12
     InventoryType=Class'DOTZWeapons.GlockAmmunition'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ammo.GlockClip'
}
