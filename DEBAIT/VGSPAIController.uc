// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * The main controller class for AI characters using the DEBAIT
 * framework.  The controller is responsible for low level behaviours,
 * like aiming, dodging, and moving, as well as reporting information
 * to the stage.  The stage handles higher level coordination,
 * especially between characters.  The AIRole handles the intermediate
 * logic required to translate orders into sequences of behaviours.
 *
 * TODO:
 *   - make sure all behaviours report completion properly, like
 *     TakePosition does.
 *
 *
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    June 2003
 */
class VGSPAIController extends VGSPAIBase
   HideDropDown;

//----------------------
// Behaviour properties
//----------------------

// Awareness settings
//
//How long must the enemy be out of sight before considering him lost
var float MaxLostContactTime;
//How long is the typical time between acquiring LOS and shooting
var float ReflexTime;

// Melee Attack settings (doesn't use the combat timer)
//
var bool bMeleeAttackCapable;

// Ranged Attack settings
//
var bool bRangedAttackCapable;
//How many bullets in a typical burst of fire.
var int MinNumShots, MaxNumShots;
//How long between bursts of fire
var float MinShotPeriod, MaxShotPeriod;
// maximum chance-to-hit factor due to skill...
var float MaxSkillOdds;

//AimRelated
//aim approaches 0 as enemy's distance approaches this
var float MaxAimRange;
//aim approaches 0 as enemy's relative lateral velocity approaches this
var float MaxAimVelocity;
//aim approaches 1 as enemy stays in sight this long.
var float MaxSecondsOfLOS;
//The scale used to aim away from the targets center, which ought to
//shrink with accuracy.
var float MissVectorScale;

// Data for StrafeMove behaviour
var float fOddsOfStrafeMove;
// don't tactical move until at least this much time has passed
var float MinTimeBetweenStrafeMove;

//Data for AdvanceMove
var float LastAdvanceMoveTime;
//how far the character will travel while panicking?
var float PanicRange;

// How long to focus on the enemy rather than the target when damaged
var float EnemyDistractDuration;
// Min distance between this character and current enemy before
// switching focus from ShootTarget to Enemy.
var float EnemyDistractDistance;
//Position selection behaviour tweaks
var float m_BunchPenalty;
var float m_BlockedPenalty;
var float m_BlockingPenalty;
var float m_NeedForCover;
var float m_NeedForContact;
var float m_NeedCohesion;
var float m_NeedForIntel;
var float m_NeedToAvoidCorpses;
var float m_NeedForClosingIn;
var float m_NeedForNearbyGoal;

// This is added to nearby navigation points when a pawn gets killed,
// and is reduced every second by 5% by the GameInfo.  Thus it's often
// desirable to make this penalty bigger if you want it to last longer.
const FEAR_PENALTY = 16384;

//---------------------------
// Other editable properties
//---------------------------

// enable debugging output
var() bool bDebugLogging;
// a bit-mask to reduce the quantity of debugging output, and related
// consts...
var() int AIDebugFlags;
const DEBUG_FIRING = 0x00000001;

// value added to path cost when passing through a claimed position
var() const int CLAIMED_POSITION_PENALTY;

//---------------------
// Internal properties
//---------------------

// How often to change focus
var float LastFocusChangeTime;
var float RandFocusChangeDuration;
// Firing Control related
var bool  bFireAtLastLocation;
var bool  bStopFireAnimation;
var int   NumShotsToGo;

// Enemy Management
var float EnemyInSightTime;
var bool  bEnemyIsVisibleCache;
var float EnemyVisibilityCacheTime;
var pawn  VisibleEnemy;
var float LoseEnemyCheckTime;
var float AcquireTime;
// an actor to shoot at if there's no enemy
var Actor ShootTarget;
var Actor tmpTarget;
var Actor pendingFocus;

var private OpponentFactory myCreator;
var private Name lastState;
var private EPhysics lastPawnPhysics;
var private float lastHitTime; // time (seconds) pawn last took damage.
var String  curBehaviour; //for debugging, should reflect current decision;
var bool bHibernating;
// AI Behaviour Modifier (Grunt, Leader, Medic)
var AIRole myAIRole;
var class<AIRole> AIType;

// navigation
var int numMoveAttempts;

// Stage related
var Stage currentStage;
var StagePosition claimedPosition;

// Order Management
enum EStageOrder
{
    SO_None,
    SO_TakeUpPosition,
    SO_HoldPosition,
    SO_TakeCover,
    SO_AttackTarget
};

var EStageOrder curStageOrder;

// Data for TakeUpPosition Order
var StagePosition TakeUpPosition;

// Data for StrafeMove behaviour
var float   LastStrafeMoveTime;
//Last time at which we made a tactical move
var Vector  strafeTarget;
var bool    bStrafeDir;

//Data for Hide behaviour
var float   LastHideTime;

//Data for TakeCover behaviour
var float       maxDistToCrouchForCover;
var float   LastTakeCoverTime;

//Data for Wander
var float   LastWanderTime;
var Actor       wanderDestination;

// Data for Panic behaviour
var bool    bHavePanicked; //Only panic once.
var float   PanicStartTime;

// data for move behaviour
var vector      moveDestination;
var float       moveSlop;

// data for charge action
var float       chargeEndTime;

//Exclamations
var ExclaimManager exclaimMgr;

const SIGHT_CHECK_TIMER     = 39201;
const FOCUS_TIMER           = 39202;
const FOCUS_UPDATE_INTERVAL = 1.5;
const UNGHOST_TIMER         = 39203;
const LOST_SIGHT_TIMER      = 68695;

//NOTE this shouldn't really be here, but it breaks the scripted sequences
//     without it.
function SelectAction() {
    myAIRole.botSelectAction();
}

//----------------
// Implementation
//----------------

/**
 */
function float getLastHitTime() {
    return lastHitTime;
}

/**
 */
function setLastHitTime() {
    lastHitTime = Level.TimeSeconds;
}

/**
 */
function BeginPlay()
{
    Super.BeginPlay();
}


function Possess(Pawn aPawn){
    super.Possess(aPawn);
    SpawnExclaimManager();
}

/**
 * Called from Pawn.possess(), which is in PostBeginPlay() for
 * statically placed pawns.
 */
function Restart()
{
    Super.Restart();
    initAIRole();
    SetMultiTimer( SIGHT_CHECK_TIMER, 3, true );
}

/**
 */
function SpawnExclaimManager()
{
    exclaimMgr = Spawn(class'ExclaimManager',self);
    exclaimMgr.init(self);
}

/**
 * Ensures that this controller has an AI role object that's ready to
 * go.
 */
function InitAIRole()
{
    if ( myAIRole == None ) {
        if ( AIType == None ) AIType = class'AIRole';
        myAIRole = Spawn(AIType,self);
    }
    myAIRole.init(self);
}

/**
 */
function Destroyed()
{
    Super.Destroyed();
    Cleanup();
    if(exclaimMgr != None) {
        exclaimMgr.Destroy();
    }
    if(myAIRole != None) {
        myAIRole.Destroy();
    }
}

/**
 */
state Scripting {
    /**
     */
    function BeginState() {
        //log( "@@@@@@@@@@@@@@@ Starting scripting state!!" );
        myAIRole.GotoState( 'Scripting' );
    }

    /**
     */
    function EndState() {
        //log( "@@@@@@@@@@@@@@@ Ending scripting state!!" );
        super.EndState();
    }

    function LeaveScripting() {
        super.LeaveScripting();
        GoalScript = none;
        myAIRole.GotoState( 'InitRole' );
    }
}


//===========================
// Opponent Factory interface
//===========================

/**
 * this is called from the OpponentFactory when it sets up a new NPC
 */
function configure( OpponentFactory f, Stage initialStage ) {
    DebugLog( self $ " configured with " $ f $ ", " $ initialStage );
    myCreator = f;
    if ( initialStage != None ) initialStage.joinStage( self );
    ClientSwitchToBestWeapon();
}

/**
 */
function SetCreator(OpponentFactory f) {
    if(myCreator != None)
        return;
    myCreator = f;
}

/**
 */
event PreSaveGame()
{
    myCreator = None;
    currentStage = None;
}


//===========================================================================
// Stage Orders - these orders are the stage's interface to the bots.
//    By following the orders, the bots should appear to be
//    coordinated and intelligent in their actions.  However, the
//    orders still leave lots of latitude for personality and
//    variations in *how* they are executed.
//
//    Controllers communicate success and failure back to the stage
//    using the Report_* methods, as specified below...
//===========================================================================

/**
 * Stage is going to maintain bookeeping, but bot is free to do what
 * it likes.
 *
 * success: N/A
 * failure: N/A
 */
function StageOrder_None() {
    myAIRole.Order_None();
}

/**
 * Go to the specified position.  Wandering away from the position
 * after arriving and reporting is okay, as long as it doesn't
 * contradict new orders.  Staying in the general vicinity of the
 * position is prefered.
 *
 * success: Report_InPosition()
 * failure: Report_PositionUnreachable()
 */
function StageOrder_TakeUpPosition( StagePosition pos ) {
    myAIRole.Order_TakeUpPosition( pos );
}

/**
 * Stay in the current position.  Bot can shoot, hide, or whatever
 * else seems appropriate in the moment.
 *
 * success: N/A
 * failure: Report_AbandonedPosition()
 */
function StageOrder_HoldPosition() {
    myAIRole.Order_HoldPosition();
}

/**
 * Get out of the line of fire by going to (or staying at) pos.  May
 * require crouching at the destination.  If no position is specified,
 * the bot should choose a location itself.
 *
 * success: Report_Covered()
 * failure: Report_Exposed()
 */
function StageOrder_TakeCover( optional StagePosition pos ) {
    myAIROle.Order_TakeCover( pos );
}

/**
 * Attack the specified actor.  The bot should not change targets
 * unless directed to do so by the stage.  Thus it is important for
 * the bot to report if it is under attack from another enemy, so that
 * the stage will be able to promptly tell the bot to change enemies
 * (if it suits the strategy of the stage).
 *
 * success: Report_TargetDestroyed()
 * failure: Report_FailedAttack()
 */
function StageOrder_AttackTarget( Actor target ) {
    myAIRole.Order_AttackTarget( target );
}

//NOTE The rest of these are kind of odd orders, maybe obselete?

/**
 * Treat the specified pawn as your current enemy?
 * NOTE obselete?  implied by attack target?
 */
function StageOrder_AlertNewEnemy(Pawn bogie, bool bCanSee)
{
    AcquireEnemy(bogie, bCanSee);
}

/**
 *
 */
//NOTE right now, only newStage should call this.  use newStage.joinStage()
function StageOrder_JoinStage( Stage newStage )
{
    if ( currentStage != None ) {
        currentStage.leaveStage( self, RSN_JoinedOtherStage );
    }
    currentStage = newStage;
    if ( Enemy != None && currentStage != None ) {
        currentStage.Report_EnemySpotted( Enemy, self );
    }
}

/**
 * called to put NPC into a dormant (minimal performance hit) mode
 */
function StageOrder_Hibernate() {
    // do nothing if already asleep.
    if ( bHibernating ) return;
    // hibernate the pawn
    bHibernating = true;
    curBehaviour = "stasis";
    lastPawnPhysics = Pawn.Physics;
    Pawn.SetPhysics(PHYS_None);
    Pawn.bStasis = true;
    pawn.bHidden = true;
    // hibernate the controller
    bStasis = true;
    GotoState('Dormant');
}

/**
 * called to undo hibernate()
 */
function StageOrder_Awaken() {
    // do nothing if already awake
    if ( !bHibernating ) return;
    // awaken the pawn
    Pawn.bStasis = false;
    Pawn.SetPhysics( lastPawnPhysics );
    // awaken the controller
    bStasis = false;
    pawn.bHidden = false;
    bHibernating = false;
    myAIRole.awakenSucceeded();
}


//=================
//Stage interfacing
//=================

/**
 * called from stage when providing a shooting position to make sure it
 * meets bot's requirements
 **/
function bool VerifyShootingPosition(StagePosition position)
{
    if ( Enemy == None || position == None ) return false;
    if( VSize(Enemy.Location - position.Location) > GetMaxFiringRange() ) {
        return false;
    }
    else return true;
}

/**
 * Heigher weight == better
 **/
function float WeightStagePosition(StagePosition position)
{
    local float weight;
    local float total;

    //if( !position.bLOSToPlayer)
    //  return 0;

    total = m_BunchPenalty + m_BlockedPenalty + m_BlockingPenalty
              + m_NeedForCover + m_NeedForContact
              + m_NeedCohesion + m_NeedForIntel + m_NeedToAvoidCorpses
              + m_NeedForClosingIn + m_NeedForNearbyGoal;

    weight =
        m_BunchPenalty * ProjDistToBuddiesAsSeenFromThreat(position)
        + m_BlockedPenalty * BlockedLineOfFireByBuddies(position)
        + m_BlockingPenalty * BlockingLineOfFireOfBuddies(position)
        + m_NeedForCover * DistanceToNearestFreeCoverSpot(position)
        + m_NeedForContact * NumberOfLinesOfSightToBuddies(position)
        + m_NeedCohesion * ProperDistanceToBuddies(position)
        + m_NeedForIntel * NumberOfLinesOfSightToThreats(position)
        + m_NeedToAvoidCorpses * DistanceToDeadBuddies(position)
        + m_NeedForClosingIn * MinimumDistanceToThreat(position)
        + m_NeedForNearbyGoal * DistanceFromMe(position);

    return weight / total;
}

