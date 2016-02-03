// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * FireAxePickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class FireAxePickup extends DOTZWeaponPickup
      placeable;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the fire axe"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.FireAxeWeapon'
     PickupMessage="You got the fire axe"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Melee.FireAxe'
}
