// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * OtisStage - similar to the MarineAttackStage from Heavy Gunner,
 *    this stage manages Otis standing around in an area, trying to
 *    hold back the zombies.
 *
 * @version $Rev: 4880 $
 * @author  Jesse LaChapelle (Jesse@digitalextremes.com)
 * @date    June 2004
 */
class OtisStage extends EntrenchStage;




//===========================================================================
// Internal data
//===========================================================================

// used to draw zombies into the action...
var Attractor myZombieAttractor;


//===========================================================================
// DEBAIT hooks
//===========================================================================

/**
 */
function joinStage( VGSPAIController c ) {
    warn( c @ "JOINING" @ self );
                if ( !(OtisAIController(c) != None ) ) {            Log( "(" $ self $ ") assertion violated: (OtisAIController(c) != None )", 'DEBUG' );           assert( OtisAIController(c) != None  );        }//    ;
    super.joinStage( c );
    if ( myZombieAttractor == None ) {
        myZombieAttractor
            = Spawn(class'Attractor',,, stagePositions[0].location);
            //  = Spawn(class'CarAlarm',,, stagePositions[0].location);
    }
    myZombieAttractor.loudness = 1;
    myZombieAttractor.activate( c.Pawn );
    GotoState( 'Engaged');
}

function leaveStage( VGSPAIController c, EReason r ) {
    super.leaveStage( c, r );
    myZombieAttractor.deactivate();
}


auto state Init {

    /**
     * make sure to call initStage()!
     */
    function BeginState() {
        initStage();
    }

BEGIN:

}

defaultproperties
{
}
