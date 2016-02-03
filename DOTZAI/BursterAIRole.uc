// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * BursterAIRole -  When within range, stops moving and start shaking and
 *     swelling up. Blows up after 4 - 6 seconds.
 *
 * @version $Rev: 4873 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class BursterAIRole extends ZombieAIRole;



const BURST_RANGE       = 400;
const BURST_CHECK_TIMER = 2984874;
const BURST_TIMER       = 294384;


/**
 * Use a timer to poll for bursting range...
 */
function BeginPlay() {
    super.BeginPlay();
    SetMultiTimer( BURST_CHECK_TIMER, 0.4, true );
}

/**
 */
function MultiTimer( int timerID ) {
    switch ( timerID ) {

    case BURST_CHECK_TIMER:
        CheckBurst();
        break;

    case BURST_TIMER:
        TryBurst();
        break;

    default:
        super.MultiTimer( timerID );
    }
}

/**
 * If the player in in range, get ready to burst (set a timer, and double check
 * before actually bursting).
 */
function CheckBurst() {
                // Log( self @ "CheckBurst"  )    ;
    if ( InBurstRange() ) {
        SetMultiTimer( BURST_TIMER, 0.7, false );
        SetMultiTimer( BURST_CHECK_TIMER, 0, false );
    }
}

/**
 * Confirm that player is still in range, then burst!
 */
function TryBurst() {
                // Log( self @ "TryBurst"  )    ;
    if ( InBurstRange() ) {
                    // Log( self @ "BURSTING..."  )    ;
        bot.pawn.Weapon.CauseAltFire();
    }
    else {
        // go back to checking for player in range...
        SetMultiTimer( BURST_CHECK_TIMER, 0.4, true );
    }
}

/**
 */
function bool InBurstRange() {
    if ( bot == none || bot.enemy == none || bot.pawn == none ) return false;
    return VSize(bot.enemy.location - bot.pawn.location) < BURST_RANGE;
}

/**
 * Rather than go into attack mode, close in to bursting range...
 */
function OnThreatSpotted( Pawn threat ) {
    if ( threat.IsHumanControlled() && threat != bot.Enemy ) {
        bot.AcquireEnemy(threat, true);
        if ( TrySeekTarget(threat) ) GotoState( 'Seeking', 'BEGIN' );
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     DebugFlags=0
}
