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
class FistWeapon extends DOTZMeleeWeapon
    config(user);


/*****************************************************************
 * PlayFiring
 * Normal fire has occured by this point, we just need to make it look
 * like it has now, so play an animation.
 *****************************************************************
 */
simulated function PlayFiring(){

   local DOTZPlayerControllerBase PlayerOwner;
   PlayerOwner = DOTZPlayerControllerBase(Instigator.Controller);


   if (bDoAltFire == true){
       PlayAnim(AltFireAnim, SingleFireRate);
   } else {
       PlayAnim(FireAnim, SingleFireRate);
   }
   IncrementFlashCount();
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AltFireAnimName="FistsAltFire"
     PawnAnimationPackage="DOTZAHumans.3PFists"
     FireAnimName="FistsFire"
     StandIdleAnimName="FistsStandIdle"
     CrouchIdleAnimName="FistsCrouchIdle"
     HitAnimName="FistsHit"
     OfficialName="Fists"
     AmmoName=Class'DOTZWeapons.FistAmmunition'
     ItemName="Fists"
     Mesh=SkeletalMesh'DOTZAWeapons.Fists'
}
