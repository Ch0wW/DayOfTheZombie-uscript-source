// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * VomitterAIRole -  When within range, convulses then pukes.
 *
 * @version $Rev: 5128 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class VomitterAIRole extends ZombieAIRole;



const VOMIT_RANGE   = 512;
const VOMIT_TIMER   = 2984;
const REVOMIT_TIMER = 3084;


/**
 * Use a timer to poll for vomit-range.
 */
function BeginPlay() {
    super.BeginPlay();
    SetMultiTimer( VOMIT_TIMER, 1.1, true );
}

/**
 */
function MultiTimer( int timerID ) {
    switch ( timerID ) {

    case REVOMIT_TIMER:
        SetMultiTimer( VOMIT_TIMER, 1.1, true );
    case VOMIT_TIMER:
        TryVomit();
        break;

    default:
        super.MultiTimer( timerID );
    }
}

/**
 * Trigger vomitting if within range.
 */
function TryVomit() {
                // Log( self @ "TryVomit"  )    ;
    if ( bot != none && bot.Enemy != none && bot.Pawn != none
            && VSize(bot.Enemy.location - bot.pawn.location) < VOMIT_RANGE ) {
                    // Log( self @ "VOMIT!"  )    ;
        // trigger the spew...
        bot.pawn.Weapon.CauseAltFire();
        // and hold off heaving again for a while...
        SetMultiTimer( VOMIT_TIMER, 0, false );
        SetMultiTimer( REVOMIT_TIMER, 10, false );
    }
}

/**
 * Rather than go into attack mode, close in to spewing range...
 */
function OnThreatSpotted( Pawn threat ) {
    if ( threat.IsHumanControlled() && threat != bot.Enemy ) {
        bot.AcquireEnemy(threat, true);
        if ( TrySeekTarget(threat) ) GotoState( 'Seeking', 'BEGIN' );
    }
}

/**
 * Same as base class, but w/o the extraneous attacking.
 */
state Wander {

    /**
     */
    function NotEngagedWanderFailed() {
        // don't attack.
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     DebugFlags=0
}
