// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Kills a Pawn in a manner that won't cause things to crash (like the
 * matinee system).
 * 
 * @author  Neil Gower (neilg@digitialextremes.com)
 * @version $Revision: #1 $
 * @date    Apr 2004
 */
class ACTION_SafePawnKill extends ScriptedAction;

/**
 */
function bool InitActionFor( ScriptedController c ) {
    local Pawn p;
    p = c.Pawn;
    if ( p == None ) return false;
    // rather than destroy the pawn, we just make him unnoticable.
    p.bHidden      = true;
    p.Velocity     = Vect( 0,0,0 );
    p.Acceleration = Vect( 0,0,0 );
    p.RotationRate = Rot( 0,0,0 );
    p.bStasis      = true;
    p.SetPhysics( PHYS_None );
    p.SetCollision( false, false, false );
    return false;	
}

defaultproperties
{
     ActionString="SafePawnKill"
}
