// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * BaseBallBatWeapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class BaseBallBatWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     StdTraceDist=200
     AltTraceDist=200
     AltFireAnimName="BaseBallBatAltFire"
     PawnAnimationPackage="DOTZAHumans.3PBaseBallBat"
     FireAnimName="BaseBallBatFire"
     StandIdleAnimName="BaseBallBatStandIdle"
     CrouchIdleAnimName="BaseBallBatCrouchIdle"
     HitAnimName="BaseBallHit"
     OfficialName="Baseball Bat"
     AmmoName=Class'DOTZWeapons.BaseBallBatAmmunition'
     PickupClass=Class'DOTZWeapons.BaseBallBatPickup'
     AttachmentClass=Class'DOTZWeapons.BaseBallBatAttachment'
     ItemName="Baseball Bat"
     Mesh=SkeletalMesh'DOTZAWeapons.Baseballbat'
}
