// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * VomitterZombie - base class for zombies that vomit and infect.
 *
 * @version $Rev$
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    July 2004
 */
class VomiterBase extends ZombiePawnBase
abstract;



var int iVomitDistance;
var int iVomitDamageRadius;
var int iVomitDamageAmount;
var class<emitter> VomitEmitterClass;
var name VomitBone;
var float VomitTime;
var float RunningTotal;
var float VomitFreq;
var name AnimVomit;
var bool bVomiting;

//var() bool ConstantVomit;

const VOMIT_ID = 22;
const DEBUG_VOMIT = 23;


/*****************************************************************
 *
 *****************************************************************
 */
function Melee_Attack(){
   if ( IsAnimating(SPECIAL_FIRE_CHANNEL) == False) {
      super.Melee_Attack();
   }
}

function Notify_MeleeDamage(){
  if ( IsAnimating(SPECIAL_FIRE_CHANNEL) == False) {
      super.Notify_MeleeDamage();
   }
}

/**
 * Called externally to make the pawn vomit-attack.
 */
function DoVomit() {
    //don't do anything while playing focus or in the crawling pose.
    if ( IsAnimating(FOCUSCHANNEL) == true || bIsCrawling ) {
                    // Log( self @ "invalid attempt to vomit" )    ;
        return;
    }
    AnimBlendParams( SPECIAL_FIRE_CHANNEL, 1,,, FIRINGBLENDBONE );
    AdvancedPlayAnim(AnimVomit, 1, 0.8, SPECIAL_FIRE_CHANNEL);
    //PlayAnim( AnimVomit, 1, 0.8, SPECIAL_FIRE_CHANNEL );
}

/**
 */
function AnimEnd( int channel ) {
    if ( channel == SPECIAL_FIRE_CHANNEL ) {
        AnimBlendToAlpha( SPECIAL_FIRE_CHANNEL, 0, 0.05 );
    }
    else super.AnimEnd( channel );
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
    super.PostBeginPlay();
//    if (ConstantVomit == true){
  //      SetMultiTimer(DEBUG_VOMIT, 4, true);
//    }
}

/*****************************************************************
 * MakeVomit
 * Emittery stuff
 *****************************************************************
 */
/* //done on the animation now!!!!
function MakeVomit() {
    local actor temp;
    temp = Spawn(VomitEmitterClass);
    temp.bHardAttach = false;
    AttachToBone(temp, 'Jaw');
}
*/

/*****************************************************************
 * Notify_MeleeDamage
 *****************************************************************
 */
function Notify_VomitDamage() {
    //Log("VomitDamage");
    AttemptVomitDamage();
    //MakeVomit();
    SetMultiTimer(VOMIT_ID, VomitFreq, true);
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int ID) {

   if (ID == VOMIT_ID){
      AttemptVomitDamage();
   } else if (ID == DEBUG_VOMIT){
      //MakeVomit();
   } else {
      Super.MultiTimer(ID);
   }

   //check to shut off the damage part
   RunningTotal += VomitFreq;
   if (RunningTotal >= VomitTime){
      SetMultiTimer(VOMIT_ID,0,false);
      RunningTotal = 0;
   }
}

/*****************************************************************
 * AttemptBurstDamage
 *****************************************************************
 */
