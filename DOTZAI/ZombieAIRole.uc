// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieAIRole -
 *
 * @version $Rev: 5272 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class ZombieAIRole extends DOTZAIRole;




//===========================================================================
// Settings
//===========================================================================
var int AttackRange;
var float MinWanderDelay;
var float MaxWanderDelay;


//===========================================================================
// internal data
//===========================================================================

// wander
// (internal use only)
var int numLooks;

// seek
// (internal use only)
var Vector SeekLocation;
var Actor  LastSeekInstigator;
var float LastSeekRefreshTime;

// obstacle smashing
// ( internal use only)
var Smashable CurrentObstacle;
var AttackPoint CurrentAttackPoint;
var int NumClearAttempts;
var float ClearStartTime;

// eating
var Actor EatTarget;
const MAX_EAT_DIST = 100;
var int FailedEatAttempts;
var float DistToEatTarget;
var int EatingTime;
const MAX_EAT_TIME = 10;

// enemy mgmt ( internal use only)
var float LastHeardEnemyTime;
const REACQUIRE_DELAY       = 1.5;

// charging
var int NumChargingZombies; // using default value as a class var.
var const int MaxChargingZombies;
var const float MaxChargeDist;
var const float MinChargeDist;
var float MinTimeBetweenCharges;
var float MaxTimeBetweenCharges;
var float LastChargeTime;
var float ChargeStartTime;
var bool bIsCharging;
var float ChargeDuration;
var bool bIgnoreBumps;
var() bool bAllowedToCharge;

// other
var bool bActivated;
const START_REACQUIRE_TIMER = 68694;
const CHARGE_TIMER          = 8375093;
const PRE_CHARGE_TIMER      = 8375094;
const THINK_AGAIN_TIMER     = 92843;
const MELEE_RANGE           = 150;
const DONT_BE_STUPID_TIMER    = 29384;
var ZombieAIController zombieBot;


//===========================================================================
// Events of interest...
//===========================================================================

function OnTakingDamage(Pawn Other, float Damage) {
    super.OnTakingDamage( other, damage );
    //in multiplayer, if some other human shoots you then go after them instead
    if (Level.NetMode != NM_StandAlone && ZombieAIController(Other.Controller)==None){
      bot.enemy = Other;
    }
}

/**
 * Called whenever an enemy pawn is in sight.
 */
function OnThreatSpotted( Pawn threat ) {
    //            // Log( self @ "OnThreatSpotted" @ threat  )    ;
    if ( threat == None ) return;

    //TODO: this probably needs fancying up.  Possibly only switch if
    //      closer, or human controlled...

    // zombies have stiff necks, they can't look up and down very far...
    if ( abs(threat.location.z - bot.pawn.location.z) > 256 ) {
        return;
    }

    if ( threat != bot.Enemy ) {
        bot.AcquireEnemy(threat, true);
    }
    GotoState( 'Attacking' );
}

/**
 *
 */
function OnThreatHeard( Pawn threat ) {
    //            // Log( self @ "OnThreatHeard not used by ZombieAIRole"  )    ;
}

/**
 * Called when something does a MakeNoise().  Instead of directly
 * acquiring the enemy at this point (as the base class does), start
 * seeking, in an effort to cause an OnThreatSpotted().
 */
function OnHeardNoise( float Loudness, Actor NoiseMaker ) {
    //            // Log( self @ "OnHeardNoise" @ loudness @ noiseMaker  )    ;
    if ( noiseMaker == None ) return;
    if ( NoiseMaker == bot.Enemy ) lastHeardEnemyTime = Level.timeSeconds;
    if ( NoiseMaker.isA('Attractor') || NoiseMaker.isA('HumanPawnBase') ) {
        //FIXME this may be a little wrong, don't want to reset seek state...
        if ( TrySeekTarget(NoiseMaker) ) GotoState( 'Seeking', 'BEGIN' );
    }
}

/**
 * It's all over for this zombie...
 */
function OnKilled( Controller killer ) {
    super.OnKilled( killer );
    EndCharge();
}

/**
 * Mmmmm... tasty carrion to feed on...
 */