/**
 */
function float ProjDistToBuddiesAsSeenFromThreat(StagePosition position)
{
    local float tmpVal;
    local vector enemyRight;

    if( currentStage.StageAgents.Length == 1) return 1.0;
    //Undo the inclusion of ourselves in the stage's calculations

    enemyRight = vect(0,1,0) >> Enemy.Rotation;

    tmpVal = position.fProjDistToBuddies;

    tmpVal *= 1000.0;
    tmpVal *= currentStage.StageAgents.Length;
    tmpVal -= abs( (Pawn.Location - position.Location) dot enemyRight );

    tmpVal = tmpVal / (currentStage.StageAgents.Length - 1);
    if (tmpVal > 1000) return 1.0;
    else return tmpVal / 1000.0;
}

/**
 */
function float BlockedLineOfFireByBuddies(StagePosition position)
{
    local float returnVal;

    if( currentStage.StageAgents.Length == 1) return 1.0;
    returnVal = currentStage.calculateStagePosnLOSIsBlocked(self, position);
    return 1.0 - (returnVal / (currentStage.StageAgents.Length - 1));
}

/**
 */
function float BlockingLineOfFireOfBuddies(StagePosition position)
{
    local float returnVal;

    if( currentStage.StageAgents.Length == 1) return 1.0;
    returnVal = currentStage.calculateStagePosnBlocksLOS(self, position);
    return 1.0 - (returnVal / (currentStage.StageAgents.Length - 1));
}

/**
 */
function float DistanceToNearestFreeCoverSpot(StagePosition position)
{
    return position.fDistToCover;

}

/**
 */
function float NumberOfLinesOfSightToBuddies(StagePosition position)
{
    return 0;
}

/**
 */
function float ProperDistanceToBuddies(StagePosition position)
{
    local float tmpVal;

    if( currentStage.StageAgents.Length == 1) return 1.0;

    tmpVal = 1000.0 - 1000.0 * position.fDistToBuddies;
    tmpVal *= currentStage.StageAgents.Length;
    tmpVal -= VSize(Pawn.Location - position.Location);

    tmpVal = tmpVal / (currentStage.StageAgents.Length - 1.0);

    if( tmpVal > 1000 ) return 0;
    else return (1000.0 - tmpVal) / 1000.0;
}

/**
 */
function float NumberOfLinesOfSightToThreats(StagePosition position)
{
    local int i, count;

    //calculate weight of bitvector
    for( i=0; i<8; i++ )
    {
        if( (position.StandLOF & (0x1 << i)) > 0) count++;
    }
    return count;
}

/**
 */
function float DistanceToDeadBuddies(StagePosition position)
{
    return 1.0 - position.FearCost/750.0;
}

/**
 */
function float MinimumDistanceToThreat(StagePosition position)
{
    local float returnVal;

    returnVal = VSize(Enemy.Location - position.Location);
    if ( returnVal > 2500 /*|| returnVal < 1000*/ ) {
        return 0;
    }
    if ( returnVal < 200) {
        return 0;
    }
    else {
        return 1.0 - ((returnVal-200.0) / 2500.0);
    }
}

function float DistanceFromMe(StagePosition position)
{
    local float returnVal;
    returnVal = VSize(Pawn.Location - position.Location);
    if ( returnVal > 2500 ) {
        return 0;
    }
    else {
        return 1.0 - ( (returnVal) / 2500.0);
    }
}

//==============
// Events
// This is where "engine level" notifications go.
//==============

/**
 * Called when a shot is taken at this pawn (so it can dodge)
 **/
function ReceiveWarning(Pawn shooter, float projSpeed, vector FireDir)
{
    DebugLog("ReceivedWarning from "$shooter$shooter.Controller);
}

/**
 * Called when the bot takes damage
 **/
function DamageAttitudeTo(Pawn Other, float Damage)
{
    if ( (Pawn.health > 0) && (Damage > 0) ) {
        TrySpotEnemy(Other , CanSee(Enemy) );
    }
    setLastHitTime();
    if( SameTeamAs(Other.Controller) ) {
        exclaimMgr.Exclaim(EET_FriendlyFire, 0);
    }
    else {
        exclaimMgr.Exclaim(EET_Pain, RandRange(0, 0.5) );
    }
    myAIRole.OnTakingDamage( Other,  Damage);
}


/**
 */
event HearNoise( float Loudness, Actor NoiseMaker)
{
    myAIRole.OnHeardNoise( loudness, noiseMaker );
    if ( Pawn(NoiseMaker) != None ) {
        TrySpotEnemy(Pawn(NoiseMaker), false);
    }
}

/**
 * called when a player (bIsPlayer==true) pawn is seen
 **/
event SeePlayer( Pawn Seen )
{
    if ( Enemy == Seen ) UpdateEnemyInfo();
    else TrySpotEnemy(Seen, true);
}

/**
 * Called as soon as Enemy is no longer visible (LOS)
 **/
event EnemyNotVisible()
{
    //log("EnemyNotVisible"@Enemy);
    EnemyInSightTime = -1;
    //bEnemyAcquired = false;
    if ( Focus == Enemy ) {
        UpdateFocus( None );
        FocalPoint = LastSeenPos;
    }
    myAIRole.OnLostSight();
    if ( currentStage != None ) {
        currentStage.Report_UnSighted(self, Enemy);
    }
    // shut off these notifications for a while.
    Disable( 'EnemyNotVisible' );
    SetMultiTimer( LOST_SIGHT_TIMER, 3.0, false );
}

/**
 * This should not only check if our enemy was killed,
 * but also notice if we see a friendly die.
 **/
function NotifyKilled( Controller Killer, Controller Killed, pawn KilledPawn )
{
    local Pawn oldEnemy;

    oldEnemy = Enemy;
    Super.NotifyKilled(Killer, Killed, KilledPawn);
    myAIRole.OnWitnessedKill( killer, killedPawn );
    if ( currentStage != None )
    {
        currentStage.Report_Killed(self, Enemy);
    }
    if ( Enemy == None )
    {
        SetRelaxAttributes();
    }
    // exclaimations!
    if ( exclaimMgr == None ) return;
    if ( Killer == self && KilledPawn == oldEnemy )
    {
        exclaimMgr.Exclaim(EET_KilledEnemy, 0.5);
    }
    else if ( SameTeamAs(Killer) && !SameTeamAs(Killed)
              && KilledPawn != None && Pawn != None
              && VSize(KilledPawn.Location - Pawn.Location) < 2500
              && LineOfSightTo(KilledPawn) )
    {
        exclaimMgr.Exclaim(EET_WitnessedKilledEnemy, RandRange(1.0, 1.5));
    }
    else if ( SameTeamAs(Killed)
              && KilledPawn != None && Pawn != None
              && VSize(KilledPawn.Location - Pawn.Location) < 2500
              && LineOfSightTo(KilledPawn) )
    {
        exclaimMgr.Exclaim(EET_WitnessedDeath, RandRange(0.0, 1.0), 0.5);
        if ( Killer != None && Killer.Pawn != None )
        {
            TrySpotEnemy(Killer.Pawn, CanSee(Killer.Pawn) );
        }
    }
}

/**
 */
event bool NotifyHitWall(vector HitNormal, actor Wall) {
    local bool superResult;

    superResult = super.NotifyHitWall( hitNormal, wall );
    myAIRole.OnHitWall( wall );

    return superResult;
}

/**
 */
event NotifyHitMover(vector HitNormal, mover Wall) {
    super.NotifyHitMover( hitNormal, wall );
    myAIRole.OnHitMover( wall );
}

/**
 * If it's an enemy, notice it, if it's a friend, coordinate moving
 * out of each others way.
 **/
event bool NotifyBump(actor Other)
{
    local Pawn P;

    super.NotifyBump( other );
    myAIRole.OnBump( other );
    P = Pawn(Other);
    if (P == None) return false;

    TrySpotEnemy(P, true);

    if ( Enemy == P ) return false;
    if ( AdjustAround(P) ) return false;

    return false;
}

/**
 * This is supposed to "interrupt" the regular movetowards stuff (by
 * setting bAdjusting) so that the bot moves around a dynamic obstacle
 **/
function bool AdjustAround(Pawn Other)
{
    local float speed;
    local vector VelDir, OtherDir, SideDir;

    speed = VSize(Pawn.Acceleration);
    if ( speed < Pawn.WalkingPct * Pawn.GroundSpeed )
        return false;

    VelDir = Pawn.Acceleration/speed;
    VelDir.Z = 0;
    OtherDir = Other.Location - Pawn.Location;
    OtherDir.Z = 0;
    OtherDir = Normal(OtherDir);
    if ( (VelDir Dot OtherDir) > 0.8 )
    {
        bAdjusting = true;
        SideDir.X = VelDir.Y;
        SideDir.Y = -1 * VelDir.X;
        if ( (SideDir Dot OtherDir) > 0 )
            SideDir *= -1;
        AdjustLoc = Pawn.Location + 2 * Other.CollisionRadius * (0.5 * VelDir + SideDir);
    }
}
//==============
// Enemy Management
//==============

function float AssessThreat( Pawn NewThreat, bool bThreatVisible )
{
    local float ThreatValue, NewStrength, Dist;

    if( NewThreat.Controller == None || SameTeamAs(NewThreat.Controller) ) return -1;
    //NewStrength = RelativeStrength(NewThreat);

    ThreatValue = NewStrength;
    Dist = VSize(NewThreat.Location - Pawn.Location);
    if ( Dist < 2000 )
    {
        ThreatValue += 0.2;
        if ( Dist < 1500 )
            ThreatValue += 0.2;
        if ( Dist < 1000 )
            ThreatValue += 0.2;
        if ( Dist < 500 )
            ThreatValue += 0.2;
    }

    if ( bThreatVisible )
        ThreatValue += 1;
    if ( (NewThreat != Enemy) && (Enemy != None) )
    {
        if ( !bThreatVisible )
            ThreatValue -= 5;
        if ( Dist > 0.7 * VSize(Enemy.Location - Pawn.Location) )
            ThreatValue -= 0.25;
        ThreatValue -= 0.2;
    }

    if ( NewThreat.IsHumanControlled() )
            ThreatValue += 0.25;

    DebugLog("assess threat "$ThreatValue$" for "$NewThreat);
    return ThreatValue;
}

/**
 * Has this bot been out of contact for MaxTime
 *  the stage may call this to see if an enemy can be removed.
 **/
function bool LostContact(float MaxTime)
{
    if ( Enemy == None || Enemy.Controller == None)
        return true;

    if ( TimeElapsed( FMax(LastSeenTime, AcquireTime) , MaxTime) )
        return true;

    return false;
}

/* LoseEnemy()
get rid of old enemy, if stage lets me
*/
function bool LoseEnemy(float Time)
{
    if ( Enemy == None || currentStage == None)
        return true;
    if ( (Enemy.Health > 0) && (Enemy.Controller != None) && (!TimeElapsed(LoseEnemyCheckTime,0.2)) )
        return false;
    LoseEnemyCheckTime = Level.TimeSeconds;
    if ( currentStage.Report_EnemyLost(self, Time) )
    {
        return true;
    }
    // still have same enemy
    return false;
}
function bool SameTeamAs( Controller c )
{
    return (c != Level.GetLocalPlayerController());
}

function bool EnemyIsVisible()
{
    if ( (EnemyVisibilityCacheTime == Level.TimeSeconds)
             && (VisibleEnemy == Enemy) )
    {
        return bEnemyIsVisibleCache;
    }
    VisibleEnemy = Enemy;
    EnemyVisibilityCacheTime = Level.TimeSeconds;
    bEnemyIsVisibleCache = LineOfSightTo(Enemy);
    return bEnemyIsVisibleCache;
}

/**
 * Manages the spotting of enemies, notifying the right objects and so on.
 *
 * @param potentialEnemy  - the new possible enemy
 * @param bCanSeePotEnemy - the new enemy is visible?
 * @param bSuppressRoleNotifications - don't do any callbacks to the role (good
 *          for avoiding infinite script recursion when the role wants to change
 *          the enemy itself!)
 */
function TrySpotEnemy( Pawn potentialEnemy, bool bCanSeePotEnemy,
                               optional bool bSuppressRoleNotifications )
{
    if( Enemy == potentialEnemy || potentialEnemy.Controller == none
            || SameTeamAs(potentialEnemy.Controller) )
    {
        return;
    }

    if ( !bSuppressRoleNotifications ) {
        if ( bCanSeePotEnemy ) myAIRole.OnThreatSpotted( potentialEnemy );
        //NOTE: if think if you can't see him, you must have heard him.
        else myAIROle.OnThreatHeard( potentialEnemy );
    }

    //notify stage
    if(currentStage != None)
    {
        //Stage will assess threat, and assign new enemy
        currentStage.Report_EnemySpotted(potentialEnemy, self);
    }
}

