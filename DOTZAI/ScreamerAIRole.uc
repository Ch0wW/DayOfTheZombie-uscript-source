// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ScreamerAIRole - manages the high-level behaviour of the screamers.  When
 *     they spot the player, they create an attractor which triggers an event
 *     matching the bot's tag (which can be set with ControllerTag in the
 *     OpponentFactory).
 *
 * @version $Rev: 4748 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ScreamerAIRole extends ZombieAIRole;



// internal
var ScreamAttractor MyAttractor;


/**
 * Stop moving and start a screamin'
 */
function OnThreatSpotted( Pawn threat ) {
    //            // Log( self @ "OnThreatSpotted!" @ threat  )    ;
    tryScream( threat );
}

/**
 * Back to screaming!
 */
function OnRegainedSight() {
    tryScream( bot.Enemy );
}

/**
 * Head for the source of the noise for a closer look.
 */
function OnHeardNoise( float Loudness, Actor NoiseMaker ) {
    local Pawn noisePawn;

    noisePawn = Pawn( NoiseMaker );
    if ( !noisePawn.isHumanControlled() ) return;
    //else it's the player!

    if ( bot.CanSee(noisePawn) ) {
        // sound the alarm!
        GotoState( 'Screaming' );
    }
    else {
        if ( TrySeekTarget(noiseMaker) ) GotoState( 'Seeking', 'BEGIN' );
    }
}

/**
 * Trigger screaming if appropriate for this target...
 */
function TryScream( Pawn target ) {
    if ( target.IsHumanControlled() ) {
        // sound the alarm!
        bot.AcquireEnemy( target, true );
        bot.UpdateFocus( target );
        GotoState( 'Screaming' );
    }
}

/**
 */
function DontBeStupid() {}

/**
 * Screaming attracts more zombies (and triggers an event)!
 */
state Screaming {

    /**
     * Sets up the attractor
     */
    function BeginState() {
        //NOTE: might improve things if the attractor was placed near the player
        myAttractor = Spawn( class'ScreamAttractor',,, bot.pawn.location );
        myAttractor.StartScream( bot.pawn, bot.tag );
        if ( debugFlags != 0 ) myAttractor.bHidden = false;
        // start scream
        bot.pawn.weapon.BotFire( false );
    }

    /**
     * Cleans up the attractor
     */
    function EndState() {
        if ( myAttractor != none ) myAttractor.Destroy();
        myAttractor = none;
        // end scream
        bot.pawn.weapon.CauseAltFire();
    }

    // just keep screaming!
    function OnHeardNoise( float Loudness, Actor NoiseMaker ) {
       //             // Log( self @ "ignoring noise"  )    ;
    }

    // just keep screaming!
    function OnThreatSpotted( Pawn threat ) {
        //            // Log( self @ "ignoring threat spotted" @ threat  )    ;
    }

    /**
     * Lost sight of the enemy, try to recover him...
     */
    function OnLostSight() {
        //            // Log( self @ "OnLostSight" @ bot.Enemy  )    ;
        SetMultiTimer( START_REACQUIRE_TIMER, REACQUIRE_DELAY, false );
    }
}

defaultproperties
{
     DebugFlags=0
}
