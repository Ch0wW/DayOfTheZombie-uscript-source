// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GolfClubWeapon - .
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class GolfClubWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     StdTraceDist=200
     AltTraceDist=200
     AltFireAnimName="GolfClubAltFire"
     PawnAnimationPackage="DOTZAHumans.3PGolfClub"
     FireAnimName="GolfClubFire"
     StandIdleAnimName="GolfClubStandIdle"
     CrouchIdleAnimName="GolfClubCrouchIdle"
     HitAnimName="GolfClubHit"
     OfficialName="Golf Club"
     AmmoName=Class'DOTZWeapons.GolfClubAmmunition'
     PickupClass=Class'DOTZWeapons.GolfClubPickup'
     AttachmentClass=Class'DOTZWeapons.GolfClubAttachment'
     ItemName="Golf Club"
     Mesh=SkeletalMesh'DOTZAWeapons.GolfClub'
}