/**
 * Inits enemy mg'mt with the new potential enemy, unless already acquired.
 */
function AcquireEnemy(Pawn potentialEnemy, bool bCanSeePotEnemy)
{
    if ( potentialEnemy == Enemy ) return;

    AcquireTime = Level.TimeSeconds;
    Enemy = potentialEnemy;
    FocalPoint = Enemy.Location;
    EnemyInSightTime = -1;
    MoveTimer = -1;
    SetCombatTimer();
    bEnemyAcquired = false;
    if(!bCanSeePotEnemy)
    {
        LastSeenTime = -1000;
        bEnemyInfoValid = false;
    }
    else
    {
        exclaimMgr.Exclaim(EET_AcquireEnemy, 0);
        myAIRole.OnEnemyAcquired();
        UpdateEnemyInfo();
    }
    SetCombatAttributes();
    myAIRole.acquireEnemySucceeded();
}


/**
 * Update the visibility info
 **/
function UpdateEnemyInfo()
{
    // Enemy was not previously visible, update lastseen visibility info
    if (EnemyInSightTime == -1) {
        EnemyInSightTime = Level.TimeSeconds;
        // check if we're re-sighting the same enemy from earlier...
        if ( VisibleEnemy == Enemy && TimeElapsed(LastSeenTime, 1.0) ) {
            myAIRole.OnRegainedSight();
            if( currentStage != none
                    && currentStage.Request_PercentEyeSighted(self) == 0 ) {
                exclaimMgr.Exclaim(EET_NoticeEnemy, 0);
            }
        }
        //only need to update the stage if we were actually unsighted until now
        if (currentStage != None) {
            currentStage.Report_EyeSighted(self, Enemy);
        }
    }

    // freshen visibility stats...
    LastSeenTime         = Level.TimeSeconds;
    bEnemyInfoValid      = true;
    VisibleEnemy         = Enemy;
    bEnemyIsVisibleCache = true;
    EnemyVisibilityCacheTime = Level.TimeSeconds;
}

/**
 *
 */
function UpdateFocus( Actor newFocus, optional bool bImmediate )
{
    if ( bImmediate ) {
        Focus = newFocus;
    }
    else if ( pendingFocus != None && newFocus == Enemy ) {
        // if focus is oscillating, prefer the enemy.
        Focus = Enemy;
    }
    else {
        PendingFocus = newFocus;
        SetMultiTimer( FOCUS_TIMER, FOCUS_UPDATE_INTERVAL, false );
    }
}

/**
 * When we acquire an enemy, we should "heighten awareness" as it were.
 **/
function SetCombatAttributes();

/**
 * When we don't have an enemy, our awareness is "less"
 **/
function SetRelaxAttributes();


//==============
// Decision logic.
// Given a situation, decide what tactical behaviour is appropriate.
// In general, we must follow orders first, however the bot may have discretion about how to handle some orders
// (engage enemies first, or while on the way etc)
//==============

/**
 *  We currently have no order, Let enemy strategy take over.
 **/
function FollowOrder_None()
{
    myAIRole.SelectAction();
}

/**
 * Try to get to our designated position, notify the stage when we get
 * there.
 **/
function FollowOrder_TakePosition()
{
    UnClaimPosition();

    if(!Pawn.ReachedDestination( TakeUpPosition ) )
    {
        if( FindBestPathToward(TakeUpPosition, false, true) )
        {
            ClaimPosition(TakeUpPosition);
            Perform_MoveTowardPosition();
        }
        else
        {
            warn( self @ "COULDN'T FIND PATH TO:" @ TakeUpPosition
                  @ "From " @ Pawn.Anchor );
            curBehaviour = "NoPathToTakeUp";
            curStageOrder = SO_None;
            //NOTEmyAIRole.TakePositionFailed();
            Perform_Error_Stop();
        }
    }
    else
    {
        curStageOrder = SO_None;
        //Pawn.Anchor = TakeUpPosition;
        if ( currentStage != None ) {
            ClaimPosition(TakeUpPosition);
            currentStage.Report_InPosition(self, TakeUpPosition);
        }
        myAIRole.TakePositionSuceeded();
    }
}

/**
 *  Stay put.  Fire at will.
 **/
function FollowOrder_HoldPosition()
{
    //TODO should make use of take-cover behaviours in hold position impl.
    myAIRole.SelectAction();
}

/**
 */
function FollowOrder_TakeCover() {
    Perform_Engaged_TakeCover();
}

/**
 * Call the appropriate order function
 **/
function FollowOrder()
{
   switch (curStageOrder)
   {
   case SO_None:
       FollowOrder_None();
       break;
   case SO_TakeUpPosition:
       FollowOrder_TakePosition();
       break;
   case SO_HoldPosition:
       FollowOrder_HoldPosition();
       break;
   case SO_TakeCover:
       FollowOrder_TakeCover();
       break;
   default:
       FollowOrder_None();
       break;
   }
}

/**
 * called during SelectCombatAction to see if we ought to pick a new position
 **/
function bool NoLongerOnGoodPosition()
{
    if ( claimedPosition == None ) return true;
    if ( !currentStage.PositionHasLOFToEnemy(claimedPosition, Enemy) ) return true;
    if ( currentStage != None ) {
        if ( currentStage.calculateStagePosnBlocksLOS(self, claimedPosition) > 0) {
            return true;
        }
        if ( currentStage.calculateStagePosnLOSIsBlocked(self, claimedPosition) > 0 ) {
            return true;
        }
    }
    if ( !VerifyShootingPosition(claimedPosition)) return true;

    if ( VSize(Enemy.Location - Pawn.Location) > GetMaxFiringRange() ) {
           return true;
        }

    //NOTEfixme:  Add time check for ability to orient towards LOF etc.

    return false;
}

/**
 * Override for non-standard weapon range checking.
 */
function float GetMaxFiringRange()
{
   return 10000;

   //NOTEWarfare Codebase
   //return Pawn.Weapon.MaxRange;
}

/**
 */
function MultiTimer( int timerID ) {
    switch ( timerID ) {
    case SIGHT_CHECK_TIMER:
        if ( enemy != None
             && VSize( enemy.location - pawn.location ) > pawn.sightRadius ) {
            // make sure that we lose track of enemies that have moved
            // beyond our sight radius.
            EnemyNotVisible();
            Enemy = None;
        }
        break;

    case FOCUS_TIMER:
        Focus = PendingFocus;
        PendingFocus = None;
        break;

    case LOST_SIGHT_TIMER:
        Enable( 'EnemyNotVisible' );
        break;


    //TODO should probably migrate the loathsome firing control timer
    //     into here some day...

    default:
        super.MultiTimer( timerID );
    }
}

//==============
//  Firing Control (how I hate you)
// In general, the timer is always on so that we are constantly checking if we have a shot.
//==============
function Timer()
{
    DebugLog( "Timer!", DEBUG_FIRING );
    if ( !bRangedAttackCapable ) return;
    TimedFireWeaponAtEnemy();
}

/**
 * Combat timer is slow, so that the calls/recalls to FireWeaponAt appear
 * to have reflexes built in.
 **/
function SetCombatTimer()
{
    if ( !bRangedAttackCapable ) return;
    //SetTimer(1.2 - 0.1 * FMin(10,Skill), True);
    SetTimer( RandRange(MinShotPeriod,MaxShotPeriod), true);
}

/**
 * If we don't have an enemy yet, or are currently shooting at one
 * set the timer to something that looks like reflexes.
 * The "reflex" delay will be upon first seeing an enemy I presume?
 **/
function TimedFireWeaponAtEnemy()
{
    DebugLog( "TimedFireWeaponAtEnemy() at" @ Level.TimeSeconds @ "s",
              DEBUG_FIRING  );
    if ( Pawn.Weapon == None ) return;

    if ( (EnemyInSightTime == -1)
            || ( !TimeElapsed(EnemyInSightTime, ReflexTime) ) )
    {
        SetTimer(0.1, True); //often enough...
        return;
    }


    if ( Pawn.Weapon.IsFiring() || (Enemy == None) || FireWeaponAt(Enemy) )
    {
        SetCombatTimer();   //Timer between bursts of fire
    }
    else
    {
        SetTimer(0.1, True); //often enough...
    }
}

function Tick(float dT)
{
    Super.Tick(dT);
    if(bStopFireAnimation)
    {
        bStopFireAnimation = false;
        StopFiring();
    }

    if(bDebugLogging)
        debugTick(dT);
}

// code-base specific
function WeaponStopFire( Weapon w );
//NOTE Pawn.Weapon.ServerStopFire(Pawn.Weapon.BotMode);

function StopFiring()
{
    if ( (Pawn != None) && (Pawn.Weapon != None) /*&& Pawn.Weapon.IsFiring()*/ )
    {
           WeaponStopFire( Pawn.Weapon );
//      bStoppedFiring = true;
    }
//  bCanFire = false;
    bFire = 0;
    bAltFire = 0;
}

/**
 * Find a spot on a side of the enemy so we'll miss
 **/
function CalculateMissVectorScale()
{
    if(Frand() < 0.5)
        MissVectorScale = 1.0;
    else
        MissVectorScale = -1.0;
}

/**
 * Check ammo, and current focus, then attempt to fire weapon.
 **/
function bool FireWeaponAt(Actor A)
{
    //DebugLog( "Trying to fire at" @ A );
    if ( A == None ) A = Enemy;
    if ( (A == None) || (Focus != A) ) {
        DebugLog( "Can't fire at" @ A @ "with focus" @ Focus, DEBUG_FIRING );
        /*
        if ( currentStage != None ) {
            //NOTE
            currentStage.Report_EnemyLost( self, Level.timeSeconds );
        }
        */
        return false;
    }

    Target = A;
    if ( (Pawn.Weapon != None) && Pawn.Weapon.HasAmmo()
             && !Pawn.Weapon.IsFiring() ) {
        NumShotsToGo = iRandRange(MinNumShots,MaxNumShots);
        CalculateMissVectorScale();
        return WeaponFireAgain(Pawn.Weapon.RefireRate(),false);
    }
    else {
        DebugLog( "Unable to fire weapon:" @ Pawn.weapon, DEBUG_FIRING );
        return false;
    }
}

/**
 */
function bool CanAttack(Actor Other)
{
    local bool result;
    // return true if in range of current weapon
    result = Pawn.Weapon.CanAttack(Other);
    DebugLog( "Weapon.CanAttack() returned" @ result, DEBUG_FIRING );
    return result;
}

function bool NeedToTurn(vector targ)
{
    local vector LookDir,AimDir;
    LookDir = Vector(Pawn.Rotation);
    LookDir.Z = 0;
    LookDir = Normal(LookDir);
    AimDir = targ - Pawn.Location;
    AimDir.Z = 0;
    AimDir = Normal(AimDir);

    return ((LookDir Dot AimDir) < 0.93);
}

/**
 * returns a number [0,1] to indicate odds of "shooting to hit"
 **/
function float ChanceToHit()
{
    local float skillOdds, range, relVelocity, losTime, result;

    if ( Pawn == None || Enemy == None ) return 0;

    //skill (0-7)
    skillOdds = FMax(MaxSkillOdds, Skill/7);

    //target distance
    range =  VSize(Pawn.Location - Enemy.Location);
    range = FClamp( 1.0 - (range/MaxAimRange), 0.0, 1.0);
    if(range == 0.0) return 0;

    //relative Velocity
    relVelocity = Normal(Enemy.Location - Pawn.Location)
        dot Normal( (Enemy.Location + 2.0*Enemy.Velocity)
                       - (Pawn.Location + Pawn.Velocity) );
    relVelocity = FClamp(relVelocity, 0.0, 1.0);
    if(relVelocity == 0.0) return 0;

    //how long visible
    if(EnemyIsVisible())
    {
        losTime = Level.TimeSeconds - EnemyInSightTime;
        losTime = FMin(losTime / MaxSecondsOfLOS, 1.0);
    }

    result = 1.0 * skillOdds * range * relVelocity*losTime;
    DebugLog( "ChanceToHit:" @ result @ "skill:" @ skillOdds
              @ "range:" @ range @ "relative velocity" @ relVelocity
              @ "los time" @ losTime, DEBUG_FIRING );
    return result;
}

function bool WillFriendlyFire(vector start, vector end, out Pawn HitFriend, out vector outHitLocation)
{
    local vector HitLocation, HitNormal, extent;
    local actor HitActor;

    extent = vect(20, 20, 20);

    //HitActor = Trace(HitLocation, HitNormal, end, start, true, extent);
    HitActor = Trace(HitLocation, HitNormal, end, start, true);

    if(HitActor != None && Pawn(HitActor) != None && Pawn(HitActor).Controller != None && SameTeamAs(Pawn(HitActor).Controller))
    {
        HitFriend = Pawn(HitActor);
        outHitLocation = HitLocation;
        return true;
    }

    return false;
}

