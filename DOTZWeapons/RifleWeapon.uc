// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * RifleWeapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class RifleWeapon extends DOTZGunWeapon
    config(user);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PawnAnimationPackage="DOTZAHumans.3P22Rifle"
     FireAnimName="22RifleFire"
     StandIdleAnimName="22RifleStandIdle"
     CrouchIdleAnimName="22RifleCrouchIdle"
     HitAnimName="22RifleHit"
     WeaponMode=WM_Single
     MuzzleFlashEmitterClass=Class'BBParticles.BBP22RifleMuzzleFlash'
     EffectiveRange=4500
     HitSpread=192.000000
     AimedOffset=(X=-9.000000,Y=-3.000000,Z=-1.000000)
     AimedFOV=30
     OfficialName=".22 Rifle"
     AmmoName=Class'DOTZWeapons.RifleAmmunition'
     PickupAmmoCount=6
     ReloadCount=6
     AutoSwitchPriority=2
     InventoryGroup=2
     PickupClass=Class'DOTZWeapons.RiflePickup'
     AttachmentClass=Class'DOTZWeapons.RifleAttachment'
     ItemName="Rifle"
     Mesh=SkeletalMesh'DOTZAWeapons.22Rifle'
}
