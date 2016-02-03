// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * LyingZombieAIController -
 *
 * @version $Rev: 5059 $
 * @author  Name (email@digitalextremes.com)
 * @date    Month 2004
 */
class LyingZombieAIController extends ZombieAIController;

var LyingZombieAIRole myLyingRole;
var XDOTZPawnBase myDotzPawn;

/**
 */
function InitAIRole() {
    super.InitAIRole();
    myLyingRole = LyingZombieAIRole( myAIRole );
    myDotzPawn  = XDOTZPawnBase( pawn );
}


//===========================================================================
// LieDown - lie there and do nothing.
//===========================================================================

/**
 */
function Perform_LieDown() {
    if ( myDotzPawn == None ) {
        Warn( pawn @ "cannot lie down" );
        return;
    }
    MoveTarget = None;
    Focus = None;
    myDotzPawn.LieDown();
    GotoState( 'LyingDown' );
}

/**
 */
state LyingDown {
    ignores DamageAttitudeTo, KilledBy, EnemyNotVisible;

    function BeginState() {
        curBehaviour = "Lie down";
    }
}


//===========================================================================
// GetUp -
//===========================================================================

/**
 */
function Perform_GetUp() {
    if ( myDotzPawn == None ) {
        Warn( pawn @ "cannot get up" );
        return;
    }
    myDotzPawn.GetUp();
    GotoState( '' );
}


//===============================================================
// DefaultProperties
//===============================================================

defaultproperties
{
     AIType=Class'DOTZAI.LyingZombieAIRole'
}
