// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieAIController -
 *
 * @version $Rev: 4980 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class ZombieAIController extends DOTZAIController;



// settings
var name EatingAnim;
var name CrawlEatingAnim;
var int iAwarenessRange;
var string DefaultWeaponType;

// internal
var class<ExclaimManager> TheExclaimManager;
var bool bForceRun;
const CONFIGURE_HACK_TIMER = 294850;
var bool bConfigured;
const EATCHANNEL = 20;

/**
 */
function BeginPlay() {
    super.BeginPlay();
    SetMultiTimer( CONFIGURE_HACK_TIMER, 3, false );
}

/**
 */
function MultiTimer( int timerID ) {
    //NOTE: an ugly hack to make sure that pawns not spawned from factories get
    //      their weapon.
    if ( timerID == CONFIGURE_HACK_TIMER ) {
        if ( !bConfigured ) configure( none, none );
    }
    else super.MultiTimer( timerID );
}

/**
 */
function bool SameTeamAs(Controller C) {
    // only zombies
    return (ZombieAIController(c) != None);
}

/**
 */
function configure( OpponentFactory f, Stage initialStage ) {
    bConfigured = true;
    super(VGSPAIController).configure( f, initialStage );
    if (Pawn != None){
       Pawn.GiveWeapon( DefaultWeaponType );
       if (AdvancedPawn(Pawn) != none &&
           ZombieFactory(f) != none &&
           ZombieFactory(f).SpawnAnims.length > 0){
          AdvancedPawn(Pawn).AnimSpawn = ZombieFactory(f).SpawnAnims;
          AdvancedPawn(Pawn).PlaySpawnAnim();
        }
    }
}

/**
 */
function bool shouldWalk() {
    local AdvancedPawn ap;

    ap = AdvancedPawn( Pawn );
    // make sure crawlers don't try to force through a run...
    if ( ap != none && ap.bIsCrawling ) return true;
    else return !bForceRun;
}

/**
 */
function bool ShouldStrafe() {
    return false;
}

/**
 * Attempt a melee attack against the current enemy.
 */
function Perform_MeleeAttack() {
     GotoState( 'MeleeAttack' );
}

/**
 */
state MeleeAttack {

BEGIN:
    curBehaviour = "MeleeAttack";
    if ( Enemy != none ) updateFocus( Enemy, true );
    FinishRotation();
    //TODO: check range? move closer?
    Pawn.Acceleration = vect(0,0,0);
    Pawn.Velocity     = vect(0,0,0);
    //NOTE: with the current melee implementation, this just means firing the
    //      "weapon"
    WeaponFireAgain(Pawn.Weapon.RefireRate(),false);
    //TODO: sync up with completion of the attack animation...
    sleep( 2 + FRand() * 1 );
    //TODO: if we had feedback from the weapon about hit/miss, the role callback
    //      would be more meaningful...
    myAiRole.MeleeAttackSucceeded();
    curBehaviour = "MeleeAttack-done";
}


/****************************************************************
 * Perform_Eating
 * Command to start the eating animation
 ****************************************************************
 */
function Perform_Eating() {
   GotoState('Eating');
}


/****************************************************************
 * InAwarnessRange
 ****************************************************************
 */
function bool InAwarenessRange(actor enemy){
   if(VSize(pawn.location - enemy.location) < iAwarenessRange){
      return true;
   } else {
      return false;
   }
}

function SpawnExclaimManager(){
   exclaimMgr = Spawn(TheExclaimManager, self);
   exclaimMgr.init(self);
}

/**
 * Override firing to trigger the melee flail of a zombie.
 *
 * NOTE This won't be necessary if we make the ZombieGrope weapon fully
 * NOTE functional.
 */
function TimedFireWeaponAtEnemy() {
                // Log( self @ "firing!"  )    ;
    //NOTE assumes the weapon is a melee attack weapon...
    if ( (Pawn.Weapon != None) && !Pawn.Weapon.IsFiring() ) {
        WeaponFireAgain( Pawn.Weapon.RefireRate(), false );
    }
}


//===============================================================
// state Eating
//===============================================================
state Eating
{
    ignores KilledBy, EnemyNotVisible;

    function BeginState() {
        local AdvancedPawn ap;
        ap = AdvancedPawn( pawn );
        if (ap.bIsCrawling) EatingAnim = CrawlEatingAnim;
    }

    function EndState() {
        // clobber the eat anim loop
        //AdvancedPawn(pawn).PlayAnim( EatingAnim );
        //LoopAnim( EatingAnim );
        AdvancedPawn(pawn).AdvancedPlayAnim( EatingAnim,,,,true );
        bControlAnimations = false;
    }


    /**
     */
    function SeePlayer(Pawn Seen){
        if ( InAwarenessRange(Seen) ) {
            Super.SeePlayer(Seen);
        }
    }

    /**
     */
    function HearNoise( float Loudness, Actor NoiseMaker){
        if (InAwarenessRange(NoiseMaker)){
            Super.HearNoise(Loudness, NoiseMaker);
        }
    }


BEGIN:
    Sleep( RandRange( 0.1, 0.8 ) );
    AdvancedPawn(Pawn).AdvancedPlayAnim(EatingAnim,,,,true);
    bControlAnimations = true;
    //Pawn.LoopAnim(EatingAnim);
}


//===============================================================
// DefaultProperties
//===============================================================

defaultproperties
{
     EatingAnim="Eating"
     CrawlEatingAnim="CrawlEating"
     iAwarenessRange=200
     DefaultWeaponType="XDOTZCharacters.ZombieGropeWeapon"
     TheExclaimManager=Class'DOTZAI.DOTZZombieExclaimMgr'
     bMeleeAttackCapable=True
     bRangedAttackCapable=False
     AIType=Class'DOTZAI.ZombieAIRole'
}
