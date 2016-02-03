// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GrenadeAmmunition -
 *
 * @version 1.0
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 * description this class is for the simple weapon
 *****************************************************************
 */

class GrenadeAmmunition extends DOTZAmmunitionBase;


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     MaxAmmo=5
     ProjectileClass=Class'DOTZWeapons.GrenadeProjectile'
     MyDamageType=Class'DOTZEngine.DOTZBulletDamage'
     PickupClass=Class'DOTZWeapons.GrenadePickup'
}