/**
 */
function Rotator AimToMiss( Ammunition FiredAmmunition, vector projStart,
                            int aimerror )
{
    local vector FireSpot, MissVector;
    local rotator MissDir, result;
    local float targetDistance, projSpeed;

    local vector outHitLocation;
    local Pawn HitFriend;

    if ( target == None ) {
        DebugLog( "AimToMiss on invalid target", DEBUG_FIRING );
        return rotator( lastSeenPos - projStart );
    }
    MissVector = vect(0,0,1) cross (Target.Location - Pawn.Location);
    MissVector.Z = 0;
    if( !EnemyIsVisible() )
    {
        result = rotator(LastSeenPos - projStart);
        DebugLog( "AimToMiss on enemy that isn't visible:" @ result,
                  DEBUG_FIRING );
        return result;
    }

    //clamp miss cone to <= 7deg
    if( (Target.CollisionRadius*2.0) / VSize(Target.Location - Pawn.Location)
            > 0.123 ) // missCone > tan(7deg)
    {
        MissVector = MissVectorScale * Normal(MissVector)
            * VSize(Target.Location - Pawn.Location) * 0.123;
    }
    else
    {
        MissVector = MissVectorScale * Normal(MissVector)
            * Target.CollisionRadius*2.0;
    }
    MissVector.Z = RandRange( Target.CollisionHeight/4,
                              Target.CollisionHeight );
    FireSpot = Target.Location;
    if(FiredAmmunition.bLeadTarget)
    {
        targetDistance = VSize(Target.Location - projStart);
        projSpeed = FiredAmmunition.ProjectileClass.default.speed;
        FireSpot += Target.Velocity * targetDistance / projSpeed;
    }
    MissDir = rotator( (FireSpot + MissVector) - projStart );

    //NOTE Q: friendly fire, what to do?
    //    A: Rather have a really good shot than a really stupid one
    if( WillFriendlyFire( projStart, FireSpot+MissVector, HitFriend,
                          outHitLocation ) )
    {
        MissDir = rotator( outHitLocation + vect(0,0,1.0)
                           * HitFriend.CollisionHeight - projStart);
    }

    DebugLog( "AimToMiss on visible enemy:" @ MissDir, DEBUG_FIRING );
    return MissDir;
}

/**
 * Subclasses may override if you don't like the conservative
 * shoot-for-the-middle approach.
 */
function vector GetTweakedFireSpot( Actor target ) {
    return target.Location;
}

/**
 */
function Rotator AimToHit( Ammunition FiredAmmunition, vector projStart,
                           int aimerror )
{
    local Vector FireSpot;
    local float targetDistance, projSpeed;
    local rotator result;
    local vector outHitLocation;
    local Pawn HitFriend;

    if ( target == None ) {
        DebugLog( "AimToHit on invalid target", DEBUG_FIRING );
        return rotator( lastSeenPos - projStart );
    }
    FireSpot = GetTweakedFireSpot( Target );
    if(FiredAmmunition.bLeadTarget)
    {
        targetDistance = VSize(Target.Location - projStart);
        projSpeed = FiredAmmunition.ProjectileClass.default.speed;
        FireSpot += Target.Velocity * targetDistance / projSpeed;
        if( WillFriendlyFire(projStart, FireSpot, HitFriend, outHitLocation) )
        {
            FireSpot = Target.Location;
            //log("FRIENDLY HITLEAD"@HitFriend);
        }
    }
    if( WillFriendlyFire( projStart, FireSpot, HitFriend, outHitLocation ) )
    {
        //log("FRIENDLY HIT"@HitFriend);
    }

    result = Rotator(FireSpot - projStart);
    DebugLog( "AimToHit enemy:" @ result, DEBUG_FIRING );
    return result;
}

/**
 * AdjustAim()
 * Returns a rotation which is the direction the bot should aim -
 * after introducing the appropriate aiming error
 **/
function rotator AdjustAim( Ammunition FiredAmmunition, vector projStart,
                            int aimerror )
{
    FiredAmmunition.WarnTarget(Target,Pawn,vect(1,0,0));
    if( FRand() <= ChanceToHit() || aimError <= 0 ) {
        return AimToHit(FiredAmmunition, projStart, aimerror);
    }
    else {
        return AimToMiss(FiredAmmunition, projStart, aimerror);
    }
}


/**
 * This is a callback from the weapon when it has finished firing.
 * bFinishedFire==true indicates a callback from the weapon, and is
 * passed into BotFire to indicate that we want to keep shooting
 * (otherwise, the gun would return false since the RefireTime on the
 * weapon hadn't been reached yet)
 *
 * In essence, when this is called, you call BotFire again
 * to keep the trigger pulled.
 *
 * the RefireRate is set on the weapon, and gives you a chance to
 * shoot in "bursts" it should really be called RefireOdds, since it's
 * really the chance that you'll stop the burst.
 **/
function bool WeaponFireAgain(float RefireRate, bool bFinishedFire)
{
    local bool bFireSuccess;

    //LastFireAttempt = Level.TimeSeconds;
    if ( Target == None ) Target = Enemy;

    if ( Target == None ) {
        DebugLog( "No target to fire at", DEBUG_FIRING );
        bStopFireAnimation = true;
        StopFiring();
        return false;
    }

    // first shot...
    if ( !Pawn.Weapon.IsFiring() )
    {
        DebugLog( "Starting burst", DEBUG_FIRING );
        if ( Pawn.Weapon.bMeleeWeapon
               || (!NeedToTurn(Target.Location) && CanAttack(Target)) )
        {
            DebugLog( "Firing weapon at" @ target, DEBUG_FIRING );
            exclaimMgr.Exclaim(EET_Attacking, 0, 0.5);
            NumShotsToGo--;
            UpdateFocus( Target, true );
            //bCanFire = true;
            //bStoppedFiring = false;
            bFireSuccess = Pawn.Weapon.BotFire(bFinishedFire);
            //DebugLog("@1@"@bFinishedFire@bFireSuccess);
            return bFireSuccess;
        }
        else if( bFireAtLastLocation && !EnemyIsVisible()
                    && !NeedToTurn(LastSeenPos) ) //supression fire
        {
            debugLog("Supress A");
            bFireSuccess = Pawn.Weapon.BotFire(bFinishedFire);
            //DebugLog("@3@"@bFinishedFire@bFireSuccess);
            return bFireSuccess;
        }
        else
        {
            DebugLog( "Cannot fire.", DEBUG_FIRING );
            //bCanFire = false;
        }
    }
    // rest of a burst...
    else if ( NumShotsToGo-- > 0 )
    {
        if ( Focus == Target && CanAttack(Target) )
        {
            //bStoppedFiring = false;
            DebugLog( "(re)firing weapon at" @ target, DEBUG_FIRING );
            bFireSuccess = Pawn.Weapon.BotFire(bFinishedFire);
            //DebugLog("@3@"@bFinishedFire@bFireSuccess);
            return bFireSuccess;
        }
        else if( bFireAtLastLocation && !EnemyIsVisible()
                     && !NeedToTurn(LastSeenPos) ) //supression fire
        {
            debugLog("Supress B");
            bFireSuccess = Pawn.Weapon.BotFire(bFinishedFire);
            //DebugLog("@3@"@bFinishedFire@bFireSuccess);
            return bFireSuccess;
        }
        else
        {
            DebugLog("CAN'T ATTACK", DEBUG_FIRING );
        }
    }

    bStopFireAnimation = true;
    //DebugLog("@4@"@bFinishedFire@bFireSuccess);

    StopFiring();
    return false;
}

//===============
// Helper functions
//===============

function UnClaimPosition()
{
    if(claimedPosition != None)
    {
        claimedPosition.bIsClaimed = false;
        claimedPosition = None;
    }
}

function ClaimPosition( StagePosition position )
{
    if(position == None)
        return;

    claimedPosition = position;
    claimedPosition.bIsClaimed = true;
}

/**
 * Sets a random direction to look at.
 **/
function SetRandomFocalPointLocation(float viewDist)
{
    local Rotator LookDir;

    if( !TimeElapsed(LastFocusChangeTime, RandFocusChangeDuration ) )
        return;
    LastFocusChangeTime = Level.TimeSeconds;
    RandFocusChangeDuration = RandRange(1.0, 2.0);

        UpdateFocus( None, true );
    LookDir = Rotation;
    LookDir.Yaw = LookDir.Yaw + iRandRange(-32768, 32768);

    FocalPoint = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1) + vector(LookDir)*viewDist;
}

function SetFocalPointNearLocation(vector oldPoint)
{
    local vector oldDirVector;
    local rotator LookDir;

    if( !TimeElapsed(LastFocusChangeTime, RandFocusChangeDuration)
            || Pawn == None ) {
        return;
    }
    LastFocusChangeTime = Level.TimeSeconds;
    RandFocusChangeDuration = RandRange(1.0, 2.0);
    UpdateFocus( None, true );

    oldDirVector = oldPoint - (Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1) );
    LookDir = rotator(oldDirVector);
    LookDir.Yaw = LookDir.Yaw + iRandRange(-8192, 8192); //45deg

    FocalPoint = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1) + vector(LookDir)*VSize(oldDirVector);
}

/**
 * NearWall()
 * returns true if there is a nearby barrier at eyeheight, and
 * changes FocalPoint to a suggested place to look
 **/
function bool NearWall(float wallDist)
{
    local actor HitActor;
    local vector HitLocation, HitNormal, ViewSpot, ViewDist, LookDir;

    LookDir = vector(Rotation);
    ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
    ViewDist = LookDir * wallDist;
    HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
    if ( HitActor == None )
        return false;

    ViewDist = Normal(HitNormal Cross vect(0,0,1)) * walldist;
    if (FRand() < 0.5)
        ViewDist *= -1;

        UpdateFocus( None, true );
    if ( FastTrace(ViewSpot + ViewDist, ViewSpot) )
    {
        FocalPoint = Pawn.Location + ViewDist;
        return true;
    }

    if ( FastTrace(ViewSpot - ViewDist, ViewSpot) )
    {
        FocalPoint = Pawn.Location - ViewDist;
        return true;
    }

    FocalPoint = Pawn.Location - LookDir * 300;
    return true;
}

/**
 * It tries to set MoveTarget to the location of the best waypoint,
 * and returns true if successful
 */
function bool FindBestPathToward( Actor A, bool bCheckedReach,
                                  bool bAllowDetour ) {
    local Actor oldMoveTarget;
    oldMoveTarget = moveTarget;

    // find the next waypoint along the path...
    if ( !bCheckedReach && ActorReachable(A) ) {
        MoveTarget = A;
    }
    else {
        MoveTarget
            = FindPathToward(A, (bAllowDetour && (NavigationPoint(A)!=None)));
    }

    // keep tabs on whether we might be stuck.
    //NOTE perhaps this should be based on time elapsed...
    if ( moveTarget == oldMoveTarget ) {
        numMoveAttempts++;
        DebugLog( "attempting to path find to" @ a @ "attempt #"
                  @ numMoveAttempts @ "to dest" @ moveTarget );
    }
    else numMoveAttempts = 1;

    if ( numMoveAttempts > 5 ) {
        DebugLog( "Giving up on path through" @ moveTarget @ "to" @ a );
        return false;
    }
    else if ( MoveTarget != None ) {
        return true;
    }
    else if ( bSoaking && (Physics != PHYS_Falling) ) {
        SoakStop("COULDN'T FIND BEST PATH TO "$A);
    }
    else {
        DebugLog("No Path to "@A);
    }

    return false;
}


//=====================
// Decision heuristics
//=====================
//NOTE we should collect all of our shouldX()-style methods here...

/**
 * A heuristic for whether running or walking is appropriate in the
 * current situation.
 */
function bool shouldWalk() {
    return Enemy == None;
}

/**
 */
function bool ShouldStrafe() {
    return true;
}


//===========================================================================
// BEHAVIOURS
//
// Behaviours are the major features of this class.  They combine low
// level unreal tech into chunks of functionality that make building
// high-level AI behaviour easier (in the AIRole).
//
// Behaviours are generally implemented like this:
//
// function Perform_X - the external interface to the behaviour,
//    called by the role (usually).
//
// function Continue_X - function that evaluates iterative behaviours
//    to see if they are complete.
//
// state X - state code that actually does the work.
//
// Some things to watch out for:
//
//   - make sure that all code paths result in a succeeded() or
//     failed() call to the role, so that it doesn't get stuck waiting
//     for a notify().
//   - don't do the completion call back in Perform_X, because the
//     caller won't have had a chance to call WaitForNotification()
//     yet.
//
// Some ideas for the future:
//
//   - behaviours seem like SSeq actions, maybe they could be unified?
//
//===========================================================================


//==============
// NotEngaged_AtRest
//
// Just idling, waiting for something to happen.
//==============
function Perform_NotEngaged_AtRest()
{
    curBehaviour = "Rest";
    GotoState('NotEngaged_AtRest');
}

