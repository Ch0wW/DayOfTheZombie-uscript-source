// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AIRole - encapsulates the logic for translating orders into
 *    behaviours.
 *
 * Note: This class is in a transitional state, so might not be quite
 *       in synch with the above description.
 *
 * Todo:
 *  - convert to state-code implementation, with latent behaviours.
 *  - maybe an instance of a role could act like a prototype object,
 *    which controllers can clone at run-time.
 *
 * @version $Revision: #1 $
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @date    Dec 2003
 */
class AIRole extends Actor;

#exec Texture Import File=Textures/Brain.tga Name=AIRoleIcon Mips=Off MASKED=1


// Our owner
var VGSPAIController    bot;

//NOTE A new idea, that doesn't exist yet between stages and
//     controllers, but might make role design easier.
enum OrderStrictness {
    OS_Normal,     // should follow this order, with room for interpretation.
    OS_Imperitive, // *must* follow this order as best it can manage.
    OS_Optional    // more of a hint, bot can follow as closely as it likes.
};

//=========
//Modifiers
//=========

// Percent of health below which a bot might hide or panic.
var float   pctHealth;

// Odds this character will panic from low health
var float   fOddsOfPanic;

// Data for StrafeMove behaviour
var float fOddsOfStrafeMove;
// don't Strafe move until at least this much time has passed
var float MinTimeBetweenStrafeMove;

// range (seconds) that bots spend under cover (when ducking in and out)
var float MinHideTime;
var float MaxHideTime;
// range (seconds) that bots spend open and shooting (when ducking in and out)
var float MinExposeTime;
var float MaxExposeTime;

// FSM state index for behaviours
var int curState;
// set to Level.TimeSeconds by behaviours to track durations
var float timeTracker;
// set to a duration by behaviours to trigger state changes
var float timeDuration;

var(AI) bool bDebugLogging;

//======================
// Current Situation
//======================

var bool bAttackAggresively;
var int NumDucknShootCycles;
var float fearFactor;

const DECAY_TIMER = 34820;
const DECAY_INTERVAL = 3.5;


/**
 */
function BeginPlay() {
    super.BeginPlay();
    SetMultiTimer( DECAY_TIMER, DECAY_INTERVAL, true );
}

/**
 */
function MultiTimer( int timerID ) {

    switch ( timerID ) {
    case DECAY_TIMER:
        fearFactor *= DECAY_INTERVAL * 0.01;
        fearFactor = FClamp( fearFactor, 0, 1.0 );
        break;

    default:
        super.MultiTimer( timerID );
        break;
    }
}

//===========================================================================
// Order hooks - called when the stage gives the controller an order.
//   See the corresponding StageOrder_* methods in VGSPAIController
//   for the semantics of the orders.
//===========================================================================

//TODO currently, these are just copied from the VGSPAIController
//     versions, eventually, they will be re-implemented to keep all of
//     the logic in the AIRole.

/**
 */
function Order_TakeUpPosition( StagePosition pos,
                               optional OrderStrictness strictness ) {
    if (pos == None) return;
    bot.curStageOrder  = SO_TakeUpPosition;
    bot.TakeUpPosition = pos;
}

/**
 */
function Order_HoldPosition( optional OrderStrictness strictness ) {
    //UnClaimPosition();
    bot.curStageOrder = SO_HoldPosition;
}

/**
 */
function Order_TakeCover( StagePosition pos,
                          optional OrderStrictness strictness ) {
    bot.curStageOrder = SO_TakeCover;
}

/**
 */
function Order_AttackTarget( Actor target,
                             optional OrderStrictness strictness ) {
    if ( target == None ) return;
    bot.curStageOrder = SO_AttackTarget;
    bot.ShootTarget   = target;
    if ( Pawn(target) != None ) {
        bot.AcquireEnemy( Pawn(target), false ); //FIXME what to use for bCanSee?
    }
}

/**
 */
function Order_None( optional OrderStrictness strictness ) {
    bot.curStageOrder = SO_None;
}


//===========================================================================
// Behaviour status callbacks...
//===========================================================================

/**
 */
function awakenSucceeded() {
    BotSelectAction();
}

/**
 */
function acquireEnemySucceeded() {
    BotSelectAction();
}

/**
 */
function NotEngagedAtRestSucceeded() {
    BotSelectAction();
}

/**
 */
function NotEngagedWanderSucceeded() {
    BotSelectAction();
}

/**
 */
function NotEngagedWanderFailed() {
    BotSelectAction();
}

/**
 */
function MoveToPositionSucceeded() {
    BotSelectAction();
}

/**
 */