function OnWitnessedKill( Controller killer, Pawn victim ) {
    super.OnWitnessedKill( killer, victim );
    if ( victim.IsHumanControlled() || victim.IsA('Otis') ) {
        EatTarget = victim;
        GotoState( 'DoSpecial', 'EAT_STUFF' );
    }
}


//===========================================================================
// High level AI scripts/plans...
//===========================================================================

/**
 * Sets a to be the new seek target, if it is better than the current
 * target.
 *
 * @returns true - target is now a, false otherwise.
 */
function bool TrySeekTarget( Actor a ) {
    // do some easy checks...
    if ( LastSeekInstigator == none     // if we don't have a seek target...
            || (LastSeekInstigator == a // or refreshing current target...
                    && Level.TimeSeconds - lastSeekRefreshTime > 3) ) {   // or it's a hero...
        LastSeekInstigator  = a;
        LastSeekRefreshTime = Level.TimeSeconds;
        SeekLocation        = a.Location;
        return true;
    }
    // check if the new seek target is closer than the current seek
    // target...
    if ( VSize(bot.Pawn.Location - a.location) <=
            VSize(bot.Pawn.Location - SeekLocation) ) {
        LastSeekInstigator = a;
        SeekLocation       = a.Location;
        bot.updateFocus( a );
        return true;
    }
    // new target didn't meet any criteria to override the current one.
    return false;
}

/**
 */
function TryClearObstacle( Actor obstacle ) {
    local Pawn potentialEnemy;

    // if it's an enemy, kill it!
    potentialEnemy = Pawn(obstacle);
    if ( potentialEnemy != None
            && !bot.SameTeamAs(potentialEnemy.controller) ) {
        bot.acquireEnemy(potentialEnemy, true);
        GotoState( 'Attacking' );
        return;
    }

    // check if it's smashable...
    currentObstacle = Smashable(obstacle);
    if ( currentObstacle != None ) {
       //             // Log( self @ "hulk smash!"  )    ;
        numClearAttempts = 0;
        GotoState( 'DoSpecial', 'SMASH_OBSTACLE' );
    }
    else {
        //            // Log( self @ obstacle @ "not smashable"  )    ;
    }
    //FIXME: need a way to resume after clearing the obstacle.
}

/**
 * Determines whether it's appropriate to charge at the enemy now.
 */
function bool ShouldCharge() {
    local bool result;

    // do some quick checks before the expensive one...
    if ( bot.Enemy == none || !bAllowedToCharge ) return false;
    // hack scuttlers to just charge a lot.
    if ( bot.Pawn.isA( 'ScuttlingZombie' ) ) {
        if ( (Level.TimeSeconds - ChargeStartTime) < MinTimeBetweenCharges
                || VSize(bot.Enemy.location - bot.pawn.Location)
                        > MaxChargeDist * 1.5 ) {
            return false;
        }
        else return true;
    }
    // check limits...
    else {
        if ( default.NumChargingZombies >= MaxChargingZombies
                && Level.TimeSeconds - default.LastChargeTime < MaxTimeBetweenCharges ) {
      //                  // Log( self @ "too many charging zombies" @ default.NumChargingZombies  )    ;
            return false;
        }
    }
    // some other checks
    if ( (Level.TimeSeconds - ChargeStartTime) < MinTimeBetweenCharges
            // time to complete spawn anim...
            || (Level.TimeSeconds - bot.Pawn.SpawnTime) < 5
            // range to enemy...
            || VSize(bot.Enemy.location - bot.pawn.Location) > MaxChargeDist
            || VSize(bot.Enemy.location - bot.pawn.Location) < MinChargeDist ) {
     //               // Log( self @ "something else preventing charge"  )    ;
        return false;
    }
    // if it all checks out, make sure we have a straight run at the enemy...
    // (this would be the expensive check)
   // log(" last failed reach time: " $ ZombieBot.FailedReachTime);
 //   log(" last failed reach: " $ ZombieBot.LastFailedReach);
    if (Level.TimeSeconds - ZombieBot.FailedReachTime > 10){
       result = bot.actorReachable(bot.Enemy);
       if ( !result ) {
                       // Log( self @ "charge enemy not reachable"  )    ;
       }
    } else {
      return false;
    }
    return result;
}