function AttemptVomitDamage() {
   local actor temp;
   local vector DamageLocation;
   //do damage to a radius (including yourself)
   DamageLocation = Location + (Normal(vector(Rotation))* iVomitDistance);
   Foreach CollidingActors(class'actor', temp,
                           iVomitDamageRadius, Location){
      if (temp != self){
         if (FastTrace(Location, temp.Location)){
            temp.TakeDamage(iVomitDamageAmount, self,vect(0,0,0),
                         vect(0,0,0),class'DOTZInfectionDamage' );
         }
      }
   }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     iVomitDistance=200
     iVomitDamageRadius=300
     VomitEmitterClass=Class'BBParticles.BBPZombieVomit'
     VomitBone="Jaw"
     VomitTime=3.000000
     VomitFreq=0.500000
     AnimVomit="AttackVomit"
     bInfectious=True
     MeleeAttacks(0)=(MeleeAttackAnim="AttackRightA",bFunctional=True,ReqBones=("RUpperArm","RForearm"))
     MeleeAttacks(1)=(MeleeAttackAnim="AttackRightB",bFunctional=True,ReqBones=("RUpperArm","RForearm"))
     MeleeAttacks(2)=(MeleeAttackAnim="AttackRightC",bFunctional=True,ReqBones=("RUpperArm","RForearm"))
     MeleeAttacks(3)=(MeleeAttackAnim="AttackLeftA",bFunctional=True,ReqBones=("LUpperArm","LForearm"))
     MeleeAttacks(4)=(MeleeAttackAnim="AttackLeftB",bFunctional=True,ReqBones=("LUpperArm","LForearm"))
     MeleeAttacks(5)=(MeleeAttackAnim="AttackLeftC",bFunctional=True,ReqBones=("LUpperArm","LForearm"))
     MeleeAttacks(6)=(MeleeAttackAnim="AttackTwoHand",bFunctional=True,ReqBones=("RUpperArm","RForearm","LUpperArm","LForearm"))
     MeleeAttacks(7)=(MeleeAttackAnim="AttackBite",bFunctional=True)
     CrawlingMeleeAttacks(0)=(MeleeAttackAnim="CrawlAttackBite",bFunctional=True)
     CrawlingMeleeAttacks(1)=(MeleeAttackAnim="CrawlAttackFall",bFunctional=True,ReqBones=("RUpperArm","RForearm"))
     CrawlingMeleeAttacks(2)=(MeleeAttackAnim="CrawlAttackRight",bFunctional=True,ReqBones=("RUpperArm","RForearm"))
     Walks(0)="WalkF"
     LegBones(0)="LCalf"
     LegBones(1)="RCalf"
     LeftArmBones(0)="LUpperArm"
     LeftArmBones(1)="LForearm"
     RightArmBones(0)="RUpperArm"
     RightArmBones(1)="RForearm"
     PlayerHitSound(0)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact1'
     PlayerHitSound(1)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact2'
     PlayerHitSound(2)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact3'
     PlayerHitSound(3)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact4'
     PlayerHitSound(4)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact5'
     PlayerHitSound(5)=Sound'DOTZXCharacters.PlayerImpactSounds.MeleeImpact6'
     NonPlayerHitSound(0)=Sound'DOTZXDestruction.DoorImpactSounds.DoorImpact1'
     NonPlayerHitSound(1)=Sound'DOTZXDestruction.DoorImpactSounds.DoorImpact2'
     NonPlayerHitSound(2)=Sound'DOTZXDestruction.DoorImpactSounds.DoorImpact3'
     NonPlayerHitSound(3)=Sound'DOTZXDestruction.DoorImpactSounds.DoorImpact4'
     LyingAnims(0)="LyingPose"
     AdditionalAnimPkg(0)=(AnimName="DOTZAZombies.ZombieStandard")
     AdditionalAnimPkg(1)=(AnimName="DOTZAZombies.Vomiter")
     BoredStandingAnimList(0)="Bored"
     AnimStandHitRight(0)="HitRightSide"
     AnimStandHitLeft(0)="HitLeftSide"
     AnimStandHitBack(0)="HitBack"
     AnimStandHitHead(0)="HitHead"
     AnimStandHitFront(0)="HitFront"
     AnimCrouchHitRight(0)="CrouchHitRightSide"
     AnimCrouchHitLeft(0)="CrouchHitLeftSide"
     AnimCrouchHitBack(0)="CrouchHitBack"
     AnimCrouchHitHead(0)="CrouchHitHead"
     AnimCrouchHitFront(0)="CrouchHitFront"
     BoredCrawlAnimList(0)="CrawlBored"
     AnimCrawlHitRight(0)="CrawlHitRightSide"
     AnimCrawlHitLeft(0)="CrawlHitLeftSide"
     AnimCrawlHitBack(0)="CrawlHitBack"
     AnimCrawlHitHead(0)="CrawlHitHead"
     AnimCrawlHitFront(0)="CrawlHitFront"
     FootStepSound(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepSound(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepSound(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepDirt(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepDirt(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepDirt(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepMetal(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepMetal(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepMetal(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepPlant(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepPlant(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepPlant(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepRock(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepRock(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepRock(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepWater(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepWater1'
     FootStepWater(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepWater2'
     FootStepWater(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepWater3'
     FootStepWood(0)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric1'
     FootStepWood(1)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric2'
     FootStepWood(2)=Sound'DOTZXCharacters.ZombieMovementSounds.MovementFootstepGeneric3'
     FootStepSnow(0)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush1'
     FootStepSnow(1)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush2'
     FootStepSnow(2)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush3'
     SpecialDamage(0)=(BoneName="LUpperArm",ReqMinHitDistance=15,DamageEmitter=Class'BBParticles.BBPGibBicep',SubDamageBones=("LForearm"),DamageMod=0.500000)
     SpecialDamage(1)=(BoneName="RUpperArm",ReqMinHitDistance=15,DamageEmitter=Class'BBParticles.BBPGibBicep',SubDamageBones=("RForearm"),DamageMod=0.500000)
     SpecialDamage(2)=(BoneName="LForearm",ReqMinHitDistance=20,DamageEmitter=Class'BBParticles.BBPGibForearm',DamageMod=0.300000)
     SpecialDamage(3)=(BoneName="RForearm",ReqMinHitDistance=20,DamageEmitter=Class'BBParticles.BBPGibForearm',DamageMod=0.300000)
     SpecialDamage(4)=(BoneName="Jaw",ReqMinHitDistance=6,DamageEmitter=Class'BBParticles.BBPGibJaw',DamageMod=0.400000)
     SpecialDamage(5)=(BoneName="Head",ReqMinHitDistance=22,offset=(Z=8.000000),DamageEmitter=Class'BBParticles.BBPGibHead',bFatal=True)
     SpecialDamage(6)=(BoneName="LCalf",ReqMinHitDistance=23,DamageEmitter=Class'BBParticles.BBPGibLeg',DamageMod=0.500000)
     SpecialDamage(7)=(BoneName="RCalf",ReqMinHitDistance=23,DamageEmitter=Class'BBParticles.BBPGibLeg',DamageMod=0.500000)
}