function MoveToLocationSucceeded() {
    BotSelectAction();
}

/**
 */
function MoveToLocationFailed() {
    BotSelectAction();
}

/**
 */
function StandGroundSucceeded() {
    BotSelectAction();
}

/**
 */
function FireAtTargetSucceeded() {
    BotSelectAction();
}

/**
 */
function RecoverEnemySucceeded() {
    BotSelectAction();
}

/**
 */
function GetLOSSucceeded() {
    BotSelectAction();
}

/**
 */
function GetLOSFailed() {
    BotSelectAction();
}

/**
 */
function HideFromEnemySucceeded() {
    BotSelectAction();
}

/**
 */
function outFromCoverSucceeded() {
    BotSelectAction();
}

/**
 */
function supressionFireSucceeded() {
    BotSelectAction();
}

/**
 */
function TakeCoverSucceeded() {
    if ( bot.currentStage != None ) bot.currentStage.Report_Covered( bot );
    BotSelectAction();
}

/**
 */
function TakeCoverFailed() {
    if ( bot.currentStage != None ) bot.currentStage.Report_Exposed( bot );
    BotSelectAction();
}

/**
 */
function ChargeSucceeded() {
    BotSelectAction();
}

/**
 */
function ChargeFailed() {
    BotSelectAction();
}


/**
 */
function strafeMoveSucceeded() {
    BotSelectAction();
}

/**
 */
function HuntSucceeded() {
    BotSelectAction();
}

/**
 */
function PanicSucceeded() {
    BotSelectAction();
}

/**
 */
function advanceMoveSucceeded() {
    BotSelectAction();
}

function errorStopSucceeded() {
    DebugLog("ErrorStop FAILED at"@bot.curBehaviour);
    BotSelectAction();
}

/**
 */
function takePositionFailed() {
    BotSelectAction();
}

/**
 */
function TakePositionSuceeded() {
    BotSelectAction();
}

/**
 */
function MeleeAttackSucceeded() {
    BotSelectAction();
}

 /**
  */
function MeleeAttackFailed() {
    BotSelectAction();
}

//===========================================================================
// Events of note, care of the controller...
//===========================================================================

/**
 */
function OnEnemyAcquired();

/**
 */
function OnTakingDamage(Pawn Other, float Damage) {
    fearFactor += 0.3;
    if ( damage >= bot.pawn.health ) fearFactor += 0.5;
    fearFactor = FClamp( fearFactor, 0, 1.0 );
}

/**
 */
function OnUnderFire();

/**
 * No longer able to see the enemy
 */
function OnLostSight();

/**
 * Caught sight of the same enemy that you lost sight of previously.
 */
function OnRegainedSight();

/**
 * Death of a friendly...
 */
function OnWitnessedDeath();

/**
 * Killed an enemy
 */
function OnWitnessedKill( Controller killer, Pawn victim ) {
    bot.DebugLog( "Saw" @ killer @ "kill" @ victim );
}

/**
 */
function OnEnemyTooClose();

/**
 */
function OnEnemyTooFar();

/**
 * Called whenever an enemy pawn is in sight, but not the current
 * enemy.
 */
function OnThreatSpotted( Pawn threat );

/**
 * Analagous to OnThreatSpotted().
 */
function OnThreatHeard( Pawn threat );

/**
 * Called whenever noise is heard, in addition to OnThreatHeard.
 */
function OnHeardNoise( float loudness, Actor noiseMaker );

/**
 * Called when the pawn... er... bumps into something?
 */
function OnBump( Actor other );

/**
 */
function OnHitWall( Actor other );

/**
 */
function OnHitMover( Actor other );

/**
 * The pawn has been reduced to 0 health.
 */
function OnKilled( Controller killer ) {
    // get out of any state that would be actually doing something...
    GotoState( 'Dead' );
}




//===========================================================================
// Misc controller interface
//===========================================================================

/**
 */
function init(VGSPAIController c)
{
    bot = c;
    SetNodeFactorWeights(c);
    bDebugLogging = c.bDebugLogging;
}


//===========================================================================
// Transient code (will probably be obselete...)
//===========================================================================

/**
 * Migrated from VGSPAIController.SelectAction()
 *
 * This will eventually be replaced by state code, which will be able
 * to block waiting for behaviours, instead of this crazy
 * state-machine polling action.
 **/
