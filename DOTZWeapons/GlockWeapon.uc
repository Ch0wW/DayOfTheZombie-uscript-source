// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GlockWeapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class GlockWeapon extends DOTZGunWeapon
    config(user);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PawnAnimationPackage="DOTZAHumans.3PGlock"
     FireAnimName="GlockFire"
     StandIdleAnimName="GlockStandIdle"
     CrouchIdleAnimName="GlockCrouchIdle"
     HitAnimName="GlockHit"
     WeaponMode=WM_Single
     TraceEmitterClass=Class'BBParticles.BBPLightTracer'
     MuzzleFlashEmitterClass=Class'BBParticles.BBPGlockMuzzleFlash'
     EffectiveRange=3000
     iInaccuracyDelta=2.000000
     HitSpread=128.000000
     AimedOffset=(X=-9.000000,Y=-3.000000,Z=-1.000000)
     OfficialName="Glock"
     AmmoName=Class'DOTZWeapons.GlockAmmunition'
     PickupAmmoCount=12
     ReloadCount=12
     AutoSwitchPriority=4
     InventoryGroup=4
     PickupClass=Class'DOTZWeapons.GlockPickup'
     AttachmentClass=Class'DOTZWeapons.GlockAttachment'
     ItemName="Glock"
     Mesh=SkeletalMesh'DOTZAWeapons.Glock'
}
