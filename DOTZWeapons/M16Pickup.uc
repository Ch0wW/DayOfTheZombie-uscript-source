// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * M16Pickup -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class M16Pickup extends DOTZWeaponPickup
      placeable;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     WeaponType="'"
     ActionPickupMessage="Press Action to take the M16"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.M16Weapon'
     PickupMessage="You got the M16"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.M16'
}