state NotEngaged_AtRest
{

    function BeginState()
    {
        Pawn.Acceleration = vect(0,0,0);
        Pawn.Velocity = vect(0,0,0);
    }

    // Don't Shoot
    function Timer() {}

    event SeePlayer( Pawn Seen )    {
            Global.SeePlayer(Seen);
            UpdateFocus( None );
    }
BEGIN:
    WaitForLanding();
    if(TakeUpPosition != None)
        SetFocalPointNearLocation( Vector(TakeUpPosition.Rotation)*2000 + Pawn.Location );
    else if( bEnemyInfoValid )
        SetFocalPointNearLocation( LastSeenPos );
    else
        SetRandomFocalPointLocation(2000);
    NearWall(1000);
    FinishRotation();
    Sleep( RandRange(2.0, 3.0) );
        myAIRole.NotEngagedAtRestSucceeded();
}


/**
 * BEHAVIOUR: Wander
 *
 * Pick a quasi-random location and move to it.  Performs one
 * "wander-move".
 */
function Perform_NotEngaged_Wander()
{
    local int numAvail, i;
    local StagePosition position;
    //    local NavigationPoint currentNode;
    local NavigationPoint anchor;

    curBehaviour = "Wander";
    wanderDestination = None;
    if ( currentStage != None ) {
        for(i=0; i< currentStage.StagePositions.Length; i++) {
            if( !currentStage.StagePositions[i].bIsClaimed ) {
                numAvail++;
                //  odds are  1/1, 1/2, 1/3, 1/4 ...
                if( FRand() < 1.0f/float(numAvail) ) {
                    position = currentStage.StagePositions[i];
                }
            }
        }
        UnClaimPosition();
        ClaimPosition(position);
        wanderDestination = position;
    }
    else {
        // no stage, find a nearby pathnode instead
        anchor = pawn.anchor;
        if ( anchor == None || anchor.pathList.length < 1 ) {
            debugLog( "can't wander from here" );
        }
        else {
            wanderDestination
                = anchor.pathList[rand(anchor.pathList.length)].end;
            UnClaimPosition();
        }
    }
    DebugLog( "wandering to" @ wanderDestination );
    ContinueWander();
}

/**
 * Called after each step of a "wander-move".
 */
function ContinueWander()
{
    // check if this wander is already done...
    if ( Pawn.ReachedDestination(wanderDestination) ) {
        myAIRole.NotEngagedWanderSucceeded();
        LastWanderTime = Level.TimeSeconds;
        return;
    }
    // stop wandering, there's an enemy!
    else if ( Enemy != None ) {
        UnClaimPosition();
        curBehaviour = "NoWander-Enemy";
        myAIRole.NotEngagedWanderFailed();
        return;
    }
    // try to move towards the destination...
    else if ( FindBestPathToward(wanderDestination, false, true) ) {
        if ( IsInState('NotEngaged_Wander') ) {
            GotoState('NotEngaged_Wander', 'MOVE');
        }
        else {
            GotoState('NotEngaged_Wander');
        }
    }
    // ERROR
    else {
        UnClaimPosition();
        curBehaviour = "NoWanderPath";
        myAIRole.NotEngagedWanderFailed();
        Perform_Error_Stop();
    }
}

/**
 * State code for wandering...
 */
state NotEngaged_Wander
{
    // Don't Shoot
    function Timer() {}

BEGIN:
    UpdateFocus( MoveTarget, true );
    FinishRotation();
    sleep(RandRange(0.1, 0.5));
MOVE:
    UpdateFocus( MoveTarget, true );
    FinishRotation();
    MoveToward( MoveTarget,,, ShouldStrafe(), ShouldWalk() );
    ContinueWander();
}


//==============
// NotEngaged_MoveTowardPosition
//
// MoveToward an actor, not currently paying attention to an enemy
//==============
function Perform_MoveTowardPosition()
{
    curBehaviour = "Moving";
    GotoState('MoveToPosition');
}

/**
 */
function Actor ActorToFace()
{
    if ( Enemy == None
            || isBehindMe(MoveTarget) || Pawn.bWantsToCrouch ) {
        UpdateFocus( MoveTarget );
        return MoveTarget;
    }
    else {
        UpdateFocus( Enemy );
        return Enemy;
    }
}

state MoveToPosition
{
    //ignores EnemyNotVisible;

BEGIN:

   if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
       UpdateFocus( MoveTarget );
       FinishRotation();
       MoveToward(MoveTarget,,, ShouldStrafe(), ShouldWalk() );
   }
   else {
       UpdateFocus( Enemy );
       MoveToward(MoveTarget, Enemy,, ShouldStrafe(), ShouldWalk() );
   }
   //NOTE maybe too soon to say success/fail?
   myAIRole.MoveToPositionSucceeded();
}


/**
 * BEHAVIOUR - MoveToLocation
 *
 * Move to the specified location.  The is the most general
 * move-behaviour.
 */
function Perform_MoveToLocation( vector location, optional float slop ) {
    moveDestination = location;
    moveSlop = slop;
    GotoState( 'MoveToLocation' );
}

function Continue_MoveToLocation() {
    if ( VSize(pawn.location - moveDestination)
             < pawn.CollisionRadius + 8 + moveSlop ) {
        // reached destination...
        GotoState( 'MoveToLocation', 'DONE' );
        myAIRole.MoveToLocationSucceeded();
        return;
    }
    else {
        //TODO: perhaps check if we're stuck?
        GotoState( 'MoveToLocation', 'MOVE' );
    }
}

state MoveToLocation {

BEGIN:
    curBehaviour = "MoveToLocation";
MOVE:
    FinishRotation();
    if ( pointReachable(moveDestination) ) {
        debugLog( "moving directly to" @ moveDestination );
        FocalPoint = moveDestination;
        moveTo( moveDestination,, ShouldWalk() );
    }
    else {
        moveTarget = FindPathTo( moveDestination );
        if ( moveTarget == none ) {
            debugLog( "can't find path to" @ moveDestination );
            if ( RouteGoal != none
                 && VSize(pawn.location - moveDestination)
                      > VSize(pawn.location - routeGoal.location) ) {
                debugLog( "falling back to" @ RouteGoal );
                //TODO: maybe insert a melee attack here?
                Sleep( RandRange(0.07, 0.15) );
                moveTarget = FindPathToward( routeGoal );
            }
            else {
                Sleep( 0.3 );
                if (myAIRole != none){
                  myAIRole.MoveToLocationFailed();
                }
                Goto( 'DONE' );
            }
        }
        if (MoveTarget !=None){
         // if we didn't hit the Goto, moveTarget should be okay now...
         debugLog( "moving to" @ moveTarget );
         FocalPoint = moveTarget.location;
         moveToward( moveTarget,,,ShouldStrafe(), ShouldWalk() );
        }
    }
    Sleep( RandRange(0.1, 0.3) );
    Continue_MoveToLocation();

DONE:
    curBehaviour      = "DoneMovingToLocation";
    Pawn.Acceleration = vect(0,0,0);
    Pawn.Velocity     = vect(0,0,0);

}

/**
 * Attempt a melee attack on the current enemy
 */
function Perform_MeleeAttack() {
    //TODO: this has to be implemented on a per-game basis.
}

//==============
// Engaged_StandGround
//
// We are engaged with an enemy, and are standing our ground (human turret)
//==============
function Perform_Engaged_StandGround()
{
    curBehaviour = "StandGround";
    if(Focus != Enemy) //not visible
    {
        SetFocalPointNearLocation(LastSeenPos);
    }
    else {
            UpdateFocus( Enemy );
        }
    //Pawn.Velocity = vect(0,0,0);
    GotoState('Engaged_StandGround');
}

/**
 */
state Engaged_StandGround
{

    function BeginState()
    {
        //Pawn.Acceleration = vect(0,0,0);
        //Pawn.Velocity = vect(0,0,0);
        bFireAtLastLocation = true;
    }

    function EndState()
    {
        MonitoredPawn = None;
        bFireAtLastLocation = false;
    }

    event SeePlayer( Pawn Seen )
    {
        Global.SeePlayer( Seen );
        if(Enemy == Seen)
        {
            UpdateFocus( Enemy );
        }
    }

BEGIN:
    if( Pawn.Acceleration != vect(0,0,0) ) {
        MoveTo(Pawn.Location,, ShouldWalk());
    }
    FinishRotation();
    Sleep( 0.1 );
    myAIRole.StandGroundSucceeded();
}


//==============
// FireAtTarget
//
// Firing on the ShootActor, and ignoring the enemy.
//==============
function Perform_NotEngaged_FireAtTarget()
{
   DebugLog( "Perform_NotEngaged_FireAtTarget" );
   curBehaviour = "FireAtTarget";
   UpdateFocus( ShootTarget );
   GotoState( 'NotEngaged_FireAtTarget' );
}

/**
 * May need to be overridden for particular games...
 */
function bool isTargetDestroyed();
/*
{
   local Pawn p;
   // consider invalid targets destroyed
   if ( ShootTarget == None ) return true;
   // check for pawn-health
   p =  Pawn( ShootTarget );
   if ( p != None ) return p.Health <= 0;
   // for all other actors, it's only considered destroyed if it's
   // being deleted...
   return !ShootTarget.bDeleteMe;
}
*/

state NotEngaged_FireAtTarget
{
   function Timer() {
      DebugLog( "FireAtTarget timer" );
      TimedFireWeaponAtEnemy();
   }
   /**
    * Fire at the target, not the enemy.
    */
   function TimedFireWeaponAtEnemy() {
      if ( Pawn.Weapon == None ) return;
      if ( Pawn.Weapon.IsFiring() || (ShootTarget == None)
           || FireWeaponAt(ShootTarget) ) {
         DebugLog( self @ "fired at" @ ShootTarget );
         SetCombatTimer(); //Timer between bursts of fire
      }
      else {
         SetTimer(0.1, True); //often enough...
      }
   }

   /**
    */
   event SeePlayer( Pawn Seen ) {
      Global.SeePlayer(Seen);
      UpdateFocus( ShootTarget );
   }

BEGIN:
   DebugLog( "NotEngaged_FireAtTarget" );
   FinishRotation();
   SetTimer( 1, true );
   Sleep( RandRange(0.5,2.0) );
   if ( isTargetDestroyed() ) {
      tmpTarget = ShootTarget;
      if ( currentStage != None ) {
         currentStage.Report_TargetDestroyed( self, ShootTarget );
      }
      if ( tmpTarget == ShootTarget ) ShootTarget = None;
   }
   myAIRole.FireAtTargetSucceeded();
}


//==============
// Engaged_RecoverEnemy
//
// Enemy was recently seen, and went out of sight,
// try to find him by going to the last position we saw him
// under the assumption that he's probably near by.
//==============

function Perform_Engaged_RecoverEnemy()
{
    curBehaviour = "RecoverEnemy";

    if( VSize(Pawn.Location - LastSeenPos) < 16)
    {
        Perform_Engaged_StandGround();
        return;
    }
    else if ( PointReachable(LastSeenPos) )
    {
        GotoState('Engaged_RecoverEnemy', 'PURSUE');
        return;
    }
    else
    {
        MoveTarget = FindPathTo(LastSeenPos);
        if( MoveTarget != None )
        {
            GotoState('Engaged_RecoverEnemy', 'PATH');
            return;
        }
        else
        {
            Perform_Engaged_StandGround();
            return;
        }
    }

}

state Engaged_RecoverEnemy
{
//ignores EnemyNotVisible;
    function bool KeepGoing()
    {
        //log("Reached"@claimedPosition@Pawn.ReachedDestination(claimedPosition) );
        return (Enemy!=None) && !EnemyIsVisible() && (VSize(Pawn.Location - LastSeenPos) > 16);
    }

    event SeePlayer( Pawn Seen )
    {
        Global.SeePlayer(Seen);
        if(Enemy == Seen ) UpdateFocus( Enemy );
    }

BEGIN:
    FinishRotation();
PURSUE:
    MoveTo(LastSeenPos,, ShouldWalk() );
    Goto('NEXT');
PATH:
    MoveToward(MoveTarget,,, ShouldStrafe(), ShouldWalk() );
NEXT:
    if( KeepGoing() )
        Perform_Engaged_RecoverEnemy();

        myAIRole.RecoverEnemySucceeded();
}


//==============
// Engaged_GetLOS
//
// Cheat and get LOS to Enemy
//==============

/**
 */
function Perform_Engaged_GetLOS()
{
    local StagePosition oldPos;

    curBehaviour = "GetLOS";
    oldPos    = claimedPosition;
    UnClaimPosition();
    if ( currentStage != None ) {
        ClaimPosition( currentStage.Request_ShootingPosition(self) );
    }

    if(claimedPosition == None)
    {
        ClaimPosition( oldPos );
        if( EnemyIsVisible() )
        {
            curBehaviour = "NoLOSSpotA";
            Perform_Error_Stop();
        }
        else
        {
            curBehaviour = "NoLOSSpotB";
            Perform_Error_Stop();
        }
        //NOTEGotoState( 'GetLOSFailed' );
        return;
    }

    Continue_Engaged_GetLOS();
}

/**
 */
