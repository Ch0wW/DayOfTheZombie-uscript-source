// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * SniperAmmunition -
 *
 * @version 1.0
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 * description this class is for the simple weapon
 *****************************************************************
 */
class SniperAmmunition extends DOTZAmmunitionBase;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DamageAmount=110
     MaxAmmo=120
     bInstantHit=True
     MyDamageType=Class'DOTZEngine.DOTZBigBulletDamage'
}