//===========================================================================
// Wander - no (known) threats nearby, nothing in particular to do but
//   wander around in an undead stupor.
 //===========================================================================
auto state Wander {

    function BeginState() {
       //             // Log( self @ "entering wander state"  )    ;
    }

    function EndState() {
       //             // Log( self @ "leaving wander state"  )    ;
    }

    function NotEngagedWanderFailed() {
        GotoState( 'Attacking' );
    }

BEGIN:
    while ( true ) {
     //               // Log( self @ "wandering"  )    ;
        Sleep( 1 );
        // look around randomly...
        numLooks = RandRange( 1, 5 );
        while ( numLooks > 0 ) {
            bot.SetRandomFocalPointLocation( 2000 );
            Sleep( RandRange(10, 30) );
            --numLooks;
        }
      //              // Log( self @ "doing the wander behaviour"  )    ;
        // find a new place to stand around...
        bot.Perform_NotEngaged_Wander();    WaitForNotification();
        // now just stand there for a while...
        Sleep( RandRange(MinWanderDelay, MaxWanderDelay) );
    }
}


//===========================================================================
// Seeking - no enemy directly accessible, but something of interest
//   to seek towards, such as an attractor or the sound of a player.
//===========================================================================
state Seeking {

    function BeginState() {
      //              // Log( self @ "entering seeking state"  )    ;
        // entering this state implies there is something to seek
        // towards...
        //            if ( !(LastSeekInstigator != None ) ) {            Log( "(" $ self $ ") assertion violated: (LastSeekInstigator != None )", 'DEBUG' );           assert( LastSeekInstigator != None  );        }//    ;
    }

    function EndState() {
     //               // Log( self @ "leaving seeking state"  )    ;
        // stop moving!
        bot.Perform_Error_Stop();
    }

    /**
     * Bumping into things may interrupt the seeking...
     */
    function OnBump( Actor other ) {
      //              // Log( self @ "OnBump" @ other  )    ;
        TryClearObstacle( other );
    }

    /**
     */
    function OnHitWall( Actor other ) {
    //                // Log( self @ "OnHitWall" @ other  )    ;
        TryClearObstacle( other );
    }

    /**
     */
    function OnHitMover( Actor other ) {
    //                // Log( self @ "OnHitMover" @ other  )    ;
        TryClearObstacle( other );
    }


BEGIN:
    // move to SeekLocation...
  //              // Log( self @ "seeking to" @ seekLocation  )    ;
    bot.Perform_MoveToLocation( seekLocation, 128 );  WaitForNotification();

    //TODO: maybe we arrived at an eat point?  chow down!

    //FIXME: assumes we made it to the location...
    LastSeekInstigator = None;
    // if we didn't end up in the attack state already, go back to
    // wandering around until something new comes up to seek...
    GotoState( 'Wander' );

}


