// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * MolotovAmmunition -
 *
 * @version 1.0
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 * description this class is for the simple weapon
 *****************************************************************
 */

class MolotovAmmunition extends DOTZAmmunitionBase;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     MaxAmmo=10
     ProjectileClass=Class'DOTZWeapons.MolotovProjectile'
     MyDamageType=Class'DOTZEngine.DOTZBulletDamage'
     PickupClass=Class'DOTZWeapons.MolotovPickup'
}
