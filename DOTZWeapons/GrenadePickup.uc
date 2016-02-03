// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GrenadePickup -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class GrenadePickup extends DOTZGrenadePickup
      placeable;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     GrenadeAmmunitionClass=Class'DOTZWeapons.GrenadeAmmunition'
     InventoryType=Class'DOTZWeapons.GrenadeWeapon'
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.grenade'
}
