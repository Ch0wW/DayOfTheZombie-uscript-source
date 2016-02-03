// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GlockPickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class GlockPickup extends DOTZWeaponPickup
      placeable;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the Glock"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.GlockWeapon'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.Glock'
}