function BotSelectAction()
{
    // Scripting
    if ( bot.ScriptingOverridesAI() && bot.ShouldPerformScript() )
    {
        if ( bot.ActionNum < bot.SequenceScript.Actions.length ) {
            bot.curBehaviour = "Script"
                @ bot.SequenceScript.Actions[bot.ActionNum].GetActionString();
        }
        else {
            bot.curBehaviour = "Script-action-out-of-bounds";
        }
        return;
    }

    // if you *are* using the state code, you'll want this callback!
    Notify();

    if( bot.currentStage != None)
    {
        bot.FollowOrder();
    }
    else
    {
        SelectAction();
    }
}

/**
 */
function SelectAction() {
    AnalyzeSituation();
    if( PerformRole() || ShouldShootTarget() ) return;
    SelectBehaviour();
    PerformBehaviour();
    return;
}

/**
 * A sketchy hack to start the crazy AIRole control flow... hopefully
 * this won't be needed once latent behaviours are implemented.
 */
auto state InitRole {
BEGIN:
    Sleep( 0.25 );
    BotSelectAction();
    GotoState('Relax');
    // ? goto state relax?
}

/**
 * Make sure the role doesn't mess with the bot while it's being scripted.
 */
state Scripting {
    function BeginState() {
        //log( "########### START SCRIPTING ##############" );
    }

    function EndState() {
        //log( "############# END SCRIPTING ###############" );
    }

    function SelectAction() {}
    function BotSelectAction() {}
    function Timer() {}
    function MultiTimer( int timerID ) {}
}

//===========================================================================
// Other code (don't know if it's in or out)
//===========================================================================


/**
 */
function SetNodeFactorWeights(VGSPAIController c);

/**
 */
function bool PerformRole()
{
    return false;
}

/**
 */
function bool ShouldShootTarget()
{
    // during combat, have to decide between shooting at the
    // target and doing other combat things - like shooting at the
    // enemy.
    local float lastHitTime;
    lastHitTime = bot.getLastHitTime();
    if ( bot.ShootTarget != None
         // haven't been damaged lately...
         && ((lastHitTime < 0)
             || (Level.TimeSeconds - lastHitTime) > bot.EnemyDistractDuration)
         // and the enemy isn't too close...
         && (VSize(bot.Enemy.Location - Location) > bot.EnemyDistractDistance)
         ) {
        //NOTEbot.Perform_NotEngaged_FireAtTarget();
        return true;
    }
    return false;
}

/**
 */
function AnalyzeSituation()
{
    local float fContactPct;

    if( bot.LostContact(bot.MaxLostContactTime) )
    {
        bot.LoseEnemy(bot.MaxLostContactTime);
    }

    if ( bot.Enemy == None && bot.currentStage != None)
    {
        bot.currentStage.FindNewEnemyFor(bot);
    }

    // if there is no stage, then an contact of 0 is reasonable
    // (we only know ourselves);
    if( bot.currentStage != None )
    {
        fContactPct = bot.currentStage.Request_PercentEyeSighted(bot);
    }
}

/**
 * SelectBehaviour
 * This must take the situation analysis and choose the most fit behaviour
 */
function SelectBehaviour();
/**
 * PerformBehaviour
 * This allows the behaviour to choose appropriate bot actions
 */
function PerformBehaviour();





//===========================================================================
// Role Tactics
//===========================================================================

//===========
// Directives
// basically, our analysis of the situation will prioritze these
//===========

function GOTO_Attack()
{
    if(bAttackAggresively)
        GotoState('AttackingAggresively');
    else
        GotoState('AttackingDefensively');
}


//================
// Attitude States
//================

state Relax
{
    function BeginState()
    {
        curState = 0;
    }

    function SelectBehaviour()
    {
        if( bot.Enemy != None )
            GOTO_Attack();
    }

    function PerformBehaviour()
    {
        Notify();
    }

BEGIN:
    while(true)
    {
        if(FRand() > 0.5) {
            bot.Perform_NotEngaged_AtRest();    WaitForNotification();
        }
        else {
            bot.Perform_NotEngaged_Wander();    WaitForNotification();
        }
    }
}

state AttackingAggresively
{
    function BeginState()
    {
        curState = 0;
    }

    function SelectBehaviour()
    {
    }

    function PerformBehaviour()
    {
        Notify();
    }

BEGIN:
    while(true)
    {
        bot.Perform_Engaged_GetLOS();        WaitForNotification();
        bot.Perform_Engaged_StandGround();   WaitForNotification();
    }
}


