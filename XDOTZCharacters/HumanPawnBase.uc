// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * HumanPawn - base class for all "regular" people in DOTZ, i.e. non-zombies.
 *
 * @version $Rev: 5489 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class HumanPawnBase extends XDOTZPawnBase
abstract notplaceable
   HideDropDown;



/**
 */
function bool TakeHeadShotsFrom(Pawn Instigator){
   return false;
}

/**
 * ShouldDoRagdoll - ragdolls can move away from the pawn location,
 * which makes eating look dumb.
 */
function bool ShouldDoRagdoll(){
   return false;
}

function AdvancedPlayAnim( name Sequence, optional float Rate,
                           optional float TweenTime, optional int Channel,
                           optional bool bLoop, optional bool bFocus){
    super.AdvancedPlayAnim(Sequence, Rate, TweenTime, Channel, bLoop, bFocus);
    Log (self @ sequence @ channel);
}


/**
 * Otis and Jack should never really get destroyed during gameplay, but just in
 * case something weird happens, let the player controller sort it out...
 */
simulated function Destroyed() {
    super.Destroyed();
    if (Level.Game !=None){
      AdvancedGameInfo(Level.Game).GameOver(); //@@@
    }
}

defaultproperties
{
     LyingAnims(0)="LyingPose"
     AdditionalAnimPkg(0)=(AnimName="DOTZAHumans.HumanStandard")
     AnimJump="JumpF"
     AnimJumpForward="JumpF"
     AnimJumpBack="JumpB"
     AnimJumpLeft="JumpL"
     AnimJumpRight="JumpR"
     AnimStandHitRight(0)="HitRightSide"
     AnimStandHitLeft(0)="HitLeftSide"
     AnimStandHitBack(0)="HitBack"
     AnimStandHitHead(0)="HitHead"
     AnimStandHitFront(0)="HitFront"
     AnimCrouchTurnLeft="CrouchTurnL"
     AnimCrouchTurnRight="CrouchTurnR"
     AnimCrouchHitRight(0)="CrouchHitRightSide"
     AnimCrouchHitLeft(0)="CrouchHitLeftSide"
     AnimCrouchHitBack(0)="CrouchHitBack"
     AnimCrouchHitHead(0)="CrouchHitHead"
     AnimCrouchHitFront(0)="CrouchHitFront"
     AnimCrouchDeathBack="DeathB"
     AnimCrouchDeathForward="DeathF"
     AnimCrouchDeathLeft="DeathL"
     AnimCrouchDeathRight="DeathR"
     AnimCrawlHitRight(0)="CrawlHitRightSide"
     AnimCrawlHitLeft(0)="CrawlHitLeftSide"
     AnimCrawlHitBack(0)="CrawlHitBack"
     AnimCrawlHitHead(0)="CrawlHitHead"
     AnimCrawlHitFront(0)="CrawlHitFront"
     AnimCrawlDeathBack="DeathB"
     AnimCrawlDeathForward="DeathF"
     AnimCrawlDeathLeft="DeathL"
     AnimCrawlDeathRight="DeathR"
     BoredomThreshold=8
     BoredomDeviation=1
     FootStepSound(0)=Sound'PlayerSounds.FootSteps.FootstepDefault1'
     FootStepSound(1)=Sound'PlayerSounds.FootSteps.FootstepDefault2'
     FootStepSound(2)=Sound'PlayerSounds.FootSteps.FootstepDefault3'
     FootStepDirt(0)=Sound'PlayerSounds.FootSteps.BFootstepDirt1'
     FootStepDirt(1)=Sound'PlayerSounds.FootSteps.BFootstepDirt2'
     FootStepDirt(2)=Sound'PlayerSounds.FootSteps.BFootstepDirt3'
     FootStepMetal(0)=Sound'PlayerSounds.FootSteps.BFootstepMetal1'
     FootStepMetal(1)=Sound'PlayerSounds.FootSteps.BFootstepMetal2'
     FootStepMetal(2)=Sound'PlayerSounds.FootSteps.BFootstepMetal3'
     FootStepPlant(0)=Sound'PlayerSounds.FootSteps.BFootstepPlant1'
     FootStepPlant(1)=Sound'PlayerSounds.FootSteps.BFootstepPlant2'
     FootStepPlant(2)=Sound'PlayerSounds.FootSteps.BFootstepPlant3'
     FootStepRock(0)=Sound'PlayerSounds.FootSteps.BFootstepRock1'
     FootStepRock(1)=Sound'PlayerSounds.FootSteps.BFootstepRock2'
     FootStepRock(2)=Sound'PlayerSounds.FootSteps.BFootstepRock3'
     FootStepWater(0)=Sound'PlayerSounds.FootSteps.FootStepWater'
     FootStepWater(1)=Sound'PlayerSounds.FootSteps.FootstepWater1'
     FootStepWater(2)=Sound'PlayerSounds.FootSteps.FootstepWater2'
     FootStepWood(0)=Sound'PlayerSounds.FootSteps.BFootstepWood1'
     FootStepWood(1)=Sound'PlayerSounds.FootSteps.BFootstepWood2'
     FootStepWood(2)=Sound'PlayerSounds.FootSteps.BFootstepWood3'
     FootStepSnow(0)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush1'
     FootStepSnow(1)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush2'
     FootStepSnow(2)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush3'
}
