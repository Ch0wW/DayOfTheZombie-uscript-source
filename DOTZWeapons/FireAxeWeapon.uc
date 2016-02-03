// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * FireAxeWeapon - .
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class FireAxeWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     StdTraceDist=150
     AltTraceDist=150
     AltFireAnimName="FireAxeAltFire"
     PawnAnimationPackage="DOTZAHumans.3PFireAxe"
     FireAnimName="FireAxeFire"
     StandIdleAnimName="FireAxeStandIdle"
     CrouchIdleAnimName="FireAxeCrouchIdle"
     HitAnimName="FireAxeHit"
     OfficialName="Fire Axe"
     AmmoName=Class'DOTZWeapons.FireAxeAmmunition'
     PickupClass=Class'DOTZWeapons.FireAxePickup'
     AttachmentClass=Class'DOTZWeapons.FireAxeAttachment'
     ItemName="Fire Axe"
     Mesh=SkeletalMesh'DOTZAWeapons.FireAxe'
}