function Continue_Engaged_GetLOS()
{
    if( FindBestPathToward(claimedPosition, false, true) )
    {
        if( IsInState('Engaged_GetLOS') ) {
            GotoState('Engaged_GetLOS', 'GETLOS');
        }
        else {
            GotoState('Engaged_GetLOS');
        }
    }
    else
    {
        UnClaimPosition();
        curBehaviour = "NoGetLOSPath";
        Perform_Error_Stop();
    }
}

state GetLOSFailed {
BEGIN:
    Sleep(0.1);
    myAIRole.GetLOSFailed();
}

state Engaged_GetLOS
{
    //ignores EnemyNotVisible;

    function bool KeepGoing()
    {
        //log("Reached"@claimedPosition@Pawn.ReachedDestination(claimedPosition) );
        return (Enemy!=None) && !Pawn.ReachedDestination(claimedPosition);
    }

BEGIN:
    FinishRotation();
GETLOS:
    //if(EnemyIsVisible())
    if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
        UpdateFocus( MoveTarget );
        FinishRotation();
        MoveToward(MoveTarget,,, ShouldStrafe(), ShouldWalk() );
    }
    else {
        UpdateFocus( Enemy );
        MoveToward(MoveTarget, Enemy,, ShouldStrafe(), ShouldWalk() );
    }

    if( KeepGoing() ) {
        Continue_Engaged_GetLOS();
    }
    myAIRole.GetLOSSucceeded();
}


//==============
// Engaged_HideFromEnemy
//
// try to get to a spot where the enemy can't shoot us
//==============

function Perform_Engaged_HideFromEnemy()
{
    curBehaviour = "Hide";

    UnClaimPosition();
        if ( currentStage != None ) {
           ClaimPosition( currentStage.Request_HidingPosition(self) );
        }
    if(claimedPosition == None)
    {
        curBehaviour = "NoHideSpot";
        Perform_Error_Stop();
        return;
    }

    if( FindBestPathToward(claimedPosition, false, true) )
    {
        if(IsInState('Engaged_HideFromEnemy') )
            GotoState('Engaged_HideFromEnemy', 'HIDE');
        else
        {
            exclaimMgr.Exclaim(EET_Fear, 0);
            GotoState('Engaged_HideFromEnemy');
        }
    }
    else
    {
        UnClaimPosition();
        curBehaviour = "NoHidePath";
        Perform_Error_Stop();
    }
}



state Engaged_HideFromEnemy
{
//ignores EnemyNotVisible;

    function bool KeepGoing()
    {
        return  (Enemy!=None) && !Pawn.ReachedDestination(claimedPosition);
    }

    function BeginState()
    {
        if(currentStage != None)
            currentStage.Report_Unsighted(self, Enemy);

    }
    function EndState()
    {
        if(currentStage != None && EnemyIsVisible() )
        {
            currentStage.Report_Eyesighted(self, Enemy);
        }
        Pawn.bWantsToCrouch = false;
    }

BEGIN:
//  FinishRotation();
    Pawn.bWantsToCrouch = true;
HIDE:
    MoveToward(MoveTarget,,,ShouldStrafe(), false);
    if( KeepGoing() )
        Perform_Engaged_HideFromEnemy();

    LastHideTime = Level.TimeSeconds;
        myAIRole.HideFromEnemySucceeded();
}

//=================
// Engage_TakeCover
// hide as best as possible...
//=================

/**
 * Crouch, or move to somewhere nearby for cover.
 */
function Perform_Engaged_TakeCover()
{
    curBehaviour = "TakeCover";
    UpdateFocus( Enemy );

    if(currentStage.PositionProvidesCoverFromEnemy(claimedPosition, Enemy) > 0)
    {
        Pawn.bWantsToCrouch = true;
        GotoState('Engaged_TakeCover', 'CROUCH');
        return;
    }

    //need a new spot
    Pawn.bWantsToCrouch = false;
    UnClaimPosition();
    if ( currentStage != None ) {
        ClaimPosition( currentStage.Request_HidingPosition(self) );
    }
    if ( claimedPosition == None )
    {
        curBehaviour = "NoCoverSpot";
        Pawn.bWantsToCrouch = true;
        Perform_Error_Stop();
        //NOTEGotoState( 'TakeCoverFailed' );
        return;
    }
    Continue_Engaged_TakeCover();

}

/**
 * Move towards cover...
 */
function Continue_Engaged_TakeCover()
{
    if( FindBestPathToward(claimedPosition, false, true) )
    {
        // run crouched to nearby cover...
        if(MoveTarget == claimedPosition) {
            RouteDist = VSize(Pawn.Location - MoveTarget.Location);
        }
        if(RouteDist < maxDistToCrouchForCover) {
            Pawn.bWantsToCrouch = true;
        }
        GotoState('Engaged_TakeCover', 'RUN');
    }
    else
    {
        UnClaimPosition();
        //NOTE crashes :-(        myAIRole.TakeCoverFailed();
        curBehaviour = "NoCoverPath";
        Perform_Error_Stop();
    }
}

state TakeCoverFailed {
BEGIN:
    Sleep(0.1);
    myAIRole.TakeCoverFailed();
    Perform_Error_Stop();
}

state Engaged_TakeCover
{
    function bool KeepGoing()
    {
            return  (Enemy!=None) && !Pawn.ReachedDestination(claimedPosition);
    }

    function BeginState()
    {
            if(currentStage != None) {
                currentStage.Report_Unsighted(self, Enemy);
            }
        }

    function EndState()
    {
            if(currentStage != None && EnemyIsVisible() )
        {
                currentStage.Report_Eyesighted(self, Enemy);
            }
            if ( pawn != None ) pawn.bWantsToCrouch = false;
    }

    function EnemyNotVisible()
        {
            Global.EnemyNotVisible();
            StopFiring();
    }

BEGIN:
//  FinishRotation();
CROUCH:
    StopFiring();
        Sleep(0.1);
        Goto('DONE');
RUN:
        if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
            UpdateFocus( MoveTarget );
            FinishRotation();
            MoveToward(MoveTarget,,, ShouldStrafe(), false );
        }
        else {
            UpdateFocus( Enemy );
            MoveToward(MoveTarget, Enemy,, ShouldStrafe(), false );
        }

    if ( KeepGoing() ) {
            Sleep(0.1);
            Continue_Engaged_TakeCover();
        }
DONE:
        UpdateFocus( Enemy );
    LastTakeCoverTime = Level.TimeSeconds;
        myAIRole.TakeCoverSucceeded();
}

//====================
// Engage_OutFromCover
// Come out of cover just long enough to shoot at enemy (whack-a-mole)
// Do it fast for element of surprise
//====================

function Perform_Engaged_OutFromCover()
{
    local int i;
    local StagePosition position, shootDest;
    local float dist, tmpDist;

    curBehaviour = "OutFromCover";

    if( claimedPosition != None
           && currentStage.positionHasLOFToEnemy(claimedPosition, Enemy) )
    {
        GotoState('Engaged_OutFromCover', 'STANDUP');
        Pawn.bWantsToCrouch = false;
        return;
    }

    UnClaimPosition();
    tmpDist = 1200;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        position = currentStage.StagePositions[i];
        if( position.bIsClaimed
            || !currentStage.positionHasLOFToEnemy(position, Enemy) ) {
            continue;
        }
        //dist = VSize(position.Location - Pawn.Location);
        dist = VSize(position.Location - LastSeeingPos);
        if( dist < tmpDist )
        {
            tmpDist = dist;
            shootDest = position;
        }
    }
    if( shootDest != None)
    {
        ClaimPosition(shootDest);
        //MoveTarget = shootDest;
    }
    else
    {
        //NOTE: If we can't just come out of cover, we should be recovering, or
        //      staking out
        curBehaviour = "NoOutFromCoverSpot";
        Perform_Error_Stop();
    }

    Continue_Engaged_OutFromCover();
}

function Continue_Engaged_OutFromCover()
{
    if( FindBestPathToward(claimedPosition, false, true) )
    {
        if( IsInState('Engaged_OutFromCover') )
            GotoState('Engaged_OutFromCover', 'MOVE');
        else
            GotoState('Engaged_OutFromCover');
    }
    else
    {
        UnClaimPosition();
        curBehaviour = "NoOutFromCoverPath";
        Perform_Error_Stop();
    }
}

state Engaged_OutFromCover
{

    function bool KeepGoing()
    {
        //log("Reached"@claimedPosition@Pawn.ReachedDestination(claimedPosition) );
        return (Enemy!=None) && !Pawn.ReachedDestination(claimedPosition);
    }

BEGIN:

MOVE:
    if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
        UpdateFocus( MoveTarget, true );
        FinishRotation();
        MoveToward(MoveTarget,,, ShouldStrafe(), false );
    }
    else {
        UpdateFocus( Enemy );
        MoveToward(MoveTarget, Enemy,, ShouldStrafe(), false );
    }
    if( KeepGoing() ) Continue_Engaged_OutFromCover();

STANDUP:
    Sleep(0.1);

DONE:
    UpdateFocus( Enemy );
    myAIRole.outFromCoverSucceeded();
}

//=======================
// Engage_SuppressionFire
// The enemy isn't visible, but lay down fire at the last seen position to keep him hidden
//=======================

function Perform_Engaged_SupressionFire()
{
    curBehaviour = "SupressionFire";
    FocalPoint = LastSeenPos;
    GotoState('Engaged_SupressionFire');
}

state Engaged_SupressionFire
{

    function BeginState()
    {
        bFireAtLastLocation = true;
    }

    function EndState()
    {
        bFireAtLastLocation = false;
    }

    event SeePlayer( Pawn Seen )
    {
        Global.SeePlayer( Seen );
        if(Enemy == Seen)
        {
                    UpdateFocus( Enemy );
        }
    }

    event EnemyNotVisible()
    {
        Global.EnemyNotVisible();
                UpdateFocus( None, true );
        FocalPoint = LastSeenPos;
    }

    /**
    * Fire at the last seen position if we can't see enemy
    */
   function TimedFireWeaponAtEnemy()
    {
        if ( Pawn.Weapon == None ) return;

        if( Pawn.Weapon.IsFiring() )
        {
            SetCombatTimer();
            return;
        }

        //FireWeaponAt(Enemy)
        NumShotsToGo = MaxNumShots;
        CalculateMissVectorScale();
        SetCombatTimer();   //Timer between bursts of fire
        WeaponFireAgain(Pawn.Weapon.RefireRate(),false);
    }

BEGIN:
    StopFiring();
    FinishRotation();
    Sleep(0.1);
    TimedFireWeaponAtEnemy();
    Sleep( NumShotsToGo * getWeaponFireRate(Pawn.Weapon) );
        myAIRole.supressionFireSucceeded();

}

/**
 * Game specific override
 */
function float getWeaponFireRate( Weapon w );
//NOTEPawn.Weapon.FireMode[Max(0,Pawn.Weapon.BotMode)].FireRate


/**
 * BEHAVIOUR: Charge
 *
 * Make a run at the current enemy
 */
function Perform_Engaged_Charge( optional float maxDuration ) {
    curBehaviour = "Charge";
    if ( maxDuration <= 0 ) maxDuration = 10;
    chargeEndTime = Level.timeSeconds + maxDuration;
    UnClaimPosition();
    GotoState( 'Engaged_Charge', 'BEGIN' );
}

function Continue_EngagedCharge() {
    if ( VSize(Pawn.location - Enemy.Location)
            < (Pawn.CollisionRadius + Enemy.CollisionRadius + 8)
         || Pawn.ReachedDestination(Enemy) ) {
        myAIRole.ChargeSucceeded();
        GotoState('Engaged_Charge', 'DONE');
    }
    else if ( Level.timeSeconds > chargeEndTime ) {
        myAIRole.ChargeFailed();
        GotoState('Engaged_Charge', 'DONE');
    }
    else if ( ActorReachable(Enemy) ) {
        MoveTarget = Enemy;
        GotoState('Engaged_Charge', 'MOVE');
    }
    else if ( FindBestPathToward(Enemy, false,true) ) {
        GotoState('Engaged_Charge', 'MOVE');
    }
    else {
        myAIRole.ChargeFailed();
        GotoState('Engaged_Charge', 'DONE');
    }
}

state Engaged_Charge
{
BEGIN:
    Continue_EngagedCharge();

MOVE:
    if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
        UpdateFocus( MoveTarget );
        FinishRotation();
        MoveToward(MoveTarget,,, ShouldStrafe(), ShouldWalk() );
    }
    else {
        UpdateFocus( Enemy );
        MoveToward(MoveTarget, Enemy,, ShouldStrafe(), ShouldWalk() );
    }
    Continue_EngagedCharge();

DONE:
    curBehaviour = "Charge-done";
    UpdateFocus( Enemy );
    FinishRotation();
}


//==============
//Engage_StrafeMove
// do a little strafe to keep from looking like we're stuck in one spot.
//==============

function Perform_Engaged_StrafeMove()
{
    curBehaviour = "Strafe";

    PickStrafeDir();
    GotoState('Engaged_StrafeMove');
}

