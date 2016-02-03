// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ShovelPickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class BaseBallBatPickup extends DOTZWeaponPickup
      placeable;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the bat"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.BaseBallBatWeapon'
     PickupMessage="You got the baseball bat"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Melee.Baseballbat'
}
