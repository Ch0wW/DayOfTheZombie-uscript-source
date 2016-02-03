// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * RiflePickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class RiflePickup extends DOTZWeaponPickup
      placeable;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the .22 Rifle"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.RifleWeapon'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.22Rifle'
}
