// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * JackSlade -
 *
 * The mesh specification for the lead action figure
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    2004
 *****************************************************************
 */
class PlayerPawnBase extends HumanPawnBase;



var int infectionDamage;
var int infectionFreq;
var name InfectedEvent;
var int disinfectioncounter;

const InfectedFOVMax    = 120;
const INFECTIONTIMER    = 24;
const DISINFECTIONTIMER = 26;
const WEAPON_UP_TIMER   = 3982834;
const WEAPON_DOWN_TIMER = 3849302;
const HUD_HACK          = 25;
const DESTROY_TIMER     = 26;

var int iMultiPlayerCorpseSecs;
var bool bWasInfected;
var bool bNoDamageEffects;

var int StartTime;

/*****************************************************************
 * PostNetReceive
 * Here we handle when data from the server comes in.
 *****************************************************************
 */
simulated event PostNetReceive(){

   if (Level.NetMode == NM_Client){
      if (bWasInfected != bInfected){
         bWasInfected = bInfected;
         DOTZPlayerControllerBase(Controller).InfectionEffect(bInfected);
      }
   }
   super.PostNetReceive();
}


function PostBeginPlay(){
   super.PostBeginPlay();
}

simulated function PostNetBeginPlay(){
   super.PostNetBeginPlay();

   if (Controller.IsA('XdotzPlayerController') == false){
      WEAPON_NAME_CENTRE += 40;
      WEAPON_NAME_Y += 40;
   }
   bNoDamageEffects = false;
   StartTime = Level.TimeSeconds;
   DOTZPlayerControllerBase(Controller).InfectionEffect(false);
}

function TakeFallingDamage(){
    local float Shake, EffectiveSpeed;

    if (Velocity.Z < -0.5 * MaxFallSpeed)
    {
        if ( Role == ROLE_Authority )
        {
            MakeNoise(1.0);
            if (Velocity.Z < -1 * MaxFallSpeed)
            {
                EffectiveSpeed = Velocity.Z;
                if ( TouchingWaterVolume() )
                    EffectiveSpeed = FMin(0, EffectiveSpeed + 100);
                if ( EffectiveSpeed < -1 * MaxFallSpeed ){
                    TakeDamage(-160 * (EffectiveSpeed + MaxFallSpeed)/MaxFallSpeed, None, Location, vect(0,0,0), class'Fell');
                    if (health > 0 ){
                     FallDown(vect(-1,0,0));
                       if(PlayerController(Controller) != none){
                        AdvancedPlayerController(Controller).Fall(); // camera effect
                       }
                    }
                }
            }
        }
        if ( Controller != None )        {
            Shake = FMin(1, -1 * Velocity.Z/MaxFallSpeed);
            Controller.ShakeView(0.175 + 0.1 * Shake, 850 * Shake, Shake * vect(0,0,1.5), 120000, vect(0,0,10), 1);
        }
    }
    else if (Velocity.Z < -1.4 * JumpZ)
        MakeNoise(0.5);
}



/*****************************************************************
 * CheckShadow
 * overridden to prevent shadowness on the player in a single player
 * game
 *****************************************************************
 */
simulated function CheckShadow(){
   /*if (Level.NetMode != NM_StandAlone){
      super.CheckShadow();
   } */
}


/*****************************************************************
 * PostLoad
 * Reset the infection state
 *****************************************************************
 */
function PostLoad() {
    super.PostLoad();
//    log(self $ "postload");
    SetInfectionState( bInfected, true );
    if (IsInState('Swimming')){
        if (Weapon != none){
            Weapon.PlayAnim('Deselect');
            SetMultiTimer( WEAPON_UP_TIMER, 0, false );
            SetMultiTimer( WEAPON_DOWN_TIMER, 0, false );
        }
    }

}

/*****************************************************************
 * PhysicsVolumeChange
 *****************************************************************
 */
event PhysicsVolumeChange( PhysicsVolume NewVolume ){

//    Log(NewVolume);

    if ( NewVolume.Isa('WaterVolume') ) {
        GotoState('Swimming');
    }
    else if ( IsInState('Swimming') && Weapon !=None ) {
        SetMultiTimer( WEAPON_UP_TIMER, 0.5, false );
        SetMultiTimer( WEAPON_DOWN_TIMER, 0, false );
        GotoState('');
    }

    super.PhysicsVolumeChange( NewVolume);
}


/*****************************************************************
 * SetInfectionState
 *****************************************************************
 */
