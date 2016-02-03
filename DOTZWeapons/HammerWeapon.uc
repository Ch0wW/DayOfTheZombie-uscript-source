// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * HammerWeapon - .
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class HammerWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AltFireAnimName="HammerAltFire"
     PawnAnimationPackage="DOTZAHumans.3PHammer"
     FireAnimName="HammerFire"
     StandIdleAnimName="HammerStandIdle"
     CrouchIdleAnimName="HammerCrouchIdle"
     HitAnimName="HammerHit"
     OfficialName="Hammer"
     AmmoName=Class'DOTZWeapons.HammerAmmunition'
     PickupClass=Class'DOTZWeapons.HammerPickup'
     AttachmentClass=Class'DOTZWeapons.HammerAttachment'
     ItemName="Hammer"
     Mesh=SkeletalMesh'DOTZAWeapons.hammer'
}
