// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * LeadPipeWeapon - .
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 *****************************************************************
 */
class LeadPipeWeapon extends DOTZMeleeWeapon
    config(user);

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     StdTraceDist=150
     AltTraceDist=150
     AltFireAnimName="LeadPipeAltFire"
     PawnAnimationPackage="DOTZAHumans.3PLeadPipe"
     FireAnimName="LeadPipeFire"
     StandIdleAnimName="LeadPipeStandIdle"
     CrouchIdleAnimName="LeadPipeCrouchIdle"
     HitAnimName="LeadPipeHit"
     OfficialName="Lead Pipe"
     AmmoName=Class'DOTZWeapons.LeadPipeAmmunition'
     PickupClass=Class'DOTZWeapons.LeadPipePickup'
     AttachmentClass=Class'DOTZWeapons.LeadPipeAttachment'
     ItemName="Lead Pipe"
     Mesh=SkeletalMesh'DOTZAWeapons.LeadPipe'
}
