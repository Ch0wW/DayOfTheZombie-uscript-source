// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * MountedWeaponA -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class MountedWeaponA extends DOTZFixedWeapon
    config(user);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     TraceEmitterClass=Class'BBParticles.BBPMediumTracer'
     MuzzleFlashEmitterClass=Class'BBParticles.BBPGlockMuzzleFlash'
     bInfiniteAmmo=True
     EffectiveRange=3000
     HitSpread=192.000000
     AimedOffset=(X=-9.000000,Y=-8.000000,Z=-1.000000)
     AimedFOV=30
     OfficialName="50-Cal."
     AmmoName=Class'DOTZWeapons.MountedWeaponAmmunitionA'
     AttachmentClass=Class'DOTZWeapons.MountedWeaponAttachmentA'
     ItemName="MountedWeaponA"
     Mesh=SkeletalMesh'DOTZAWeapons.MountedGun'
}
