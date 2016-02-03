// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GolfClubPickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class GolfClubPickup extends DOTZWeaponPickup
      placeable;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the golf club"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.GolfClubWeapon'
     PickupMessage="You got the golf club"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Melee.GolfClub'
}