function bool TestDirection(vector dir, float minDist, out vector pick)
{
    local vector HitLocation, HitNormal, dist;
    local actor HitActor;

    pick = dir * RandRange(minDist, 2 * minDist);

    HitActor = Trace(HitLocation, HitNormal, Pawn.Location + pick + 1.5 * Pawn.CollisionRadius * dir , Pawn.Location, false);
    if (HitActor != None)
    {
        pick = HitLocation + (HitNormal - dir) * 2 * Pawn.CollisionRadius;
        if ( !FastTrace(pick, Pawn.Location) )
            return false;
    }
    else
        pick = Pawn.Location + pick;

    /*
    if( Pawn.Anchor != None && VSize(pick - Pawn.Anchor.Location) > 500 )
    {
        pick = pick + Normal(Pawn.Anchor.Location - pick) * ( VSize(Pawn.Anchor.Location - pick) - 500 ) ;
    }
    */
    if( claimedPosition != None && VSize(pick - claimedPosition.Location) > 500 )
    {
        pick = pick + Normal(claimedPosition.Location - pick) * ( VSize(claimedPosition.Location - pick) - 500 ) ;
    }

    dist = pick - Pawn.Location;
    if (Pawn.Physics == PHYS_Walking)
        dist.Z = 0;

    if(bDebugLogging)
        curBehaviour = curBehaviour @ VSize(dist) / Pawn.CollisionRadius;

    return (VSize(dist) > minDist);
}

function PickStrafeDir()
{
    local Vector strafeDir;

    strafeDir = Normal(Vector(Rotation) cross vect(0,0,1));

    bStrafeDir = !bStrafeDir;
    if(bStrafeDir)
        strafeDir = -1 * strafeDir;


    if(!TestDirection(strafeDir, Pawn.CollisionRadius * RandRange(2.0, 5.0), strafeTarget) )
    {
        curBehaviour = "NoStrafeDir";
        Perform_Error_Stop();
    }

    //drawdebugline(Pawn.Location, strafeTarget, 255,255,255);
}

state Engaged_StrafeMove
{

    //Avoid falling off ledges while strafing
    function BeginState()
    {
        Pawn.bAvoidLedges = true;
        Pawn.bStopAtLedges = true;
        Pawn.bCanJump = false;
        bAdjustFromWalls = false;
    }

    function EndState()
    {
        bAdjustFromWalls = true;
        if ( Pawn == None )
            return;
        Pawn.bAvoidLedges = false;
        Pawn.bStopAtLedges = false;
        MinHitWall -= 0.15;
        if (Pawn.JumpZ > 0)
            Pawn.bCanJump = true;
    }

BEGIN:
        FinishRotation();
    MoveTo( strafeTarget, Enemy, ShouldWalk() );
    LastStrafeMoveTime = Level.TimeSeconds;

    //If it was *our* move that hid the enemy, we ought to recover it.
    if ( (Enemy == None) || EnemyIsVisible() || !FastTrace(Enemy.Location, LastSeeingPos) )
        Goto('FinishedStrafe');

RecoverEnemy:
    curBehaviour = "StrafeRecover";
    StopFiring();
    Sleep(0.1 + 0.2 * FRand());
    Destination = LastSeeingPos + 4 * Pawn.CollisionRadius
                          * Normal(LastSeeingPos - Pawn.Location);
        FinishRotation();
    MoveTo(Destination, Enemy, ShouldWalk() );

FinishedStrafe:
        myAIRole.strafeMoveSucceeded();
}

//==============
// Engaged_HuntEnemy
// Hopefully this doesn't happen to often, but basically, chase the player since we can't rely on the
// stage for LOS (or he's just too far)
// NOTE Rather than pathfind right to the enemy, we could try AI Game Wisdon 2 article 2.6.
//==============

function Perform_Engaged_HuntEnemy()
{
    curBehaviour = "Hunting";

    UnClaimPosition();
    Continue_Engaged_HuntEnemy();
}

function Continue_Engaged_HuntEnemy()
{
    if( FindBestPathToward(Enemy, false, true) )
    {
        if( IsInState('Engaged_HuntEnemy') )
            GotoState('Engaged_HuntEnemy', 'MOVE');
        else
            GotoState('Engaged_HuntEnemy');
    }
    else
    {
        curBehaviour = "NoHuntPath";
        Perform_Error_Stop();
    }
}

state Engaged_HuntEnemy
{
    function bool KeepGoing()
    {
        return (Enemy!=None) && !EnemyIsVisible();
    }

BEGIN:
    FinishRotation();
MOVE:
    MoveToward(MoveTarget,,, ShouldStrafe(), ShouldWalk() );
    if(KeepGoing())
        Continue_Engaged_HuntEnemy();
    myAIRole.HuntSucceeded();
}

//==============
// Engaged_Panic
// This can be our basic "Panic" state.. we will just try to run away from the enemy.
// if we gain enough distance, lose sight, or do it long enough, we can finish panicking
// stage for LOS (or he's just too far)
//==============

function bool KeepPanicking()
{
    if(Enemy == None)
        return false;

    if( VSize(Pawn.Location - Enemy.Location) < PanicRange )
        return true;

    if( !TimeElapsed(LastSeenTime, 2.0) )
        return true;

    if( !TimeElapsed(PanicStartTime, 3.0) )
        return true;

    return false;
}
function Perform_Engaged_Panic()
{
    curBehaviour = "Panic";
    UpdateFocus( None );
    bHavePanicked = true;
    PanicStartTime=Level.TimeSeconds;
    UnClaimPosition();
    exclaimMgr.Exclaim(EET_Panic, 0.1);
    GotoState('Engaged_Panic');
}

state Engaged_Panic
{
//ignores EnemyNotVisible;

    event SeePlayer( Pawn Seen )
    {
        Global.SeePlayer(Seen);
        UpdateFocus( MoveTarget );
    }

    /**
     * from our current anchor, pick a pathposition that goes away from enemy.
     * search locally since we're not really "thinking coherently", plus
     * getting cornered might look cool for a panic retreat.
     **/
    function PickDestination()
    {
        local int i;
        local StagePosition position, panicDest;
        local float dist, tmpDist;

        for( i = 0; i < currentStage.StagePositions.Length; i++ )
        {
            position = currentStage.StagePositions[i];
            dist = VSize(position.Location - Enemy.Location);
            if( VSize(position.Location - Pawn.Location) < dist && (dist > tmpDist) )
            {
                tmpDist = dist;
                panicDest = position;
            }
        }

        if (! FindBestPathToward(panicDest, false, false) )
        {
            //NOTE This should do something more interesting like cower, beg for mercy etc...
            curBehaviour = "NoPanicDir";
            Perform_Error_Stop();
        }
    }

    function PickDestinationOld()
    {
        local NavigationPoint bestPosition, position;
        local ReachSpec spec;
        local float dp, bestDP;
        local int i, numPaths;
        local vector enemyDir;
        local NavigationPoint fromSpot;


        fromSpot = Pawn.Anchor;
        if(fromSpot == None)
            fromSpot = Pawn.LastAnchor;

        numPaths = 0;
        enemyDir = (Pawn.Location - enemy.Location);

        for(i = 0; i < fromSpot.PathList.length; i++ )
        {
            spec = fromSpot.PathList[i];
            position = spec.End;
            dp = (spec.End.Location - spec.Start.Location) dot enemyDir;

            if( dp > 0.0 )
            {
                numPaths++;
                //don't always pick the "most away" position, since then any bots in the area might go the same way.
                if( FRand() < 1.0f/float(numPaths) )        //  odds are  1/1, 1/2, 1/3, 1/4 ...
                {
                    bestDP = dp;
                    bestPosition = position;
                }
            }
        }

        if( bestPosition != None )
        {
            MoveTarget = bestPosition;
        }
        else
        {
            //NOTE This should do something more interesting like cower, beg for mercy etc...
            curBehaviour = "NoPanicDir";
            Perform_Error_Stop();
        }
    }

    function BeginState()
    {
        if(currentStage != None)
            currentStage.Report_Unsighted(self, Enemy);
    }
    function EndState()
    {
        if(currentStage != None && EnemyIsVisible() )
        {
            currentStage.Report_Eyesighted(self, Enemy);
        }
    }

BEGIN:
    PickDestination();
//  FinishRotation();
FLEE:
    MoveToward(MoveTarget,,, ShouldStrafe(), false);
    PickDestination();
    if( KeepPanicking() )
        Goto('FLEE');
DONE:
        myAIRole.PanicSucceeded();
}

//========================
// Engaged_AdvanceMove
// Find a new position to engage our enemy from
//========================
function Perform_Engaged_AdvanceMove()
{
    local StagePosition oldPosition;
    local StagePosition bestPosition;
    local float oldWeight, oldDist;

    curBehaviour = "AdvanceMove";

    oldPosition = claimedPosition;
    if(oldPosition == None)
    {   oldWeight = 0;
        oldDist = 99999;
    }
    else
    {
        oldWeight = WeightStagePosition(oldPosition);
        oldDist = VSize(oldPosition.Location - Enemy.Location);
    }

    UnClaimPosition();

    if(!PickClosestBetterSpot( oldWeight, oldDist, oldPosition, bestPosition) )
    {
        curBehaviour = "NoNewTacticalSpot";
        Perform_Error_Stop();
    }

    ClaimPosition(bestPosition);

    Continue_Engaged_AdvanceMove();
    return;
}

function Continue_Engaged_AdvanceMove()
{

    if( FindBestPathToward(claimedPosition, false, true) )
    {
        if( IsInState('Engaged_AdvanceMove') )
            GotoState('Engaged_AdvanceMove', 'MOVE');
        else
            GotoState('Engaged_AdvanceMove');
    }
    else
    {
        UnClaimPosition();
        curBehaviour = "NoAdvanceMovePath";
        Perform_Error_Stop();
    }

}

state Engaged_AdvanceMove
{

    function bool KeepGoing()
    {
        //log("Reached"@claimedPosition@Pawn.ReachedDestination(claimedPosition) );
        return (Enemy!=None) && !Pawn.ReachedDestination(claimedPosition);
    }

BEGIN:
    FinishRotation();
MOVE:
        if ( isBehindMe(MoveTarget) || Pawn.bWantsToCrouch || Enemy == None ) {
            UpdateFocus( MoveTarget, true );
            FinishRotation();
            MoveToward( MoveTarget,,, ShouldStrafe(), ShouldWalk() );
        }
        else {
            UpdateFocus( enemy );
            MoveToward( MoveTarget, Enemy,, ShouldStrafe(), ShouldWalk() );
        }
    if( KeepGoing() ) Continue_Engaged_AdvanceMove();

    LastAdvanceMoveTime = Level.TimeSeconds;
        myAIRole.advanceMoveSucceeded();
}

//==============
// Dead
//
// Make sure we notify Stage if appropriate
//==============
function WasKilledBy(Controller Other)
{
    //add fear
    local StagePosition position;
    local int i;
    local float tmpDist;

    if ( currentStage == None ) return;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        position = currentStage.StagePositions[i];
        if ( position == None || Pawn == None ) continue;
        tmpDist = VSize(position.Location - Pawn.Location);
        if( tmpDist < 750) {
            position.FearCost += 750 - tmpDist;
        }
    }
}

/**
 */
//NOTE not sure why this works, but WasKilledBy() doesn't (in UW codebase)...?
function PawnDied( Pawn p ) {
    local NavigationPoint dest;
    if ( p.anchor != None ) p.anchor.fearCost += FEAR_PENALTY;
    dest = NavigationPoint( moveTarget );
    if ( dest != None ) dest.fearCost += FEAR_PENALTY;
    super.PawnDied( p );
    myAIRole.OnKilled( none );
    GotoState( 'Dead' );
}

/**
 * Perform proper housekeeping before being destroyed.
 */
function Cleanup() {
    if ( currentStage != none ) currentStage.leaveStage(self, RSN_Died);
    Enemy = None;
    if ( (GoalScript != None) && (HoldSpot(GoalScript) == None) ) {
        FreeScript();
    }
    StopFiring();
    UnClaimPosition();
    if ( myCreator != None ) myCreator.OpponentDied( self );
}

/**
 */
function DestroyPawn() {
    Cleanup();
    super.DestroyPawn();
}


State Dead
{
ignores SeePlayer, HearNoise, KilledBy, EnemyNotVisible;

    //function Timer() {}

    function BeginState()
    {
            Destroy();
    }

}

// for hibernating
State Dormant {
ignores EnemyNotVisible, SeePlayer, HearNoise;

}

//==============
// Debugging
//==============

/**
 *  Basically the same as standGround, but it relies on the caller to set "curBehaviour" to be used for unaccounted-for
 * situations like when a path can't be found, etc.
 **/
function Perform_Error_Stop()
{
    if(Focus != Enemy) //not visible
    {
        SetFocalPointNearLocation(LastSeenPos);
    }
    if ( Pawn != none ) Pawn.Velocity = vect(0,0,0);
    GotoState('Error_Stop');
}

state Error_Stop
{
    function BeginState()
    {
        if ( pawn != none ) {
            Pawn.Acceleration = vect(0,0,0);
            Pawn.Velocity = vect(0,0,0);
        }
    }

BEGIN:
    FinishRotation();
    Sleep( 2.0 );
    myAIRole.ErrorStopSucceeded();
}

