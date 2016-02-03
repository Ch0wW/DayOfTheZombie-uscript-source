// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * LeadPipePickup - 
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class LeadPipePickup extends DOTZWeaponPickup
      placeable;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ActionPickupMessage="Press Action to take the lead pipe"
     MaxDesireability=0.750000
     InventoryType=Class'DOTZWeapons.LeadPipeWeapon'
     PickupMessage="You got the lead pipe"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Melee.LeadPipe'
}