//===========================================================================
// Attacking - engaged with an enemy, give 'em what for!
//===========================================================================
state Attacking {

    function BeginState() {
    //                // Log( self @ "entering attack state"  )    ;
        LastSeekInstigator = bot.enemy;
        bot.updateFocus( bot.enemy );
        bot.SetCombatTimer();
    }

    function EndState() {
        //            // Log( self @ "leaving attack state"  )    ;
        bot.SetTimer( 0, false );
    }

    /**
     * Lost sight of the enemy, try to recover him...
     */
    function OnLostSight() {
        //            // Log( self @ "OnLostSight" @ bot.Enemy  )    ;
        SetMultiTimer( START_REACQUIRE_TIMER, REACQUIRE_DELAY, false );
    }

    /**
     * Attack isn't working.  :-(
     */
    function ChargeFailed() {
        //SetMultiTimer( START_REACQUIRE_TIMER, REACQUIRE_DELAY, false );
    }

    /**
     */
    function OnBump( Actor other ) {
        local Pawn enemy;
        if ( bIgnoreBumps ) return;
        enemy = Pawn( other );
        if ( enemy != none && enemy.IsHumanControlled() ) {
            bIgnoreBumps = true;
            // should set it back again after some time...
            bot.WeaponFireAgain(bot.Pawn.Weapon.RefireRate(),false);
        }

    }

    //
    // Zombies are very single-minded, and ignore many inputs when
    // attacking...
    //
    function OnThreatSpotted( Pawn threat ) {
        if ( threat == bot.Enemy ) {
            //            // Log( self @ "reacquired" @ threat  )    ;
            SetMultiTimer( START_REACQUIRE_TIMER, 0, false );
        }
        else {
           //            // Log( self @ "ignoring OnThreatSpotted" @ threat  )    ;
        }
    }

    function OnHeardNoise( float Loudness, Actor NoiseMaker) {
        //            // Log( self @ "ignoring HearNoise" @ loudness )    ;
        if ( NoiseMaker == bot.Enemy ) lastHeardEnemyTime = Level.timeSeconds;
    }

    function bool TrySeekTarget( Actor a ) {
        return false;
    }

    /**
     * @returns a little bit less than the amount of time it should take to
     *          charge the enemy.
     */
    function float getChargeDuration() {
        local float dist;
        dist = VSize(bot.enemy.location - bot.pawn.location) * 0.8;
        return dist/bot.pawn.GroundSpeed;
    }

BEGIN:
    while ( true ) {
        //            // Log( self @ "attacking"  )    ;
        // Charge!
        if ( shouldCharge() ) {
            StartCharge();
            chargeDuration = getChargeDuration();
            //            // Log( self @ "charge should take" @ chargeDuration @ "seconds"  )    ;
            if ( chargeDuration > 1.5 ) {
                // some wild flailing along the way...
                SetMultiTimer( PRE_CHARGE_TIMER, 0.2, false );
            }
            // timer will trigger an attack just before the bot reaches the
            // enemy, so that it overlaps with the running.
            SetMultiTimer( CHARGE_TIMER, chargeDuration, false );
            bIgnoreBumps = false;
            bot.Perform_MoveToLocation( bot.pawn.location
                                              + ( (bot.enemy.location
                                                     - bot.pawn.location)*0.9 ),
                                          MELEE_RANGE );
            WaitForNotification();
            EndCharge();
        }
        // normal attack
        else {
            if ( VSize(bot.enemy.location - bot.pawn.location) < MELEE_RANGE ) {
                bIgnoreBumps = true;
                bot.Perform_MeleeAttack();
                WaitForNotification();
                bIgnoreBumps = false;
            }
            else {
                // move to a spot in front of the enemy...
                bot.Perform_MoveToLocation( bot.pawn.location
                                              + ( (bot.enemy.location
                                                     - bot.pawn.location)*0.8 ),
                                            MELEE_RANGE );
                // wait a bit and then re-think this action, since moves can
                // take a really long time...
                WaitForNotification( 2 );
            }

        }
        //if you just killed enemy, eat 'im!
        //NOTE: should probably check range to the body here...
        if ( bot.Enemy.Health <= 0 ) {
            EatTarget = bot.Enemy;
            GotoState( 'DoSpecial', 'EAT_STUFF' );
        }
        //FIXME: do we need this?
        Sleep( 0.3 );
    }
}


