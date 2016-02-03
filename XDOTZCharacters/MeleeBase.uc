// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MeleeBase extends ZombiePawnBase
abstract notplaceable
   HideDropDown;

var() class<WeaponAttachment> MeleeWeaponClass;
var() class<WeaponPickup> MeleePickupClass;
var WeaponAttachment MeleeWeapon;
var int HeadShotHack;


simulated function PostNetReceive(){
   super.PostNetReceive();
   if (Health <=0){
    if (MeleeWeapon != none){
      DetachFromBone(MeleeWeapon);
      MeleeWeapon.Destroy();
    }

   }
}

simulated function PostNetBeginPlay(){

   super.PostNetBeginPlay();
   //attach a weapon
   SetCollision(false,false,false);
   MeleeWeapon = Spawn(MeleeWeaponClass,self,,Location);
   if (MeleeWeapon != none){
      AttachToBone(MeleeWeapon, 'Weapon');
   }
   SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers);

}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function BeginPlay(){

   walks.length = 1;
   walks[0] = 'WalkF';
   super.BeginPlay();

   //No dashing
   ZombieAIRole(ZombieAIController(Controller).myAIRole).bAllowedToCharge = false;

   //set attack anims for melee
    MeleeAttacks.remove(1,2); //leave attackrighta
    MeleeAttacks.remove(2,4); //leave attacklefta

    //Hack out the ablility to blow off arms and legs
    SpecialDamage.Remove( 6, 2 );
    SpecialDamage.Remove(0,4);
}


/*****************************************************************
 * DoSpecialDamage
 * Overridden to check for leg damage to convert these guys into crawlers.
 *****************************************************************
 */
function int DoSpecialDamage( vector Hitlocation, vector HitDirection,
                                int Damage ) {
   HeadShotHack++;
   if (HeadShotHack < 7){
      return Damage;
   }

   return super.DoSpecialDamage(HitLocation, HitDirection, Damage);

}

/*****************************************************************
 * Melee_Attack
 * Called by the controller to make the pawn do a melee attack
 *****************************************************************
 */
function Melee_Attack(){
   local int index;
   //don't do anything while playing focus
   if (IsAnimating(FOCUSCHANNEL) == true){
    // ("Melee damage failed");
      return;
   }
   SetBoredomTimer(false);
   //Walking
   index = int(Frand()*MeleeAttacks.length);
   //Log(MeleeAttacks[index].MeleeAttackAnim);
   AnimBlendParams(FIRINGCHANNEL,1,,,FIRINGBLENDBONE);
   AdvancedPlayAnim(MeleeAttacks[index].MeleeAttackAnim,1,0.8,FIRINGCHANNEL);
}


/*****************************************************************
 * Notify_MeleeDamage
 *****************************************************************
 */
function Notify_MeleeDamage(){
   AttemptMeleeDamage();
}


//===========================================================================
// State FocusedAnimation
//
//===========================================================================
//state  FocusedAnimation
//{
//
//}

/*****************************************************************
 * Died
 * turn off you timers
 *****************************************************************
 */
function Died(Controller killer, class<DamageType> type, vector hitlocation){
    local WeaponPickup temp;
    super.Died(killer, type, hitlocation);
    if (MeleeWeapon != none){
      DetachFromBone(MeleeWeapon);
      MeleeWeapon.Destroy();
    }
    temp = Spawn(MeleePickupClass);
    temp.InitDroppedPickupFor(None);
    temp.Velocity.X = FRand()*30;
    temp.Velocity.Y = FRand()*30;
    temp.Velocity.Z = FRand()*30;
}


//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     iMeleeDamageRadius=110
     iMeleeAttackRange=100
     iMeleeDamageAmount=35
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
     AnimRunForward="WalkF"
     AnimRunBack="WalkB"
     AnimRunLeft="WalkL"
     AnimRunRight="WalkR"
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
     bAllowedToFall=False
     Health=200
     ControllerClass=Class'DOTZAI.NoChargeZombieController'
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
}