function SetInfectionState(bool iState, optional bool bForce ){

    //no sense doing stuff if you already done it'afore
    //... unless you're re-initializing because of load game...
    if ( !bForce ) {
        if (bInfected == iState ){
            return;
        } else {
            bInfected = iState;
        }
    }

//    Log(self $ " setinfectionstate: " $ iState);
    DOTZPlayerControllerBase(Controller).InfectionEffect(bInfected);
   //DOTZPlayerControllerBase(Controller).MotionBlurOn();
    //always trigger events, and set timers on the client
    if (bInfected == true){
      if (!bForce){
         TriggerEvent( InfectedEvent, self, none);
      }
      SetMultiTimer(INFECTIONTIMER,infectionFreq,true);
    }
}

/*****************************************************************
 * DoInfectionDamage
 *****************************************************************
 */
function DoInfectionDamage(){
   if (bInfected == true){
      disinfectioncounter++;
      TakeDamage(infectionDamage, none,vect(0,0,0),vect(0,0,0), class'DOTZInfectionDamage');
      if (PlayerController(Controller).DefaultFOV  < InfectedFOVMax ){
        PlayerController(Controller).DefaultFOV += 6;
      }

      if (disinfectioncounter > 3){
         DoDisinfection();
      }
   }
}

/*
function PreSave(){
   super.PreSave();
   log("PreSave");
   DOTZPlayerControllerBase(Controller).InfectionEffect(false);
}

function PostSave(){
   super.PostSave();
   log("PostSave");
   DOTZPlayerControllerBase(Controller).InfectionEffect(bInfected);
}
*/

/*****************************************************************
 *
 *****************************************************************
 */

function DoDisinfection(){
   bInfected = false;
   disinfectioncounter=0;
   SetMultiTimer(INFECTIONTIMER,0,false);
   DOTZPlayerControllerBase(Controller).InfectionEffect(false);
   //DOTZPlayerControllerBase(Controller).MotionBlurOff();
   PlayerController(Controller).FixFOV();
   //DOTZHealthBar(MyLifeBar).SetInfected( bInfected );
   PlayerController(controller).ClientFlash(0.2, vect(1000,1000,1000 ));
}

/*****************************************************************
 * TravelPostAccept
 *****************************************************************
 */
function TravelPostAccept(){
    super.TravelPostAccept();

//   Log("Travel post accept called on the player");

    if (bInfected == true){
        SetMultiTimer(INFECTIONTIMER,infectionFreq,true);
    }
}

/*****************************************************************
 * PlayTakeHit
 * Overridden to prevent the hit noises from infection damage
 *****************************************************************
 */
function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType) {
    local name HitAnim;
    local E_HitPart hitPart;

    //turn off the boredom timer
    SetBoredomTimer(false);
//    AnimBlendParams(TAKEHITCHANNEL,1);
   AnimBlendParams(TAKEHITCHANNEL,1,,,FIRINGBLENDBONE );
    hitPart = calcHitPart( hitLoc );
    Spawn(BloodEmitter,,,HitLoc);

    //this is the added line, the reason for overridding
    if (damageType != class'DOTZInfectionDamage'){
        PlayHitSound();
    }
    ViewKick(ViewKickMagnitude);

    //try and use a weapon specific hit animation first
   if (AdvancedWeapon(Weapon) != none){
      HitAnim = AdvancedWeapon(Weapon).GetHitanim();
      //Log("you win: " $ hitanim);
   }

   if (HitAnim == ''){
    switch ( hitPart ) {
    case HIT_Back:
        HitAnim = HitBack[int(Frand()*HitBack.length)];
        break;
    case HIT_Head:
        HitAnim = HitHead[int(Frand()*HitHead.length)];
        break;
    case HIT_Chest:
        HitAnim = HitFront[int(Frand()*HitFront.length)];
        break;
    case HIT_Left:
        HitAnim = HitLeft[int(Frand()*HitLeft.length)];
        break;
    case HIT_Right:
    default:
        HitAnim = HitRight[int(Frand()*HitRight.length)];
        break;
    }
   }
//    PlayAnim(HitAnim,1,hitblend,TAKEHITCHANNEL);
   AdvancedPlayAnim(HitAnim,1,hitblend,TAKEHITCHANNEL);
}




/*****************************************************************
 * TakeDamage
 *****************************************************************
 */
