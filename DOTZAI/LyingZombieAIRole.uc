// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * LyingZombieAIRole - special zombies that lie on the ground until
 *    awakened by something.
 *
 * @version $Rev: 2188 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    June 2004
 */
class LyingZombieAIRole extends ZombieAIRole;



//
var() float AwarenessRange;

//
var LyingZombieAIController myLyingController;


/**
 */
function init(VGSPAIController c) {
    super.init( c );
    myLyingController = LyingZombieAIController( c );
}

/**
 */
auto state LyingDown {

    function OnHeardNoise( float loudness, Actor noiseMaker ) {
        TryWakeUp( noiseMaker );
    }

    function OnThreatHeard( Pawn threat ) {
                    // Log( self @ "ignoring OnThreatHeard"  )    ;
    }

    function OnThreatSpotted( Pawn threat ) {
        TryWakeUp( threat );
    }

    /**
     */
    function BeginState(){
        //        LyingZombieAIController(bot).Perform_AISpecificTask();
    }

BEGIN:
                // Log( self @ "lying down"  )    ;
    myLyingController.Perform_LieDown();
    // sit in this state until TryWakeup succeeds.
}


/**
 * Wakes up, if appropriate
 */
function TryWakeup( Actor a ) {
    if ( VSize(a.location - bot.pawn.location) < awarenessRange ) {
        myLyingController.Perform_GetUp();
        GotoState( 'Wander' );
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     AwarenessRange=200.000000
}
