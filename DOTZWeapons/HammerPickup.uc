// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * HammerPickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class HammerPickup extends DOTZWeaponPickup
      placeable;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the hammer"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.HammerWeapon'
     PickupMessage="You got the hammer"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Melee.hammer'
}