state AttackingDefensively
{
    function BeginState()
    {
        curState = 0;
    }

    function OnTakingDamage(Pawn Other, float Damage)
    {
        if(bot.SameTeamAs(Other.Controller))
            return;
        if(curState != 1)
        {
            bot.Perform_Engaged_TakeCover();
            curState = 1;
        }
    }


    function SelectBehaviour()
    {
        if( bot.Enemy == None )
            GotoState('Relax');
    }

    //enemy facing me within 20deg
    function bool EnemyIsFacingMe()
    {
        if ( bot == None || bot.Enemy == None || bot.Pawn == None || bot.Enemy != Level.GetLocalPlayerController().Pawn) {
            return false;
        }
        return ( Vector(bot.Enemy.Rotation)
                 dot Normal(bot.Pawn.Location - bot.Enemy.Location) > 0.94 );
    }

    //Basically an implementation of Whack-A-Mole
    function PerformBehaviour()
    {
        Notify();
    }

BEGIN:
    NumDucknShootCycles = 0;
    while(true) {
        //take cover
        bot.Perform_Engaged_TakeCover();    WaitForNotification();
        //stay covered
        timeTracker  = bot.LastTakeCoverTime;
        timeDuration = RandRange(MinHideTime, MaxHideTime);
        timeDuration += 5 * fearFactor;
        while( !TimeElapsed( timeTracker, timeDuration)
                || EnemyIsFacingMe() ) {
            bot.Perform_Engaged_TakeCover();    WaitForNotification();
        }
        //come out
        bot.Perform_Engaged_OutFromCover();     WaitForNotification();
        //attack for a while
        timeTracker  = Level.TimeSeconds;
        timeDuration = RandRange(MinExposeTime, MaxExposeTime);
        timeDuration += NumDucknShootCycles;
        while( !TimeElapsed( timeTracker, timeDuration) ) {
            if(!bot.EnemyIsVisible()) {
                GotoState('Pursue');
            }
            bot.Perform_Engaged_StandGround();  WaitForNotification();
        }
        NumDucknShootCycles++;
    }
}



state Pursue
{
    function SelectBehaviour()
    {
        if( bot.Enemy == None )
            GotoState('Relax');
        if( ! bot.NoLongerOnGoodPosition() )
            GOTO_Attack();
    }

    function PerformBehaviour()
    {
        Notify();
    }

BEGIN:
    while(true) {
        bot.Perform_Engaged_GetLOS();  WaitForNotification();
    }
}

state Hide
{
    function SelectBehaviour()
    {
        if( TimeElapsed(bot.getLastHitTime(), 5.0) )
        {
            GOTO_Attack();
        }
        if( TimeElapsed(bot.LastSeenTime, 2.0 ) )
        {
            GOTO_Attack();
        }
    }

    function PerformBehaviour()
    {
        Notify();
    }
BEGIN:
    while(true) {
        if( !bot.EnemyIsVisible() ) {
                bot.Perform_Engaged_StandGround();  WaitForNotification();
        }
        if( !TimeElapsed(bot.getLastHitTime(), 5.0) ) {
            bot.Perform_Engaged_HideFromEnemy();  WaitForNotification();
        }
    }
}

/**
 * State for after the pawn is dead.
 */
state Dead {
   //TODO: make this state really efficient, in case the role doesn't get
   //      cleaned up right away.
}


//========
// Helpers
//========

function bool TimeElapsed(float startTime, float duration)
{
    return (Level.TimeSeconds - startTime) >= duration;
}

function float contactPct()
{
    if( bot.currentStage != None ) {
        return bot.currentStage.Request_PercentEyeSighted( bot );
    }
    else return 0;
}

function float contactNum()
{
    if( bot.currentStage != None ) {
        return (bot.currentStage.StageAgents.Length - 1)
                  * bot.currentStage.Request_PercentEyeSighted( bot );
    }
    else return 0;
}

/**
 * Handy debugging helper.
 */
function DebugLog( coerce String s, optional name tag ) {
   if ( bDebugLogging ) Log( self @ s, 'VGSPAIController' );
}

/**
 * Realtime onscreen debug info...
 */
function DisplayDebug(Canvas c, out float YL, out float YPos) {
    c.SetDrawColor(128, 255, 128);
    c.SetPos(4, YPos);
    c.DrawText( "ROLE:" @ self @ "State:" @ GetStateName() );
    YPos += YL;
    c.SetPos(4,YPos);
    c.SetDrawColor(0, 255 ,0);
}

defaultproperties
{
     pctHealth=0.500000
     fOddsOfPanic=0.500000
     fOddsOfStrafeMove=0.250000
     MinTimeBetweenStrafeMove=1.000000
     MinHideTime=1.000000
     MaxHideTime=2.000000
     MinExposeTime=1.000000
     MaxExposeTime=2.000000
     bHidden=True
     Texture=Texture'DEBAIT.AIRoleIcon'
}