//===========================================================================
// Performing some special activity...
//===========================================================================
state DoSpecial {

    function BeginState() {
         EatingTime = Level.TimeSeconds;
        //            // Log( self @ "entering special state"  )    ;
    }

    function EndState() {
        //            // Log( self @ "leaving special state"  )    ;
        bot.target = none;
        bot.Focus  = none;
        bot.updateFocus( None );
    }

    // Zombies are very single-minded, and ignore many inputs when
    // doing special stuff...

    function OnThreatSpotted( Pawn threat ) {
        //            // Log( self @ "ignoring OnThreatSpotted" @ threat  )    ;
        if (Level.TimeSeconds - EatingTime > MAX_EAT_TIME){
            super.OnThreatSpotted(threat);
        }
    }

    function OnHeardNoise( float Loudness, Actor NoiseMaker) {
        //            // Log( self @ "ignoring HearNoise" @ loudness )    ;
        if ( NoiseMaker == bot.Enemy ) lastHeardEnemyTime = Level.timeSeconds;
        if (Level.TimeSeconds - EatingTime > MAX_EAT_TIME){
            super.OnHeardNoise( Loudness, NoiseMaker);
        }
    }


BEGIN:
    // if you didn't pick a specific thing to do, we're done!
    Goto( 'DONE' );

SMASH_OBSTACLE:

    //            // Log( self @ "smashing"  )    ;

    // get into position...
    currentAttackPoint = currentObstacle.getAttackPoint( bot.pawn );
    if ( currentAttackPoint == None ) Goto( 'DONE' );
    bot.Perform_MoveToLocation( currentAttackPoint.getAttackLocation() );
    WaitForNotification();
    // face the right way...
    bot.Target = currentObstacle.getSmashActor();
    Bot.Focus = currentObstacle.getSmashActor();
    Sleep( 1 ); // wait for rotation

    // start attacking ...
    for ( numClearAttempts = 0; numClearAttempts < 5; ++numClearAttempts ) {
        //            // Log( self @ "Attacking obstacle"  )    ;
        bot.Perform_MeleeAttack();      WaitForNotification();
        if ( currentObstacle.getAttackPoint(bot.pawn) == none ) break;
    }
    if ( currentObstacle.getAttackPoint(bot.pawn) != none ) {
        // if the obstacle is still in place, smash it good!
        currentObstacle.doSmash( bot.pawn );
    }
    bot.target = none;
    bot.Focus  = none;
    goto( 'DONE' );

EAT_STUFF:
    //            // Log( self @ "Eating stuff"  )    ;
    failedEatAttempts = 0;
    while ( failedEatAttempts < 5 ) {
        if ( EatTarget == none && bot.enemy.Health <= 0 ) {
            EatTarget = bot.enemy;
        }
        if ( EatTarget != none ) {
            distToEatTarget = VSize(EatTarget.location - bot.pawn.location);
            if ( distToEatTarget > MAX_EAT_DIST) {
                // zombies love to eat, so they run towards food.
                zombieBot.bForceRun = true;
                Sleep( RandRange( 0.1, 0.7 ) );
                //            // Log( self @ "GRABBING A BITE:" @ eatTarget @ eatTarget.location  )    ;
                bot.Perform_MoveToLocation( eatTarget.location, MAX_EAT_DIST );
                WaitForNotification( 1 );
                bot.Pawn.Velocity = vect( 0,0,0 );
                bot.Pawn.Acceleration = vect( 0,0,0 );
                zombieBot.bForceRun = false;
            }
            bot.target = eatTarget;
            bot.Focus  = eatTarget;
            if (VSize(EatTarget.location - bot.pawn.location ) <= MAX_EAT_DIST){
                DOTZAIController(bot).Perform_Eating();
            }
            else {
                // bail out if you're not getting any closer to the target...
                if ( distToEatTarget
                        - VSize(EatTarget.location - bot.Pawn.Location) < 128 ){
                    // a little hack to make the zombie walk away...
                    LastSeekInstigator = EatTarget;
                    SeekLocation
                        = Vect(0,0,1) * bot.Pawn.Location
                            + ( Vect(-1,-1,0)
                                * Normal(bot.Pawn.Location - eatTarget.location)
                                * RandRange(0.5, 1.5) * 512 );
                    goto( 'DONE' );
                }
                ++failedEatAttempts;
            }
            Sleep( 0.3 );
        }
        else goto( 'DONE' );
    }
    Goto( 'DONE' );

DONE:
    //            // Log( self @ "done DoSpecial"  )    ;
    bot.Target = none;
    if ( bot.enemy != none ) GotoState( 'Attacking' );
    else if ( LastSeekInstigator != none ) GotoState( 'Seeking' );
    else GotoState( 'Wander' );
}


//===========================================================================
// HELPERS
//===========================================================================

/**
 */
function init( VGSPAIController c ) {
    super.init( c );
    zombieBot = ZombieAIController( c );
    SetMultiTimer( DONT_BE_STUPID_TIMER, 6.0 + RandRange(0, 2.5), false );
}

/**
 */
