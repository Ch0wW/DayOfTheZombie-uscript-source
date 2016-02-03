// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ShovelWeapon - a pseudo-weapon for throwing grenades by hand.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class ShovelWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     StdTraceDist=150
     AltTraceDist=150
     AltFireAnimName="ShovelAltFire"
     PawnAnimationPackage="DOTZAHumans.3PShovel"
     FireAnimName="ShovelFire"
     StandIdleAnimName="ShovelStandIdle"
     CrouchIdleAnimName="ShovelCrouchIdle"
     HitAnimName="ShovelHit"
     OfficialName="Shovel"
     AmmoName=Class'DOTZWeapons.ShovelAmmunition'
     PickupClass=Class'DOTZWeapons.ShovelPickup'
     AttachmentClass=Class'DOTZWeapons.ShovelAttachment'
     ItemName="Shovel"
     Mesh=SkeletalMesh'DOTZAWeapons.shovel'
}