function TakeDamage(int Damage,Pawn instigatedBy, Vector Hitlocation,
                    vector momentum, class<damageType> damageType){
                // Log( self @ "" $ DamageType  )    ;

    if (bNoDamageEffects == true || Level.TimeSeconds - StartTime < 5){
      return;
    }

    //already dead igmore further damage so you don't
    //chunk up and prevent the death animation from playing
    if (Health < 0){
        return;
    }

    if (DamageType == class'DOTZInfectionDamage') {
        SetInfectionState(true);
    }
    //fire should burn the zombies much worse
    else if (DamageType == class'Burned') {
                    // Log( self @ "Damage was: " $ Damage )    ;
        Damage = Damage / 4;
                    // Log( self @ "Damage reset to : " $ Damage )    ;
    }
    //can't hurt yourself with some weapons
    if (InstigatedBy == self && AdvancedWeapon(Weapon).bCanDamageSelf == false){
        return;
    }
    //you are much tougher in kungfu mode
    if (DOTZPlayerControllerBase(Controller).KungFuMode == true){
        Damage = Damage / 3;
    }
    Super.TakeDamage(Damage,instigatedBy, Hitlocation, momentum, damageType);
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int ID){
    switch ( ID ) {
    case INFECTIONTIMER:
        DoInfectionDamage();
        break;

    case WEAPON_UP_TIMER:
        Weapon.BringUp();
        AdvancedWeapon(Weapon).AccuracyIndicator
            = AdvancedWeapon(Weapon).default.AccuracyIndicator;
        break;

    case WEAPON_DOWN_TIMER:
        AdvancedWeapon(Weapon).AccuracyIndicator = none;
        Weapon.PutDown();
        break;

    case DESTROY_TIMER:
        Destroy();
        break;

    default:
        Super.MultiTimer(ID);
   }
}

/****************************************************************
 * Died
 ****************************************************************
 */
function Died( Controller killer, class<DamageType> damageType,
               vector hitLocation ) {
   //almost like do disinfection, but we leave the health bar, and
   //don't do the 'heal' flash
   bInfected = false;
   disinfectioncounter=0;
   SetMultiTimer(INFECTIONTIMER,0,false);
   //AdvancedPlayerController(Controller).MotionBlurOff();
   DOTZPlayerControllerBase(Controller).InfectionEffect(false);
   PlayerController(Controller).FixFOV();

  // Log(self $ " has ded");
   if (Level.NetMode != NM_Standalone){
      SetMultiTimer(DESTROY_TIMER,iMultiPlayerCorpseSecs,false);
//      Log(self $ " has ded");
//     LifeSpan=5;
   }

   super.Died(killer, damageType, hitlocation);
}

state Swimming{
   /*****************************************************************
    * BeginState
    *****************************************************************
    */
   function BeginState(){
        SetMultiTimer( WEAPON_DOWN_TIMER, 0.5, false );
        SetMultiTimer( WEAPON_UP_TIMER, 0, false );
   }

   /*****************************************************************
    * ChangedWeapon
    *****************************************************************
    */
   function ChangedWeapon(){
   }
}


/*****************************************************************
 * Destroyed
 *****************************************************************
 */
function Destroyed(){
   SetMultiTimer(INFECTIONTIMER,0,false);
   SetMultiTimer(DISINFECTIONTIMER,0,false);
//   Log(self $ " has been destroyed");
   Super.Destroyed();
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     infectionDamage=7
     infectionFreq=2
     InfectedEvent="PLAYER_INFECTED"
     iMultiPlayerCorpseSecs=20
     bNoDamageEffects=True
     LyingAnims(0)="LyingPose"
     FallSound=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4'
     AdditionalAnimPkg(0)=(AnimName="DOTZAHumans.HumanStandard")
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
     AnimCrawlHitRight(0)="CrawlHitRightSide"
     AnimCrawlHitLeft(0)="CrawlHitLeftSide"
     AnimCrawlHitBack(0)="CrawlHitBack"
     AnimCrawlHitHead(0)="CrawlHitHead"
     AnimCrawlHitFront(0)="CrawlHitFront"
     BloodEmitter=None
     RagdollLifeSpan=0.000000
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
     bDoFootsteps=True
     HitSounds(0)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt1'
     HitSounds(1)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt2'
     HitSounds(2)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt3'
     HitSounds(3)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4'
     DeathSounds(0)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainDeath1'
     DeathSounds(1)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainDeath2'
     DeathSounds(2)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainDeath3'
     DeathSounds(3)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainDeath4'
     DeathSounds(4)=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainDeath5'
     bInfiniteAmmo=False
     bAlwaysPlayDying=True
     bDamageKicksView=True
     bJumpCapable=True
     bCanPickupInventory=True
     GroundSpeed=565.000000
     ControllerClass=None
     bAlwaysRelevant=True
     bTravel=False
     CollisionRadius=30.000000
}