function MultiTimer( int timerID ) {
    switch ( timerID ) {

    //TODO: might be better to be in a separate state for "just lost contact",
    //      which can more quickly reacquire...
    case START_REACQUIRE_TIMER:
        global.TrySeekTarget( bot.enemy );
        GotoState( 'Seeking' );
        break;

    case PRE_CHARGE_TIMER:
    case CHARGE_TIMER:
        // asynchronous attack, hopefully timed a little before reaching the
        // enemy...
        bot.WeaponFireAgain(bot.Pawn.Weapon.RefireRate(),false);
        break;

    case THINK_AGAIN_TIMER:
        // interrupt movement to allow bot a chance to reassess the situation.
        bot.MoveTimer = -1;
        break;

    case DONT_BE_STUPID_TIMER:
        DontBeStupid();
        break;

    default:
        super.MultiTimer( timerID );
    }
}

/**
 * Periodically override zombie behaviour, in hopes of avoiding stupid
 * situations.
 */
function DontBeStupid() {
    local Pawn player;
    //            // Log( self @ "Checking for stupid situations... if you are not in multiplayer mode"  )    ;
    if (Level.NetMode == NM_Standalone){
       player = Level.GetLocalPlayerController().pawn;
       if ( player == none ) return;
       // ignore the player if he's too far up...
       if ( abs(player.location.z - bot.pawn.location.z) < 512 ) {
           // if the player IS the enemy, and you can attack, then get on it!
           if ( player == bot.Enemy && GetStateName() != 'Attacking'
                   &&  bot.actorReachable(bot.Enemy)) {
               GotoState( 'Attacking' );
           }
           // if the player isn't the enemy, but you can see and reach him, then
           // start attacking!
           if ( player != bot.Enemy
                   && bot.CanSee(player)
                   &&  bot.actorReachable(bot.Enemy))
           {
               bot.AcquireEnemy(player, true);
               GotoState( 'Attacking' );
           }
       }
       SetMultiTimer( DONT_BE_STUPID_TIMER, 4.0 + RandRange(0, 2.5), false );
   }
}

/**
 * Bookkeeping for when a charge starts
 */
function StartCharge() {
    ChargeStartTime        = Level.TimeSeconds;
    default.LastChargeTime = ChargeStartTime;
    zombieBot.bForceRun    = true;
    bIsCharging            = true;
    default.NumChargingZombies = default.NumChargingZombies + 1;
}

/**
 * Bookkeeping for when a charge ends.  Safe to call even when not charging.
 */
function EndCharge() {
    if ( !bIsCharging ) return;
    default.NumChargingZombies = default.NumChargingZombies - 1;
    bIsCharging         = false;
    zombieBot.bForceRun = false;
}

/**
 * InAttackRange
 */
function bool InAttackRange(actor enemy){
    //NOTE: maybe migrate this to the ZombieGropeWeapon?
   if(VSize(bot.pawn.location - enemy.location) < 150){
      return true;
   } else {
      return false;
   }
}

/**
 * Realtime onscreen debug info...
 */
function DisplayDebug( Canvas c, out float YL, out float YPos ) {
    super.DisplayDebug( c, YL, YPos );
    c.SetPos(4, YPos);
    C.DrawText( "LastSeekInstigator:" @ LastSeekInstigator
                    @ "SeekLocation:" @ SeekLocation );
    YPos += YL;
    C.SetPos(4,YPos);
}

/**
 */
function PreBeginPlay() {
    super.PreBeginPlay();
    // make sure charging is possibe at the beginning of the game...
    ChargeStartTime = Level.TimeSeconds - MinTimeBetweenCharges;
    LastChargeTime  = ChargeStartTime;
}


//===============================================================
// Default Properties
//===============================================================

defaultproperties
{
     AttackRange=150
     MinWanderDelay=10.000000
     MaxWanderDelay=30.000000
     LastSeekRefreshTime=-10.000000
     MaxChargingZombies=1
     MaxChargeDist=1750.000000
     MinChargeDist=100.000000
     MinTimeBetweenCharges=15.000000
     MaxTimeBetweenCharges=30.000000
     bAllowedToCharge=True
     DebugFlags=1
}
