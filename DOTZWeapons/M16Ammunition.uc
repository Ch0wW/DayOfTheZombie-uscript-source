// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * LightAmmunition -
 *
 * @version 1.0
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 * description this class is for the simple weapon
 *****************************************************************
 */

class M16Ammunition extends DOTZAmmunitionBase;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DamageAmount=18
     MaxAmmo=80
     bInstantHit=True
     MyDamageType=Class'DOTZEngine.DOTZBigBulletDamage'
}
