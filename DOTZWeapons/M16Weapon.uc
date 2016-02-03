// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * M16Weapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class M16Weapon extends DOTZGunWeapon
    config(user);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PawnAnimationPackage="DOTZAHumans.3PM16"
     FireAnimName="M16Fire"
     StandIdleAnimName="M16StandIdle"
     CrouchIdleAnimName="M16CrouchIdle"
     HitAnimName="M16Hit"
     MuzzleFlashEmitterClass=Class'BBParticles.BBPM16MuzzleFlash'
     EffectiveRange=3000
     HitSpread=192.000000
     AimedOffset=(X=-9.000000,Y=-8.000000,Z=-1.000000)
     AimedFOV=30
     OfficialName="M-16"
     AmmoName=Class'DOTZWeapons.M16Ammunition'
     PickupAmmoCount=30
     ReloadCount=30
     AutoSwitchPriority=7
     InventoryGroup=7
     PickupClass=Class'DOTZWeapons.M16Pickup'
     AttachmentClass=Class'DOTZWeapons.M16Attachment'
     ItemName="M16"
     Mesh=SkeletalMesh'DOTZAWeapons.M16'
}