/**
 */
function vector WorldToScreen( vector w ) {
    //NOTE: I think this method is portable across codebases...
   return Level.GetLocalPlayerController().player.console.WorldToScreen( w );
}

/**
 * When called, will draw debug text above the bots head
 */
function DrawHUDDebug(Canvas C)
{
    local vector screenPos;

    if (!bDebugLogging || Pawn == None) return;

    screenPos = WorldToScreen( Pawn.Location
                               + vect(0,0,1)*Pawn.CollisionHeight );
    if (screenPos.Z > 1.0) return;

    C.SetPos(screenPos.X - 8*Len(curBehaviour)/2, screenPos.y-12);
    C.SetDrawColor(0,255,0);
    //C.Font = C.tinyFont;

    C.DrawText( myAIROle.GetStateName());
    C.SetPos(screenPos.X - 8*Len(curBehaviour)/2, screenPos.y);

    if( LatentFloat == 0) {
        C.DrawText( curBehaviour );
    }
    else {
        C.DrawText( curBehaviour @LatentFloat);
    }

    C.SetPos(screenPos.X - 8*Len(curBehaviour)/2, screenPos.y-24);
    if( !exclaimMgr.bScheduled
        && Level.TimeSeconds <= exclaimMgr.nextExclamation.time + 1 ) {
        C.DrawText( exclaimMgr.LastMsg );
    }
}

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local string drawText;
    if ( !bDebugLogging ) return;

//    canvas.font = canvas.tinyFont;
    Super.DisplayDebug(Canvas,YL, YPos);
    Canvas.SetPos(4,YPos);
    Canvas.SetDrawColor(0,255,0);
    drawText = "STAGE:";
    if ( currentStage == None ) {
        drawText = drawText @ "None";
    }
    else {
        drawText = drawText @ currentStage.StageName;
    }

    drawText = drawText @ " Stage order:";
    switch (curStageOrder)
    {
    case SO_None:
        drawText = drawText @ "SO_None";
        break;
    case SO_TakeUpPosition:
        drawText = drawText @ "SO_TakeUpPosition"@TakeUpPosition;
        break;
    case SO_HoldPosition:
        drawText = drawText @ "SO_HoldPosition";
        break;
    case SO_TakeCover:
        drawText = drawText @ "SO_TakeCover";
        break;
    default:
        drawText = drawText @ "Unrecognized order:" @ curStageOrder;
        break;
    }
    Canvas.DrawText(drawText);
    YPos += YL;
    Canvas.SetPos(4,YPos);

    drawText = "Performing:" @ curBehaviour;
    if(Enemy != None) {
        drawText = drawText @ "hitChance:" @ ChanceToHit() @ "enemyDist"
            @ VSize(Enemy.Location - Pawn.Location);
    }
    Canvas.DrawText(drawText);
    YPos += YL;
    Canvas.SetPos(4,YPos);

    drawText = "Enemy:" $ Enemy @ "ShootTarget:" $ ShootTarget
                   @ "FocalPoint:" $ FocalPoint;
    Canvas.DrawText( drawText );
    YPos += YL;
    Canvas.SetPos(4,YPos);
    myAIRole.DisplayDebug(Canvas,YL, YPos);
}

/**
 * Handy debugging helper.  No flags means always output, otherwise
 * output is only generated when the flag bits are also set in
 * AIDebugFlags.
 */
function DebugLog( coerce String s, optional int flags ) {
    if ( bDebugLogging ) {
        if ( flags == 0 || (flags & AIDebugFlags) != 0 ) {
            Log( self @ s, 'VGSPAIController' );
        }
    }
}

function debugTick(float dT)
{

    if(claimedPosition != None)
        drawdebugline(Pawn.Location, claimedPosition.Location, 255,0,255);
    /*
    if(Pawn.Anchor != None)
        drawdebugline(Pawn.Location, Pawn.Anchor.Location, 0,255,0 );
    */

    //drawEnemyTarget();
    drawCover();
    //drawPosnLOS();
    //drawPositionWeights();
    //drawExperimentalGrid(); //green
    //debugDrawBlockingLOF(); //red
    //debugDrawBlockedLOF(); // blue
    //debugDrawFireCone(); //cone-shaped
    //debugDrawVerifiedPositions(); //white and black
}

/**
 */
function drawEnemyTarget()
{
    if(Enemy != None)
    {
        if(EnemyIsVisible()) {
            if( SameTeamAs(Level.GetLocalPlayerController()) ) {
                drawdebugline( Pawn.Location+vect(0,0,10), Enemy.Location,
                               0, 0, 255 );
            }
            else {
                drawdebugline( Pawn.Location+vect(0,0,10), Enemy.Location,
                               255, 0, 0 );
            }
        }
        else {
            drawdebugline( Pawn.Location+vect(0,0,10), LastSeenPos,
                           179, 179, 255 );
        }
    }
}

/**
 */
function drawCover()
{
    local int i;
    local StagePosition position;

    if ( currentStage == None ) return;

    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        position = currentStage.StagePositions[i];
        if( currentStage.PositionProvidesCoverFromEnemy(position, Enemy) > 0) {
            drawdebugline( position.Location,
                           position.Location + vect(0,0,1)*50, 0,255,0 );
        }
        //else if (position.bCrouchCover) {
            //if ( position.CrouchCover >= CT_PartialCover ) {
            //drawdebugline( position.Location,
            //               position.Location + vect(0,0,1)*50, 255,0,0 );
        //}
        else {
            drawdebugline( position.Location,
                           position.Location + vect(0,0,1)*50, 255,0,0 );
        }
    }
}

function drawPosnLOS()
{
    local int i, j;
    local StagePosition position;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
        {
            position = currentStage.StagePositions[i];
            //if(position.bLOSTOPlayer > 0)
            for(j=0;j<8;j++)
            {
                if( (position.StandLOF & (0x1<<j)) != 0 )
                {   drawdebugline(position.Location, position.Location + vect(0,0,1)*50 + vect(0,1,0)*10*j, 255,255,255);
                }
                else if(currentStage.Enemies[j] != None)
                {   drawdebugline(position.Location, position.Location + vect(0,0,1)*50 + vect(0,1,0)*10*j, 128,128,128);
                }
                else
                {   drawdebugline(position.Location, position.Location + vect(0,0,1)*50 + vect(0,1,0)*10*j, 0,0,0);
                }

            }
            /*
            if(position.bProvidesCover)
            {
                drawdebugline(position.Location + vect(0,0,1)*50, position.Location + vect(0,0,1)*100, 0,255,0);
            }
            else
            {   drawdebugline(position.Location + vect(0,0,1)*50, position.Location + vect(0,0,1)*100, 255,0,0);
            }
            */
        }
}

function drawPositionWeights()
{
    local int i;
    local StagePosition position;
    local float weight;

    if(Enemy != None)
    {
        for( i = 0; i < currentStage.StagePositions.Length; i++ )
        {
            position = currentStage.StagePositions[i];
            weight = WeightStagePosition(position);
            weight = 255.0 * weight;
            drawdebugline(position.Location, position.Location + vect(0,0,1)*50, weight,0,0);
        }
    }
}

function drawExperimentalGrid()
{

    local int gridNum, colSize;
    local int x, y, sign, xSign, ySign;
    local vector delta, spot;

    colSize = 160;
    gridNum = 1200 / (colSize*2);

    for(sign = 0; sign<4; sign++)
    {
        xSign = 1 - 2*(sign/2);
        ySign = 1 - 2*(sign%2);
        for(x = 0; x < gridNum; x++)
        {
            for(y = 0; y < gridNum-x; y++)
            {
                delta = vect(1,0,0)*colSize*x*xSign + vect(0,1,0)*colSize*y*ySign;
                spot = Pawn.Anchor.Location + delta;
                spot.X = int( (spot.X + 0.5*colSize) / colSize ) * colSize;
                spot.Y = int( (spot.Y + 0.5*colSize) / colSize ) * colSize;

                drawdebugline(spot, spot + vect(0,0,1)*50 , 0,255,0 );
            }
        }
    }

}

function debugDrawVerifiedPositions()
{
    local int i;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        if( VerifyShootingPosition(currentStage.StagePositions[i]) )
            drawdebugline(currentStage.StagePositions[i].Location, currentStage.StagePositions[i].Location + 50 * vect(0,0,1), 255,255,255);
        else
            drawdebugline(currentStage.StagePositions[i].Location, currentStage.StagePositions[i].Location + 50 * vect(0,0,1), 0,0,0);
    }
}

function debugDrawFireCone()
{
    if(Enemy != None)
    {
        if( (Enemy.CollisionRadius*3.0) / VSize(Pawn.Location - Enemy.Location) > 0.123 )
        {
            drawdebugline(Pawn.Location,  Enemy.Location + (( Normal(Enemy.Location - Pawn.Location)*VSize(Pawn.Location - Enemy.Location)* 0.123) << rotator(vect(0,1,0))), 0,0,255);
            drawdebugline(Pawn.Location,  Enemy.Location + (( Normal(Enemy.Location - Pawn.Location)*VSize(Pawn.Location - Enemy.Location)* 0.123) << rotator(vect(0,-1,0))), 0,0,255);
        }
        else
        {
            drawdebugline(Pawn.Location,  Enemy.Location + (( Normal(Enemy.Location - Pawn.Location)*Enemy.CollisionRadius*3.0) << rotator(vect(0,1,0))), 0,255,0);
            drawdebugline(Pawn.Location,  Enemy.Location + (( Normal(Enemy.Location - Pawn.Location)*Enemy.CollisionRadius*3.0) << rotator(vect(0,-1,0))), 0,255,0);
        }
    }
}

function debugDrawBlockedLOF()
{
    local int i;

    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        if( currentStage.calculateStagePosnLOSIsBlocked(self, currentStage.StagePositions[i]) > 0)
        {
            drawdebugline(currentStage.StagePositions[i].Location, currentStage.StagePositions[i].Location + 50 * vect(0,0,1), 0,0,255);
        }
    }
}

function debugDrawBlockingLOF()
{
    local int i;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        if( currentStage.calculateStagePosnBlocksLOS(self, currentStage.StagePositions[i]) > 0)
        {
            drawdebugline(currentStage.StagePositions[i].Location, currentStage.StagePositions[i].Location + 100 * vect(0,0,1), 255,0,0);
        }
    }
}


/**
 * Determines whether an actor is behind the pawn.
 */
function bool isBehindMe( Actor a ) {
    return Vector(pawn.rotation) dot (a.location - pawn.location) < 0.5;
}


//=============
// Helpers
//=============

/**
 * integer version of RandRange, returns an random integer between Min and Max
 **/
function int iRandRange(int min, int max)
{
    return Min + Rand((Max - Min) + 1);
}

/**
 * startTime must have been set to Level.TimeSeconds at some point in the past
 **/
function bool TimeElapsed(float startTime, float duration)
{
    return (Level.TimeSeconds - startTime) >= duration;
}

/**
 * Pick closest better StagePosition
 **/
function bool PickClosestBetterSpot(float baseWeight, float baseDist, StagePosition oldPosition, out StagePosition newPosition)
{
    local StagePosition position;
    local float weight, dist, bestDist;
    local int i;

    bestDist = 99999;
    for( i = 0; i < currentStage.StagePositions.Length; i++ )
    {
        position = currentStage.StagePositions[i];
        weight = WeightStagePosition(position);
        if( position == oldPosition || position.bIsClaimed || weight < baseWeight || VSize(position.Location - Enemy.Location) > baseDist || !VerifyShootingPosition(position)  )
            continue;
        dist = VSize(position.Location - Pawn.Location);
        if(dist < bestDist)
        {
            bestDist = dist;
            newPosition = position;
        }
    }
    if(newPosition == None)
        return false;

    return true;
}

defaultproperties
{
     MaxLostContactTime=5.000000
     ReflexTime=0.500000
     bRangedAttackCapable=True
     MinNumShots=3
     MaxNumShots=5
     MinShotPeriod=1.000000
     MaxShotPeriod=3.000000
     MaxSkillOdds=0.200000
     MaxAimRange=5000.000000
     MaxAimVelocity=500.000000
     MaxSecondsOfLOS=3.000000
     fOddsOfStrafeMove=0.250000
     MinTimeBetweenStrafeMove=3.000000
     EnemyDistractDuration=7.000000
     EnemyDistractDistance=1000.000000
     m_BunchPenalty=1.000000
     m_BlockedPenalty=1.000000
     m_BlockingPenalty=1.000000
     m_NeedForCover=1.000000
     m_NeedForContact=1.000000
     m_NeedCohesion=1.000000
     m_NeedForIntel=1.000000
     m_NeedToAvoidCorpses=1.000000
     m_NeedForClosingIn=1.000000
     m_NeedForNearbyGoal=1.000000
     CLAIMED_POSITION_PENALTY=9999
     lastHitTime=-1.000000
     maxDistToCrouchForCover=300.000000
}
