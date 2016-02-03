// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * RevolverWeapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class RevolverWeapon extends DOTZGunWeapon
    config(user);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PawnAnimationPackage="DOTZAHumans.3PRevolver"
     FireAnimName="RevolverFire"
     StandIdleAnimName="RevolverStandIdle"
     CrouchIdleAnimName="RevolverCrouchIdle"
     HitAnimName="RevolverHit"
     WeaponMode=WM_Single
     MuzzleFlashEmitterClass=Class'BBParticles.BBPRevolverMuzzleFlash'
     EffectiveRange=3000
     iInaccuracyDelta=2.000000
     HitSpread=128.000000
     AimedOffset=(X=-23.000000,Y=-19.000000,Z=5.000000)
     OfficialName="Revolver"
     AmmoName=Class'DOTZWeapons.RevolverAmmunition'
     PickupAmmoCount=6
     ReloadCount=6
     AutoSwitchPriority=3
     InventoryGroup=3
     PickupClass=Class'DOTZWeapons.RevolverPickup'
     AttachmentClass=Class'DOTZWeapons.RevolverAttachment'
     ItemName="Revolver"
     Mesh=SkeletalMesh'DOTZAWeapons.Revolver'
}
