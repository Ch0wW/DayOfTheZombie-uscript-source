// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * MountedWeaponAmmunitionA -
 *
 * @version 1.0
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 * description this class is for the simple weapon
 *****************************************************************
 */

class MountedWeaponAmmunitionA extends DOTZAmmunitionBase;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DamageAmount=25
     ImpactEmitter=Class'BBParticles.BBPImpactDirt'
     ImpactMetal=None
     ImpactRock=None
     ImpactWater=None
     MaxAmmo=80
     bInstantHit=True
     MyDamageType=Class'DOTZEngine.DOTZBigBulletDamage'
}
